@Observed
export class ObservedArray<T> extends Array<T> {
  constructor(params: T[]) {
    if(Array.isArray(params)) {
      super(...params)
    }
  }
}