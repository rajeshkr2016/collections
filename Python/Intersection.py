def Intersection(first, second):
    second = set(second)
    common=[item for item in first if item in second]
    return common