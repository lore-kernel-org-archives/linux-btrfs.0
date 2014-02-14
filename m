Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:37819 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaBNTZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 14:25:31 -0500
Date: Fri, 14 Feb 2014 20:25:26 +0100
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
Message-ID: <20140214202526.3199f6cc@datenkhaos.de>
In-Reply-To: <52F3FC72.3020603@fb.com>
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
	<20140203192811.72866921@datenkhaos.de>
	<52F00538.3010505@fb.com>
	<20140203235334.791312d1@datenkhaos.de>
	<52F0F566.1090206@fb.com>
	<20140205091428.076fa15c@datenkhaos.de>
	<52F25D7B.90807@fb.com>
	<20140205183406.47023d24@datenkhaos.de>
	<52F28A69.8050804@fb.com>
	<20140205203023.535d6f96@datenkhaos.de>
	<52F292C7.7030701@fb.com>
	<20140205224250.7876dd16@datenkhaos.de>
	<52F2B151.70307@fb.com>
	<20140205235732.04263a51@datenkhaos.de>
	<52F3FC72.3020603@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 Feb 2014 16:19:46 -0500
Josef Bacik <jbacik@fb.com> wrote:

> Ok so I thought I reproduced the problem but I just reproduced a
> different problem.  Please undo any changes you've made and apply
> this patch and reproduce and then provide me with any debug output
> that gets spit out.  I'm sending this via thunderbird with 6
> different extensions to make sure it comes out right so if it doesn't
> work let me know and I'll just paste it somewhere.  Thanks,

Sorry for the long delay. Was to busy last week.

Here is the output:

[   25.240971] looped a lot, count 14, nr 32, no_selected_ref 99986
[   25.267639] looped a lot, count 14, nr 32, no_selected_ref 199987
[   25.294308] looped a lot, count 14, nr 32, no_selected_ref 299988
[   25.320605] looped a lot, count 14, nr 32, no_selected_ref 399989
[   25.346639] looped a lot, count 14, nr 32, no_selected_ref 499990
[   25.372517] looped a lot, count 14, nr 32, no_selected_ref 599991
[   25.398924] looped a lot, count 14, nr 32, no_selected_ref 699992
[   25.425443] looped a lot, count 14, nr 32, no_selected_ref 799993
[   25.451344] looped a lot, count 14, nr 32, no_selected_ref 899994
[   25.477350] looped a lot, count 14, nr 32, no_selected_ref 999995
[   25.503069] looped a lot, count 14, nr 32, no_selected_ref 1099996
[   25.529372] looped a lot, count 14, nr 32, no_selected_ref 1199997
[   25.555549] looped a lot, count 14, nr 32, no_selected_ref 1299998
[   25.581418] looped a lot, count 14, nr 32, no_selected_ref 1399999
[   25.607514] looped a lot, count 14, nr 32, no_selected_ref 1500000
[   25.633794] looped a lot, count 14, nr 32, no_selected_ref 1600001
[   25.659699] looped a lot, count 14, nr 32, no_selected_ref 1700002
[   25.686095] looped a lot, count 14, nr 32, no_selected_ref 1800003
[   25.711906] looped a lot, count 14, nr 32, no_selected_ref 1900004
[   25.752255] looped a lot, count 14, nr 32, no_selected_ref 2000005
[   25.788077] looped a lot, count 0, nr 32, no_selected_ref 100000
[   25.811966] looped a lot, count 14, nr 32, no_selected_ref 2100006
[  360.749227] looped a lot, count 8, nr 32, no_selected_ref 99992
[  360.770434] looped a lot, count 8, nr 32, no_selected_ref 199993
[  360.792136] looped a lot, count 8, nr 32, no_selected_ref 299994
[  360.813571] looped a lot, count 8, nr 32, no_selected_ref 399995
[  360.834932] looped a lot, count 8, nr 32, no_selected_ref 499996
[  360.856085] looped a lot, count 8, nr 32, no_selected_ref 599997
[  360.877374] looped a lot, count 8, nr 32, no_selected_ref 699998
[  360.899455] looped a lot, count 8, nr 32, no_selected_ref 799999
[  360.921175] looped a lot, count 8, nr 32, no_selected_ref 900000
[  360.942409] looped a lot, count 8, nr 32, no_selected_ref 1000001
[  360.963800] looped a lot, count 8, nr 32, no_selected_ref 1100002
[  360.985397] looped a lot, count 8, nr 32, no_selected_ref 1200003
[  361.007148] looped a lot, count 8, nr 32, no_selected_ref 1300004
[  361.028789] looped a lot, count 8, nr 32, no_selected_ref 1400005
[  361.050564] looped a lot, count 8, nr 32, no_selected_ref 1500006
[  361.072008] looped a lot, count 8, nr 32, no_selected_ref 1600007
[  361.093269] looped a lot, count 8, nr 32, no_selected_ref 1700008
[  361.114645] looped a lot, count 8, nr 32, no_selected_ref 1800009
[  361.136099] looped a lot, count 8, nr 32, no_selected_ref 1900010
[  361.157566] looped a lot, count 8, nr 32, no_selected_ref 2000011
[  361.178969] looped a lot, count 8, nr 32, no_selected_ref 2100012
[  361.200397] looped a lot, count 8, nr 32, no_selected_ref 2200013
[  361.221980] looped a lot, count 8, nr 32, no_selected_ref 2300014
[  361.243435] looped a lot, count 8, nr 32, no_selected_ref 2400015
[  361.264777] looped a lot, count 8, nr 32, no_selected_ref 2500016
[  361.286518] looped a lot, count 8, nr 32, no_selected_ref 2600017
[  361.308240] looped a lot, count 8, nr 32, no_selected_ref 2700018
[  361.329850] looped a lot, count 8, nr 32, no_selected_ref 2800019
[  361.351420] looped a lot, count 8, nr 32, no_selected_ref 2900020
[  361.372633] looped a lot, count 8, nr 32, no_selected_ref 3000021
[  361.394330] looped a lot, count 8, nr 32, no_selected_ref 3100022
[  361.416039] looped a lot, count 8, nr 32, no_selected_ref 3200023
[  361.437659] looped a lot, count 8, nr 32, no_selected_ref 3300024
[  361.459181] looped a lot, count 8, nr 32, no_selected_ref 3400025
[  361.481058] looped a lot, count 8, nr 32, no_selected_ref 3500026
[  361.502441] looped a lot, count 8, nr 32, no_selected_ref 3600027
[  361.523964] looped a lot, count 8, nr 32, no_selected_ref 3700028
[  361.545387] looped a lot, count 8, nr 32, no_selected_ref 3800029
[  361.566717] looped a lot, count 8, nr 32, no_selected_ref 3900030
[  361.588079] looped a lot, count 8, nr 32, no_selected_ref 4000031
[  361.609673] looped a lot, count 8, nr 32, no_selected_ref 4100032
[  361.631028] looped a lot, count 8, nr 32, no_selected_ref 4200033
[  361.652498] looped a lot, count 8, nr 32, no_selected_ref 4300034
[  361.673928] looped a lot, count 8, nr 32, no_selected_ref 4400035
[  361.695360] looped a lot, count 8, nr 32, no_selected_ref 4500036
[  361.716931] looped a lot, count 8, nr 32, no_selected_ref 4600037
[  361.738483] looped a lot, count 8, nr 32, no_selected_ref 4700038
[  361.759869] looped a lot, count 8, nr 32, no_selected_ref 4800039
[  361.781233] looped a lot, count 8, nr 32, no_selected_ref 4900040
[  361.802583] looped a lot, count 8, nr 32, no_selected_ref 5000041
[  361.823978] looped a lot, count 8, nr 32, no_selected_ref 5100042
[  361.845326] looped a lot, count 8, nr 32, no_selected_ref 5200043
[  361.866800] looped a lot, count 8, nr 32, no_selected_ref 5300044
[  361.888344] looped a lot, count 8, nr 32, no_selected_ref 5400045
[  361.909774] looped a lot, count 8, nr 32, no_selected_ref 5500046
[  361.931973] looped a lot, count 8, nr 32, no_selected_ref 5600047
[  361.953859] looped a lot, count 8, nr 32, no_selected_ref 5700048
[  361.975572] looped a lot, count 8, nr 32, no_selected_ref 5800049
[  361.997023] looped a lot, count 8, nr 32, no_selected_ref 5900050
[  362.018684] looped a lot, count 8, nr 32, no_selected_ref 6000051
[  362.040180] looped a lot, count 8, nr 32, no_selected_ref 6100052
[  362.061715] looped a lot, count 8, nr 32, no_selected_ref 6200053
[  362.083493] looped a lot, count 8, nr 32, no_selected_ref 6300054
[  362.105084] looped a lot, count 8, nr 32, no_selected_ref 6400055
[  362.126530] looped a lot, count 8, nr 32, no_selected_ref 6500056
[  362.147787] looped a lot, count 8, nr 32, no_selected_ref 6600057
[  362.169122] looped a lot, count 8, nr 32, no_selected_ref 6700058
[  362.190554] looped a lot, count 8, nr 32, no_selected_ref 6800059
[  362.211914] looped a lot, count 8, nr 32, no_selected_ref 6900060
[  362.233366] looped a lot, count 8, nr 32, no_selected_ref 7000061
[  362.254853] looped a lot, count 8, nr 32, no_selected_ref 7100062
[  362.276623] looped a lot, count 8, nr 32, no_selected_ref 7200063
[  362.298133] looped a lot, count 8, nr 32, no_selected_ref 7300064
[  362.319708] looped a lot, count 8, nr 32, no_selected_ref 7400065
[  362.341379] looped a lot, count 8, nr 32, no_selected_ref 7500066
[  362.362752] looped a lot, count 8, nr 32, no_selected_ref 7600067
[  362.384074] looped a lot, count 8, nr 32, no_selected_ref 7700068
[  362.405274] looped a lot, count 8, nr 32, no_selected_ref 7800069
[  362.426603] looped a lot, count 8, nr 32, no_selected_ref 7900070
[  362.447885] looped a lot, count 8, nr 32, no_selected_ref 8000071
[  362.469246] looped a lot, count 8, nr 32, no_selected_ref 8100072
[  362.491065] looped a lot, count 8, nr 32, no_selected_ref 8200073
[  362.512658] looped a lot, count 8, nr 32, no_selected_ref 8300074
[  362.534073] looped a lot, count 8, nr 32, no_selected_ref 8400075
[  362.555552] looped a lot, count 8, nr 32, no_selected_ref 8500076
[  362.577102] looped a lot, count 8, nr 32, no_selected_ref 8600077
[  362.598589] looped a lot, count 8, nr 32, no_selected_ref 8700078
[  362.620210] looped a lot, count 8, nr 32, no_selected_ref 8800079
[  362.641682] looped a lot, count 8, nr 32, no_selected_ref 8900080
[  362.663321] looped a lot, count 8, nr 32, no_selected_ref 9000081
[  362.684743] looped a lot, count 8, nr 32, no_selected_ref 9100082
[  362.706412] looped a lot, count 8, nr 32, no_selected_ref 9200083
[  362.727894] looped a lot, count 8, nr 32, no_selected_ref 9300084
[  362.749706] looped a lot, count 8, nr 32, no_selected_ref 9400085
[  362.771509] looped a lot, count 8, nr 32, no_selected_ref 9500086
[  362.793361] looped a lot, count 8, nr 32, no_selected_ref 9600087
[  362.814870] looped a lot, count 8, nr 32, no_selected_ref 9700088
[  362.836327] looped a lot, count 8, nr 32, no_selected_ref 9800089
[  362.857664] looped a lot, count 8, nr 32, no_selected_ref 9900090
[  362.879472] looped a lot, count 8, nr 32, no_selected_ref 10000091
[  362.901027] looped a lot, count 8, nr 32, no_selected_ref 10100092
[  362.922354] looped a lot, count 8, nr 32, no_selected_ref 10200093
[  362.943738] looped a lot, count 8, nr 32, no_selected_ref 10300094
[  362.965155] looped a lot, count 8, nr 32, no_selected_ref 10400095
[  362.986662] looped a lot, count 8, nr 32, no_selected_ref 10500096
[  363.008007] looped a lot, count 8, nr 32, no_selected_ref 10600097
[  363.029425] looped a lot, count 8, nr 32, no_selected_ref 10700098
[  363.050763] looped a lot, count 8, nr 32, no_selected_ref 10800099
[  363.072534] looped a lot, count 8, nr 32, no_selected_ref 10900100
[  363.094240] looped a lot, count 8, nr 32, no_selected_ref 11000101
[  363.115942] looped a lot, count 8, nr 32, no_selected_ref 11100102
[  363.137657] looped a lot, count 8, nr 32, no_selected_ref 11200103
[  363.158938] looped a lot, count 8, nr 32, no_selected_ref 11300104
[  363.180332] looped a lot, count 8, nr 32, no_selected_ref 11400105
[  363.201775] looped a lot, count 8, nr 32, no_selected_ref 11500106
[  363.223247] looped a lot, count 8, nr 32, no_selected_ref 11600107
[  363.244772] looped a lot, count 8, nr 32, no_selected_ref 11700108
[  363.266491] looped a lot, count 8, nr 32, no_selected_ref 11800109
[  363.288122] looped a lot, count 8, nr 32, no_selected_ref 11900110
[  363.309474] looped a lot, count 8, nr 32, no_selected_ref 12000111
[  363.331045] looped a lot, count 8, nr 32, no_selected_ref 12100112
[  363.352557] looped a lot, count 8, nr 32, no_selected_ref 12200113
[  363.373953] looped a lot, count 8, nr 32, no_selected_ref 12300114
[  363.395317] looped a lot, count 8, nr 32, no_selected_ref 12400115
[  363.416671] looped a lot, count 8, nr 32, no_selected_ref 12500116
[  363.438159] looped a lot, count 8, nr 32, no_selected_ref 12600117
[  363.459492] looped a lot, count 8, nr 32, no_selected_ref 12700118
[  363.481107] looped a lot, count 8, nr 32, no_selected_ref 12800119
[  363.502414] looped a lot, count 8, nr 32, no_selected_ref 12900120
[  363.523811] looped a lot, count 8, nr 32, no_selected_ref 13000121
[  363.545350] looped a lot, count 8, nr 32, no_selected_ref 13100122
[  363.566799] looped a lot, count 8, nr 32, no_selected_ref 13200123
[  363.588588] looped a lot, count 8, nr 32, no_selected_ref 13300124
[  363.609956] looped a lot, count 8, nr 32, no_selected_ref 13400125
[  363.631435] looped a lot, count 8, nr 32, no_selected_ref 13500126
[  363.652845] looped a lot, count 8, nr 32, no_selected_ref 13600127
[  363.674150] looped a lot, count 8, nr 32, no_selected_ref 13700128
[  363.695320] looped a lot, count 8, nr 32, no_selected_ref 13800129
[  363.716674] looped a lot, count 8, nr 32, no_selected_ref 13900130
[  363.738236] looped a lot, count 8, nr 32, no_selected_ref 14000131
[  363.760047] looped a lot, count 8, nr 32, no_selected_ref 14100132
[  363.781534] looped a lot, count 8, nr 32, no_selected_ref 14200133
[  363.803040] looped a lot, count 8, nr 32, no_selected_ref 14300134
[  363.824479] looped a lot, count 8, nr 32, no_selected_ref 14400135
[  363.846132] looped a lot, count 8, nr 32, no_selected_ref 14500136
[  363.867889] looped a lot, count 8, nr 32, no_selected_ref 14600137
[  363.889092] looped a lot, count 8, nr 32, no_selected_ref 14700138
[  363.910906] looped a lot, count 8, nr 32, no_selected_ref 14800139
[  363.932526] looped a lot, count 8, nr 32, no_selected_ref 14900140
[  363.954255] looped a lot, count 8, nr 32, no_selected_ref 15000141
[  363.975972] looped a lot, count 8, nr 32, no_selected_ref 15100142
[  363.997615] looped a lot, count 8, nr 32, no_selected_ref 15200143
[  364.019092] looped a lot, count 8, nr 32, no_selected_ref 15300144
[  364.040501] looped a lot, count 8, nr 32, no_selected_ref 15400145
[  364.061895] looped a lot, count 8, nr 32, no_selected_ref 15500146
[  364.083585] looped a lot, count 8, nr 32, no_selected_ref 15600147
[  364.105070] looped a lot, count 8, nr 32, no_selected_ref 15700148
[  364.126723] looped a lot, count 8, nr 32, no_selected_ref 15800149
[  364.148449] looped a lot, count 8, nr 32, no_selected_ref 15900150
[  364.170233] looped a lot, count 8, nr 32, no_selected_ref 16000151
[  364.191596] looped a lot, count 8, nr 32, no_selected_ref 16100152
[  364.213065] looped a lot, count 8, nr 32, no_selected_ref 16200153
[  364.234895] looped a lot, count 8, nr 32, no_selected_ref 16300154
[  364.256348] looped a lot, count 8, nr 32, no_selected_ref 16400155
[  364.277868] looped a lot, count 8, nr 32, no_selected_ref 16500156
[  364.299398] looped a lot, count 8, nr 32, no_selected_ref 16600157
[  364.320699] looped a lot, count 8, nr 32, no_selected_ref 16700158
[  364.342358] looped a lot, count 8, nr 32, no_selected_ref 16800159
[  364.364065] looped a lot, count 8, nr 32, no_selected_ref 16900160
[  364.385906] looped a lot, count 8, nr 32, no_selected_ref 17000161
[  364.407646] looped a lot, count 8, nr 32, no_selected_ref 17100162
[  364.429217] looped a lot, count 8, nr 32, no_selected_ref 17200163
[  364.450834] looped a lot, count 8, nr 32, no_selected_ref 17300164
[  364.472390] looped a lot, count 8, nr 32, no_selected_ref 17400165
[  364.494100] looped a lot, count 8, nr 32, no_selected_ref 17500166
[  364.515912] looped a lot, count 8, nr 32, no_selected_ref 17600167
[  364.537362] looped a lot, count 8, nr 32, no_selected_ref 17700168
[  364.559044] looped a lot, count 8, nr 32, no_selected_ref 17800169
[  364.580638] looped a lot, count 8, nr 32, no_selected_ref 17900170
[  364.602300] looped a lot, count 8, nr 32, no_selected_ref 18000171
[  364.624056] looped a lot, count 8, nr 32, no_selected_ref 18100172
[  364.645597] looped a lot, count 8, nr 32, no_selected_ref 18200173
[  364.667096] looped a lot, count 8, nr 32, no_selected_ref 18300174
[  364.688515] looped a lot, count 8, nr 32, no_selected_ref 18400175
[  364.710114] looped a lot, count 8, nr 32, no_selected_ref 18500176
[  364.731481] looped a lot, count 8, nr 32, no_selected_ref 18600177
[  364.753253] looped a lot, count 8, nr 32, no_selected_ref 18700178
[  364.775085] looped a lot, count 8, nr 32, no_selected_ref 18800179
[  364.796570] looped a lot, count 8, nr 32, no_selected_ref 18900180
[  364.817877] looped a lot, count 8, nr 32, no_selected_ref 19000181
[  364.839222] looped a lot, count 8, nr 32, no_selected_ref 19100182
[  364.860602] looped a lot, count 8, nr 32, no_selected_ref 19200183
[  364.881993] looped a lot, count 8, nr 32, no_selected_ref 19300184
[  364.903697] looped a lot, count 8, nr 32, no_selected_ref 19400185
[  364.925244] looped a lot, count 8, nr 32, no_selected_ref 19500186
[  364.946774] looped a lot, count 8, nr 32, no_selected_ref 19600187
[  364.968269] looped a lot, count 8, nr 32, no_selected_ref 19700188
[  364.989615] looped a lot, count 8, nr 32, no_selected_ref 19800189
[  365.011161] looped a lot, count 8, nr 32, no_selected_ref 19900190
[  365.032529] looped a lot, count 8, nr 32, no_selected_ref 20000191
[  365.054208] looped a lot, count 8, nr 32, no_selected_ref 20100192
[  365.075749] looped a lot, count 8, nr 32, no_selected_ref 20200193
[  365.097765] looped a lot, count 8, nr 32, no_selected_ref 20300194
[  365.119157] looped a lot, count 8, nr 32, no_selected_ref 20400195
[  365.140654] looped a lot, count 8, nr 32, no_selected_ref 20500196
[  365.162062] looped a lot, count 8, nr 32, no_selected_ref 20600197
[  365.183891] looped a lot, count 8, nr 32, no_selected_ref 20700198
[  365.205442] looped a lot, count 8, nr 32, no_selected_ref 20800199
[  365.226928] looped a lot, count 8, nr 32, no_selected_ref 20900200
[  365.248450] looped a lot, count 8, nr 32, no_selected_ref 21000201
[  365.270104] looped a lot, count 8, nr 32, no_selected_ref 21100202
[  365.291457] looped a lot, count 8, nr 32, no_selected_ref 21200203
[  365.312609] looped a lot, count 8, nr 32, no_selected_ref 21300204
[  365.333877] looped a lot, count 8, nr 32, no_selected_ref 21400205
[  365.355375] looped a lot, count 8, nr 32, no_selected_ref 21500206
[  365.376778] looped a lot, count 8, nr 32, no_selected_ref 21600207
[  365.398336] looped a lot, count 8, nr 32, no_selected_ref 21700208
[  365.419807] looped a lot, count 8, nr 32, no_selected_ref 21800209
[  365.441280] looped a lot, count 8, nr 32, no_selected_ref 21900210
[  365.462730] looped a lot, count 8, nr 32, no_selected_ref 22000211
[  365.484189] looped a lot, count 8, nr 32, no_selected_ref 22100212
[  365.505685] looped a lot, count 8, nr 32, no_selected_ref 22200213
[  365.527115] looped a lot, count 8, nr 32, no_selected_ref 22300214
[  365.548741] looped a lot, count 8, nr 32, no_selected_ref 22400215
[  365.570509] looped a lot, count 8, nr 32, no_selected_ref 22500216
[  365.592227] looped a lot, count 8, nr 32, no_selected_ref 22600217
[  365.613704] looped a lot, count 8, nr 32, no_selected_ref 22700218
[  365.635184] looped a lot, count 8, nr 32, no_selected_ref 22800219
[  365.656888] looped a lot, count 8, nr 32, no_selected_ref 22900220
[  365.678514] looped a lot, count 8, nr 32, no_selected_ref 23000221
[  365.699749] looped a lot, count 8, nr 32, no_selected_ref 23100222
[  365.721289] looped a lot, count 8, nr 32, no_selected_ref 23200223
[  365.742875] looped a lot, count 8, nr 32, no_selected_ref 23300224
[  365.764532] looped a lot, count 8, nr 32, no_selected_ref 23400225
[  365.785993] looped a lot, count 8, nr 32, no_selected_ref 23500226
[  365.807459] looped a lot, count 8, nr 32, no_selected_ref 23600227
[  365.828809] looped a lot, count 8, nr 32, no_selected_ref 23700228
[  365.850029] looped a lot, count 8, nr 32, no_selected_ref 23800229
[  365.871508] looped a lot, count 8, nr 32, no_selected_ref 23900230
[  365.893013] looped a lot, count 8, nr 32, no_selected_ref 24000231
[  365.914487] looped a lot, count 8, nr 32, no_selected_ref 24100232
[  365.935851] looped a lot, count 8, nr 32, no_selected_ref 24200233
[  365.957194] looped a lot, count 8, nr 32, no_selected_ref 24300234
[  365.978668] looped a lot, count 8, nr 32, no_selected_ref 24400235
[  366.000277] looped a lot, count 8, nr 32, no_selected_ref 24500236
[  366.021753] looped a lot, count 8, nr 32, no_selected_ref 24600237
[  366.043208] looped a lot, count 8, nr 32, no_selected_ref 24700238
[  366.064962] looped a lot, count 8, nr 32, no_selected_ref 24800239
[  366.086683] looped a lot, count 8, nr 32, no_selected_ref 24900240
[  366.108162] looped a lot, count 8, nr 32, no_selected_ref 25000241
[  366.129597] looped a lot, count 8, nr 32, no_selected_ref 25100242
[  366.151133] looped a lot, count 8, nr 32, no_selected_ref 25200243
[  366.172530] looped a lot, count 8, nr 32, no_selected_ref 25300244
[  366.194096] looped a lot, count 8, nr 32, no_selected_ref 25400245
[  366.215790] looped a lot, count 8, nr 32, no_selected_ref 25500246
[  366.237518] looped a lot, count 8, nr 32, no_selected_ref 25600247
[  366.259266] looped a lot, count 8, nr 32, no_selected_ref 25700248
[  366.280854] looped a lot, count 8, nr 32, no_selected_ref 25800249
[  366.302243] looped a lot, count 8, nr 32, no_selected_ref 25900250
[  366.323689] looped a lot, count 8, nr 32, no_selected_ref 26000251
[  366.345358] looped a lot, count 8, nr 32, no_selected_ref 26100252
[  366.366937] looped a lot, count 8, nr 32, no_selected_ref 26200253
[  366.388425] looped a lot, count 8, nr 32, no_selected_ref 26300254
[  366.409914] looped a lot, count 8, nr 32, no_selected_ref 26400255
[  366.431406] looped a lot, count 8, nr 32, no_selected_ref 26500256
[  366.453008] looped a lot, count 8, nr 32, no_selected_ref 26600257
[  366.474690] looped a lot, count 8, nr 32, no_selected_ref 26700258
[  366.496096] looped a lot, count 8, nr 32, no_selected_ref 26800259
[  366.517519] looped a lot, count 8, nr 32, no_selected_ref 26900260
[  366.538790] looped a lot, count 8, nr 32, no_selected_ref 27000261
[  366.560210] looped a lot, count 8, nr 32, no_selected_ref 27100262
[  366.581692] looped a lot, count 8, nr 32, no_selected_ref 27200263
[  366.603128] looped a lot, count 8, nr 32, no_selected_ref 27300264
[  366.624682] looped a lot, count 8, nr 32, no_selected_ref 27400265
[  366.646050] looped a lot, count 8, nr 32, no_selected_ref 27500266
[  366.667544] looped a lot, count 8, nr 32, no_selected_ref 27600267
[  366.688894] looped a lot, count 8, nr 32, no_selected_ref 27700268
[  366.710372] looped a lot, count 8, nr 32, no_selected_ref 27800269
[  366.731964] looped a lot, count 8, nr 32, no_selected_ref 27900270
[  366.753702] looped a lot, count 8, nr 32, no_selected_ref 28000271
[  366.775399] looped a lot, count 8, nr 32, no_selected_ref 28100272
[  366.797159] looped a lot, count 8, nr 32, no_selected_ref 28200273
[  366.818601] looped a lot, count 8, nr 32, no_selected_ref 28300274
[  366.840299] looped a lot, count 8, nr 32, no_selected_ref 28400275
[  366.861773] looped a lot, count 8, nr 32, no_selected_ref 28500276
[  366.883179] looped a lot, count 8, nr 32, no_selected_ref 28600277
[  366.904590] looped a lot, count 8, nr 32, no_selected_ref 28700278
[  366.926414] looped a lot, count 8, nr 32, no_selected_ref 28800279
[  366.947831] looped a lot, count 8, nr 32, no_selected_ref 28900280
[  366.969259] looped a lot, count 8, nr 32, no_selected_ref 29000281
[  366.990936] looped a lot, count 8, nr 32, no_selected_ref 29100282
[  367.012576] looped a lot, count 8, nr 32, no_selected_ref 29200283
[  367.033886] looped a lot, count 8, nr 32, no_selected_ref 29300284
[  367.055427] looped a lot, count 8, nr 32, no_selected_ref 29400285
[  367.076908] looped a lot, count 8, nr 32, no_selected_ref 29500286
[  367.098398] looped a lot, count 8, nr 32, no_selected_ref 29600287
[  367.120014] looped a lot, count 8, nr 32, no_selected_ref 29700288
[  367.141542] looped a lot, count 8, nr 32, no_selected_ref 29800289
[  367.163057] looped a lot, count 8, nr 32, no_selected_ref 29900290
[  367.184581] looped a lot, count 8, nr 32, no_selected_ref 30000291
[  367.206039] looped a lot, count 8, nr 32, no_selected_ref 30100292
[  367.227277] looped a lot, count 8, nr 32, no_selected_ref 30200293
[  367.248976] looped a lot, count 8, nr 32, no_selected_ref 30300294
[  367.270561] looped a lot, count 8, nr 32, no_selected_ref 30400295
[  367.292030] looped a lot, count 8, nr 32, no_selected_ref 30500296
[  367.313657] looped a lot, count 8, nr 32, no_selected_ref 30600297
[  367.335185] looped a lot, count 8, nr 32, no_selected_ref 30700298
[  367.356646] looped a lot, count 8, nr 32, no_selected_ref 30800299
[  367.378272] looped a lot, count 8, nr 32, no_selected_ref 30900300
[  367.400081] looped a lot, count 8, nr 32, no_selected_ref 31000301
[  367.421627] looped a lot, count 8, nr 32, no_selected_ref 31100302
[  367.443184] looped a lot, count 8, nr 32, no_selected_ref 31200303
[  367.464658] looped a lot, count 8, nr 32, no_selected_ref 31300304
[  367.486130] looped a lot, count 8, nr 32, no_selected_ref 31400305
[  367.507577] looped a lot, count 8, nr 32, no_selected_ref 31500306
[  367.529085] looped a lot, count 8, nr 32, no_selected_ref 31600307
[  367.550922] looped a lot, count 8, nr 32, no_selected_ref 31700308
[  367.572269] looped a lot, count 8, nr 32, no_selected_ref 31800309
[  367.593500] looped a lot, count 8, nr 32, no_selected_ref 31900310
[  367.614691] looped a lot, count 8, nr 32, no_selected_ref 32000311
[  367.636432] looped a lot, count 8, nr 32, no_selected_ref 32100312
[  367.657891] looped a lot, count 8, nr 32, no_selected_ref 32200313
[  367.679426] looped a lot, count 8, nr 32, no_selected_ref 32300314
[  367.700749] looped a lot, count 8, nr 32, no_selected_ref 32400315
[  367.722339] looped a lot, count 8, nr 32, no_selected_ref 32500316
[  367.744110] looped a lot, count 8, nr 32, no_selected_ref 32600317
[  367.765902] looped a lot, count 8, nr 32, no_selected_ref 32700318
[  367.787737] looped a lot, count 8, nr 32, no_selected_ref 32800319
[  367.809425] looped a lot, count 8, nr 32, no_selected_ref 32900320
[  367.831051] looped a lot, count 8, nr 32, no_selected_ref 33000321
[  367.852758] looped a lot, count 8, nr 32, no_selected_ref 33100322
[  367.874385] looped a lot, count 8, nr 32, no_selected_ref 33200323
[  367.895627] looped a lot, count 8, nr 32, no_selected_ref 33300324
[  367.916990] looped a lot, count 8, nr 32, no_selected_ref 33400325
[  367.938447] looped a lot, count 8, nr 32, no_selected_ref 33500326
[  367.960104] looped a lot, count 8, nr 32, no_selected_ref 33600327
[  367.981541] looped a lot, count 8, nr 32, no_selected_ref 33700328
[  368.002732] looped a lot, count 8, nr 32, no_selected_ref 33800329
[  368.023990] looped a lot, count 8, nr 32, no_selected_ref 33900330
[  368.045156] looped a lot, count 8, nr 32, no_selected_ref 34000331
[  368.066700] looped a lot, count 8, nr 32, no_selected_ref 34100332
[  368.088195] looped a lot, count 8, nr 32, no_selected_ref 34200333
[  368.109430] looped a lot, count 8, nr 32, no_selected_ref 34300334
[  368.131214] looped a lot, count 8, nr 32, no_selected_ref 34400335
[  368.153121] looped a lot, count 8, nr 32, no_selected_ref 34500336
[  368.174392] looped a lot, count 8, nr 32, no_selected_ref 34600337
[  368.195771] looped a lot, count 8, nr 32, no_selected_ref 34700338
[  368.217260] looped a lot, count 8, nr 32, no_selected_ref 34800339
[  368.238833] looped a lot, count 8, nr 32, no_selected_ref 34900340
[  368.260496] looped a lot, count 8, nr 32, no_selected_ref 35000341
[  368.282026] looped a lot, count 8, nr 32, no_selected_ref 35100342
[  368.303411] looped a lot, count 8, nr 32, no_selected_ref 35200343
[  368.324732] looped a lot, count 8, nr 32, no_selected_ref 35300344
[  368.346075] looped a lot, count 8, nr 32, no_selected_ref 35400345
[  368.367713] looped a lot, count 8, nr 32, no_selected_ref 35500346
[  368.389414] looped a lot, count 8, nr 32, no_selected_ref 35600347
[  368.410915] looped a lot, count 8, nr 32, no_selected_ref 35700348
[  368.432179] looped a lot, count 8, nr 32, no_selected_ref 35800349
[  368.453386] looped a lot, count 8, nr 32, no_selected_ref 35900350
[  368.474846] looped a lot, count 8, nr 32, no_selected_ref 36000351
[  368.496343] looped a lot, count 8, nr 32, no_selected_ref 36100352
[  368.517704] looped a lot, count 8, nr 32, no_selected_ref 36200353
[  368.539087] looped a lot, count 8, nr 32, no_selected_ref 36300354
[  368.560592] looped a lot, count 8, nr 32, no_selected_ref 36400355
[  368.581956] looped a lot, count 8, nr 32, no_selected_ref 36500356
[  368.603488] looped a lot, count 8, nr 32, no_selected_ref 36600357
[  368.624976] looped a lot, count 8, nr 32, no_selected_ref 36700358
[  368.646336] looped a lot, count 8, nr 32, no_selected_ref 36800359
[  368.667771] looped a lot, count 8, nr 32, no_selected_ref 36900360
[  368.689068] looped a lot, count 8, nr 32, no_selected_ref 37000361
[  368.710450] looped a lot, count 8, nr 32, no_selected_ref 37100362
[  368.731881] looped a lot, count 8, nr 32, no_selected_ref 37200363
[  368.753651] looped a lot, count 8, nr 32, no_selected_ref 37300364

Do you need also the perf record?

regards,
  Johannes
