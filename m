Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34564 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2FDMBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 08:01:36 -0400
Received: by vcbf11 with SMTP id f11so2371986vcb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 05:01:35 -0700 (PDT)
Message-ID: <4FCCA39C.8060409@gmail.com>
Date: Mon, 04 Jun 2012 08:01:32 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Arne Jansen <sensille@gmx.net>,
        Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Help with data recovering
References: <4FCA189F.9050000@gmail.com> <4FCC0DD7.9050807@cn.fujitsu.com> <4FCC12BA.9070701@gmail.com> <4FCC1A6F.8050805@cn.fujitsu.com> <4FCC1AE1.8050802@gmail.com> <4FCC2496.6070805@cn.fujitsu.com> <4FCC6F44.2030503@gmx.net> <4FCC9C63.7000605@gmail.com> <4FCC9CD5.2050309@gmx.net> <4FCC9F6C.5090305@gmail.com> <20120604114901.GA15986@carfax.org.uk>
In-Reply-To: <20120604114901.GA15986@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for helping.

~$ uname -a
Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02 UTC 
2012 x86_64 x86_64 x86_64 GNU/Linux

I compiled progs from recent git (week or two ago). I can compile it 
again if there updates.

The output of btrfs-find-root is pretty long and below:
max@s0:~$ sudo btrfs-find-root /dev/sdb
Super think's the tree root is at 5532762525696, chunk root 20979712
Well block 619435147264 seems great, but generation doesn't match, 
have=8746, want=9096
Well block 743223128064 seems great, but generation doesn't match, 
have=8748, want=9096
Well block 743248633856 seems great, but generation doesn't match, 
have=8752, want=9096
Well block 743266234368 seems great, but generation doesn't match, 
have=8753, want=9096
Well block 969724792832 seems great, but generation doesn't match, 
have=5637, want=9096
Well block 1098761064448 seems great, but generation doesn't match, 
have=8754, want=9096
Well block 1098864041984 seems great, but generation doesn't match, 
have=8755, want=9096
Well block 1098934513664 seems great, but generation doesn't match, 
have=5669, want=9096
Well block 1158068850688 seems great, but generation doesn't match, 
have=8756, want=9096
Well block 1158075731968 seems great, but generation doesn't match, 
have=8758, want=9096
Well block 1158076698624 seems great, but generation doesn't match, 
have=8757, want=9096
Well block 1158088052736 seems great, but generation doesn't match, 
have=8759, want=9096
Well block 1158100176896 seems great, but generation doesn't match, 
have=8760, want=9096
Well block 1158148661248 seems great, but generation doesn't match, 
have=8761, want=9096
Well block 2100757860352 seems great, but generation doesn't match, 
have=5764, want=9096
Well block 2466610917376 seems great, but generation doesn't match, 
have=8762, want=9096
Well block 2466672377856 seems great, but generation doesn't match, 
have=8763, want=9096
Well block 2488210591744 seems great, but generation doesn't match, 
have=8764, want=9096
Well block 2531410206720 seems great, but generation doesn't match, 
have=8767, want=9096
Well block 2531417419776 seems great, but generation doesn't match, 
have=8768, want=9096
Well block 2531424862208 seems great, but generation doesn't match, 
have=8766, want=9096
Well block 2531434991616 seems great, but generation doesn't match, 
have=8771, want=9096
Well block 2531487129600 seems great, but generation doesn't match, 
have=8772, want=9096
Well block 2531488305152 seems great, but generation doesn't match, 
have=8773, want=9096
Well block 2531535376384 seems great, but generation doesn't match, 
have=8774, want=9096
Well block 2531544256512 seems great, but generation doesn't match, 
have=8775, want=9096
Well block 2531545665536 seems great, but generation doesn't match, 
have=8777, want=9096
Well block 2531545931776 seems great, but generation doesn't match, 
have=8776, want=9096
Well block 2531556044800 seems great, but generation doesn't match, 
have=8778, want=9096
Well block 2531566743552 seems great, but generation doesn't match, 
have=8779, want=9096
Well block 2531568861184 seems great, but generation doesn't match, 
have=8781, want=9096
Well block 2531580190720 seems great, but generation doesn't match, 
have=8780, want=9096
Well block 2531622813696 seems great, but generation doesn't match, 
have=8783, want=9096
Well block 2531640410112 seems great, but generation doesn't match, 
have=8784, want=9096
Well block 2579974737920 seems great, but generation doesn't match, 
have=5973, want=9096
Well block 2579981524992 seems great, but generation doesn't match, 
have=8786, want=9096
Well block 2579986628608 seems great, but generation doesn't match, 
have=8785, want=9096
Well block 2579986755584 seems great, but generation doesn't match, 
have=8787, want=9096
Well block 2580003811328 seems great, but generation doesn't match, 
have=8788, want=9096
Well block 2580047167488 seems great, but generation doesn't match, 
have=8789, want=9096
Well block 2580099772416 seems great, but generation doesn't match, 
have=8790, want=9096
Well block 2580101951488 seems great, but generation doesn't match, 
have=8791, want=9096
Well block 2580141211648 seems great, but generation doesn't match, 
have=8793, want=9096
Well block 2580156325888 seems great, but generation doesn't match, 
have=8795, want=9096
Well block 2580163178496 seems great, but generation doesn't match, 
have=8797, want=9096
Well block 2580167774208 seems great, but generation doesn't match, 
have=8796, want=9096
Well block 2580172333056 seems great, but generation doesn't match, 
have=8798, want=9096
Well block 2580174557184 seems great, but generation doesn't match, 
have=8799, want=9096
Well block 2580185227264 seems great, but generation doesn't match, 
have=8801, want=9096
Well block 2580185432064 seems great, but generation doesn't match, 
have=8800, want=9096
Well block 2623192694784 seems great, but generation doesn't match, 
have=8802, want=9096
Well block 2623196753920 seems great, but generation doesn't match, 
have=8803, want=9096
Well block 2623215923200 seems great, but generation doesn't match, 
have=8805, want=9096
Well block 2623224307712 seems great, but generation doesn't match, 
have=8806, want=9096
Well block 2623225470976 seems great, but generation doesn't match, 
have=8807, want=9096
Well block 2623260155904 seems great, but generation doesn't match, 
have=8808, want=9096
Well block 2623262482432 seems great, but generation doesn't match, 
have=8809, want=9096
Well block 2623318437888 seems great, but generation doesn't match, 
have=8810, want=9096
Well block 2623324426240 seems great, but generation doesn't match, 
have=8812, want=9096
Well block 2623325806592 seems great, but generation doesn't match, 
have=8811, want=9096
Well block 2623406964736 seems great, but generation doesn't match, 
have=8813, want=9096
Well block 2623412379648 seems great, but generation doesn't match, 
have=8814, want=9096
Well block 2714790506496 seems great, but generation doesn't match, 
have=8815, want=9096
Well block 2827742171136 seems great, but generation doesn't match, 
have=6089, want=9096
Well block 2827822125056 seems great, but generation doesn't match, 
have=8816, want=9096
Well block 2827859574784 seems great, but generation doesn't match, 
have=8817, want=9096
Well block 2827885608960 seems great, but generation doesn't match, 
have=8818, want=9096
Well block 2827965370368 seems great, but generation doesn't match, 
have=8819, want=9096
Well block 2827996184576 seems great, but generation doesn't match, 
have=8820, want=9096
Well block 2887060779008 seems great, but generation doesn't match, 
have=6096, want=9096
Well block 2887071612928 seems great, but generation doesn't match, 
have=8823, want=9096
Well block 2887072702464 seems great, but generation doesn't match, 
have=8821, want=9096
Well block 2887078473728 seems great, but generation doesn't match, 
have=8822, want=9096
Well block 2887120949248 seems great, but generation doesn't match, 
have=8825, want=9096
Well block 2887138783232 seems great, but generation doesn't match, 
have=8827, want=9096
Well block 2887139446784 seems great, but generation doesn't match, 
have=8828, want=9096
Well block 2887146373120 seems great, but generation doesn't match, 
have=8829, want=9096
Well block 2887158681600 seems great, but generation doesn't match, 
have=8830, want=9096
Well block 2887163641856 seems great, but generation doesn't match, 
have=8831, want=9096
Well block 2887189938176 seems great, but generation doesn't match, 
have=6113, want=9096
Well block 2887196823552 seems great, but generation doesn't match, 
have=6114, want=9096
Well block 2887205089280 seems great, but generation doesn't match, 
have=6115, want=9096
Well block 2887206965248 seems great, but generation doesn't match, 
have=6116, want=9096
Well block 2887213744128 seems great, but generation doesn't match, 
have=6117, want=9096
Well block 2887220994048 seems great, but generation doesn't match, 
have=6118, want=9096
Well block 2887242031104 seems great, but generation doesn't match, 
have=6119, want=9096
Well block 2887250567168 seems great, but generation doesn't match, 
have=6120, want=9096
Well block 2887255285760 seems great, but generation doesn't match, 
have=6121, want=9096
Well block 2887261667328 seems great, but generation doesn't match, 
have=6122, want=9096
Well block 2887268433920 seems great, but generation doesn't match, 
have=6123, want=9096
Well block 2887275102208 seems great, but generation doesn't match, 
have=6124, want=9096
Well block 2887281631232 seems great, but generation doesn't match, 
have=6125, want=9096
Well block 2887284424704 seems great, but generation doesn't match, 
have=6126, want=9096
Well block 2887291019264 seems great, but generation doesn't match, 
have=6127, want=9096
Well block 2887296684032 seems great, but generation doesn't match, 
have=6128, want=9096
Well block 2887303159808 seems great, but generation doesn't match, 
have=6129, want=9096
Well block 2887309631488 seems great, but generation doesn't match, 
have=8833, want=9096
Well block 2887310200832 seems great, but generation doesn't match, 
have=8832, want=9096
Well block 2946415992832 seems great, but generation doesn't match, 
have=8834, want=9096
Well block 2946421940224 seems great, but generation doesn't match, 
have=8835, want=9096
Well block 2946563887104 seems great, but generation doesn't match, 
have=8837, want=9096
Well block 2946566844416 seems great, but generation doesn't match, 
have=8838, want=9096
Well block 2984269713408 seems great, but generation doesn't match, 
have=8844, want=9096
Well block 2984277966848 seems great, but generation doesn't match, 
have=8840, want=9096
Well block 2984284127232 seems great, but generation doesn't match, 
have=8845, want=9096
Well block 2984285650944 seems great, but generation doesn't match, 
have=8846, want=9096
Well block 2984365961216 seems great, but generation doesn't match, 
have=8847, want=9096
Well block 2984382795776 seems great, but generation doesn't match, 
have=8848, want=9096
Well block 2984383729664 seems great, but generation doesn't match, 
have=8849, want=9096
Well block 2984385560576 seems great, but generation doesn't match, 
have=8850, want=9096
Well block 2984389398528 seems great, but generation doesn't match, 
have=8851, want=9096
Well block 2984396165120 seems great, but generation doesn't match, 
have=8852, want=9096
Well block 2984406396928 seems great, but generation doesn't match, 
have=8854, want=9096
Well block 2984458833920 seems great, but generation doesn't match, 
have=8856, want=9096
Well block 2984486629376 seems great, but generation doesn't match, 
have=8857, want=9096
Well block 3022114922496 seems great, but generation doesn't match, 
have=8860, want=9096
Well block 3022121263104 seems great, but generation doesn't match, 
have=8859, want=9096
Well block 3022132695040 seems great, but generation doesn't match, 
have=8861, want=9096
Well block 3022162219008 seems great, but generation doesn't match, 
have=8862, want=9096
Well block 3022205132800 seems great, but generation doesn't match, 
have=8863, want=9096
Well block 3022215454720 seems great, but generation doesn't match, 
have=8864, want=9096
Well block 3022216146944 seems great, but generation doesn't match, 
have=8865, want=9096
Well block 3022300733440 seems great, but generation doesn't match, 
have=8866, want=9096
Well block 3022307860480 seems great, but generation doesn't match, 
have=8867, want=9096
Well block 3065306001408 seems great, but generation doesn't match, 
have=8868, want=9096
Well block 3065333374976 seems great, but generation doesn't match, 
have=8870, want=9096
Well block 3065333981184 seems great, but generation doesn't match, 
have=8869, want=9096
Well block 3065341300736 seems great, but generation doesn't match, 
have=8871, want=9096
Well block 3065341947904 seems great, but generation doesn't match, 
have=8872, want=9096
Well block 3065384251392 seems great, but generation doesn't match, 
have=8873, want=9096
Well block 3065395499008 seems great, but generation doesn't match, 
have=8874, want=9096
Well block 3065432784896 seems great, but generation doesn't match, 
have=8875, want=9096
Well block 3065435996160 seems great, but generation doesn't match, 
have=8876, want=9096
Well block 3065474654208 seems great, but generation doesn't match, 
have=8877, want=9096
Well block 3065476714496 seems great, but generation doesn't match, 
have=8878, want=9096
Well block 3065496293376 seems great, but generation doesn't match, 
have=8880, want=9096
Well block 3065496625152 seems great, but generation doesn't match, 
have=8881, want=9096
Well block 3065499615232 seems great, but generation doesn't match, 
have=8882, want=9096
Well block 3065522581504 seems great, but generation doesn't match, 
have=8886, want=9096
Well block 3103147339776 seems great, but generation doesn't match, 
have=8887, want=9096
Well block 3103149096960 seems great, but generation doesn't match, 
have=8888, want=9096
Well block 3103154950144 seems great, but generation doesn't match, 
have=8889, want=9096
Well block 3103165263872 seems great, but generation doesn't match, 
have=8890, want=9096
Well block 3103165509632 seems great, but generation doesn't match, 
have=8891, want=9096
Well block 3103168155648 seems great, but generation doesn't match, 
have=8892, want=9096
Well block 3103171592192 seems great, but generation doesn't match, 
have=8893, want=9096
Well block 3103175024640 seems great, but generation doesn't match, 
have=8894, want=9096
Well block 3103185793024 seems great, but generation doesn't match, 
have=8896, want=9096
Well block 3103188922368 seems great, but generation doesn't match, 
have=8895, want=9096
Well block 3103210176512 seems great, but generation doesn't match, 
have=8897, want=9096
Well block 3103210971136 seems great, but generation doesn't match, 
have=8898, want=9096
Well block 3103228485632 seems great, but generation doesn't match, 
have=8899, want=9096
Well block 3103237844992 seems great, but generation doesn't match, 
have=8900, want=9096
Well block 3103238144000 seems great, but generation doesn't match, 
have=8901, want=9096
Well block 3103240544256 seems great, but generation doesn't match, 
have=8902, want=9096
Well block 3103243677696 seems great, but generation doesn't match, 
have=8903, want=9096
Well block 3103244447744 seems great, but generation doesn't match, 
have=8904, want=9096
Well block 3103258718208 seems great, but generation doesn't match, 
have=8905, want=9096
Well block 3103261290496 seems great, but generation doesn't match, 
have=8906, want=9096
Well block 3103281463296 seems great, but generation doesn't match, 
have=8907, want=9096
Well block 3103282315264 seems great, but generation doesn't match, 
have=8908, want=9096
Well block 3103298441216 seems great, but generation doesn't match, 
have=8909, want=9096
Well block 3103302393856 seems great, but generation doesn't match, 
have=6389, want=9096
Well block 3103323017216 seems great, but generation doesn't match, 
have=8910, want=9096
Well block 3103323447296 seems great, but generation doesn't match, 
have=8911, want=9096
Well block 3103325896704 seems great, but generation doesn't match, 
have=8912, want=9096
Well block 3103329468416 seems great, but generation doesn't match, 
have=8913, want=9096
Well block 3103330926592 seems great, but generation doesn't match, 
have=8914, want=9096
Well block 3103345201152 seems great, but generation doesn't match, 
have=8915, want=9096
Well block 3103345958912 seems great, but generation doesn't match, 
have=8916, want=9096
Well block 3103368241152 seems great, but generation doesn't match, 
have=8917, want=9096
Well block 3103369076736 seems great, but generation doesn't match, 
have=8918, want=9096
Well block 3103382474752 seems great, but generation doesn't match, 
have=8919, want=9096
Well block 3103395471360 seems great, but generation doesn't match, 
have=8920, want=9096
Well block 3103395753984 seems great, but generation doesn't match, 
have=8921, want=9096
Well block 3103398383616 seems great, but generation doesn't match, 
have=8922, want=9096
Well block 3103401709568 seems great, but generation doesn't match, 
have=8923, want=9096
Well block 3103403487232 seems great, but generation doesn't match, 
have=8924, want=9096
Well block 3103411101696 seems great, but generation doesn't match, 
have=8925, want=9096
Well block 3216163819520 seems great, but generation doesn't match, 
have=6451, want=9096
Well block 3216170438656 seems great, but generation doesn't match, 
have=6507, want=9096
Well block 3216180826112 seems great, but generation doesn't match, 
have=6509, want=9096
Well block 3216188633088 seems great, but generation doesn't match, 
have=8926, want=9096
Well block 3216201068544 seems great, but generation doesn't match, 
have=8927, want=9096
Well block 3216202895360 seems great, but generation doesn't match, 
have=8928, want=9096
Well block 3216226570240 seems great, but generation doesn't match, 
have=8929, want=9096
Well block 3216227221504 seems great, but generation doesn't match, 
have=8930, want=9096
Well block 3216242212864 seems great, but generation doesn't match, 
have=8931, want=9096
Well block 3216250953728 seems great, but generation doesn't match, 
have=8932, want=9096
Well block 3216251314176 seems great, but generation doesn't match, 
have=8933, want=9096
Well block 3216253743104 seems great, but generation doesn't match, 
have=8934, want=9096
Well block 3216257495040 seems great, but generation doesn't match, 
have=8935, want=9096
Well block 3216260059136 seems great, but generation doesn't match, 
have=8936, want=9096
Well block 3216274374656 seems great, but generation doesn't match, 
have=8938, want=9096
Well block 3216274612224 seems great, but generation doesn't match, 
have=8937, want=9096
Well block 3216289120256 seems great, but generation doesn't match, 
have=6477, want=9096
Well block 3216298061824 seems great, but generation doesn't match, 
have=6520, want=9096
Well block 3216307097600 seems great, but generation doesn't match, 
have=6521, want=9096
Well block 3216364236800 seems great, but generation doesn't match, 
have=8939, want=9096
Well block 3216365404160 seems great, but generation doesn't match, 
have=8940, want=9096
Well block 3216387854336 seems great, but generation doesn't match, 
have=8941, want=9096
Well block 3216403558400 seems great, but generation doesn't match, 
have=8942, want=9096
Well block 3216404262912 seems great, but generation doesn't match, 
have=8943, want=9096
Well block 3216407031808 seems great, but generation doesn't match, 
have=8944, want=9096
Well block 3216410210304 seems great, but generation doesn't match, 
have=8945, want=9096
Well block 3216411242496 seems great, but generation doesn't match, 
have=8946, want=9096
Well block 3259377135616 seems great, but generation doesn't match, 
have=8947, want=9096
Well block 3259392462848 seems great, but generation doesn't match, 
have=8949, want=9096
Well block 3259393642496 seems great, but generation doesn't match, 
have=8950, want=9096
Well block 3259398754304 seems great, but generation doesn't match, 
have=8948, want=9096
Well block 3259411787776 seems great, but generation doesn't match, 
have=8951, want=9096
Well block 3259419025408 seems great, but generation doesn't match, 
have=6571, want=9096
Well block 3259422646272 seems great, but generation doesn't match, 
have=8952, want=9096
Well block 3259423043584 seems great, but generation doesn't match, 
have=8953, want=9096
Well block 3259430191104 seems great, but generation doesn't match, 
have=8954, want=9096
Well block 3259436924928 seems great, but generation doesn't match, 
have=8955, want=9096
Well block 3259439054848 seems great, but generation doesn't match, 
have=8956, want=9096
Well block 3259453116416 seems great, but generation doesn't match, 
have=8958, want=9096
Well block 3259454189568 seems great, but generation doesn't match, 
have=8957, want=9096
Well block 3259479363584 seems great, but generation doesn't match, 
have=8959, want=9096
Well block 3259480965120 seems great, but generation doesn't match, 
have=8960, want=9096
Well block 3259514920960 seems great, but generation doesn't match, 
have=8961, want=9096
Well block 3259539255296 seems great, but generation doesn't match, 
have=8962, want=9096
Well block 3259540201472 seems great, but generation doesn't match, 
have=8963, want=9096
Well block 3259547783168 seems great, but generation doesn't match, 
have=8964, want=9096
Well block 3259555237888 seems great, but generation doesn't match, 
have=8965, want=9096
Well block 3259556577280 seems great, but generation doesn't match, 
have=8966, want=9096
Well block 3259586670592 seems great, but generation doesn't match, 
have=6553, want=9096
Well block 3259622793216 seems great, but generation doesn't match, 
have=8967, want=9096
Well block 3259631628288 seems great, but generation doesn't match, 
have=8968, want=9096
Well block 3259633111040 seems great, but generation doesn't match, 
have=8969, want=9096
Well block 3307982426112 seems great, but generation doesn't match, 
have=8971, want=9096
Well block 3308003274752 seems great, but generation doesn't match, 
have=8972, want=9096
Well block 3308008677376 seems great, but generation doesn't match, 
have=6881, want=9096
Well block 3308015095808 seems great, but generation doesn't match, 
have=8975, want=9096
Well block 3308031418368 seems great, but generation doesn't match, 
have=8977, want=9096
Well block 3308041916416 seems great, but generation doesn't match, 
have=8979, want=9096
Well block 3308047122432 seems great, but generation doesn't match, 
have=8978, want=9096
Well block 3308071120896 seems great, but generation doesn't match, 
have=8980, want=9096
Well block 3308072128512 seems great, but generation doesn't match, 
have=8981, want=9096
Well block 3308085768192 seems great, but generation doesn't match, 
have=8982, want=9096
Well block 3308094103552 seems great, but generation doesn't match, 
have=8983, want=9096
Well block 3308094361600 seems great, but generation doesn't match, 
have=8984, want=9096
Well block 3308096815104 seems great, but generation doesn't match, 
have=8985, want=9096
Well block 3308100771840 seems great, but generation doesn't match, 
have=8986, want=9096
Well block 3308102782976 seems great, but generation doesn't match, 
have=8987, want=9096
Well block 3308120915968 seems great, but generation doesn't match, 
have=6936, want=9096
Well block 3308123820032 seems great, but generation doesn't match, 
have=8988, want=9096
Well block 3308124946432 seems great, but generation doesn't match, 
have=8989, want=9096
Well block 3308149964800 seems great, but generation doesn't match, 
have=8990, want=9096
Well block 3308151025664 seems great, but generation doesn't match, 
have=8991, want=9096
Well block 3308163780608 seems great, but generation doesn't match, 
have=8992, want=9096
Well block 3308167315456 seems great, but generation doesn't match, 
have=6961, want=9096
Well block 3308169089024 seems great, but generation doesn't match, 
have=6962, want=9096
Well block 3308169162752 seems great, but generation doesn't match, 
have=6963, want=9096
Well block 3308170137600 seems great, but generation doesn't match, 
have=6964, want=9096
Well block 3308173950976 seems great, but generation doesn't match, 
have=6965, want=9096
Well block 3308174385152 seems great, but generation doesn't match, 
have=6966, want=9096
Well block 3308176388096 seems great, but generation doesn't match, 
have=8993, want=9096
Well block 3308176777216 seems great, but generation doesn't match, 
have=8994, want=9096
Well block 3308179423232 seems great, but generation doesn't match, 
have=8995, want=9096
Well block 3308183064576 seems great, but generation doesn't match, 
have=8996, want=9096
Well block 3308184117248 seems great, but generation doesn't match, 
have=8997, want=9096
Well block 3308192186368 seems great, but generation doesn't match, 
have=6974, want=9096
Well block 3308195463168 seems great, but generation doesn't match, 
have=8998, want=9096
Well block 3308196433920 seems great, but generation doesn't match, 
have=8999, want=9096
Well block 3308217372672 seems great, but generation doesn't match, 
have=9000, want=9096
Well block 3308218216448 seems great, but generation doesn't match, 
have=9001, want=9096
Well block 3356598226944 seems great, but generation doesn't match, 
have=7009, want=9096
Well block 3356689129472 seems great, but generation doesn't match, 
have=7012, want=9096
Well block 3356693929984 seems great, but generation doesn't match, 
have=7013, want=9096
Well block 3356699000832 seems great, but generation doesn't match, 
have=7015, want=9096
Well block 3356700569600 seems great, but generation doesn't match, 
have=9002, want=9096
Well block 3356708118528 seems great, but generation doesn't match, 
have=9003, want=9096
Well block 3356712800256 seems great, but generation doesn't match, 
have=9005, want=9096
Well block 3356714262528 seems great, but generation doesn't match, 
have=9004, want=9096
Well block 3356742012928 seems great, but generation doesn't match, 
have=9009, want=9096
Well block 3356807712768 seems great, but generation doesn't match, 
have=9010, want=9096
Well block 3356810645504 seems great, but generation doesn't match, 
have=9011, want=9096
Well block 3405159735296 seems great, but generation doesn't match, 
have=5263, want=9096
Well block 3405196206080 seems great, but generation doesn't match, 
have=9012, want=9096
Well block 3405245640704 seems great, but generation doesn't match, 
have=9015, want=9096
Well block 3405265301504 seems great, but generation doesn't match, 
have=9016, want=9096
Well block 3405270106112 seems great, but generation doesn't match, 
have=9017, want=9096
Well block 3405289385984 seems great, but generation doesn't match, 
have=9019, want=9096
Well block 3405383557120 seems great, but generation doesn't match, 
have=9020, want=9096
Well block 3405384617984 seems great, but generation doesn't match, 
have=9021, want=9096
Well block 3475205132288 seems great, but generation doesn't match, 
have=5278, want=9096
Well block 3475206082560 seems great, but generation doesn't match, 
have=5279, want=9096
Well block 3475230576640 seems great, but generation doesn't match, 
have=7123, want=9096
Well block 3475232927744 seems great, but generation doesn't match, 
have=7125, want=9096
Well block 3475235311616 seems great, but generation doesn't match, 
have=9023, want=9096
Well block 3475237179392 seems great, but generation doesn't match, 
have=9025, want=9096
Well block 3475240382464 seems great, but generation doesn't match, 
have=7128, want=9096
Well block 3475266129920 seems great, but generation doesn't match, 
have=9028, want=9096
Well block 3475279261696 seems great, but generation doesn't match, 
have=9027, want=9096
Well block 3475337981952 seems great, but generation doesn't match, 
have=9032, want=9096
Well block 3475352297472 seems great, but generation doesn't match, 
have=9031, want=9096
Well block 3518444724224 seems great, but generation doesn't match, 
have=9038, want=9096
Well block 3518445928448 seems great, but generation doesn't match, 
have=9035, want=9096
Well block 3518446641152 seems great, but generation doesn't match, 
have=9033, want=9096
Well block 3518460506112 seems great, but generation doesn't match, 
have=9042, want=9096
Well block 3518469042176 seems great, but generation doesn't match, 
have=9041, want=9096
Well block 3518602706944 seems great, but generation doesn't match, 
have=9048, want=9096
Well block 3518610194432 seems great, but generation doesn't match, 
have=9044, want=9096
Well block 3518614880256 seems great, but generation doesn't match, 
have=9049, want=9096
Well block 3518619107328 seems great, but generation doesn't match, 
have=9050, want=9096
Well block 3567122915328 seems great, but generation doesn't match, 
have=9054, want=9096
Well block 3567130849280 seems great, but generation doesn't match, 
have=9055, want=9096
Well block 3567159414784 seems great, but generation doesn't match, 
have=9056, want=9096
Well block 3567164891136 seems great, but generation doesn't match, 
have=9059, want=9096
Well block 3567209717760 seems great, but generation doesn't match, 
have=9061, want=9096
Well block 3567210893312 seems great, but generation doesn't match, 
have=9062, want=9096
Well block 3674660569088 seems great, but generation doesn't match, 
have=9063, want=9096
Well block 3674713247744 seems great, but generation doesn't match, 
have=9065, want=9096
Well block 3674727108608 seems great, but generation doesn't match, 
have=9066, want=9096
Well block 3674785320960 seems great, but generation doesn't match, 
have=9067, want=9096
Well block 3674788827136 seems great, but generation doesn't match, 
have=9069, want=9096
Well block 3674792534016 seems great, but generation doesn't match, 
have=9068, want=9096
Well block 3674808315904 seems great, but generation doesn't match, 
have=9071, want=9096
Well block 3728604938240 seems great, but generation doesn't match, 
have=5297, want=9096
Well block 3728635133952 seems great, but generation doesn't match, 
have=7598, want=9096
Well block 3728682438656 seems great, but generation doesn't match, 
have=7599, want=9096
Well block 3728770461696 seems great, but generation doesn't match, 
have=9074, want=9096
Well block 3728819929088 seems great, but generation doesn't match, 
have=9073, want=9096
Well block 3820340637696 seems great, but generation doesn't match, 
have=9075, want=9096
Well block 3960145862656 seems great, but generation doesn't match, 
have=9076, want=9096
Well block 4046161489920 seems great, but generation doesn't match, 
have=9077, want=9096
Well block 4046213595136 seems great, but generation doesn't match, 
have=9079, want=9096
Well block 4046217637888 seems great, but generation doesn't match, 
have=9081, want=9096
Well block 4046217846784 seems great, but generation doesn't match, 
have=9080, want=9096
Well block 4046252736512 seems great, but generation doesn't match, 
have=9083, want=9096
Well block 4046301515776 seems great, but generation doesn't match, 
have=9085, want=9096
Well block 4046302756864 seems great, but generation doesn't match, 
have=9084, want=9096
Well block 4046358921216 seems great, but generation doesn't match, 
have=9086, want=9096
Well block 4046409486336 seems great, but generation doesn't match, 
have=9087, want=9096
Well block 4046414626816 seems great, but generation doesn't match, 
have=9088, want=9096
Well block 4148447113216 seems great, but generation doesn't match, 
have=7618, want=9096
Well block 4148522024960 seems great, but generation doesn't match, 
have=9089, want=9096
Well block 4148539457536 seems great, but generation doesn't match, 
have=9090, want=9096
Well block 4455562448896 seems great, but generation doesn't match, 
have=9092, want=9096
Well block 4455568302080 seems great, but generation doesn't match, 
have=9091, want=9096
Well block 4848395739136 seems great, but generation doesn't match, 
have=9093, want=9096
Well block 4923796594688 seems great, but generation doesn't match, 
have=9094, want=9096
Well block 4923798065152 seems great, but generation doesn't match, 
have=9095, want=9096
Found tree root at 5532762525696


On 06/04/2012 07:49 AM, Hugo Mills wrote:
> On Mon, Jun 04, 2012 at 07:43:40AM -0400, Maxim Mikheev wrote:
>> Hi Arne,
>>
>> Can you advice how can I recover data?
>> I tried almost everything what I found on https://btrfs.wiki.kernel.org
>>
>> /btrfs-restore restored some files but it is not what was stored.
>     Can you post the complete output of find-root please?
>
>> I have seen this command
>>
>> --------------------------------------------------
>> In case of a corrupted superblock, start by asking btrfsck to use an
>> alternate copy of the superblock instead of the superblock #0. This
>> is achieved via the -s option followed by the number of the
>> alternate copy you wish to use. In the following example we ask for
>> using the superblock copy #2 of /dev/sda7:
>>
>> # ./btrfsck -s 2 /dev/sd7
>>
>> -----------------------------------------
>> but it gave me:
>> $ sudo btrfsck -s 2 /dev/sdb
>> btrfsck: invalid option -- 's'
>> usage: btrfsck dev
>> Btrfs Btrfs v0.19
>     What exact version of the package do you have? Did you compile from
> a recent git, or do you have a distribution -progs package installed?
> If the latter, what date does it have in the version number?
>
>     Hugo.
>
