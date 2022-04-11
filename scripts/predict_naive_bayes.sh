#! /bin/bash -

# Color related variables
COLOR_CYAN="\e[1;36m"
COLOR_PURPLE="\e[1;35m"
COLOR_RESET="\e[0m"

DD="0405"
wheights="068_Naive_Bayes_04-11_18:15.z"

echo "Predict on data in data/processed/twitter/predict/" "$DD"
for filename in data/processed/twitter/predict/${DD}/*.csv; do
	echo -e $COLOR_CYAN "processing..." "$filename" $COLOR_RESET
		poetry run python -m src models --task predict --model  naive-bayes --weights_in models/${wheights} --dataset_type predict --flat_y --in_csv ${filename}
done

# poetry run dvc add data
# poetry run dvc push
# git add data.dvc
# git commit -m $1
# git push
