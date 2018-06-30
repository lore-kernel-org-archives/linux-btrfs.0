Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51140 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbeF3VGW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 17:06:22 -0400
Date: Sat, 30 Jun 2018 14:06:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: suy.fnst@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Message-ID: <20180630210610.vhx6dbq7gkflwqhb@merlins.org>
References: <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
 <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
 <20180629072831.qocyipdvmcm6cbo7@merlins.org>
 <20180629171044.yudgzzwpgpetim5q@merlins.org>
 <20180630024419.tzupddsw627iyhaz@merlins.org>
 <01065a4e-4157-7a42-bffb-4e002defa3ba@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01065a4e-4157-7a42-bffb-4e002defa3ba@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 30, 2018 at 10:49:07PM +0800, Qu Wenruo wrote:
> But the last abort looks pretty possible to be the culprit.
> 
> Would you try to dump the extent tree?
> # btrfs inspect dump-tree -t extent <device> | grep -A50 156909494272

Sure, there you go:

	item 25 key (156909494272 EXTENT_ITEM 55320576) itemoff 14943 itemsize 24
		refs 19715 gen 31575 flags DATA
	item 26 key (156909494272 EXTENT_DATA_REF 571620086735451015) itemoff 14915 itemsize 28
		extent data backref root 21641 objectid 374857 offset 235175936 count 1452
	item 27 key (156909494272 EXTENT_DATA_REF 1765833482087969671) itemoff 14887 itemsize 28
		extent data backref root 23094 objectid 374857 offset 235175936 count 1442
	item 28 key (156909494272 EXTENT_DATA_REF 1807626434455810951) itemoff 14859 itemsize 28
		extent data backref root 21503 objectid 374857 offset 235175936 count 1454
	item 29 key (156909494272 EXTENT_DATA_REF 1879818091602916231) itemoff 14831 itemsize 28
		extent data backref root 21462 objectid 374857 offset 235175936 count 1454
	item 30 key (156909494272 EXTENT_DATA_REF 3610854505775117191) itemoff 14803 itemsize 28
		extent data backref root 23134 objectid 374857 offset 235175936 count 1442
	item 31 key (156909494272 EXTENT_DATA_REF 3754675454231458695) itemoff 14775 itemsize 28
		extent data backref root 23052 objectid 374857 offset 235175936 count 1442
	item 32 key (156909494272 EXTENT_DATA_REF 5060494667839714183) itemoff 14747 itemsize 28
		extent data backref root 23174 objectid 374857 offset 235175936 count 1440
	item 33 key (156909494272 EXTENT_DATA_REF 5476627808561673095) itemoff 14719 itemsize 28
		extent data backref root 22911 objectid 374857 offset 235175936 count 1
	item 34 key (156909494272 EXTENT_DATA_REF 6378484416458011527) itemoff 14691 itemsize 28
		extent data backref root 23012 objectid 374857 offset 235175936 count 1442
	item 35 key (156909494272 EXTENT_DATA_REF 7338474132555182983) itemoff 14663 itemsize 28
		extent data backref root 21872 objectid 374857 offset 235175936 count 1
	item 36 key (156909494272 EXTENT_DATA_REF 7516565391717970823) itemoff 14635 itemsize 28
		extent data backref root 21826 objectid 374857 offset 235175936 count 1452
	item 37 key (156909494272 SHARED_DATA_REF 14871537025024) itemoff 14631 itemsize 4
		shared data backref count 10
	item 38 key (156909494272 SHARED_DATA_REF 14871617568768) itemoff 14627 itemsize 4
		shared data backref count 73
	item 39 key (156909494272 SHARED_DATA_REF 14871619846144) itemoff 14623 itemsize 4
		shared data backref count 59
	item 40 key (156909494272 SHARED_DATA_REF 14871623270400) itemoff 14619 itemsize 4
		shared data backref count 68
	item 41 key (156909494272 SHARED_DATA_REF 14871623532544) itemoff 14615 itemsize 4
		shared data backref count 70
	item 42 key (156909494272 SHARED_DATA_REF 14871626383360) itemoff 14611 itemsize 4
		shared data backref count 76
	item 43 key (156909494272 SHARED_DATA_REF 14871635132416) itemoff 14607 itemsize 4
		shared data backref count 60
	item 44 key (156909494272 SHARED_DATA_REF 14871649533952) itemoff 14603 itemsize 4
		shared data backref count 79
	item 45 key (156909494272 SHARED_DATA_REF 14871862378496) itemoff 14599 itemsize 4
		shared data backref count 70
	item 46 key (156909494272 SHARED_DATA_REF 14909667098624) itemoff 14595 itemsize 4
		shared data backref count 72
	item 47 key (156909494272 SHARED_DATA_REF 14909669720064) itemoff 14591 itemsize 4
		shared data backref count 58
	item 48 key (156909494272 SHARED_DATA_REF 14909734567936) itemoff 14587 itemsize 4
		shared data backref count 73
	item 49 key (156909494272 SHARED_DATA_REF 14909920477184) itemoff 14583 itemsize 4
		shared data backref count 79
	item 50 key (156909494272 SHARED_DATA_REF 14942279335936) itemoff 14579 itemsize 4
		shared data backref count 79
	item 51 key (156909494272 SHARED_DATA_REF 14942304862208) itemoff 14575 itemsize 4
		shared data backref count 72
	item 52 key (156909494272 SHARED_DATA_REF 14942348378112) itemoff 14571 itemsize 4
		shared data backref count 67
	item 53 key (156909494272 SHARED_DATA_REF 14942366138368) itemoff 14567 itemsize 4
		shared data backref count 51
	item 54 key (156909494272 SHARED_DATA_REF 14942384799744) itemoff 14563 itemsize 4
		shared data backref count 64
	item 55 key (156909494272 SHARED_DATA_REF 14978234613760) itemoff 14559 itemsize 4
		shared data backref count 61
	item 56 key (156909494272 SHARED_DATA_REF 14978246459392) itemoff 14555 itemsize 4
		shared data backref count 56
	item 57 key (156909494272 SHARED_DATA_REF 14978256879616) itemoff 14551 itemsize 4
		shared data backref count 75
	item 58 key (156909494272 SHARED_DATA_REF 15001465749504) itemoff 14547 itemsize 4
		shared data backref count 77
	item 59 key (156909494272 SHARED_DATA_REF 18215010877440) itemoff 14543 itemsize 4
		shared data backref count 79
	item 60 key (156909494272 SHARED_DATA_REF 18215045660672) itemoff 14539 itemsize 4
		shared data backref count 10
	item 61 key (156909494272 SHARED_DATA_REF 18215099023360) itemoff 14535 itemsize 4
		shared data backref count 56
	item 62 key (156909494272 SHARED_DATA_REF 18215114522624) itemoff 14531 itemsize 4
		shared data backref count 70
	item 63 key (156909494272 SHARED_DATA_REF 18215129874432) itemoff 14527 itemsize 4
		shared data backref count 68
	item 64 key (156909494272 SHARED_DATA_REF 18215130267648) itemoff 14523 itemsize 4
		shared data backref count 72
	item 65 key (156909494272 SHARED_DATA_REF 18215136264192) itemoff 14519 itemsize 4
		shared data backref count 64
	item 66 key (156909494272 SHARED_DATA_REF 18215138623488) itemoff 14515 itemsize 4
		shared data backref count 72
	item 67 key (156909494272 SHARED_DATA_REF 18215188414464) itemoff 14511 itemsize 4
		shared data backref count 58
	item 68 key (156909494272 SHARED_DATA_REF 18215188447232) itemoff 14507 itemsize 4
		shared data backref count 74
	item 69 key (156909494272 SHARED_DATA_REF 18215188529152) itemoff 14503 itemsize 4
		shared data backref count 69
	item 70 key (156909494272 SHARED_DATA_REF 18215204896768) itemoff 14499 itemsize 4
		shared data backref count 67
	item 71 key (156909494272 SHARED_DATA_REF 18215228358656) itemoff 14495 itemsize 4
		shared data backref count 68
	item 72 key (156909494272 SHARED_DATA_REF 18215228899328) itemoff 14491 itemsize 4
		shared data backref count 81
	item 73 key (156909494272 SHARED_DATA_REF 18215240892416) itemoff 14487 itemsize 4
		shared data backref count 78
	item 74 key (156909494272 SHARED_DATA_REF 18215244251136) itemoff 14483 itemsize 4
		shared data backref count 58
	item 75 key (156909494272 SHARED_DATA_REF 18215244365824) itemoff 14479 itemsize 4
		shared data backref count 63
	item 76 key (156909494272 SHARED_DATA_REF 18215252770816) itemoff 14475 itemsize 4
		shared data backref count 76
	item 77 key (156909494272 SHARED_DATA_REF 18215264337920) itemoff 14471 itemsize 4
		shared data backref count 76
	item 78 key (156909494272 SHARED_DATA_REF 18215270055936) itemoff 14467 itemsize 4
		shared data backref count 73
	item 79 key (156909494272 SHARED_DATA_REF 18215290601472) itemoff 14463 itemsize 4
		shared data backref count 63
	item 80 key (156909494272 SHARED_DATA_REF 18215290617856) itemoff 14459 itemsize 4
		shared data backref count 54
	item 81 key (156909494272 SHARED_DATA_REF 18244453154816) itemoff 14455 itemsize 4
		shared data backref count 79
	item 82 key (156909494272 SHARED_DATA_REF 18244454383616) itemoff 14451 itemsize 4
		shared data backref count 71
	item 83 key (156909494272 SHARED_DATA_REF 18249494151168) itemoff 14447 itemsize 4
		shared data backref count 79
	item 84 key (156909494272 SHARED_DATA_REF 18249500721152) itemoff 14443 itemsize 4
		shared data backref count 71
	item 85 key (156909494272 SHARED_DATA_REF 18249523789824) itemoff 14439 itemsize 4
		shared data backref count 51
	item 86 key (156909494272 SHARED_DATA_REF 18249586802688) itemoff 14435 itemsize 4
		shared data backref count 68
	item 87 key (156909494272 SHARED_DATA_REF 18249587703808) itemoff 14431 itemsize 4
		shared data backref count 70
	item 88 key (156909494272 SHARED_DATA_REF 18249588178944) itemoff 14427 itemsize 4
		shared data backref count 72
	item 89 key (156909494272 SHARED_DATA_REF 18249591291904) itemoff 14423 itemsize 4
		shared data backref count 67
	item 90 key (156909494272 SHARED_DATA_REF 18249598238720) itemoff 14419 itemsize 4
		shared data backref count 74
	item 91 key (156909494272 SHARED_DATA_REF 18249602285568) itemoff 14415 itemsize 4
		shared data backref count 79
	item 92 key (156909494272 SHARED_DATA_REF 18249611378688) itemoff 14411 itemsize 4
		shared data backref count 65
	item 93 key (156909494272 SHARED_DATA_REF 18249613082624) itemoff 14407 itemsize 4
		shared data backref count 55
	item 94 key (156909494272 SHARED_DATA_REF 18249642229760) itemoff 14403 itemsize 4
		shared data backref count 75
	item 95 key (156909494272 SHARED_DATA_REF 18249643458560) itemoff 14399 itemsize 4
		shared data backref count 68
	item 96 key (156909494272 SHARED_DATA_REF 18250800021504) itemoff 14395 itemsize 4
		shared data backref count 79
	item 97 key (156909494272 SHARED_DATA_REF 18250814963712) itemoff 14391 itemsize 4
		shared data backref count 71
	item 98 key (156909494272 SHARED_DATA_REF 18252047237120) itemoff 14387 itemsize 4
		shared data backref count 55
	item 99 key (156909494272 SHARED_DATA_REF 18252132515840) itemoff 14383 itemsize 4
		shared data backref count 68
	item 100 key (156909494272 SHARED_DATA_REF 18252134236160) itemoff 14379 itemsize 4
		shared data backref count 72
	item 101 key (156909494272 SHARED_DATA_REF 18252274827264) itemoff 14375 itemsize 4
		shared data backref count 68
	item 102 key (156909494272 SHARED_DATA_REF 18252313460736) itemoff 14371 itemsize 4
		shared data backref count 67
	item 103 key (156909494272 SHARED_DATA_REF 18252335906816) itemoff 14367 itemsize 4
		shared data backref count 79
	item 104 key (156909494272 SHARED_DATA_REF 18252336742400) itemoff 14363 itemsize 4
		shared data backref count 74
	item 105 key (156909494272 SHARED_DATA_REF 18254150631424) itemoff 14359 itemsize 4
		shared data backref count 56
	item 106 key (156909494272 SHARED_DATA_REF 18254342537216) itemoff 14355 itemsize 4
		shared data backref count 67
	item 107 key (156909494272 SHARED_DATA_REF 18255671017472) itemoff 14351 itemsize 4
		shared data backref count 72
	item 108 key (156909494272 SHARED_DATA_REF 18255806038016) itemoff 14347 itemsize 4
		shared data backref count 69
	item 109 key (156909494272 SHARED_DATA_REF 18255821996032) itemoff 14343 itemsize 4
		shared data backref count 67
	item 110 key (156909494272 SHARED_DATA_REF 18256006414336) itemoff 14339 itemsize 4
		shared data backref count 79
	item 111 key (156909494272 SHARED_DATA_REF 18256021012480) itemoff 14335 itemsize 4
		shared data backref count 74
	item 112 key (156909494272 SHARED_DATA_REF 18260113752064) itemoff 14331 itemsize 4
		shared data backref count 75
	item 113 key (156909494272 SHARED_DATA_REF 18260113883136) itemoff 14327 itemsize 4
		shared data backref count 65
	item 114 key (156909494272 SHARED_DATA_REF 18260114849792) itemoff 14323 itemsize 4
		shared data backref count 51
	item 115 key (156909494272 SHARED_DATA_REF 18260115013632) itemoff 14319 itemsize 4
		shared data backref count 70
	item 116 key (156909494272 SHARED_DATA_REF 18261625552896) itemoff 14315 itemsize 4
		shared data backref count 75
	item 117 key (156909494272 SHARED_DATA_REF 18261631107072) itemoff 14311 itemsize 4
		shared data backref count 65
	item 118 key (156909494272 SHARED_DATA_REF 18261652078592) itemoff 14307 itemsize 4
		shared data backref count 52
	item 119 key (156909494272 SHARED_DATA_REF 18261658025984) itemoff 14303 itemsize 4
		shared data backref count 70
	item 120 key (156964814848 EXTENT_ITEM 7487488) itemoff 13856 itemsize 447
		refs 2505 gen 31575 flags DATA
		extent data backref root 21826 objectid 374857 offset 290496512 count 192
		extent data backref root 21872 objectid 374857 offset 290496512 count 192
		extent data backref root 23012 objectid 374857 offset 290496512 count 193
		extent data backref root 22911 objectid 374857 offset 290496512 count 192
		extent data backref root 23174 objectid 374857 offset 290496512 count 193
		extent data backref root 23052 objectid 374857 offset 290496512 count 193
		extent data backref root 23134 objectid 374857 offset 290496512 count 193
		extent data backref root 21462 objectid 374857 offset 290496512 count 192
		extent data backref root 21503 objectid 374857 offset 290496512 count 192
		extent data backref root 23094 objectid 374857 offset 290496512 count 193
		extent data backref root 21641 objectid 374857 offset 290496512 count 192
		shared data backref parent 18215389659136 count 55
		shared data backref parent 18215388102656 count 63
		shared data backref parent 18215294795776 count 69
		shared data backref parent 18215244365824 count 7
		shared data backref parent 14978251440128 count 55
		shared data backref parent 14978250768384 count 63
		shared data backref parent 14978248212480 count 69
		shared data backref parent 14978246459392 count 7
	item 121 key (156972302336 EXTENT_ITEM 8192) itemoff 13487 itemsize 369
		refs 13 gen 31575 flags DATA
		extent data backref root 21826 objectid 374857 offset 297984000 count 1
		extent data backref root 21872 objectid 374857 offset 297984000 count 1
		extent data backref root 23012 objectid 374857 offset 297984000 count 1
		extent data backref root 22911 objectid 374857 offset 297984000 count 1
		extent data backref root 23174 objectid 374857 offset 297984000 count 1
		extent data backref root 23052 objectid 374857 offset 297984000 count 1
		extent data backref root 23134 objectid 374857 offset 297984000 count 1
		extent data backref root 21462 objectid 374857 offset 297984000 count 1
		extent data backref root 21503 objectid 374857 offset 297984000 count 1
		extent data backref root 23094 objectid 374857 offset 297984000 count 1
		extent data backref root 21641 objectid 374857 offset 297984000 count 1
		shared data backref parent 18215389659136 count 1
		shared data backref parent 14978251440128 count 1
	item 122 key (156972310528 EXTENT_ITEM 102400) itemoff 13450 itemsize 37
		refs 1 gen 31631 flags DATA
		shared data backref parent 17763118120960 count 1
	item 123 key (156972412928 EXTENT_ITEM 102400) itemoff 13413 itemsize 37
		refs 1 gen 31631 flags DATA
		shared data backref parent 17763118120960 count 1
	item 124 key (156972515328 EXTENT_ITEM 102400) itemoff 13376 itemsize 37
		refs 1 gen 31631 flags DATA
		shared data backref parent 17763118120960 count 1
	item 125 key (156972617728 EXTENT_ITEM 102400) itemoff 13339 itemsize 37
		refs 1 gen 31631 flags DATA
		shared data backref parent 17763118120960 count 1
	item 126 key (156972720128 EXTENT_ITEM 98304) itemoff 13302 itemsize 37
