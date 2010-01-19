From: mroconnor@oel.state.nj.us
Subject: btrfsck errors
Date: Tue, 19 Jan 2010 10:31:34 -0500
Message-ID: <a348d1da19.4b558a06@dhs.state.nj.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While compiling yesterday I had a power failure and consequently did a btrfsck on /dev/sda6(/var). The output is as follows:
   1.
      cosmo2 home # btrfsck /dev/sda6              
   2.
      parent transid verify failed on 2178560000 wanted 46688 found 46681
   3.
      parent transid verify failed on 2178560000 wanted 46688 found 46681
   4.
      parent transid verify failed on 2178818048 wanted 46688 found 46677
   5.
      parent transid verify failed on 2178818048 wanted 46688 found 46677
   6.
      parent transid verify failed on 2181349376 wanted 46687 found 46678
   7.
      parent transid verify failed on 2181349376 wanted 46687 found 46678
   8.
      parent transid verify failed on 2181361664 wanted 46687 found 46678
   9.
      parent transid verify failed on 2181361664 wanted 46687 found 46678
  10.
      parent transid verify failed on 2178850816 wanted 46688 found 46681
  11.
      parent transid verify failed on 2178850816 wanted 46688 found 46681
  12.
      parent transid verify failed on 2181111808 wanted 46688 found 46681
  13.
      parent transid verify failed on 2181111808 wanted 46688 found 46681
  14.
      parent transid verify failed on 2178936832 wanted 46687 found 46681
  15.
      parent transid verify failed on 2178936832 wanted 46687 found 46681
  16.
      parent transid verify failed on 2181394432 wanted 46687 found 46678
  17.
      parent transid verify failed on 2181394432 wanted 46687 found 46678
  18.
      parent transid verify failed on 2179432448 wanted 46688 found 46680
  19.
      parent transid verify failed on 2179432448 wanted 46688 found 46680
  20.
      parent transid verify failed on 2179444736 wanted 46688 found 46680
  21.
      parent transid verify failed on 2179444736 wanted 46688 found 46680
  22.
      parent transid verify failed on 2179076096 wanted 46688 found 46680
  23.
      parent transid verify failed on 2179076096 wanted 46688 found 46680
  24.
      parent transid verify failed on 2179100672 wanted 46688 found 46680
  25.
      parent transid verify failed on 2179100672 wanted 46688 found 46680
  26.
      parent transid verify failed on 2179313664 wanted 46688 found 46681
  27.
      parent transid verify failed on 2179313664 wanted 46688 found 46681
  28.
      parent transid verify failed on 2179428352 wanted 46688 found 46655
  29.
      parent transid verify failed on 2179428352 wanted 46688 found 46655
  30.
      parent transid verify failed on 2179919872 wanted 46688 found 46680
  31.
      parent transid verify failed on 2179919872 wanted 46688 found 46680
  32.
      parent transid verify failed on 2178514944 wanted 46687 found 46681
  33.
      parent transid verify failed on 2178514944 wanted 46687 found 46681
  34.
      parent transid verify failed on 2178527232 wanted 46687 found 46681
  35.
      parent transid verify failed on 2178527232 wanted 46687 found 46681
  36.
      bad block 2177335296
  37.
      leaf parent key incorrect 2177454080
  38.
      bad block 2177454080
  39.
      parent transid verify failed on 2179133440 wanted 46688 found 46680
  40.
      parent transid verify failed on 2179133440 wanted 46688 found 46680
  41.
      parent transid verify failed on 2179158016 wanted 46688 found 46680
  42.
      parent transid verify failed on 2179158016 wanted 46688 found 46680
  43.
      bad block 2178179072
  44.
      parent transid verify failed on 2179166208 wanted 46688 found 46680
  45.
      parent transid verify failed on 2179166208 wanted 46688 found 46680
  46.
      leaf parent key incorrect 2178572288
  47.
      bad block 2178572288
  48.
      parent transid verify failed on 2179940352 wanted 46688 found 46680
  49.
      parent transid verify failed on 2179940352 wanted 46688 found 46680
  50.
      parent transid verify failed on 2179932160 wanted 46688 found 46680
  51.
      parent transid verify failed on 2179932160 wanted 46688 found 46680
  52.
      parent transid verify failed on 2179928064 wanted 46688 found 46680
  53.
      parent transid verify failed on 2179928064 wanted 46688 found 46680
  54.
      parent transid verify failed on 2179661824 wanted 46688 found 46642
  55.
      parent transid verify failed on 2179661824 wanted 46688 found 46642
  56.
      parent transid verify failed on 2180509696 wanted 46688 found 46654
  57.
      parent transid verify failed on 2180509696 wanted 46688 found 46654
  58.
      parent transid verify failed on 2181001216 wanted 46687 found 46681
  59.
      parent transid verify failed on 2181001216 wanted 46687 found 46681
  60.
      parent transid verify failed on 2179837952 wanted 46688 found 46680
  61.
      parent transid verify failed on 2179837952 wanted 46688 found 46680
  62.
      parent transid verify failed on 2181402624 wanted 46687 found 46678
  63.
      parent transid verify failed on 2181402624 wanted 46687 found 46678
  64.
      parent transid verify failed on 2180497408 wanted 46687 found 46680
  65.
      parent transid verify failed on 2180497408 wanted 46687 found 46680
  66.
      Extent back ref already exists for 2177454080 parent 0 root 5
  67.
      Extent back ref already exists for 3286974464 parent 0 root 2
  68.
      Extent back ref already exists for 3285573632 parent 0 root 2
  69.
      Extent back ref already exists for 2310156288 parent 0 root 2
  70.
      Extent back ref already exists for 3256508416 parent 0 root 2
  71.
      Extent back ref already exists for 2178600960 parent 0 root 2
  72.
      Extent back ref already exists for 2181705728 parent 0 root 2
  73.
      Extent back ref already exists for 3281485824 parent 0 root 2
  74.
      Extent back ref already exists for 2180653056 parent 0 root 2
  75.
      Extent back ref already exists for 3276193792 parent 0 root 2
  76.
      Extent back ref already exists for 3239202816 parent 0 root 2
  77.
      Extent back ref already exists for 122793984 parent 0 root 2
  78.
      Extent back ref already exists for 3251040256 parent 0 root 2
  79.
      Extent back ref already exists for 149803008 parent 0 root 2
  80.
      Extent back ref already exists for 158666752 parent 0 root 2
  81.
      Extent back ref already exists for 148348928 parent 0 root 2
  82.
      Extent back ref already exists for 3257196544 parent 0 root 2
  83.
      Extent back ref already exists for 3278946304 parent 0 root 2
  84.
      Extent back ref already exists for 2179198976 parent 0 root 2
  85.
      Extent back ref already exists for 3278979072 parent 0 root 2
  86.
      Extent back ref already exists for 3278999552 parent 0 root 2
  87.
      Extent back ref already exists for 2180423680 parent 0 root 2
  88.
      Extent back ref already exists for 3281154048 parent 0 root 2
  89.
      Extent back ref already exists for 2180849664 parent 0 root 2
  90.
      Extent back ref already exists for 2179108864 parent 0 root 2
  91.
      Extent back ref already exists for 2180587520 parent 0 root 2
  92.
      Extent back ref already exists for 3196379136 parent 0 root 2
  93.
      Extent back ref already exists for 3252383744 parent 0 root 2
  94.
      Extent back ref already exists for 3176054784 parent 0 root 2
  95.
      Extent back ref already exists for 152825856 parent 0 root 2
  96.
      Extent back ref already exists for 44937216 parent 0 root 2
  97.
      Extent back ref already exists for 37134336 parent 0 root 2
  98.
      Extent back ref already exists for 3170701312 parent 0 root 2
  99.
      Extent back ref already exists for 2181140480 parent 0 root 2
 100.
      Extent back ref already exists for 2179727360 parent 0 root 2
 101.
      Extent back ref already exists for 2181582848 parent 0 root 2
 102.
      Extent back ref already exists for 2181206016 parent 0 root 2
 103.
      Extent back ref already exists for 2181242880 parent 0 root 2
 104.
      Extent back ref already exists for 2180919296 parent 0 root 2
 105.
      Extent back ref already exists for 2180509696 parent 0 root 2
 106.
      Extent back ref already exists for 3257274368 parent 0 root 2
 107.
      Extent back ref already exists for 2181480448 parent 0 root 2
 108.
      Extent back ref already exists for 2179465216 parent 0 root 2
 109.
      Extent back ref already exists for 2180984832 parent 0 root 2
 110.
      Extent back ref already exists for 2181046272 parent 0 root 2
 111.
      Extent back ref already exists for 3245359104 parent 0 root 2
 112.
      Extent back ref already exists for 3273404416 parent 0 root 2
 113.
      Extent back ref already exists for 3247984640 parent 0 root 2
 114.
      Extent back ref already exists for 3245457408 parent 0 root 2
 115.
      Extent back ref already exists for 3246477312 parent 0 root 2
 116.
      Extent back ref already exists for 3315339264 parent 0 root 2
 117.
      Extent back ref already exists for 170917888 parent 0 root 2
 118.
      Extent back ref already exists for 3255443456 parent 0 root 2
 119.
      Extent back ref already exists for 2200133632 parent 0 root 2
 120.
      Extent back ref already exists for 239788032 parent 0 root 2
 121.
      Extent back ref already exists for 2260353024 parent 0 root 2
 122.
      Extent back ref already exists for 2264961024 parent 0 root 2
 123.
      Extent back ref already exists for 2310512640 parent 0 root 2
 124.
      Extent back ref already exists for 2265976832 parent 0 root 2
 125.
      Extent back ref already exists for 2264891392 parent 0 root 2
 126.
      Extent back ref already exists for 2290892800 parent 0 root 2
 127.
      Extent back ref already exists for 3174277120 parent 0 root 2
 128.
      Extent back ref already exists for 2272235520 parent 0 root 2
 129.
      Extent back ref already exists for 3248009216 parent 0 root 2
 130.
      Extent back ref already exists for 2251325440 parent 0 root 2
 131.
      Extent back ref already exists for 2253697024 parent 0 root 2
 132.
      Extent back ref already exists for 3255447552 parent 0 root 2
 133.
      Extent back ref already exists for 2272428032 parent 0 root 2
 134.
      Extent back ref already exists for 2179719168 parent 0 root 2
 135.
      Extent back ref already exists for 3314683904 parent 0 root 2
 136.
      Extent back ref already exists for 2179461120 parent 0 root 2
 137.
      Extent back ref already exists for 3319283712 parent 0 root 2
 138.
      Extent back ref already exists for 3317047296 parent 0 root 2
 139.
      Extent back ref already exists for 3252248576 parent 0 root 2
 140.
      Extent back ref already exists for 156422144 parent 0 root 2
 141.
      Extent back ref already exists for 2199965696 parent 0 root 2
 142.
      Extent back ref already exists for 3252060160 parent 0 root 2
 143.
      Extent back ref already exists for 2259120128 parent 0 root 2
 144.
      Extent back ref already exists for 3251183616 parent 0 root 2
 145.
      Extent back ref already exists for 159109120 parent 0 root 2
 146.
      Extent back ref already exists for 3252432896 parent 0 root 2
 147.
      Extent back ref already exists for 2253619200 parent 0 root 2
 148.
      Extent back ref already exists for 3242545152 parent 0 root 2
 149.
      Extent back ref already exists for 152981504 parent 0 root 2
 150.
      Extent back ref already exists for 3242561536 parent 0 root 2
 151.
      Extent back ref already exists for 2240618496 parent 0 root 2
 152.
      Extent back ref already exists for 2238615552 parent 0 root 2
 153.
      Extent back ref already exists for 2238918656 parent 0 root 2
 154.
      Extent back ref already exists for 2242625536 parent 0 root 2
 155.
      Extent back ref already exists for 3252260864 parent 0 root 2
 156.
      Extent back ref already exists for 3175890944 parent 0 root 2
 157.
      Extent back ref already exists for 3240443904 parent 0 root 2
 158.
      Extent back ref already exists for 3285667840 parent 0 root 2
 159.
      Extent back ref already exists for 3253108736 parent 0 root 2
 160.
      Extent back ref already exists for 2179993600 parent 0 root 2
 161.
      Extent back ref already exists for 3303710720 parent 0 root 2
 162.
      Extent back ref already exists for 5397479424 parent 0 root 2
 163.
      Extent back ref already exists for 172224512 parent 0 root 2
 164.
      Extent back ref already exists for 2200854528 parent 0 root 2
 165.
      Extent back ref already exists for 107851776 parent 0 root 2
 166.
      Extent back ref already exists for 3247714304 parent 0 root 2
 167.
      Extent back ref already exists for 37548032 parent 0 root 2
 168.
      Extent back ref already exists for 2211860480 parent 0 root 2
 169.
      Extent back ref already exists for 3249405952 parent 0 root 2
 170.
      Extent back ref already exists for 3251105792 parent 0 root 2
 171.
      Extent back ref already exists for 3249418240 parent 0 root 2
 172.
      Extent back ref already exists for 3251097600 parent 0 root 2
 173.
      Extent back ref already exists for 2180362240 parent 0 root 2
 174.
      Extent back ref already exists for 2335461376 parent 0 root 2
 175.
      Extent back ref already exists for 2185633792 parent 0 root 2
 176.
      Extent back ref already exists for 3281698816 parent 0 root 2
 177.
      Extent back ref already exists for 3281285120 parent 0 root 2
 178.
      Extent back ref already exists for 3280814080 parent 0 root 2
 179.
      Extent back ref already exists for 3280326656 parent 0 root 2
 180.
      Extent back ref already exists for 3323940864 parent 0 root 2
 181.
      Extent back ref already exists for 3276931072 parent 0 root 2
 182.
      Extent back ref already exists for 3281391616 parent 0 root 2
 183.
      Extent back ref already exists for 3254247424 parent 0 root 2
 184.
      Extent back ref already exists for 3284082688 parent 0 root 2
 185.
      Extent back ref already exists for 3261763584 parent 0 root 2
 186.
      Extent back ref already exists for 2192773120 parent 0 root 2
 187.
      Extent back ref already exists for 3171557376 parent 0 root 2
 188.
      Extent back ref already exists for 3258724352 parent 0 root 2
 189.
      Extent back ref already exists for 2253701120 parent 0 root 2
 190.
      Extent back ref already exists for 3181678592 parent 0 root 2
 191.
      Extent back ref already exists for 3227725824 parent 0 root 2
 192.
      Extent back ref already exists for 3237351424 parent 0 root 2
 193.
      Extent back ref already exists for 3237429248 parent 0 root 2
 194.
      Extent back ref already exists for 3237441536 parent 0 root 2
 195.
      Extent back ref already exists for 3284832256 parent 0 root 2
 196.
      Extent back ref already exists for 3237601280 parent 0 root 2
 197.
      Extent back ref already exists for 3237597184 parent 0 root 2
 198.
      Extent back ref already exists for 2266791936 parent 0 root 2
 199.
      Extent back ref already exists for 2192814080 parent 0 root 2
 200.
      Extent back ref already exists for 2178072576 parent 0 root 2
 201.
      Extent back ref already exists for 2262659072 parent 0 root 2
 202.
      Extent back ref already exists for 3309621248 parent 0 root 2
 203.
      Extent back ref already exists for 3284467712 parent 0 root 2
 204.
      Extent back ref already exists for 3304726528 parent 0 root 2
 205.
      Extent back ref already exists for 3316289536 parent 0 root 2
 206.
      Extent back ref already exists for 3306782720 parent 0 root 2
 207.
      Extent back ref already exists for 3175100416 parent 0 root 2
 208.
      Extent back ref already exists for 3305791488 parent 0 root 2
 209.
      Extent back ref already exists for 3174588416 parent 0 root 2
 210.
      Extent back ref already exists for 3314884608 parent 0 root 2
 211.
      Extent back ref already exists for 3315748864 parent 0 root 2
 212.
      Extent back ref already exists for 3307376640 parent 0 root 2
 213.
      Extent back ref already exists for 3315249152 parent 0 root 2
 214.
      Extent back ref already exists for 3314388992 parent 0 root 2
 215.
      Extent back ref already exists for 3330605056 parent 0 root 2
 216.
      Extent back ref already exists for 3311341568 parent 0 root 2
 217.
      Extent back ref already exists for 3171360768 parent 0 root 2
 218.
      Extent back ref already exists for 3356221440 parent 0 root 2
 219.
      Extent back ref already exists for 3352186880 parent 0 root 2
 220.
      Extent back ref already exists for 3393183744 parent 0 root 2
 221.
      Extent back ref already exists for 3393458176 parent 0 root 2
 222.
      Extent back ref already exists for 3392995328 parent 0 root 2
 223.
      Extent back ref already exists for 3393851392 parent 0 root 2
 224.
      Extent back ref already exists for 2445783040 parent 0 root 2
 225.
      Extent back ref already exists for 3393863680 parent 0 root 2
 226.
      Extent back ref already exists for 3374362624 parent 0 root 2
 227.
      Extent back ref already exists for 3171381248 parent 0 root 2
 228.
      Extent back ref already exists for 3392737280 parent 0 root 2
 229.
      Extent back ref already exists for 3393638400 parent 0 root 2
 230.
      Extent back ref already exists for 3392684032 parent 0 root 2
 231.
      Extent back ref already exists for 3392598016 parent 0 root 2
 232.
      Extent back ref already exists for 3353808896 parent 0 root 2
 233.
      Extent back ref already exists for 3353833472 parent 0 root 2
 234.
      Extent back ref already exists for 3393056768 parent 0 root 2
 235.
      Extent back ref already exists for 3393011712 parent 0 root 2
 236.
      Extent back ref already exists for 3394060288 parent 0 root 2
 237.
      Extent back ref already exists for 3353280512 parent 0 root 2
 238.
      Extent back ref already exists for 2342436864 parent 0 root 2
 239.
      Extent back ref already exists for 3382042624 parent 0 root 2
 240.
      Extent back ref already exists for 3382120448 parent 0 root 2
 241.
      Extent back ref already exists for 3391401984 parent 0 root 2
 242.
      Extent back ref already exists for 3354288128 parent 0 root 2
 243.
      Extent back ref already exists for 3354517504 parent 0 root 2
 244.
      Extent back ref already exists for 3354689536 parent 0 root 2
 245.
      Extent back ref already exists for 3354959872 parent 0 root 2
 246.
      Extent back ref already exists for 3355086848 parent 0 root 2
 247.
      Extent back ref already exists for 3355123712 parent 0 root 2
 248.
      Extent back ref already exists for 2180923392 parent 0 root 2
 249.
      Extent back ref already exists for 2180841472 parent 0 root 2
 250.
      Extent back ref already exists for 2180988928 parent 0 root 2
 251.
      Extent back ref already exists for 5482930176 parent 0 root 2
 252.
      Extent back ref already exists for 5483565056 parent 0 root 2
 253.
      Extent back ref already exists for 2177306624 parent 0 root 2
 254.
      Extent back ref already exists for 2177032192 parent 0 root 2
 255.
      Extent back ref already exists for 3284815872 parent 0 root 2
 256.
      Extent back ref already exists for 2179321856 parent 0 root 2
 257.
      Extent back ref already exists for 2178514944 parent 0 root 2
 258.
      Extent back ref already exists for 2179313664 parent 0 root 2
 259.
      Extent back ref already exists for 2178527232 parent 0 root 2
 260.
      Extent back ref already exists for 2179256320 parent 0 root 2
 261.
      Extent back ref already exists for 2179112960 parent 0 root 2
 262.
      Extent back ref already exists for 2178945024 parent 0 root 2
 263.
      Extent back ref already exists for 2178936832 parent 0 root 2
 264.
      Extent back ref already exists for 2178850816 parent 0 root 2
 265.
      Extent back ref already exists for 2178879488 parent 0 root 2
 266.
      Extent back ref already exists for 2181111808 parent 0 root 2
 267.
      Extent back ref already exists for 2179457024 parent 0 root 2
 268.
      Extent back ref already exists for 2178818048 parent 0 root 2
 269.
      Extent back ref already exists for 2180521984 parent 0 root 2
 270.
      Extent back ref already exists for 2179428352 parent 0 root 2
 271.
      Extent back ref already exists for 2179416064 parent 0 root 2
 272.
      Extent back ref already exists for 35745792 parent 0 root 2
 273.
      Extent back ref already exists for 35766272 parent 0 root 2
 274.
      Extent back ref already exists for 96477184 parent 0 root 2
 275.
      Extent back ref already exists for 2310221824 parent 0 root 2
 276.
      Extent back ref already exists for 35778560 parent 0 root 2
 277.
      Extent back ref already exists for 90050560 parent 0 root 2
 278.
      Extent back ref already exists for 96473088 parent 0 root 2
 279.
      Extent back ref already exists for 3285512192 parent 0 root 2
 280.
      Extent back ref already exists for 2181816320 parent 0 root 2
 281.
      Extent back ref already exists for 3270258688 parent 0 root 2
 282.
      Extent back ref already exists for 2310148096 parent 0 root 2
 283.
      Extent back ref already exists for 3273310208 parent 0 root 2
 284.
      Extent back ref already exists for 3273293824 parent 0 root 2
 285.
      Extent back ref already exists for 3254325248 parent 0 root 2
 286.
      Extent back ref already exists for 3254145024 parent 0 root 2
 287.
      Extent back ref already exists for 35794944 parent 0 root 2
 288.
      Extent back ref already exists for 3250622464 parent 0 root 2
 289.
      Extent back ref already exists for 3289681920 parent 0 root 2
 290.
      Extent back ref already exists for 3175976960 parent 0 root 2
 291.
      Extent back ref already exists for 2290155520 parent 0 root 2
 292.
      Extent back ref already exists for 2211823616 parent 0 root 2
 293.
      Extent back ref already exists for 2289508352 parent 0 root 2
 294.
      Extent back ref already exists for 3176030208 parent 0 root 2
 295.
      Extent back ref already exists for 2179104768 parent 0 root 2
 296.
      Extent back ref already exists for 35803136 parent 0 root 2
 297.
      Extent back ref already exists for 3253161984 parent 0 root 2
 298.
      Extent back ref already exists for 2287669248 parent 0 root 2
 299.
      Extent back ref already exists for 134451200 parent 0 root 2
 300.
      Extent back ref already exists for 134483968 parent 0 root 2
 301.
      Extent back ref already exists for 2212564992 parent 0 root 2
 302.
      Extent back ref already exists for 3285479424 parent 0 root 2
 303.
      Extent back ref already exists for 3274514432 parent 0 root 2
 304.
      Extent back ref already exists for 2285789184 parent 0 root 2
 305.
      leaf parent key incorrect 2178527232
 306.
      bad block 2178527232
 307.
      leaf 2179428352 items 47 free space 423 generation 46688 owner 2
 308.
      fs uuid 2798014f-4195-4ae2-8475-f4ad0c48b515
 309.
      chunk uuid 1f00a012-b785-4a54-8a2d-70fe27a1922e
 310.
              item 0 key (2178646016 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
 311.
                      extent refs 1 gen 46641 flags 2
 312.
                      tree block key (95760384 a8 4096) level 0
 313.
                      tree block backref root 2
 314.
              item 1 key (2178650112 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
 315.
                      extent refs 1 gen 45943 flags 2
 316.
                      tree block key (8571427 60 159) level 0
 317.
                      tree block backref root 5
 318.
              item 2 key (2178654208 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
 319.
                      extent refs 1 gen 46655 flags 2
 320.
                      tree block key (18446744073709551606 80 6554558464) level 0
 321.
                      tree block backref root 7
 322.
              item 3 key (2178658304 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
 323.
                      extent refs 1 gen 46646 flags 2
 324.
                      tree block key (3251314688 a8 4096) level 0
 325.
                      tree block backref root 2
 326.
              item 4 key (2178662400 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
 327.
                      extent refs 1 gen 37018 flags 2
 328.
                      tree block key (14322377 54 4012192816) level 0
 329.
                      tree block backref root 5
 330.
              item 5 key (2178666496 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
 331.
                      extent refs 1 gen 45943 flags 2
 332.
                      tree block key (8571427 54 3711589444) level 0
 333.
                      tree block backref root 5
 334.
              item 6 key (2178670592 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
 335.
                      extent refs 1 gen 45943 flags 2
 336.
                      tree block key (17461870 c 8571427) level 0
 337.
                      tree block backref root 5
 338.
              item 7 key (2178674688 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
 339.
                      extent refs 1 gen 37063 flags 2
 340.
                      tree block key (14337789 c 14337785) level 0
 341.
                      tree block backref root 5
 342.
              item 8 key (2178678784 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
 343.
                      extent refs 1 gen 46644 flags 2
 344.
                      tree block key (3230724096 a8 4096) level 0
 345.
                      tree block backref root 2
 346.
              item 9 key (2178682880 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
 347.
                      extent refs 1 gen 46688 flags 2
 348.
                      tree block key (18446744073709551606 80 6359879680) level 0
 349.
                      tree block backref root 7
 350.
              item 10 key (2178686976 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
 351.
                      extent refs 1 gen 36447 flags 2
 352.
                      tree block key (7677488 54 1938223241) level 0
 353.
                      tree block backref root 5
 354.
              item 11 key (2178691072 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
 355.
                      extent refs 1 gen 42146 flags 2
 356.
                      tree block key (18446744073709551606 80 6799990784) level 0
 357.
                      tree block backref root 7
 358.
              item 12 key (2178695168 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
 359.
                      extent refs 1 gen 42090 flags 2
 360.
                      tree block key (16145673 c 8872137) level 0
 361.
                      tree block backref root 5
 362.
              item 13 key (2178699264 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
 363.
                      extent refs 1 gen 46644 flags 2
 364.
                      tree block key (3230994432 a8 4096) level 0
 365.
                      tree block backref root 2
 366.
              item 14 key (2178703360 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
 367.
                      extent refs 1 gen 46646 flags 2
 368.
                      tree block key (3277049856 a8 4096) level 0
 369.
                      tree block backref root 2
 370.
              item 15 key (2178711552 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
 371.
                      extent refs 1 gen 2339 flags 2
 372.
                      tree block key (3681146 c 3681128) level 0
 373.
                      tree block backref root 5
 374.
              item 16 key (2178715648 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
 375.
                      extent refs 1 gen 46648 flags 2
 376.
                      tree block key (3224952832 a8 4096) level 0
 377.
                      tree block backref root 2
 378.
              item 17 key (2178719744 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
 379.
                      extent refs 1 gen 2337 flags 2
 380.
                      tree block key (3679304 c 3679287) level 0
 381.
                      tree block backref root 5
 382.
              item 18 key (2178723840 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
 383.
                      extent refs 1 gen 46648 flags 2
 384.
                      tree block key (3225165824 a8 4096) level 0
 385.
                      tree block backref root 2
 386.
              item 19 key (2178727936 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
 387.
                      extent refs 1 gen 33938 flags 2
 388.
                      tree block key (13099319 c 7681036) level 0
 389.
                      tree block backref root 5
 390.
              item 20 key (2178732032 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
 391.
                      extent refs 1 gen 2339 flags 2
 392.
                      tree block key (3681209 c 2171568) level 0
 393.
                      tree block backref root 5
 394.
              item 21 key (2178740224 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
 395.
                      extent refs 1 gen 37021 flags 2
 396.
                      tree block key (18446744073709551606 80 11917647872) level 0
 397.
                      tree block backref root 7
 398.
              item 22 key (2178744320 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
 399.
                      extent refs 1 gen 46650 flags 2
 400.
                      tree block key (18446744073709551606 80 6766718976) level 0
 401.
                      tree block backref root 7
 402.
              item 23 key (2178748416 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
 403.
                      extent refs 1 gen 46646 flags 2
 404.
                      tree block key (6372171776 a8 4096) level 0
 405.
                      tree block backref root 2
 406.
              item 24 key (2178752512 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
 407.
                      extent refs 1 gen 42181 flags 2
 408.
                      tree block key (18446744073709551606 80 6803992576) level 0
 409.
                      tree block backref root 7
 410.
              item 25 key (2178756608 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
 411.
                      extent refs 1 gen 36447 flags 2
 412.
                      tree block key (7677489 54 3087554206) level 0
 413.
                      tree block backref root 5
 414.
              item 26 key (2178760704 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
 415.
                      extent refs 1 gen 35194 flags 2
 416.
                      tree block key (4358156 54 3759369742) level 0
 417.
                      tree block backref root 5
 418.
              item 27 key (2178764800 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
 419.
                      extent refs 1 gen 46646 flags 2
 420.
                      tree block key (6376935424 a8 4096) level 0
 421.
                      tree block backref root 2
 422.
              item 28 key (2178768896 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
 423.
                      extent refs 1 gen 46646 flags 2
 424.
                      tree block key (6379257856 a8 4096) level 0
 425.
                      tree block backref root 2
 426.
              item 29 key (2178772992 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
 427.
                      extent refs 1 gen 39216 flags 2
 428.
                      tree block key (9042728 54 911881434) level 0
 429.
                      tree block backref root 5
 430.
              item 30 key (2178777088 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
 431.
                      extent refs 1 gen 46646 flags 2
 432.
                      tree block key (6379995136 a8 4096) level 0
 433.
                      tree block backref root 2
 434.
              item 31 key (2178785280 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
 435.
                      extent refs 1 gen 42171 flags 2
 436.
                      tree block key (16205710 1 0) level 0
 437.
                      tree block backref root 5
 438.
              item 32 key (2178789376 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
 439.
                      extent refs 1 gen 37066 flags 2
 440.
                      tree block key (14337835 c 14337780) level 0
 441.
                      tree block backref root 5
 442.
              item 33 key (2178793472 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
 443.
                      extent refs 1 gen 36447 flags 2
 444.
                      tree block key (7690702 c 7677488) level 0
 445.
                      tree block backref root 5
 446.
              item 34 key (2178797568 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
 447.
                      extent refs 1 gen 35194 flags 2
 448.
                      tree block key (2455605248 a8 4096) level 0
 449.
                      tree block backref root 2
 450.
              item 35 key (2178805760 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
 451.
                      extent refs 1 gen 46641 flags 2
 452.
                      tree block key (17598472 6c 0) level 0
 453.
                      tree block backref root 5
 454.
              item 36 key (2178809856 EXTENT_ITEM 4096) itemoff 2108 itemsize 51
 455.
                      extent refs 1 gen 46688 flags 2
 456.
                      tree block key (0 c0 4194304) level 3
 457.
                      tree block backref root 2
 458.
              item 37 key (2178813952 EXTENT_ITEM 4096) itemoff 2057 itemsize 51
 459.
                      extent refs 1 gen 45948 flags 2
 460.
                      tree block key (11939005 1 0) level 0
 461.
                      tree block backref root 5
 462.
              item 38 key (2178818048 EXTENT_ITEM 4096) itemoff 2006 itemsize 51
 463.
                      extent refs 1 gen 46688 flags 2
 464.
                      tree block key (0 c0 4194304) level 2
 465.
                      tree block backref root 2
 466.
              item 39 key (2178822144 EXTENT_ITEM 4096) itemoff 1955 itemsize 51
 467.
                      extent refs 1 gen 37066 flags 2
 468.
                      tree block key (14337837 c 14337780) level 0
 469.
                      tree block backref root 5
 470.
              item 40 key (2178826240 EXTENT_ITEM 4096) itemoff 1904 itemsize 51
 471.
                      extent refs 1 gen 46647 flags 2
 472.
                      tree block key (18446744073709551606 80 6552621056) level 0
 473.
                      tree block backref root 7
 474.
              item 41 key (2178830336 EXTENT_ITEM 4096) itemoff 1853 itemsize 51
 475.
                      extent refs 1 gen 46199 flags 2
 476.
                      tree block key (17446732 6c 6385664) level 0
 477.
                      tree block backref root 5
 478.
              item 42 key (2178834432 EXTENT_ITEM 4096) itemoff 1802 itemsize 51
 479.
                      extent refs 1 gen 46647 flags 2
 480.
                      tree block key (18446744073709551606 80 6560460800) level 0
 481.
                      tree block backref root 7
 482.
              item 43 key (2178838528 EXTENT_ITEM 4096) itemoff 1751 itemsize 51
 483.
                      extent refs 1 gen 46646 flags 2
 484.
                      tree block key (6392451072 a8 8192) level 0
 485.
                      tree block backref root 2
 486.
              item 44 key (2178842624 EXTENT_ITEM 4096) itemoff 1700 itemsize 51
 487.
                      extent refs 1 gen 46641 flags 2
 488.
                      tree block key (3198681088 a8 4096) level 0
 489.
                      tree block backref root 2
 490.
              item 45 key (2178846720 EXTENT_ITEM 4096) itemoff 1649 itemsize 51
 491.
                      extent refs 1 gen 46653 flags 2
 492.
                      tree block key (17599630 6c 917504) level 0
 493.
                      tree block backref root 5
 494.
              item 46 key (2178850816 EXTENT_ITEM 4096) itemoff 1598 itemsize 51
 495.
                      extent refs 1 gen 46688 flags 2
 496.
                      tree block key (1204404224 a8 4096) level 1
 497.
                      tree block backref root 2
 498.
      failed to find block number 2178707456
 499.
      Aborted

Also at pastebin http://pastebin.com/m1e463204

Please advise. Thanks in advance for the assistance

Marc. 



This E-mail, including any attachments, may be intended solely for the personal 
and confidential use of the sender and recipient(s) named above. This message 
may include advisory, consultative and/or deliberative material and, as such, 
would be privileged and confidential and not a public document. Any Information 
in this e-mail identifying a client of the Department of Human Services is 
confidential. If you have received this e-mail in error, you must not review, 
transmit, convert to hard copy, copy, use or disseminate this e-mail or any 
attachments to it and you must delete this message. You are requested to notify 
the sender by return e-mail.
