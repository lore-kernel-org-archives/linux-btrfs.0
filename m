Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52484 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaHNTOH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:14:07 -0400
Date: Thu, 14 Aug 2014 12:14:05 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-zero-log fails, can't mount FS
Message-ID: <20140814191405.GE27531@merlins.org>
References: <20140814160902.GA25370@merlins.org> <53ECE953.70009@gmail.com> <20140814172743.GC27531@merlins.org> <CED1BA77-2F2E-4ABF-AE56-5896FA377627@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CED1BA77-2F2E-4ABF-AE56-5896FA377627@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 01:10:05PM -0600, Chris Murphy wrote:
> 
> On Aug 14, 2014, at 11:27 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > On Thu, Aug 14, 2014 at 12:52:35PM -0400, Austin S Hemmelgarn wrote:
> >> I don't think it is likely that the Samsung SSD is to blame, in my
> >> experience Samsung's SSD's are better than almost every other brand
> >> except Intel, and I know that they honor write-barriers correctly.
> >> The likely issue is that the system hung during the process of a commit,
> >> which is one of the few things that I know of that consistently corrupts
> >> the filesystem.  There isn't really anything I know of to prevent it,
> >> except for making your system as stable as possible.
> >> Interestingly, this type of thing is the only issue I've ever had with
> >> BTRFS that wasn't traceable to hardware problems.
> > 
> > That was my understanding too, thanks for confirming.
> > 
> > Until this bug gets fixed, I'm perplexed as to why btrfs-zero-log isn't
> > fixing this.
> > Can't I unroll the last commits until I get to a stable one?
> 
> What do you get for btrfs-debug-tree -R <dev>

Gotta love all those tools that core dump :)

