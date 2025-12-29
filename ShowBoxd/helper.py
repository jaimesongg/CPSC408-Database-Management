import csv

class helper:
    # convert string to int, float, or leave as string
    @staticmethod
    def convert(value):
        types = [int, float, str]
        if value == '':
            return None
        for t in types:
            try:
                return t(value)
            except:
                pass

    # read CSV and return list of cleaned rows
    @staticmethod
    def data_cleaner(path):
        cleaned = []
        with open(path, newline='', encoding='utf-8') as f:
            reader = csv.reader(f)
            for row in reader:
                # strip whitespace and convert types
                converted = [helper.convert(item.strip()) for item in row]
                cleaned.append(converted)
        return cleaned
    
    
