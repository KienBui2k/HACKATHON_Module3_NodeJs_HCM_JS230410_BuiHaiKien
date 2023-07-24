-- Bài tập 2:
-- Hiển thị toàn bộ nội dung của bảng Architect
SELECT * FROM `architect` WHERE 1
-- Hiển thị danh sách gồm họ tên và giới tính của kiến trúc sư
SELECT name, sex FROM architect
-- Hiển thị những năm sinh có thể có của các kiến trúc sư
SELECT birthday FROM architect
-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh tăng dần)
SELECT name,birthday FROM architect ORDER BY birthday ASC
-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh giảm dần)
SELECT name,birthday FROM architect ORDER BY birthday DESC
-- Hiển thị danh sách các công trình có chi phí từ thấp đến cao. Nếu 2 công trình có chi phí bằng nhau sắp xếp tên thành phố theo bảng chữ cái building
SELECT name,city,cost FROM `building` ORDER BY cost;

-- Bài tập 4:
-- Hiển thị tất cả thông tin của kiến trúc sư "le thanh tung"
SELECT *  FROM architect WHERE name='le thanh tung'
-- Hiển thị tên, năm sinh các công nhân có chuyên môn hàn hoặc điện
SELECT * FROM `worker` WHERE skill = 'han' OR skill = 'dien';
-- Hiển thị tên các công nhân có chuyên môn hàn hoặc điện và năm sinh lớn hơn 1948
SELECT name, birthday, skill FROM worker WHERE (skill = 'han' OR skill = 'dien') AND birthday > 1948;
-- Hiển thị những công nhân bắt đầu vào nghề khi dưới 20 (birthday + 20 > year)
SELECT name, birthday, year, skill FROM worker WHERE (year - birthday) < 20;
-- Hiển thị những công nhân có năm sinh 1945, 1940, 1948
SELECT name, birthday FROM worker WHERE birthday IN (1945, 1940, 1948);
-- Tìm những công trình có chi phí đầu tư từ 200 đến 500 triệu đồng
SELECT name, cost FROM building WHERE cost BETWEEN 200 AND 500;
-- Tìm kiếm những kiến trúc sư có họ là nguyen: % chuỗi
SELECT * FROM architect WHERE name LIKE '%Nguyen%';
-- Tìm kiếm những kiến trúc sư có tên đệm là anh
SELECT * FROM architect WHERE name LIKE '% Anh %';
-- Tìm kiếm những kiến trúc sư có tên bắt đầu th và có 3 ký tự
SELECT * FROM architect WHERE name LIKE '%Th_';
-- Tìm chủ thầu không có phone
SELECT * FROM contractor WHERE phone IS NULL;

-- Bài tập 5:
-- Thống kê tổng số kiến trúc sư
SELECT COUNT(*) AS total_architects FROM architect;
-- Thống kê tổng số kiến trúc sư nam
SELECT COUNT(*) AS total_men_architects FROM architect WHERE sex = 1;
--  Tìm ngày tham gia công trình nhiều nhất của công nhân
SELECT date, COUNT(worker_id) AS total_workers FROM work GROUP BY date ORDER BY total_workers DESC LIMIT 1;
-- Tìm ngày tham gia công trình ít nhất của công nhân

--Tìm tổng số ngày tham gia công trình của tất cả công nhân
SELECT SUM(total) AS total_days_worked FROM work;
-- Tìm tổng chi phí phải trả cho việc thiết kế công trình của kiến trúc sư có Mã số 1
SELECT SUM(benefit) AS total_cost FROM design WHERE architect_id = 1;
-- Tìm trung bình số ngày tham gia công trình của công nhân

-- Hiển thị thông tin kiến trúc sư: họ tên, tuổi
SELECT name, YEAR(CURDATE()) - birthday AS age FROM architect;
--Tính thù lao của kiến trúc sư: Thù lao = benefit * 1000
SELECT a.name AS architect_name, SUM(d.benefit * 1000) AS total_salary
FROM architect a
INNER JOIN design d ON a.id = d.architect_id
GROUP BY a.name;


-- Bài tập 6
-- Hiển thị thông tin công trình có chi phí cao nhất
SELECT 
    building.name,
		building.cost * 1000 as Cost_Building,
    COALESCE((
			SELECT SUM(design.benefit * 1000)
      FROM design
      WHERE design.building_id = building.id
    ), 0) AS kySuCost,
		COALESCE((
			SELECT SUM(work.total * 500)
      FROM work
      WHERE work.building_id = building.id
    ), 0) AS congNhanCost,
    COALESCE((
      SELECT SUM(design.benefit * 1000)
      FROM design
      WHERE design.building_id = building.id
    ), 0) + COALESCE((
			SELECT SUM(work.total * 500)
      FROM work
      WHERE work.building_id = building.id
    ) + building.cost * 1000, 0) AS TongChiPhi,
		building.city
