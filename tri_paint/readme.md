## 三角划分马赛克
* 参数声明：(target, point_num, choice_num),
    * target: 对象图片（string）
    * point_num: 划分的点数（int）
    * choice_num: 输出几幅图片，以任意挑选

*使用`delaunay`进行三角划分，并在轮廓线上着重描点