--
	item 30 key (1569094942720 EXTENT_ITEM 24576) itemoff 14678 itemsize 53
		refs 1 gen 97048 flags DATA
		extent data backref root 21462 objectid 374857 offset 90849280 count 1
	item 31 key (1569094967296 EXTENT_ITEM 94208) itemoff 14625 itemsize 53
		refs 1 gen 94313 flags DATA
		extent data backref root 19852 objectid 67985779 offset 0 count 1
	item 32 key (1569095061504 EXTENT_ITEM 299008) itemoff 14572 itemsize 53
		refs 1 gen 136347 flags DATA
		extent data backref root 19852 objectid 129958928 offset 0 count 1
	item 33 key (1569095360512 EXTENT_ITEM 40960) itemoff 14519 itemsize 53
		refs 1 gen 95673 flags DATA
		extent data backref root 19852 objectid 70844817 offset 0 count 1
	item 34 key (1569095475200 EXTENT_ITEM 36864) itemoff 14466 itemsize 53
		refs 1 gen 134400 flags DATA
		extent data backref root 19852 objectid 123134122 offset 0 count 1
	item 35 key (1569095536640 EXTENT_ITEM 16384) itemoff 14413 itemsize 53
		refs 1 gen 134270 flags DATA
		extent data backref root 19852 objectid 122565390 offset 0 count 1
	item 36 key (1569095557120 EXTENT_ITEM 286720) itemoff 14360 itemsize 53
		refs 1 gen 97139 flags DATA
		extent data backref root 19852 objectid 75280458 offset 0 count 1
	item 37 key (1569095843840 EXTENT_ITEM 8192) itemoff 14323 itemsize 37
		refs 1 gen 88571 flags DATA
		shared data backref parent 14909069754368 count 1
	item 38 key (1569095852032 EXTENT_ITEM 122880) itemoff 14270 itemsize 53
		refs 1 gen 76214 flags DATA
		extent data backref root 19852 objectid 35849748 offset 0 count 1
	item 39 key (1569095974912 EXTENT_ITEM 8192) itemoff 14220 itemsize 50
		refs 2 gen 88571 flags DATA
		shared data backref parent 18214784647168 count 1
		shared data backref parent 14909069754368 count 1
	item 40 key (1569095983104 EXTENT_ITEM 8192) itemoff 14170 itemsize 50
		refs 2 gen 88571 flags DATA
		shared data backref parent 18214784647168 count 1
		shared data backref parent 14909069754368 count 1
	item 41 key (1569096114176 EXTENT_ITEM 286720) itemoff 14117 itemsize 53
		refs 1 gen 95205 flags DATA
		extent data backref root 19852 objectid 69436429 offset 0 count 1
	item 42 key (1569096400896 EXTENT_ITEM 122880) itemoff 14064 itemsize 53
		refs 1 gen 92983 flags DATA
		extent data backref root 19852 objectid 66052505 offset 0 count 1
	item 43 key (1569096523776 EXTENT_ITEM 270336) itemoff 14011 itemsize 53
		refs 1 gen 94720 flags DATA
		extent data backref root 19852 objectid 68432863 offset 0 count 1
	item 44 key (1569097105408 EXTENT_ITEM 45056) itemoff 13958 itemsize 53
		refs 1 gen 96865 flags DATA
		extent data backref root 19852 objectid 74357290 offset 0 count 1
	item 45 key (1569097150464 EXTENT_ITEM 8192) itemoff 13905 itemsize 53
		refs 1 gen 97048 flags DATA
		extent data backref root 21462 objectid 374857 offset 99221504 count 1
	item 46 key (1569097158656 EXTENT_ITEM 110592) itemoff 13868 itemsize 37

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
