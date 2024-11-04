import { ObservedArray } from "../common/app_model";
import { HttpRequest } from "../utils/tools";

export interface NewsItem {
  id: string;
  title: string;
  summary: string;
}

export class DiscoverPageModel {
  list: ObservedArray<NewsItem> = new ObservedArray([])

  loadData(){
    HttpRequest.get(`https://papi.jiemian.com/page/api/kuaixun/getlistmore?cid=1323kb&start_time=${Math.floor(Date.now()/1000)}&page=1&tagid=1323`)
      .then(res=>{
        const listData = res!['result']['list'] as NewsItem[]
        listData.forEach(item=>{
          this.list.push({
            id: item.id,
            title: item.title,
            summary: item.summary
          })
        })
      })
  }
}