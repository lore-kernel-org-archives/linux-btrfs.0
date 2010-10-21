From: dont <dontbeeeevil@gmail.com>
Subject: kernel bug during balancing in raid0
Date: Thu, 21 Oct 2010 15:22:09 -0400
Message-ID: <20101021192209.GA24743@cerasus.24.29.103.16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is my first ever mail for a mailing list!! This is exciting!!

Anyways, this is the scenario:

I have four 1TB drives that I've strapped together with the help of
btrfs using its built in RAID0.

The second and third drives that I added and subsequently balanced it
with:

btrfs-vol -b /mnt/raid0

went smooth without any reported errors and the command returned
cleanly.

Now since I compiled the new btrfs-utils form get a couple days ago I
noticed in the wiki there are command name changes so this time I used
this:

btrfs filesystem balance /mnt/raid0

and I can hear it doing stuff for a little while but then I get this
message in the terminal:

segmentation fault.

After this parts of my system become un-usable, like many commands get
stuck in the terminal not doing anything.

However the drive seems to have been added and I have not sufferend data
loss.

df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb              3.7T  1.7T  2.0T  46% /mnt/raid0

df
Filesystem           1K-blocks        Used  Available Use% Mounted on
/dev/sdb             3907050336 1779276448 2127773888  46% /mnt/raid0

dmesg shows something about this thing:

kernel BUG at fs/btrfs/extent-tree.c:2148!

oh I almost forgot my kernel is 2.6.35.

And the full dmesg output is below after the command I used.

btrfs filesystem balance /mnt/raid0/

