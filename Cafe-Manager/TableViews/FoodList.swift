import UIKit
import SkeletonView
class FoodList: UITableView,UITableViewDelegate,UITableViewDataSource {
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        delegate = self
        dataSource = self
    }
    func updateData(_ newData:[FoodDetail]){
        data = newData
        for category in data.map({$0.type}){
            if !categoryTable.contains(category){
                categoryTable.append(category)
            }
            
        }
        reloadData()
    }
    var categoryTable = [String]()
    var data:[FoodDetail] = []/*[FoodDetail(image: #imageLiteral(resourceName: "food"), title: "Patase", foodDescription: "ingredibly delicious food staright from Italy.Bit Oily but good to consume", promotion: 30, cost: 340),
                             FoodDetail(image: #imageLiteral(resourceName: "avatar"), title: "Human", foodDescription: "A very stupid human orinated from earth.Good taste for canibals.Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero", cost: 600)
    ]*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count == 0 ? 3:data.filter({$0.type == categoryTable[section]}).count
    }
    func provideImage(index:Int,newImage:UIImage?) {
        if(newImage == nil){
            return
        }
        if(index > data.count){
            return // very rare index out bound exception can occur sometimes
        }
        data[index].image = newImage
        var indexPath = IndexPath(row: 0, section: 0)
        let matchingType = data[index].type
        for i in 0..<index{
            if data[i].type == matchingType{
                indexPath.row += 1
            }
        }
        
        indexPath.section = categoryTable.firstIndex(of: data[index].type)!
        reloadRows(at: [indexPath], with: .none)
    }
    func transverse(view:UIView,mode:Bool,exceptionView:UIView? = nil){
        if(view is UIButton || view is UILabel || view is UIImageView){
            view.isSkeletonable = true
            if(mode){
                view.showAnimatedGradientSkeleton()
            }else if(view != exceptionView){
                view.hideSkeleton()
            }
        }
        else{
            for child in view.subviews{
                transverse(view: child,mode:mode,exceptionView: exceptionView
                )
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filteredData = data.filter({$0.type == categoryTable[indexPath.section]})
        let cell = tableView.dequeueReusableCell(withIdentifier:"foodDetail") as! FoodSmallDetailCell
        if(data.count > 0){
        transverse(view: cell.contentView, mode: false,exceptionView: cell.foodImage)
        let foodDetail = filteredData[indexPath.row]
        if foodDetail.image != nil{
            cell.foodImage.hideSkeleton()
            cell.foodImage.image = data[indexPath.row].image
        }
            cell.foodImage?.image = foodDetail.image
            cell.foodTitle.text = foodDetail.title
            cell.foodDescription.text = foodDetail.foodDescription
            if(foodDetail.promotion > 0){
                cell.promotion.isHidden = false
                cell.promotion.text = "\(foodDetail.promotion)% off"
            }else{
                cell.promotion.isHidden = true
            }
            cell.cost.text = "Rs.\(foodDetail.cost)"
        
        }else{
            cell.foodDescription.numberOfLines = 2
            transverse(view: cell.contentView, mode: true)
            
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryTable.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        categoryTable[section]
    }
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
