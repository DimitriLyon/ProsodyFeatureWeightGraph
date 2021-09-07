if __name__ == "__main__":
    file_name = input("File name (without extension): ")
    lines_to_cut = int(input("How many lines should be cut from the data: "))
    first_file = open(file_name + ".txt", "r")
    data = first_file.readlines()
    for i in range(lines_to_cut):
        data.pop(0)
    second_file = open(file_name + ".csv","w")
    abbrev_number_codes = {"vr":1, "pd":2, "cp":3, "cr":4, "sr":5,
                           "tl":6, "th":7, "np":8, "wp":9, "vo":10}
    to_rmv_list = []
    for data_line in data:
        if "NA" in data_line:
            to_rmv_list.append(data_line)
    for r in to_rmv_list:
        data.remove(r)
    del to_rmv_list
    del data_line
    for l in data:
        line_data = l.split()
        #trimming unnecessary data
        line_data.pop(0)
        line_data.pop(0)
        line_data.pop(1)
        line_data.pop(1)
        #turning the abbreviations into number codes
        line_data[1] = abbrev_number_codes[line_data[1]]
        #turns weight into a single number that defines the line thickness group
        weight = float(line_data[0])
        if weight >0:
            if weight > .08:
                line_data[0] = "+4"
            elif weight > .04:
                line_data[0] = "+3"
            elif weight > .02:
                line_data[0] = "+2"
            else:
                line_data[0] = "+1"
        else:
            if weight < -.08:
                line_data[0] = "-4"
            elif weight < -.04:
                line_data[0] = "-3"
            elif weight < -.02:
                line_data[0] = "-2"
            else:
                line_data[0] = "-1"
        
        s = str(line_data)
        s = s.strip("[]")
        s = s.replace("'","")
        second_file.write(s)
        second_file.write("\n")
    first_file.close()
    second_file.close()