[10040.981444] btrfs: relocating block group 6230205857792 flags 12
[10197.411858] btrfs: found 22355 extents
[10197.954791] btrfs: relocating block group 6226984632320 flags 9
[10198.501821] btrfs: relocating block group 6223763406848 flags 9
[10198.991431] btrfs: relocating block group 6220542181376 flags 9
[10199.522250] btrfs: relocating block group 6217320955904 flags 9
[10200.122756] btrfs: relocating block group 6214099730432 flags 9
[10200.641977] btrfs: relocating block group 6210878504960 flags 9
[10201.164459] btrfs: relocating block group 6207657279488 flags 9
[10201.662113] btrfs: relocating block group 6204436054016 flags 9
[10202.217882] btrfs: relocating block group 6201214828544 flags 9
[10202.757626] btrfs: relocating block group 6197993603072 flags 9
[10203.362371] btrfs: relocating block group 6194772377600 flags 9
[10203.868333] btrfs: relocating block group 6191551152128 flags 9
[10206.431497] btrfs: relocating block group 6188329926656 flags 9
[10207.094667] btrfs: relocating block group 6185108701184 flags 9
[10207.600651] btrfs: relocating block group 6181887475712 flags 9
[10208.355416] btrfs: relocating block group 6178666250240 flags 9
[10208.877984] btrfs: relocating block group 6175445024768 flags 9
[10209.582904] btrfs: relocating block group 6172223799296 flags 9
[10210.254746] btrfs: relocating block group 6169002573824 flags 9
[10210.843661] btrfs: relocating block group 6165781348352 flags 9
[10211.564444] btrfs: relocating block group 6162560122880 flags 9
[10212.162329] btrfs: relocating block group 6159338897408 flags 9
[10212.851535] btrfs: relocating block group 6156117671936 flags 9
[10213.445385] btrfs: relocating block group 6152896446464 flags 9
[10214.069966] btrfs: relocating block group 6149675220992 flags 9
[10214.756110] btrfs: relocating block group 6146453995520 flags 9
[10215.372133] btrfs: relocating block group 6143232770048 flags 9
[10215.911293] btrfs: relocating block group 6140011544576 flags 9
[10216.566483] btrfs: relocating block group 6136790319104 flags 9
[10217.205129] btrfs: relocating block group 6133569093632 flags 9
[10217.822784] btrfs: relocating block group 6130347868160 flags 9
[10218.416009] btrfs: relocating block group 6127126642688 flags 9
[10219.087872] btrfs: relocating block group 6123905417216 flags 9
[10219.734828] btrfs: relocating block group 6120684191744 flags 9
[10220.363728] btrfs: relocating block group 6117462966272 flags 9
[10220.987199] btrfs: relocating block group 6114241740800 flags 9
[10221.592132] btrfs: relocating block group 6111020515328 flags 9
[10222.264522] btrfs: relocating block group 6107799289856 flags 9
[10222.795290] btrfs: relocating block group 6104578064384 flags 9
[10223.450587] btrfs: relocating block group 6101356838912 flags 9
[10224.047699] btrfs: relocating block group 6098135613440 flags 9
[10224.586848] btrfs: relocating block group 6094914387968 flags 9
[10225.119203] btrfs: relocating block group 6091693162496 flags 9
[10225.706517] btrfs: relocating block group 6088471937024 flags 9
[10226.287043] btrfs: relocating block group 6085250711552 flags 9
[10226.834568] btrfs: relocating block group 6082029486080 flags 9
[10227.390150] btrfs: relocating block group 6078808260608 flags 9
[10227.954166] btrfs: relocating block group 6075587035136 flags 9
[10228.475583] btrfs: relocating block group 6072365809664 flags 9
[10229.148512] btrfs: relocating block group 6072097439744 flags 12
[10378.421912] btrfs: found 58060 extents
[10378.954956] btrfs: relocating block group 6068876214272 flags 9
[10379.510704] btrfs: relocating block group 6065654988800 flags 9
[10380.008041] btrfs: found 16 extents
[10382.000905] btrfs: found 16 extents
[10382.364463] btrfs: relocating block group 6062433763328 flags 9
[10388.567461] btrfs: found 555 extents
[10394.134759] btrfs: found 555 extents
[10394.522857] btrfs: relocating block group 6059212537856 flags 9
[10429.490145] btrfs: found 1704 extents
[10434.178702] btrfs: found 1704 extents
[10434.495818] btrfs: relocating block group 6055991312384 flags 9
[10472.702014] btrfs: found 692 extents
[10477.377791] btrfs: found 692 extents
[10477.600609] btrfs: relocating block group 6052770086912 flags 9
[10516.320215] btrfs: found 95465 extents
[10538.311122] btrfs: found 95465 extents
[10539.486622] btrfs: relocating block group 6049548861440 flags 9
[10584.131239] btrfs: found 4442 extents
[10606.305761] btrfs: found 4442 extents
[10606.790892] btrfs: relocating block group 6046327635968 flags 9
[10608.367230] btrfs: found 461 extents
[10612.213591] btrfs: found 461 extents
[10612.520683] btrfs: relocating block group 6043106410496 flags 9
[10616.677808] btrfs: found 590 extents
[10621.698849] btrfs: found 590 extents
[10622.033443] btrfs: relocating block group 6039885185024 flags 9
[10667.703853] btrfs: found 4286 extents
[10679.384468] btrfs: found 4286 extents
[10679.686517] btrfs: relocating block group 6036663959552 flags 9
[10727.409438] btrfs: found 15100 extents
[10745.491058] btrfs: found 15100 extents
[10745.961203] btrfs: relocating block group 6033442734080 flags 9
[10789.147454] btrfs: found 10211 extents
[10810.440277] btrfs: found 10211 extents
[10810.917645] btrfs: relocating block group 6030221508608 flags 9
[10812.101431] btrfs: found 112 extents
[10813.623103] btrfs: found 112 extents
[10814.311143] btrfs: relocating block group 6027000283136 flags 9
[10814.914292] btrfs: found 2 extents
[10816.264940] btrfs: found 2 extents
[10816.969948] btrfs: relocating block group 6023779057664 flags 9
[10817.890739] btrfs: found 54 extents
[10819.346472] btrfs: found 54 extents
[10819.880014] btrfs: relocating block group 6020557832192 flags 9
[10840.525170] btrfs: found 18763 extents
[10878.819886] btrfs: found 18763 extents
[10879.247239] btrfs: relocating block group 6017336606720 flags 9
[10881.256958] btrfs: found 1775 extents
[10884.949299] btrfs: found 1775 extents
[10885.231395] btrfs: relocating block group 6014115381248 flags 9
[10925.898722] btrfs: found 6997 extents
[10943.018433] btrfs: found 6997 extents
[10943.295111] btrfs: relocating block group 6010894155776 flags 9
[10969.980614] btrfs: found 17724 extents
[10998.682491] btrfs: found 17724 extents
[10999.358091] btrfs: relocating block group 6007672930304 flags 9
[11053.457422] btrfs: found 19863 extents
[11084.816220] btrfs: found 19863 extents
[11085.427041] btrfs: relocating block group 6004451704832 flags 9
[11126.320232] btrfs: found 546 extents
[11135.213641] btrfs: found 546 extents
[11136.122515] btrfs: relocating block group 6001230479360 flags 9
[11143.530409] btrfs: found 638 extents
[11148.216417] btrfs: found 638 extents
[11148.513126] btrfs: relocating block group 5998009253888 flags 9
[11189.263630] btrfs: found 1164 extents
[11193.289301] btrfs: found 1164 extents
[11193.679025] btrfs: relocating block group 5994788028416 flags 9
[11234.698271] btrfs: found 1185 extents
[11239.278542] btrfs: found 1185 extents
[11239.636468] btrfs: relocating block group 5991566802944 flags 9
[11272.096041] btrfs: found 1218 extents
[11277.962297] btrfs: found 1218 extents
[11278.414520] btrfs: relocating block group 5988345577472 flags 9
[11312.147923] btrfs: found 43298 extents
[11374.080658] btrfs: found 43298 extents
[11375.239684] btrfs: relocating block group 5985124352000 flags 9
[11418.037575] btrfs: found 4046 extents
[11429.936177] btrfs: found 4046 extents
[11430.431828] btrfs: relocating block group 5981903126528 flags 9
[11473.153910] btrfs: found 5440 extents
[11494.780298] btrfs: found 5440 extents
[11495.364547] btrfs: relocating block group 5978681901056 flags 9
[11536.326923] btrfs: found 1641 extents
[11542.306170] btrfs: found 1641 extents
[11542.722631] btrfs: relocating block group 5975460675584 flags 9
[11587.907543] btrfs: found 21101 extents
[11604.905517] btrfs: found 21101 extents
[11605.405882] btrfs: relocating block group 5972239450112 flags 9
[11650.253623] btrfs: found 57768 extents
[11679.796181] btrfs: found 57768 extents
[11680.504099] btrfs: relocating block group 5969018224640 flags 9
[11722.321146] btrfs: found 1639 extents
[11734.233418] btrfs: found 1639 extents
[11734.681078] btrfs: relocating block group 5965796999168 flags 9
[11738.461541] btrfs: found 430 extents
[11742.285240] btrfs: found 430 extents
[11742.787473] btrfs: relocating block group 5965528629248 flags 12
[11840.558670] btrfs: found 56833 extents
[11841.182185] btrfs: relocating block group 5962307403776 flags 9
[11868.792717] btrfs: found 43165 extents
[11876.958612] btrfs: found 43165 extents
[11877.624135] btrfs: relocating block group 5959086178304 flags 9
[11913.389672] btrfs: found 20783 extents
[11917.406456] btrfs: found 20783 extents
[11917.941681] btrfs: relocating block group 5955864952832 flags 9
[11956.186819] btrfs: found 22462 extents
[11960.880475] btrfs: found 22462 extents
[11961.437245] btrfs: relocating block group 5952643727360 flags 9
[12002.848985] btrfs: found 18419 extents
[12008.651334] btrfs: found 18419 extents
[12009.249375] btrfs: relocating block group 5949422501888 flags 9
[12048.222873] btrfs: found 1013 extents
[12052.957227] btrfs: found 1013 extents
[12053.348331] btrfs: relocating block group 5946201276416 flags 9
[12095.705613] btrfs: found 93 extents
[12097.230580] btrfs: found 93 extents
[12097.825115] btrfs: relocating block group 5942980050944 flags 9
[12133.416334] btrfs: found 750 extents
[12140.963969] btrfs: found 750 extents
[12141.336838] btrfs: relocating block group 5939758825472 flags 9
[12180.249850] btrfs: found 1439 extents
[12187.169629] btrfs: found 1439 extents
[12187.731441] btrfs: relocating block group 5936537600000 flags 9
[12227.069532] btrfs: found 14970 extents
[12234.031171] btrfs: found 14970 extents
[12234.594967] btrfs: relocating block group 5933316374528 flags 9
[12274.948019] btrfs: found 2434 extents
[12283.087421] btrfs: found 2434 extents
[12283.715651] btrfs: relocating block group 5930095149056 flags 9
[12323.410693] btrfs: found 429 extents
[12329.658284] btrfs: found 429 extents
[12330.302901] btrfs: relocating block group 5926873923584 flags 9
[12368.084618] btrfs: found 198 extents
[12373.664629] btrfs: found 198 extents
[12374.360688] btrfs: relocating block group 5923652698112 flags 9
[12413.531706] btrfs: found 618 extents
[12422.345080] btrfs: found 618 extents
[12422.849491] btrfs: relocating block group 5920431472640 flags 9
[12468.831732] btrfs: found 270 extents
[12476.321410] btrfs: found 270 extents
[12476.683896] btrfs: relocating block group 5917210247168 flags 9
[12514.795819] btrfs: found 5815 extents
[12529.226993] btrfs: found 5815 extents
[12529.531463] btrfs: relocating block group 5913989021696 flags 9
[12574.788110] btrfs: found 8603 extents
[12585.370183] btrfs: found 8603 extents
[12585.731601] btrfs: relocating block group 5910767796224 flags 9
[12622.470452] btrfs: found 2935 extents
[12627.871397] btrfs: found 2935 extents
[12628.386931] btrfs: relocating block group 5907546570752 flags 9
[12681.121118] btrfs: found 29 extents
[12688.976480] btrfs: found 29 extents
[12689.241495] btrfs: relocating block group 5904325345280 flags 9
[12738.811870] btrfs: found 6445 extents
[12750.990157] btrfs: found 6445 extents
[12751.604009] btrfs: relocating block group 5901104119808 flags 9
[12796.993292] btrfs: found 8926 extents
[12808.840737] btrfs: found 8926 extents
[12809.165261] btrfs: relocating block group 5897882894336 flags 9
[12847.379636] btrfs: found 1899 extents
[12852.529066] btrfs: found 1899 extents
[12852.764982] btrfs: relocating block group 5894661668864 flags 9
[12894.234880] btrfs: found 339 extents
[12898.958451] btrfs: found 339 extents
[12899.430774] btrfs: relocating block group 5891440443392 flags 9
[12945.157709] btrfs: found 146 extents
[12950.052557] btrfs: found 146 extents
[12950.410805] btrfs: relocating block group 5888219217920 flags 9
[12991.131446] btrfs: found 1825 extents
[12999.021408] btrfs: found 1825 extents
[12999.477186] btrfs: relocating block group 5884997992448 flags 9
[13042.953967] btrfs: found 63 extents
[13047.568764] btrfs: found 63 extents
[13047.996417] btrfs: relocating block group 5881776766976 flags 9
[13086.094860] btrfs: found 2891 exten: found 2891 extents
[13094.685677] btrfs: relocating block group 5878555541504 flags 9
[13147.274834] btrfs: found 22568 extents
[13156.941555] btrfs: found 22568 extents
[13157.502166] btrfs: relocating block group 5875334316032 flags 9
[13180.044370] btrfs: found 2646 extents
[13187.010683] btrfs: found 2646 extents
[13187.479147] btrfs: relocating block group 5872113090560 flags 9
[13239.644816] btrfs: found 7304 extents
[13250.968423] btrfs: found 7304 extents
[13251.576033] btrfs: relocating block group 5868891865088 flags 9
[13298.742192] btrfs: found 2618 extents
[13320.724640] btrfs: found 2618 extents
[13321.373916] btrfs: relocating block group 5865670639616 flags 9
[13358.940277] btrfs: found 3905 extents
[13369.211498] btrfs: found 3905 extents
[13369.591878] btrfs: relocating block group 5862449414144 flags 9
[13413.215252] btrfs: found 292 extents
[13420.033731] btrfs: found 292 extents
[13420.598294] btrfs: relocating block group 5859228188672 flags 9
[13460.639477] btrfs: found 60 extents
[13466.851411] btrfs: found 60 extents
[13467.344302] btrfs: relocating block group 5856006963200 flags 9
[13505.725792] btrfs: found 91 extents
[13511.199472] btrfs: found 91 extents
[13511.607883] btrfs: relocating block group 5852785737728 flags 9
[13554.171165] btrfs: found 2553 extents
[13563.676945] btrfs: found 2553 extents
[13564.164240] btrfs: relocating block group 5849564512256 flags 9
[13622.953579] btrfs: found 9085 extents
[13641.106741] btrfs: found 9085 extents
[13641.747013] btrfs: relocating block group 5846343286784 flags 9
[13687.099538] btrfs: found 2864 extents
[13703.909254] btrfs: found 2864 extents
[13705.189821] btrfs: relocating block group 5843122061312 flags 9
[13752.695044] btrfs: found 2864 extents
[13769.695326] btrfs: found 2864 extents
[13770.344572] btrfs: relocating block group 5839900835840 flags 9
[13814.835965] btrfs: found 969 extents
[13825.579251] btrfs: found 969 extents
[13826.330953] btrfs: relocating block group 5836679610368 flags 9
[13867.297913] btrfs: found 4687 extents
[13877.952198] btrfs: found 4687 extents
[13878.726964] btrfs: relocating block group 5833458384896 flags 9
[13923.700494] btrfs: found 162 extents
[13932.631643] btrfs: found 162 extents
[13933.047776] btrfs: relocating block group 5830237159424 flags 9
[14031.064601] btrfs: found 94 extents
[14036.209560] btrfs: found 94 extents
[14036.524396] btrfs: relocating block group 5827015933952 flags 9
[14079.564431] btrfs: found 365 extents
[14087.563858] btrfs: found 365 extents
[14087.807027] btrfs: relocating block group 5823794708480 flags 9
[14136.718488] btrfs: found 2343 extents
[14150.042976] btrfs: found 2343 extents
[14150.726978] btrfs: relocating block group 5820573483008 flags 9
[14194.222367] btrfs: found 297 extents
[14202.876128] btrfs: found 297 extents
[14203.351768] btrfs: relocating block group 5817352257536 flags 9
[14257.191438] btrfs: found 657 extents
[14263.885962] btrfs: found 657 extents
[14264.065707] btrfs: relocating block group 5814131032064 flags 9
[14314.393110] btrfs: found 4835 extents
[14322.539940] btrfs: found 4835 extents
[14322.769534] btrfs: relocating block group 5810909806592 flags 9
[14378.597203] btrfs: found 15580 extents
[14389.090886] btrfs: found 15580 extents
[14389.462655] btrfs: relocating block group 5807688581120 flags 9
[14438.366646] btrfs: found 320 extents
[14443.059071] btrfs: found 320 extents
[14443.254484] btrfs: relocating block group 5804467355648 flags 9
[14480.041583] btrfs: found 667 extents
[14484.055491] btrfs: found 667 extents
[14484.237857] btrfs: relocating block group 5801246130176 flags 9
[14522.183243] btrfs: found 3110 extents
[14531.338003] btrfs: found 3110 extents
[14531.602133] btrfs: relocating block group 5798024904704 flags 9
[14573.600709] btrfs: found 3693 extents
[14580.628735] btrfs: found 3693 extents
[14580.886173] btrfs: relocating block group 5794803679232 flags 9
[14617.423704] btrfs: found 3752 extents
[14623.361683] btrfs: found 3752 extents
[14623.649284] btrfs: relocating block group 5791582453760 flags 9
[14660.70 group 5752927748096 flags 9
[15348.853814] btrfs: found 48466 extents
[15372.164966] btrfs: found 48466 extents
[15373.366265] btrfs: relocating block group 5752659378176 flags 12
[15506.503573] btrfs: found 61528 extents
[15506.858843] btrfs: relocating block group 5749438152704 flags 9
[15566.118866] btrfs: found 35948 extents
[15582.425850] btrfs: found 35948 extents
[15583.020391] btrfs: relocating block group 5749169782784 flags 12
[15660.238681] btrfs: found 61746 extents
[15660.919927] btrfs: relocating block group 5748901412864 flags 12
[15790.565276] btrfs: found 61290 extents
[15791.138295] btrfs: relocating block group 5745680187392 flags 9
[15853.725805] btrfs: found 41636 extents
[15876.684424] btrfs: found 41636 extents
[15877.469942] btrfs: relocating block group 5742458961920 flags 9
[15940.432985] btrfs: found 10069 extents
[15948.403268] btrfs: found 10069 extents
[15948.772912] btrfs: relocating block group 5739237736448 flags 9
[16048.392521] btrfs: found 29968 extents
[16061.695657] btrfs: found 29968 extents
[16062.382222] btrfs: relocating block group 5736016510976 flags 9
[16113.827645] btrfs: found 38182 extents
[16124.541791] btrfs: found 38182 extents
[16125.176750] btrfs: relocating block group 5732795285504 flags 9
[16160.841772] btrfs: found 21009 extents
[16167.214309] btrfs: found 21009 extents
[16167.645556] btrfs: relocating block group 5729574060032 flags 9
[16203.050083] btrfs: found 22310 extents
[16212.487034] btrfs: found 22310 extents
[16213.055410] btrfs: relocating block group 5726352834560 flags 9
[16247.748032] btrfs: found 7775 extents
[16254.895423] btrfs: found 7775 extents
[16255.271097] btrfs: relocating block group 5723131609088 flags 9
[16295.130334] btrfs: found 10892 extents
[16302.100080] btrfs: found 10892 extents
[16303.569600] btrfs: relocating block group 5719910383616 flags 9
[16337.254957] btrfs: found 6167 extents
[16344.357233] btrfs: found 6167 extents
[16344.681886] btrfs: relocating block group 5716689158144 flags 9
[16377.863245] btrfs: found 9190 extents
[16391.326852] btrfs: found 9190 extents
[16391.724712] btrfs: relocating block group 5713467932672 flags 9
[16444.137916] btrfs: found 19036 extents
[16473.166632] btrfs: found 19036 extents
[16473.974903] btrfs: relocating block group 5710246707200 flags 9
[16508.319974] btrfs: found 7719 extents
[16514.546926] btrfs: found 7719 extents
[16515.014290] btrfs: relocating block group 5707025481728 flags 9
[16548.919245] btrfs: found 3919 extents
[16555.064691] btrfs: found 3919 extents
[16555.352208] btrfs: relocating block group 5703804256256 flags 9
[16595.080692] btrfs: found 8714 extents
[16606.610425] btrfs: found 8714 extents
[16606.960952] btrfs: relocating block group 5700583030784 flags 9
[16640.974505] btrfs: found 573 extents
[16645.750890] btrfs: found 573 extents
[16646.139641] btrfs: relocating block group 5697361805312 flags 9
[16681.009859] btrfs: found 4781 extents
[16687.059858] btrfs: found 4781 extents
[16687.599993] btrfs: relocating block group 5697093435392 flags 12
[16781.978590] btrfs: found 60820 extents
[16782.255155] btrfs: relocating block group 5693872209920 flags 9
[16821.444228] btrfs: found 5823 extents
[16827.092512] btrfs: found 5823 extents
[16827.420657] btrfs: relocating block group 5690650984448 flags 9
[16860.044636] btrfs: found 4942 extents
[16865.510838] btrfs: found 4942 extents
[16865.881582] btrfs: relocating block group 5690382614528 flags 12
[17017.273257] btrfs: found 52120 extents
[17017.768740] btrfs: relocating block group 5687161389056 flags 9
[17053.701817] btrfs: found 2787 extents
[17064.291512] btrfs: found 2787 extents
[17064.547360] btrfs: relocating block group 5686893019136 flags 12
[17117.101967] leaf 5513411411968 total ptrs 42 free space 470
[17117.101972] 	item 0 key (5687045914624 a8 4096) itemoff 3935 itemsize
60
[17117.101975] 		extent refs 2 gen 774097 flags 2
[17117.101977] 		tree block key (1316294 1 0) level 0
[17117.101979] 		shared block backref parent 5643272757248
[17117.101980] 		shared block backref parent 5512908656640
[17117.1l 0
[17117.102114] 		shared block backref parent 5641845055488
[17117.102116] 		shared block backref parent 5513427140608
[17117.102118] 	item 17 key (5687045980160 a8 4096) itemoff 2915
itemsize 51
[17117.102120] 		extent refs 1 gen 802517 flags 2
[17117.102121] 		tree block key (18446744073709551606 80
5432148566016) level 0
[17117.102123] 		tree block backref root 7
[17117.102125] 	item 18 key (5687045984256 a8 4096) itemoff 2855
itemsize 60
[17117.102127] 		extent refs 2 gen 802517 flags 2
[17117.102128] 		tree block key (2231429 1 0) level 0
[17117.102130] 		shared block backref parent 5687028011008
[17117.102131] 		shared block backref parent 5513494880256
[17117.102133] 	item 19 key (5687045988352 a8 4096) itemoff 2804
itemsize 51
[17117.102135] 		extent refs 1 gen 774056 flags 2
[17117.102137] 		tree block key (4483941728256 a8 4096) level 0
[17117.102138] 		tree block backref root 2
[17117.102140] 	item 20 key (5687045992448 a8 4096) itemoff 2744
itemsize 60
[17117.102142] 		extent refs 2 gen 773054 flags 2
[17117.102143] 		tree block key (839465 60 401) level 0
[17117.102145] 		shared block backref parent 5641683312640
[17117.102146] 		shared block backref parent 5513371439104
[17117.102148] 	item 21 key (5687045996544 a8 4096) itemoff 2684
itemsize 60
[17117.102150] 		extent refs 2 gen 774097 flags 2
[17117.102151] 		tree block key (1325036 1 0) level 0
[17117.102153] 		shared block backref parent 5487845535744
[17117.102154] 		shared block backref parent 4483077029888
[17117.102156] 	item 22 key (5687046000640 a8 4096) itemoff 2624
itemsize 60
[17117.102158] 		extent refs 2 gen 802517 flags 2
[17117.102160] 		tree block key (2231428 6c 0) level 0
[17117.102161] 		shared block backref parent 5687028011008
[17117.102163] 		shared block backref parent 5513494880256
[17117.102164] 	item 23 key (5687046004736 a8 4096) itemoff 2573
itemsize 51
[17117.102166] 		extent refs 1 gen 802519 flags 2
[17117.102168] 		tree block key (2234263 c 2233723) level 0
[17117.102169] 		tree block backref root 5
[17117.102171] 	item 24 key (5687046008832 a8 4096) itemoff 2513
itemsize 60
[17117.102173] 		extent refs 2 gen 772435 flags 2
[17117.102175] 		tree block key (990800 1 0) level 0
[17117.102176] 		shared block backref parent 5643047448576
[17117.102177] 		shared block backref parent 5513496764416
[17117.102179] 	item 25 key (5687046017024 a8 4096) itemoff 2462
itemsize 51
[17117.102181] 		extent refs 1 gen 802517 flags 2
[17117.102183] 		tree block key (5430686355456 a8 4096) level 0
[17117.102184] 		tree block backref root 2
[17117.102186] 	item 26 key (5687046021120 a8 4096) itemoff 2402
itemsize 60
[17117.102188] 		extent refs 2 gen 773032 flags 2
[17117.102189] 		tree block key (841818 60 308) level 0
[17117.102191] 		shared block backref parent 5513411293184
[17117.102192] 		shared block backref parent 4483207266304
[17117.102194] 	item 27 key (5687046025216 a8 4096) itemoff 2342
itemsize 60
[17117.102196] 		extent refs 2 gen 774094 flags 2
[17117.102198] 		tree block key (1342959 1 0) level 0
[17117.102199] 		shared block backref parent 5512685510656
[17117.102201] 		shared block backref parent 4482994823168
[17117.102203] 	item 28 key (5687046029312 a8 4096) itemoff 2282
itemsize 60
[17117.102204] 		extent refs 2 gen 774097 flags 2
[17117.102206] 		tree block key (1324995 c 839006) level 0
[17117.102207] 		shared block backref parent 5487845535744
[17117.102209] 		shared block backref parent 4483077029888
[17117.102211] 	item 29 key (5687046033408 a8 4096) itemoff 2222
itemsize 60
[17117.102213] 		extent refs 2 gen 774094 flags 2
[17117.102215] 		tree block key (1343598 18 3198782427) level 0
[17117.102216] 		shared block backref parent 5512685510656
[17117.102217] 		shared block backref parent 4482994823168
[17117.102219] 	item 30 key (5687046037504 a8 4096) itemoff 2162
itemsize 60
[17117.102221] 		extent refs 2 gen 802517 flags 2
[17117.102223] 		tree block key (2231438 1 0) level 0
[17117.102224] 		shared block backref parent 5687028011008
[17117.102226] 		shared block backref parent 5513494880256
[17117.102228] 	i.102546]  [<ffffffff8103d131>] ?
get_parent_ip+0x11/0x50
[17117.102551]  [<ffffffff8103d131>] ? get_parent_ip+0x11/0x50
[17117.102557]  [<ffffffff81202672>] run_clustered_refs+0x4d2/0x7f0
[17117.102563]  [<ffffffff81202a50>] btrfs_run_delayed_refs+0xc0/0x210
[17117.102569]  [<ffffffff81213647>] __btrfs_end_transaction+0x67/0x220
[17117.102575]  [<ffffffff811fedd6>] ? btrfs_block_rsv_check+0x86/0x170
[17117.102580]  [<ffffffff8121380e>]
btrfs_end_transaction_throttle+0xe/0x10
[17117.102586]  [<ffffffff8125585c>] relocate_block_group+0x3dc/0x5c0
[17117.102592]  [<ffffffff81255b18>]
btrfs_relocate_block_group+0xd8/0x270
[17117.102598]  [<ffffffff812380e3>] btrfs_relocate_chunk+0x83/0x620
[17117.102603]  [<ffffffff81236328>] ? map_extent_buffer+0xd8/0xf0
[17117.102608]  [<ffffffff8103d915>] ? sub_preempt_count+0x95/0xd0
[17117.102613]  [<ffffffff81233d3e>] ? unmap_extent_buffer+0xe/0x40
[17117.102618]  [<ffffffff812247ac>] ? btrfs_item_offset+0xdc/0xf0
[17117.102624]  [<ffffffff81238f73>] btrfs_balance+0x203/0x280
[17117.102630]  [<ffffffff8110aa8c>] ? path_put+0x2c/0x40
[17117.102635]  [<ffffffff812412d0>] btrfs_ioctl+0x300/0x980
[17117.102639]  [<ffffffff8103d131>] ? get_parent_ip+0x11/0x50
[17117.102644]  [<ffffffff8103d915>] ? sub_preempt_count+0x95/0xd0
[17117.102651]  [<ffffffff814827b5>] ? _raw_spin_unlock+0x15/0x40
[17117.102656]  [<ffffffff8110f938>] vfs_ioctl+0x38/0xd0
[17117.102661]  [<ffffffff8110ff00>] do_vfs_ioctl+0x80/0x520
[17117.102667]  [<ffffffff81110419>] sys_ioctl+0x79/0x90
[17117.102673]  [<ffffffff81002e82>] system_call_fastpath+0x16/0x1b
[17117.102677] ---[ end trace 6a6f5b9ed6855ece ]---
[17117.102681] btrfs unable to find ref byte nr 5687045951488 parent 0
root 5  owner 0 offset 0
[17117.102696] ------------[ cut here ]------------
[17117.102700] kernel BUG at fs/btrfs/extent-tree.c:2148!
[17117.102704] invalid opcode: 0000 [#1] PREEMPT SMP 
[17117.102711] last sysfs file:
/sys/devices/pci0000:00/0000:00:05.2/host6/uevent
[17117.102715] CPU 2 
[17117.102718] Modules linked in: ntfs af_packet nfsd lockd auth_rpcgss
sunrpc nvidia(P) agpgart ipv6 arc4 ecb zd1211rw mac80211 cfg80211 nvram
ledtrig_gpio ledtrig_backlight ledtrig_default_on ledtrig_heartbeat
ledtrig_timer cachefiles fscache configs configfs snd_hwdep snd_hrtimer
snd_seq_midi snd_seq_midi_event snd_seq display lcd video output
power_meter bridge stp llc tun adm1021 adm1025 hwmon_vid i2c_dev
powernow_k8 mperf cpufreq_ondemand cpufreq_performance cpufreq_powersave
cpufreq_stats cpufreq_conservative freq_table mce_inject snd_ice1712
snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_cs8427 snd_ac97_codec snd_pcm
snd_timer snd_page_alloc ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device rtc_cmos rtc_core rtc_lib snd soundcore k10temp evdev
processor fan thermal forcedeth thermal_sys i2c_nforce2 i2c_core
asus_atk0110 hwmon unix
[17117.102836] 
[17117.102840] Pid: 10828, comm: btrfs Tainted: P        W
2.6.35-gentoo-r10 #6 M2N-SLI DELUXE/System Product Name
[17117.102844] RIP: 0010:[<ffffffff8120267a>]  [<ffffffff8120267a>]
run_clustered_refs+0x4da/0x7f0
[17117.102851] RSP: 0018:ffff8801b3df1998  EFLAGS: 00010282
[17117.102854] RAX: 00000000fffffffe RBX: ffff8802143b4e40 RCX:
ffff88019fd62cf0
[17117.102858] RDX: 0000000000000000 RSI: ffffea0005af6d70 RDI:
0000000000000206
[17117.102862] RBP: ffff8801b3df1a78 R08: ffff8801b3df1858 R09:
0000000000000000
[17117.102866] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[17117.102869] R13: ffff88020ca43c00 R14: ffff88023d357800 R15:
ffff88023a40b280
[17117.102874] FS:  00007fd4ca00f740(0000) GS:ffff880001b00000(0000)
knlGS:0000000000000000
[17117.102878] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[17117.102881] CR2: 00007fb967010000 CR3: 00000001b2d44000 CR4:
00000000000006e0
[17117.102885] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[17117.102889] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[17117.102893] Process btrfs (pid: 10828, threadinfo ffff8801b3df0000,
task ffff8801e1e95e40)
[17117.102897] Stack:
[17117.102899]  00000000000000