FROM 
    building;
-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT 
    building.name,
		building.cost * 1000 as Cost_Building,
    COALESCE((
			SELECT SUM(design.benefit * 1000)
      FROM design
      WHERE design.building_id = building.id
    ), 0) AS kySuCost,
		COALESCE((
			SELECT SUM(work.total * 500)
      FROM work
      WHERE work.building_id = building.id
    ), 0) AS congNhanCost,
    COALESCE((
      SELECT SUM(design.benefit * 1000)
      FROM design
      WHERE design.building_id = building.id
    ), 0) + COALESCE((
			SELECT SUM(work.total * 500)
      FROM work
      WHERE work.building_id = building.id
    ) + building.cost * 1000, 0) AS TongChiPhi,
		building.city
FROM 
    building
HAVING 
    TongChiPhi > (
      SELECT COALESCE(SUM(design.benefit * 1000), 0) + COALESCE(SUM(work.total * 500), 0) + building.cost * 1000 AS TongChiPhiMaxCanTho
      FROM building
      INNER JOIN design ON design.building_id = building.id
      INNER JOIN work ON work.building_id = building.id
      WHERE building.city = 'Cần Thơ'
			GROUP BY building.id
      ORDER BY TongChiPhiMaxCanTho DESC
			LIMIT 1
    )
ORDER BY 
    TongChiPhi DESC;
-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ
SELECT 
    building.name,
		building.cost * 1000 as Cost_Building,
    COALESCE((
			SELECT SUM(design.benefit * 1000)
      FROM design
      WHERE design.building_id = building.id
    ), 0) AS kySuCost,
		COALESCE((
			SELECT SUM(work.total * 500)
      FROM work
      WHERE work.building_id = building.id
    ), 0) AS congNhanCost,
    COALESCE((
      SELECT SUM(design.benefit * 1000)
      FROM design
      WHERE design.building_id = building.id
    ), 0) + COALESCE((
			SELECT SUM(work.total * 500)
      FROM work
      WHERE work.building_id = building.id
    ) + building.cost * 1000, 0) AS TongChiPhi,
		building.city
FROM 
    building
WHERE building.city != 'Cần Thơ'
HAVING 
    TongChiPhi > ANY (
      SELECT COALESCE(SUM(design.benefit * 1000), 0) + COALESCE(SUM(work.total * 500), 0) + building.cost * 1000 AS TongChiPhiMaxCanTho
      FROM building
      INNER JOIN design ON design.building_id = building.id
      INNER JOIN work ON work.building_id = building.id
      WHERE building.city = 'Cần Thơ'
			GROUP BY building.id
      ORDER BY TongChiPhiMaxCanTho DESC
    )
ORDER BY 
    TongChiPhi DESC;
-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT building.name AS 'Tên Công Ty'
FROM building
LEFT JOIN design on building.id = design.building_id
WHERE design.building_id IS NULL 
-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp
SELECT a1.name AS architect_name1, a2.name AS architect_name2
FROM architect a1, architect a2
WHERE a1.id <> a2.id AND a1.birthday = a2.birthday AND a1.place = a2.place;


-- Bài tập 7
-- Hiển thị thù lao trung bình của từng kiến trúc sư
SELECT architect_id, AVG(benefit) * 1000 AS average_fee
FROM design
GROUP BY architect_id;
-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố
SELECT building.city, 
	SUM(
		building.cost * 1000 
		+ COALESCE(
			(
				SELECT SUM(design.benefit * 1000)
				FROM design
				WHERE design.building_id = building.id
			), 0)
		+ COALESCE(
			(
				SELECT SUM(work.total * 500)
				FROM work
				WHERE work.building_id = building.id
			), 0)
	) as 'Tổng Chi Phí Đầu Tư'
FROM building
GROUP BY building.city
-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
SELECT
    building.name,
    SUM(
        COALESCE(design.benefit * 1000, 0)
    ) as ChiPhiChoKienTrucSu
FROM building
INNER JOIN design ON building.id = design.building_id
GROUP BY building.name
HAVING ChiPhiChoKienTrucSu > 50 * 1000


--Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp
