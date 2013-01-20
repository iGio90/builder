DEVICE="$1"
TARGET="$2"
cd out/target/product/$DEVICE/ && mkdir tmp && mv jellybam-*.zip tmp/ && cd tmp && echo "Unzipping the build" && unzip -q jellybam-*.zip && rm *.zip && cp -r ../../../../../fullbuild/$TARGET/system/* system/ && echo "Zipping the final build" && zip -r -q jellybam-5.1.0_$DEVICE.STABLE.zip * && echo "Moving the build into final folder" && mkdir ../../../../../final && mv jellybam-* ../../../../../ && mv ../../../../../jellybam-*.zip final/ && cd ../ && rm -r tmp && rm jellybam-* && rm jellybam_*;
