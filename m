Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pl1.haspere.com ([209.177.156.123]:57223 "EHLO pl1.haspere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbbAHPCM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 10:02:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 08 Jan 2015 09:02:11 -0600
From: Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>, chris@colorremedies.com,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: BTRFS: Transaction aborted (error -5)
Reply-To: Y4BwxfPC4k5h@dyweni.com
In-Reply-To: <3a54c891af5096fadaff3c29151b1841@localhost>
References: <4ac53d9eeb92abf031b2b68c1b130215@pl1.haspere.com>
 <CAJCQCtSqTzOywjiZXeSdrw2nLYzyMZBnWSMmzbtVgeZthizv4w@mail.gmail.com>
 <29f367e22e5607854cc3c20730f099ac@localhost>
 <3a54c891af5096fadaff3c29151b1841@localhost>
Message-ID: <dfa426629b491947b5ee5e3ac5727724@localhost>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Just wondering if someone could help me figure out what happened to this 
file system?  As you see below, the kernel reports btrfs errors on both 
drives, but was able to correct the errors on the first drive.  The 
second drive not so lucky.  However, running 'badblocks -nsv' (the 
non-destructive read-write test) on both drives shows both drive free of 
bad blocks.

Both drives are 1TB 7200RPM spinners.  And, as Chris indicated earlier, 
its strange that the file system gets different check sums for the same 
block...

Thanks,
Dyweni



On 2015-01-06 09:15, Dyweni - BTRFS wrote:
> Hi,
> 
> BTRFS check on /dev/sdc1 reveals everything looks ok:
> 
> # btrfs check /dev/sdc1
> Checking filesystem on /dev/sdc1
> UUID: 26ed1033-429a-444f-97cc-ce8103db4c39
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 195515710524 bytes used err is 0
> total csum bytes: 205915200
> total tree bytes: 407355392
> total fs tree bytes: 94830592
> total extent tree bytes: 31588352
> btree space waste bytes: 100867438
> file data blocks allocated: 537492316160
>  referenced 195656101888
> Btrfs v3.18
> 
> 
> 
> 
> (/dev/sdd1 and /dev/sdc1 are the only two btrfs file systems in this 
> machine).
> 
> 
> 
> Oddly, when the problem with /dev/sdd1 started, problems with /dev/sdc1 
> were
> also reported, but /dev/sdc1 managed to fix itself.
> 
> Below is the complete dmesg output from when problems first started
> until /dev/sdd1 went readonly with errors.
> 
> The strangest part of all of this, is that the dmesg output shows no
> errors about the drive being physically bad.
> (I ran badblocks -nsv on both /dev/sdd and /dev/sdc, and it confirmed
> 0 bad blocks for both drives).
> 
> 
> 
> 
> [25581.099684] BTRFS: sdd1 checksum verify failed on 521797632 wanted
> 8F2F5FEC found 3E879EFE level 0
> [25581.105441] BTRFS: read error corrected: ino 1 off 521797632 (dev
> /dev/sdd1 sector 1035520)
> [25581.105612] BTRFS: read error corrected: ino 1 off 521801728 (dev
> /dev/sdd1 sector 1035528)
> [25581.105784] BTRFS: read error corrected: ino 1 off 521805824 (dev
> /dev/sdd1 sector 1035536)
> [25581.105956] BTRFS: read error corrected: ino 1 off 521809920 (dev
> /dev/sdd1 sector 1035544)
> [27777.799514] BTRFS: sdd1 checksum verify failed on 680296448 wanted
> AB0E191F found 192D4134 level 0
> [27777.856199] BTRFS: read error corrected: ino 1 off 680296448 (dev
> /dev/sdd1 sector 1345088)
> [27777.860571] BTRFS: read error corrected: ino 1 off 680300544 (dev
> /dev/sdd1 sector 1345096)
> [27777.909634] BTRFS: read error corrected: ino 1 off 680304640 (dev
> /dev/sdd1 sector 1345104)
> [27777.909876] BTRFS: read error corrected: ino 1 off 680308736 (dev
> /dev/sdd1 sector 1345112)
> [29292.777237] BTRFS: sdc1 checksum verify failed on 937738240 wanted
> F4196CDA found AF30B394 level 0
> [29292.778022] BTRFS: sdc1 checksum verify failed on 937738240 wanted
> F4196CDA found AF30B394 level 0
> [29292.781889] BTRFS: read error corrected: ino 1 off 937738240 (dev
> /dev/sdc1 sector 1847904)
> [29292.782054] BTRFS: read error corrected: ino 1 off 937742336 (dev
> /dev/sdc1 sector 1847912)
> [29292.782224] BTRFS: read error corrected: ino 1 off 937746432 (dev
> /dev/sdc1 sector 1847920)
> [29292.782399] BTRFS: read error corrected: ino 1 off 937750528 (dev
> /dev/sdc1 sector 1847928)
> [29691.731107] BTRFS: sdd1 checksum verify failed on 610877440 wanted
> 5A8006E7 found 1CFE4A20 level 0
> [29691.791550] BTRFS: read error corrected: ino 1 off 610877440 (dev
> /dev/sdd1 sector 1209504)
> [29691.793252] BTRFS: read error corrected: ino 1 off 610881536 (dev
> /dev/sdd1 sector 1209512)
> [29691.793608] BTRFS: read error corrected: ino 1 off 610885632 (dev
> /dev/sdd1 sector 1209520)
> [29691.793797] BTRFS: read error corrected: ino 1 off 610889728 (dev
> /dev/sdd1 sector 1209528)
> [34626.017914] BTRFS: sdd1 checksum verify failed on 737181696 wanted
> 15D7099D found B6A2A7A9 level 0
> [34626.022656] BTRFS: read error corrected: ino 1 off 737181696 (dev
> /dev/sdd1 sector 1456192)
> [34626.022867] BTRFS: read error corrected: ino 1 off 737185792 (dev
> /dev/sdd1 sector 1456200)
> [34626.023107] BTRFS: read error corrected: ino 1 off 737189888 (dev
> /dev/sdd1 sector 1456208)
> [34626.023314] BTRFS: read error corrected: ino 1 off 737193984 (dev
> /dev/sdd1 sector 1456216)
> [37057.349996] BTRFS: sdc1 checksum verify failed on 701792256 wanted
> A7BD5067 found 87EF0602 level 0
> [37057.424920] BTRFS: read error corrected: ino 1 off 701792256 (dev
> /dev/sdc1 sector 1387072)
> [37057.425178] BTRFS: read error corrected: ino 1 off 701796352 (dev
> /dev/sdc1 sector 1387080)
> [37057.450174] BTRFS: read error corrected: ino 1 off 701800448 (dev
> /dev/sdc1 sector 1387088)
> [37057.453476] BTRFS: read error corrected: ino 1 off 701804544 (dev
> /dev/sdc1 sector 1387096)
> [38283.714855] BTRFS: sdd1 checksum verify failed on 190169088 wanted
> 27D1E032 found 585B1651 level 0
> [38283.715349] BTRFS: sdd1 checksum verify failed on 190169088 wanted
> 27D1E032 found 585B1651 level 0
> [38283.724140] BTRFS: read error corrected: ino 1 off 190169088 (dev
> /dev/sdd1 sector 387808)
> [38283.724313] BTRFS: read error corrected: ino 1 off 190173184 (dev
> /dev/sdd1 sector 387816)
> [38283.724485] BTRFS: read error corrected: ino 1 off 190177280 (dev
> /dev/sdd1 sector 387824)
> [38283.724648] BTRFS: read error corrected: ino 1 off 190181376 (dev
> /dev/sdd1 sector 387832)
> [38385.874438] BTRFS: sdd1 checksum verify failed on 472825856 wanted
> 937078F5 found 7FCB4F87 level 0
> [38385.897113] BTRFS: read error corrected: ino 1 off 472825856 (dev
> /dev/sdd1 sector 939872)
> [38385.897336] BTRFS: read error corrected: ino 1 off 472829952 (dev
> /dev/sdd1 sector 939880)
> [38385.897567] BTRFS: read error corrected: ino 1 off 472834048 (dev
> /dev/sdd1 sector 939888)
> [38385.897790] BTRFS: read error corrected: ino 1 off 472838144 (dev
> /dev/sdd1 sector 939896)
> [39015.821873] BTRFS: sdc1 checksum verify failed on 443613184 wanted
> 302CD9DE found ED697366 level 0
> [39015.823523] BTRFS: read error corrected: ino 1 off 443613184 (dev
> /dev/sdc1 sector 882816)
> [39015.823755] BTRFS: read error corrected: ino 1 off 443617280 (dev
> /dev/sdc1 sector 882824)
> [39015.824015] BTRFS: read error corrected: ino 1 off 443621376 (dev
> /dev/sdc1 sector 882832)
> [39015.824273] BTRFS: read error corrected: ino 1 off 443625472 (dev
> /dev/sdc1 sector 882840)
> [41213.535718] BTRFS: sdd1 checksum verify failed on 397557760 wanted
> EBCB7405 found C1365A5E level 0
> [41213.579520] BTRFS: read error corrected: ino 1 off 397557760 (dev
> /dev/sdd1 sector 792864)
> [41213.579687] BTRFS: read error corrected: ino 1 off 397561856 (dev
> /dev/sdd1 sector 792872)
> [41213.579913] BTRFS: read error corrected: ino 1 off 397565952 (dev
> /dev/sdd1 sector 792880)
> [41213.580062] BTRFS: read error corrected: ino 1 off 397570048 (dev
> /dev/sdd1 sector 792888)
> [41535.669279] BTRFS: sdc1 checksum verify failed on 476348416 wanted
> A645D195 found 21AD02F8 level 0
> [41535.805928] BTRFS: read error corrected: ino 1 off 476348416 (dev
> /dev/sdc1 sector 946752)
> [41535.807125] BTRFS: read error corrected: ino 1 off 476352512 (dev
> /dev/sdc1 sector 946760)
> [41535.808775] BTRFS: read error corrected: ino 1 off 476356608 (dev
> /dev/sdc1 sector 946768)
> [41535.810561] BTRFS: read error corrected: ino 1 off 476360704 (dev
> /dev/sdc1 sector 946776)
> [42148.710341] BTRFS: sdc1 checksum verify failed on 807469056 wanted
> 8490C0D5 found FB751835 level 0
> [42148.771176] BTRFS: sdc1 checksum verify failed on 807469056 wanted
> 8490C0D5 found FB751835 level 0
> [42148.773574] BTRFS: read error corrected: ino 1 off 807469056 (dev
> /dev/sdc1 sector 1593472)
> [42148.780409] BTRFS: read error corrected: ino 1 off 807473152 (dev
> /dev/sdc1 sector 1593480)
> [42148.784868] BTRFS: read error corrected: ino 1 off 807477248 (dev
> /dev/sdc1 sector 1593488)
> [42148.785629] BTRFS: read error corrected: ino 1 off 807481344 (dev
> /dev/sdc1 sector 1593496)
> [42263.866339] BTRFS: sdc1 checksum verify failed on 1019822080 wanted
> EE99B968 found 42D4359B level 0
> [42263.867150] BTRFS: read error corrected: ino 1 off 1019822080 (dev
> /dev/sdc1 sector 2008224)
> [42263.867371] BTRFS: read error corrected: ino 1 off 1019826176 (dev
> /dev/sdc1 sector 2008232)
> [42263.867651] BTRFS: read error corrected: ino 1 off 1019830272 (dev
> /dev/sdc1 sector 2008240)
> [42263.867874] BTRFS: read error corrected: ino 1 off 1019834368 (dev
> /dev/sdc1 sector 2008248)
> [43510.239652] BTRFS: sdd1 checksum verify failed on 561528832 wanted
> 8E3D9918 found 462F00F8 level 0
> [43510.277730] BTRFS: sdd1 checksum verify failed on 561528832 wanted
> 8E3D9918 found 462F00F8 level 0
> [43510.284768] BTRFS: read error corrected: ino 1 off 561528832 (dev
> /dev/sdd1 sector 1113120)
> [43510.284951] BTRFS: read error corrected: ino 1 off 561532928 (dev
> /dev/sdd1 sector 1113128)
> [43510.285120] BTRFS: read error corrected: ino 1 off 561537024 (dev
> /dev/sdd1 sector 1113136)
> [43510.285292] BTRFS: read error corrected: ino 1 off 561541120 (dev
> /dev/sdd1 sector 1113144)
> [43665.199768] BTRFS: sdd1 checksum verify failed on 912867328 wanted
> 322FCD22 found E3B80F9F level 0
> [43665.204858] BTRFS: read error corrected: ino 1 off 912867328 (dev
> /dev/sdd1 sector 1799328)
> [43665.205055] BTRFS: read error corrected: ino 1 off 912871424 (dev
> /dev/sdd1 sector 1799336)
> [43665.205249] BTRFS: read error corrected: ino 1 off 912875520 (dev
> /dev/sdd1 sector 1799344)
> [43665.205431] BTRFS: read error corrected: ino 1 off 912879616 (dev
> /dev/sdd1 sector 1799352)
> [44830.868804] BTRFS: sdc1 checksum verify failed on 177061888 wanted
> 91211FC3 found 9ED5C83C level 0
> [44830.881691] BTRFS: read error corrected: ino 1 off 177061888 (dev
> /dev/sdc1 sector 362208)
> [44830.881890] BTRFS: read error corrected: ino 1 off 177065984 (dev
> /dev/sdc1 sector 362216)
> [44830.882090] BTRFS: read error corrected: ino 1 off 177070080 (dev
> /dev/sdc1 sector 362224)
> [44830.882271] BTRFS: read error corrected: ino 1 off 177074176 (dev
> /dev/sdc1 sector 362232)
> [45891.249508] BTRFS: sdd1 checksum verify failed on 738902016 wanted
> 39A87C68 found 26F7DDC0 level 0
> [45891.250573] BTRFS: sdd1 checksum verify failed on 738902016 wanted
> 39A87C68 found 26F7DDC0 level 0
> [45891.256723] BTRFS: read error corrected: ino 1 off 738902016 (dev
> /dev/sdd1 sector 1459552)
> [45891.256930] BTRFS: read error corrected: ino 1 off 738906112 (dev
> /dev/sdd1 sector 1459560)
> [45891.257149] BTRFS: read error corrected: ino 1 off 738910208 (dev
> /dev/sdd1 sector 1459568)
> [45891.257354] BTRFS: read error corrected: ino 1 off 738914304 (dev
> /dev/sdd1 sector 1459576)
> [46483.180506] BTRFS: sdd1 checksum verify failed on 629964800 wanted
> 4925982F found FDC8E201 level 0
> [46484.513724] BTRFS: sdd1 checksum verify failed on 629964800 wanted
> 4925982F found FDC8E201 level 0
> [46484.531887] BTRFS: read error corrected: ino 1 off 629964800 (dev
> /dev/sdd1 sector 1246784)
> [46484.532272] BTRFS: read error corrected: ino 1 off 629968896 (dev
> /dev/sdd1 sector 1246792)
> [46484.532435] BTRFS: read error corrected: ino 1 off 629972992 (dev
> /dev/sdd1 sector 1246800)
> [46484.532606] BTRFS: read error corrected: ino 1 off 629977088 (dev
> /dev/sdd1 sector 1246808)
> [47018.575521] BTRFS: sdd1 checksum verify failed on 1057505280 wanted
> 73DE9ACE found CCB9B94F level 0
> [47018.575961] BTRFS: sdd1 checksum verify failed on 1057505280 wanted
> 73DE9ACE found CCB9B94F level 0
> [47018.587562] BTRFS: read error corrected: ino 1 off 1057505280 (dev
> /dev/sdd1 sector 2081824)
> [47018.587727] BTRFS: read error corrected: ino 1 off 1057509376 (dev
> /dev/sdd1 sector 2081832)
> [47018.587985] BTRFS: read error corrected: ino 1 off 1057513472 (dev
> /dev/sdd1 sector 2081840)
> [47018.588171] BTRFS: read error corrected: ino 1 off 1057517568 (dev
> /dev/sdd1 sector 2081848)
> [47093.159882] BTRFS: sdd1 checksum verify failed on 355254272 wanted
> 6CCD79A6 found D82B8A63 level 0
> [47120.658821] BTRFS: sdd1 checksum verify failed on 355254272 wanted
> 6CCD79A6 found D82B8A63 level 0
> [47120.668197] BTRFS: read error corrected: ino 1 off 355254272 (dev
> /dev/sdd1 sector 710240)
> [47120.668385] BTRFS: read error corrected: ino 1 off 355258368 (dev
> /dev/sdd1 sector 710248)
> [47120.668537] BTRFS: read error corrected: ino 1 off 355262464 (dev
> /dev/sdd1 sector 710256)
> [47120.668707] BTRFS: read error corrected: ino 1 off 355266560 (dev
> /dev/sdd1 sector 710264)
> [47187.793809] BTRFS: sdd1 checksum verify failed on 610385920 wanted
> 8942E6D9 found 974441F7 level 0
> [47187.803132] BTRFS: read error corrected: ino 1 off 610385920 (dev
> /dev/sdd1 sector 1208544)
> [47187.803321] BTRFS: read error corrected: ino 1 off 610390016 (dev
> /dev/sdd1 sector 1208552)
> [47187.803500] BTRFS: read error corrected: ino 1 off 610394112 (dev
> /dev/sdd1 sector 1208560)
> [47187.804405] BTRFS: read error corrected: ino 1 off 610398208 (dev
> /dev/sdd1 sector 1208568)
> [47293.372124] BTRFS: sdd1 checksum verify failed on 30064640 wanted
> E532B4CB found 1F6BB1CF level 0
> [47293.392624] BTRFS: read error corrected: ino 1 off 30064640 (dev
> /dev/sdd1 sector 75104)
> [47293.392931] BTRFS: read error corrected: ino 1 off 30068736 (dev
> /dev/sdd1 sector 75112)
> [47293.393143] BTRFS: read error corrected: ino 1 off 30072832 (dev
> /dev/sdd1 sector 75120)
> [47293.393367] BTRFS: read error corrected: ino 1 off 30076928 (dev
> /dev/sdd1 sector 75128)
> [47415.432548] BTRFS: sdc1 checksum verify failed on 483311616 wanted
> 2337659C found FE72CF24 level 0
> [47415.806725] BTRFS: sdc1 checksum verify failed on 483311616 wanted
> 2337659C found FE72CF24 level 0
> [47415.816027] BTRFS: read error corrected: ino 1 off 483311616 (dev
> /dev/sdc1 sector 960352)
> [47415.816199] BTRFS: read error corrected: ino 1 off 483315712 (dev
> /dev/sdc1 sector 960360)
> [47415.816372] BTRFS: read error corrected: ino 1 off 483319808 (dev
> /dev/sdc1 sector 960368)
> [47415.816838] BTRFS: read error corrected: ino 1 off 483323904 (dev
> /dev/sdc1 sector 960376)
> [47593.204118] BTRFS: sdd1 checksum verify failed on 131497984 wanted
> C1B6312B found E5650C5B level 0
> [47593.212026] BTRFS: read error corrected: ino 1 off 131497984 (dev
> /dev/sdd1 sector 273216)
> [47593.212182] BTRFS: read error corrected: ino 1 off 131502080 (dev
> /dev/sdd1 sector 273224)
> [47593.212355] BTRFS: read error corrected: ino 1 off 131506176 (dev
> /dev/sdd1 sector 273232)
> [47593.212526] BTRFS: read error corrected: ino 1 off 131510272 (dev
> /dev/sdd1 sector 273240)
> [48026.762834] BTRFS: sdc1 checksum verify failed on 856752128 wanted
> 640450F found B927668E level 0
> [48026.802163] BTRFS: read error corrected: ino 1 off 856752128 (dev
> /dev/sdc1 sector 1689728)
> [48026.802810] BTRFS: read error corrected: ino 1 off 856756224 (dev
> /dev/sdc1 sector 1689736)
> [48026.803040] BTRFS: read error corrected: ino 1 off 856760320 (dev
> /dev/sdc1 sector 1689744)
> [48026.803240] BTRFS: read error corrected: ino 1 off 856764416 (dev
> /dev/sdc1 sector 1689752)
> [48157.352847] BTRFS: sdd1 checksum verify failed on 721502208 wanted
> F58E06B7 found 28CBAC0F level 0
> [48157.363809] BTRFS: read error corrected: ino 1 off 721502208 (dev
> /dev/sdd1 sector 1425568)
> [48157.364175] BTRFS: read error corrected: ino 1 off 721506304 (dev
> /dev/sdd1 sector 1425576)
> [48157.364341] BTRFS: read error corrected: ino 1 off 721510400 (dev
> /dev/sdd1 sector 1425584)
> [48157.364559] BTRFS: read error corrected: ino 1 off 721514496 (dev
> /dev/sdd1 sector 1425592)
> [48717.558596] BTRFS: sdd1 checksum verify failed on 425967616 wanted
> 8B488C01 found 52F6044C level 0
> [48717.576610] BTRFS: read error corrected: ino 1 off 425967616 (dev
> /dev/sdd1 sector 848352)
> [48717.576856] BTRFS: read error corrected: ino 1 off 425971712 (dev
> /dev/sdd1 sector 848360)
> [48717.577651] BTRFS: read error corrected: ino 1 off 425975808 (dev
> /dev/sdd1 sector 848368)
> [48717.577877] BTRFS: read error corrected: ino 1 off 425979904 (dev
> /dev/sdd1 sector 848376)
> [48740.429310] BTRFS: sdd1 checksum verify failed on 570064896 wanted
> 4B343BE0 found BD92455F level 0
> [48740.437713] BTRFS: read error corrected: ino 1 off 570064896 (dev
> /dev/sdd1 sector 1129792)
> [48740.437935] BTRFS: read error corrected: ino 1 off 570068992 (dev
> /dev/sdd1 sector 1129800)
> [48740.438098] BTRFS: read error corrected: ino 1 off 570073088 (dev
> /dev/sdd1 sector 1129808)
> [48740.438271] BTRFS: read error corrected: ino 1 off 570077184 (dev
> /dev/sdd1 sector 1129816)
> [48746.809311] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 6E0D3115 level 0
> [48746.810381] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 6E0D3115 level 0
> [48746.819699] BTRFS: sdd1 checksum verify failed on 588447744 wanted
> F90C810B found 24492BB3 level 0
> [48746.819733] ------------[ cut here ]------------
> [48746.819746] WARNING: CPU: 0 PID: 31802 at fs/btrfs/super.c:259
> __btrfs_abort_transaction+0x43/0x110()
> [48746.819747] BTRFS: Transaction aborted (error -5)
> [48746.819748] Modules linked in: iscsi_trgt(O)
> [48746.819755] CPU: 0 PID: 31802 Comm: kworker/u2:11 Tainted: G
>    O  3.16.5-gentoo-20150103-0758 #1
> [48746.819757] Hardware name:    /MS-6570, BIOS 6.00 PG 11/07/2003
> [48746.819762] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
> [48746.819764]  c9a9fe74 c9a9fe74 c9a9fe34 c14d581f c9a9fe64 c10333d0
> c15bcea0 c9a9fe90
> [48746.819767]  00007c3a c15c9417 00000103 c11c8723 c11c8723 fffffffb
> f4c1a000 c14fd856
> [48746.819771]  c9a9fe7c c103341e 00000009 c9a9fe74 c15bcea0 c9a9fe90
> c9a9fea8 c11c8723
> [48746.819775] Call Trace:
> [48746.819783]  [<c14d581f>] dump_stack+0x16/0x18
> [48746.819787]  [<c10333d0>] warn_slowpath_common+0x70/0x90
> [48746.819791]  [<c11c8723>] ? __btrfs_abort_transaction+0x43/0x110
> [48746.819793]  [<c11c8723>] ? __btrfs_abort_transaction+0x43/0x110
> [48746.819796]  [<c103341e>] warn_slowpath_fmt+0x2e/0x30
> [48746.819799]  [<c11c8723>] __btrfs_abort_transaction+0x43/0x110
> [48746.819805]  [<c11e2cc4>] btrfs_run_delayed_refs.part.74+0xd4/0x1d0
> [48746.819808]  [<c11e2e4d>] delayed_ref_async_start+0x6d/0x80
> [48746.819810]  [<c1222558>] normal_work_helper+0x88/0x120
> [48746.819813]  [<c12227db>] btrfs_extent_refs_helper+0xb/0x10
> [48746.819816]  [<c1044081>] process_one_work+0xd1/0x300
> [48746.819819]  [<c1044779>] worker_thread+0xe9/0x430
> [48746.819821]  [<c1044690>] ? create_and_start_worker+0x40/0x40
> [48746.819823]  [<c1044690>] ? create_and_start_worker+0x40/0x40
> [48746.819828]  [<c1048cf5>] kthread+0x95/0xb0
> [48746.819831]  [<c14da0c0>] ret_from_kernel_thread+0x20/0x30
> [48746.819834]  [<c1048c60>] ? kthread_worker_fn+0xb0/0xb0
> [48746.819835] ---[ end trace 554ae9ecb6239dc6 ]---
> [48746.819838] BTRFS: error (device sdd1) in
> btrfs_run_delayed_refs:2806: errno=-5 IO failure
> [48746.819840] BTRFS info (device sdd1): forced readonly
