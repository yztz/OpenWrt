# 打开文件A和文件B
with open('armv8-n1.config', 'r') as file_a, open('armv8-mini.config', 'r') as file_b:
    # 读取文件内容并将每一行作为集合中的元素，忽略以井号开头的注释行
    lines_a = {line.strip() for line in file_a if not line.strip().startswith('#')}
    lines_b = {line.strip() for line in file_b if not line.strip().startswith('#')}

# 找到文件A中存在但文件B中不存在的行
lines_only_in_a = lines_a - lines_b

# 找到文件B中存在但文件A中不存在的行
lines_only_in_b = lines_b - lines_a

# 将结果写入两个新的文件副本
with open('compare-armv8-n1.config', 'w') as output_file_a, open('compare-armv8-mini.config.config', 'w') as output_file_b:
    output_file_a.write('\n'.join(lines_only_in_a))
    output_file_b.write('\n'.join(lines_only_in_b))
