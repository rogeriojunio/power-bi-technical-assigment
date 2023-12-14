WITH rogerio AS (
SELECT DISTINCT MAX(o.id) AS max
FROM public.order_lines o
GROUP BY o.company_id
),
rogerio2 AS (
SELECT o.company_id
FROM public.order_lines o
GROUP BY o.company_id
HAVING COUNT(DISTINCT o.id) > 1
)

SELECT o.id, o.line_id, o.product_id, o.company_id, o.order_date,
CASE WHEN (o.order_date > o.delivery_date) THEN o.order_date ELSE o.delivery_date END AS delivery_date,
CASE WHEN o.id IN (SELECT r.max FROM rogerio r) THEN 'yes' ELSE 'no' END AS company_last_order,
CASE WHEN o.company_id IN (SELECT r2.company_id FROM rogerio2 r2) THEN 'yes' ELSE 'no' END AS company_is_recurring_customer,
CASE WHEN (o.order_date > o.delivery_date) THEN 'yes' ELSE 'no' END AS delivery_date_is_assumed
FROM public.order_lines o
ORDER BY o.company_id, o.id