legolas:~#  btrfs-debug-tree -R /dev/mapper/disk1 
Check tree block failed, want=49500766208, have=8622613565695139001
Check tree block failed, want=49500766208, have=8622613565695139001
Check tree block failed, want=49500766208, have=10955809011958619003
Check tree block failed, want=49500766208, have=10955809011958619003
Check tree block failed, want=49500766208, have=10955809011958619003
read block failed check_tree_block
Couldn't setup log root tree
root tree: 863567872 level 1
chunk tree: 20971520 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 848805888 level 2
device tree key (DEV_TREE ROOT_ITEM 0) 443924480 level 1
fs tree key (FS_TREE ROOT_ITEM 0) 995983360 level 1
checksum tree key (CSUM_TREE ROOT_ITEM 0) 835649536 level 2
uuid tree key (UUID_TREE ROOT_ITEM 0) 996458496 level 0
file tree key (390 ROOT_ITEM 206) 612500717568 level 2
file tree key (391 ROOT_ITEM 207) 336409575424 level 2
file tree key (392 ROOT_ITEM 208) 836059136 level 2
file tree key (393 ROOT_ITEM 209) 931414016 level 1
file tree key (394 ROOT_ITEM 0) 835256320 level 2
file tree key (4498 ROOT_ITEM 0) 510159699968 level 0
file tree key (8381 ROOT_ITEM 115314) 510114430976 level 2
file tree key (8382 ROOT_ITEM 115315) 510089117696 level 1
file tree key (8383 ROOT_ITEM 115316) 510109270016 level 2
file tree key (8384 ROOT_ITEM 115317) 510120607744 level 2
file tree key (10019 ROOT_ITEM 135098) 49889722368 level 2
file tree key (10020 ROOT_ITEM 135099) 49842421760 level 1
file tree key (10021 ROOT_ITEM 135100) 230384123904 level 2
file tree key (10022 ROOT_ITEM 135101) 230647595008 level 2
file tree key (11301 ROOT_ITEM 151188) 229924634624 level 2
file tree key (11302 ROOT_ITEM 151189) 229842403328 level 1
file tree key (11303 ROOT_ITEM 151190) 229937119232 level 2
file tree key (11304 ROOT_ITEM 151191) 229862588416 level 2
file tree key (12601 ROOT_ITEM 167621) 138067968 level 2
file tree key (12602 ROOT_ITEM 167622) 164167680 level 1
file tree key (12603 ROOT_ITEM 167623) 202440704 level 2
file tree key (12604 ROOT_ITEM 167624) 330072064 level 2
file tree key (12625 ROOT_ITEM 167930) 230598770688 level 2
file tree key (12626 ROOT_ITEM 167931) 230692569088 level 2
file tree key (12627 ROOT_ITEM 167932) 230637207552 level 1
file tree key (12628 ROOT_ITEM 167933) 230750437376 level 2
file tree key (12629 ROOT_ITEM 167934) 230780665856 level 2
file tree key (13479 ROOT_ITEM 178311) 230256492544 level 2
file tree key (13480 ROOT_ITEM 178312) 230230228992 level 1
file tree key (13481 ROOT_ITEM 178313) 230511280128 level 2
file tree key (13482 ROOT_ITEM 178314) 230665158656 level 2
file tree key (13910 ROOT_ITEM 183332) 49714839552 level 2
file tree key (13911 ROOT_ITEM 183333) 49841012736 level 1
file tree key (13912 ROOT_ITEM 183334) 110214152192 level 2
file tree key (13913 ROOT_ITEM 183335) 110268973056 level 2
file tree key (14038 ROOT_ITEM 184865) 327415414784 level 2
file tree key (14039 ROOT_ITEM 184866) 336409411584 level 0
file tree key (14798 ROOT_ITEM 195605) 612576329728 level 2
file tree key (14799 ROOT_ITEM 195606) 612562141184 level 1
file tree key (14800 ROOT_ITEM 195607) 612588486656 level 2
file tree key (14801 ROOT_ITEM 195608) 31932416 level 2
file tree key (15563 ROOT_ITEM 205226) 510513643520 level 2
file tree key (15564 ROOT_ITEM 205227) 510557667328 level 0
file tree key (16652 ROOT_ITEM 218081) 230195118080 level 2
file tree key (16653 ROOT_ITEM 218113) 230195134464 level 2
file tree key (16786 ROOT_ITEM 219953) 491881742336 level 2
file tree key (16787 ROOT_ITEM 219954) 504223088640 level 2
file tree key (16788 ROOT_ITEM 219957) 504223121408 level 2
file tree key (16789 ROOT_ITEM 219958) 504290639872 level 1
file tree key (16790 ROOT_ITEM 219960) 504290656256 level 1
file tree key (16791 ROOT_ITEM 219961) 504531058688 level 2
file tree key (16792 ROOT_ITEM 219980) 504531075072 level 2
file tree key (16793 ROOT_ITEM 219981) 168427520 level 2
file tree key (16804 ROOT_ITEM 220132) 168607744 level 2
file tree key (17027 ROOT_ITEM 223030) 230017482752 level 2
file tree key (17037 ROOT_ITEM 223088) 230017564672 level 2
file tree key (17038 ROOT_ITEM 223089) 491855331328 level 2
file tree key (17039 ROOT_ITEM 223100) 491855675392 level 2
file tree key (17040 ROOT_ITEM 223101) 492153208832 level 1
file tree key (17041 ROOT_ITEM 223104) 492153241600 level 1
file tree key (17042 ROOT_ITEM 223106) 504231215104 level 2
file tree key (17043 ROOT_ITEM 223109) 504231247872 level 2
file tree key (17044 ROOT_ITEM 223110) 49890738176 level 2
file tree key (17075 ROOT_ITEM 223551) 49890754560 level 2
file tree key (17181 ROOT_ITEM 224965) 504618991616 level 2
file tree key (17182 ROOT_ITEM 224966) 504678170624 level 0
file tree key (17280 ROOT_ITEM 226286) 491965333504 level 2
file tree key (17290 ROOT_ITEM 226338) 491965349888 level 2
file tree key (17291 ROOT_ITEM 226339) 492110839808 level 2
file tree key (17292 ROOT_ITEM 226341) 492110905344 level 2
file tree key (17293 ROOT_ITEM 226342) 504548524032 level 1
file tree key (17294 ROOT_ITEM 226344) 504548655104 level 1
file tree key (17295 ROOT_ITEM 226345) 504569757696 level 2
file tree key (17296 ROOT_ITEM 226347) 504569806848 level 2
file tree key (17297 ROOT_ITEM 226348) 49817305088 level 2
file tree key (17308 ROOT_ITEM 226474) 49817337856 level 2
file tree key (17525 ROOT_ITEM 229435) 491893882880 level 2
file tree key (17531 ROOT_ITEM 229493) 491893932032 level 2
file tree key (17532 ROOT_ITEM 229494) 504272453632 level 2
file tree key (17533 ROOT_ITEM 229496) 504272486400 level 2
file tree key (17534 ROOT_ITEM 229497) 504432590848 level 1
file tree key (17535 ROOT_ITEM 229499) 504432607232 level 1
file tree key (17536 ROOT_ITEM 229500) 504496865280 level 2
file tree key (17537 ROOT_ITEM 229502) 504496881664 level 2
file tree key (17538 ROOT_ITEM 229503) 179634176 level 2
file tree key (17549 ROOT_ITEM 229599) 179666944 level 2
file tree key (17751 ROOT_ITEM 232357) 611785850880 level 0
file tree key (17780 ROOT_ITEM 232627) 49572134912 level 2
file tree key (17962 ROOT_ITEM 235135) 510159732736 level 0
file tree key (17992 ROOT_ITEM 235423) 491842600960 level 2
file tree key (17993 ROOT_ITEM 235528) 491842617344 level 2
file tree key (17994 ROOT_ITEM 235529) 492302827520 level 2
file tree key (17995 ROOT_ITEM 235531) 492302860288 level 2
file tree key (17996 ROOT_ITEM 235532) 504195743744 level 1
file tree key (17997 ROOT_ITEM 235535) 504195760128 level 1
file tree key (17998 ROOT_ITEM 235536) 504257396736 level 2
file tree key (17999 ROOT_ITEM 235542) 504257544192 level 2
file tree key (18000 ROOT_ITEM 235543) 504230019072 level 2
file tree key (18088 ROOT_ITEM 236585) 612167581696 level 1
file tree key (18089 ROOT_ITEM 236587) 612167598080 level 1
file tree key (18090 ROOT_ITEM 236588) 612201299968 level 2
file tree key (18091 ROOT_ITEM 236590) 612201316352 level 2
file tree key (18092 ROOT_ITEM 236591) 105119744 level 2
file tree key (18093 ROOT_ITEM 236593) 105218048 level 2
file tree key (18094 ROOT_ITEM 236702) 611759964160 level 2
file tree key (18095 ROOT_ITEM 236705) 611759980544 level 2
file tree key (18096 ROOT_ITEM 236706) 611815489536 level 2
file tree key (18097 ROOT_ITEM 236708) 611815620608 level 2
file tree key (18098 ROOT_ITEM 236709) 611968499712 level 1
file tree key (18099 ROOT_ITEM 236711) 611968516096 level 1
file tree key (18100 ROOT_ITEM 236712) 612016160768 level 2
file tree key (18101 ROOT_ITEM 236714) 612016373760 level 2
file tree key (18102 ROOT_ITEM 236715) 612596367360 level 2
file tree key (18103 ROOT_ITEM 236718) 612596400128 level 2
file tree key (18104 ROOT_ITEM 236851) 510560157696 level 2
file tree key (18105 ROOT_ITEM 236855) 510560206848 level 2
file tree key (18106 ROOT_ITEM 236856) 611572793344 level 2
file tree key (18107 ROOT_ITEM 236858) 611572809728 level 2
file tree key (18108 ROOT_ITEM 236859) 611641606144 level 1
file tree key (18109 ROOT_ITEM 236861) 611641622528 level 1
file tree key (18110 ROOT_ITEM 236862) 611783540736 level 2
file tree key (18111 ROOT_ITEM 236864) 611783589888 level 2
file tree key (18112 ROOT_ITEM 236865) 49582915584 level 2
file tree key (18113 ROOT_ITEM 236879) 49582964736 level 2
file tree key (18114 ROOT_ITEM 236974) 504642289664 level 2
file tree key (18115 ROOT_ITEM 236977) 504642322432 level 2
file tree key (18116 ROOT_ITEM 236978) 504615698432 level 2
file tree key (18117 ROOT_ITEM 236980) 504615895040 level 2
file tree key (18118 ROOT_ITEM 236981) 510088232960 level 1
file tree key (18119 ROOT_ITEM 236983) 510088249344 level 1
file tree key (18120 ROOT_ITEM 236984) 510239031296 level 2
file tree key (18121 ROOT_ITEM 236986) 510239047680 level 2
file tree key (18122 ROOT_ITEM 236987) 612355768320 level 2
file tree key (18123 ROOT_ITEM 236998) 612355784704 level 2
file tree key (18124 ROOT_ITEM 237099) 229982093312 level 2
file tree key (18125 ROOT_ITEM 237102) 229982109696 level 2
file tree key (18126 ROOT_ITEM 237103) 299814764544 level 2
file tree key (18127 ROOT_ITEM 237105) 299814780928 level 2
file tree key (18128 ROOT_ITEM 237106) 327476559872 level 1
file tree key (18129 ROOT_ITEM 237108) 327476625408 level 1
file tree key (18130 ROOT_ITEM 237109) 354673475584 level 2
file tree key (18131 ROOT_ITEM 237111) 354674851840 level 2
file tree key (18132 ROOT_ITEM 237112) 504458788864 level 2
file tree key (18133 ROOT_ITEM 237119) 504458805248 level 2
file tree key (18134 ROOT_ITEM 237203) 612264886272 level 2
file tree key (18135 ROOT_ITEM 237206) 612264902656 level 2
file tree key (18136 ROOT_ITEM 237208) 636928000 level 2
file tree key (18137 ROOT_ITEM 237211) 637960192 level 2
file tree key (18138 ROOT_ITEM 237212) 991019008 level 1
file tree key (18139 ROOT_ITEM 237214) 991051776 level 1
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 29442048 level 0
btrfs root backup slot 0
	tree root gen 237211 block 637976576
		extent root gen 237212 block 648151040
		chunk root gen 236333 block 20971520
		device root gen 236333 block 443924480
		csum root gen 237212 block 644497408
		fs root gen 237211 block 638418944
		578956607488 used 928795811840 total 1 devices
btrfs root backup slot 1
	tree root gen 237212 block 660799488
		extent root gen 237213 block 596721664
		chunk root gen 236333 block 20971520
		device root gen 236333 block 443924480
		csum root gen 237213 block 596475904
		fs root gen 237212 block 660668416
		578954768384 used 928795811840 total 1 devices
btrfs root backup slot 2
	tree root gen 237213 block 830685184
		extent root gen 237213 block 596721664
		chunk root gen 236333 block 20971520
		device root gen 236333 block 443924480
		csum root gen 237214 block 835649536
		fs root gen 237212 block 660668416
		578956967936 used 928795811840 total 1 devices
btrfs root backup slot 3
	tree root gen 237214 block 863567872
		extent root gen 237215 block 1011187712
		chunk root gen 236333 block 20971520
		device root gen 236333 block 443924480
		csum root gen 237215 block 1005453312
		fs root gen 237214 block 995983360
		579045502976 used 928795811840 total 1 devices
total bytes 928795811840
bytes used 578953150464
uuid 79a9a6c7-0955-4820-b81e-0c0681a657c1
Btrfs v3.14.1
Segmentation fault (core dumped)

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
