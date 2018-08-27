Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:48322 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbeH0GRF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 02:17:05 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
From: Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
Date: Sun, 26 Aug 2018 22:32:20 -0400
MIME-Version: 1.0
In-Reply-To: <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/26/2018 8:16 PM, Qu Wenruo wrote:
> Corrupted tree block bytenr matches with the number reported by kernel.
> You could provide the tree block dump for bytenr 7687860535296, and
> maybe we could find out what's going wrong and fix it manually.
>
> # btrfs ins dump-tree -b 7687860535296 <device>

Thank you for your reply.

# btrfs ins dump-tree -b 7687860535296 /dev/Cached/Backups
btrfs-progs v4.15.1
leaf free space ret -2002721201, leaf data size 16283, used 2002737484 
nritems 319
leaf 7687860535296 items 319 free space -2002721201 generation 2862 owner 7
leaf 7687860535296 flags 0x1(WRITTEN) backref revision 1
fs uuid acff5096-1128-4b24-a15e-4ba04261edc3
chunk uuid 0d2fdb5d-00c0-41b3-b2ed-39a5e3bf98aa
         item 0 key (18446744073650847734 EXTENT_CSUM 8487178285056) 
itemoff 13211 itemsize 3072
                 range start 8487178285056 end 8487181430784 length 3145728
         item 1 key (18446744073650880502 EXTENT_CSUM 8487174090752) 
itemoff 10139 itemsize 3072
                 range start 8487174090752 end 8487177236480 length 3145728
         item 2 key (18446744073650913270 EXTENT_CSUM 8487167782912) 
itemoff 3251 itemsize 6888
                 range start 8487167782912 end 8487174836224 length 7053312
         item 3 key (18446744073651011574 EXTENT_CSUM 8487166103552) 
itemoff 187 itemsize 3064
                 range start 8487166103552 end 8487169241088 length 3137536
         item 4 key (58523648 UNKNOWN.0 4115587072) itemoff 0 itemsize 0
         item 5 key (58523648 UNKNOWN.0 4115058688) itemoff 0 itemsize 0
         item 6 key (58392576 UNKNOWN.0 4115050496) itemoff 0 itemsize 0
         item 7 key (58392576 UNKNOWN.0 9160800976331685888) itemoff 
1325803612 itemsize 1549669347
         item 8 key (15706350841398176100 UNKNOWN.160 
9836230374950416562) itemoff -507102832 itemsize -1565142843
         item 9 key (16420776794030147775 UNKNOWN.139 
1413404178631177347) itemoff 319666572 itemsize -2033238481
         item 10 key (12490357187492557094 UNKNOWN.100 
8703020161114007581) itemoff 1698374107 itemsize 427239449
         item 11 key (10238910558655956878 UNKNOWN.145 
13172984620675614213) itemoff -1386707845 itemsize -2094889124
         item 12 key (14429452134272870167 UNKNOWN.47 
5095274587264087555) itemoff -385621303 itemsize -1014793681
         item 13 key (12392706351935785292 TREE_BLOCK_REF 
17075682359779944300) itemoff 467435242 itemsize -1974352848
                 tree block backref
         item 14 key (9030638330689148475 UNKNOWN.146 
16510052416438219760) itemoff -1329727247 itemsize -989772882
         item 15 key (2557232588403612193 UNKNOWN.89 
11359249297629415033) itemoff -1393664382 itemsize -222178533
         item 16 key (16832668804185527807 UNKNOWN.190 
12813564574805698827) itemoff -824350641 itemsize 113587270
         item 17 key (17721977661761488041 UNKNOWN.133 
65181195353232031) itemoff 1165455420 itemsize -11248999
         item 18 key (17041494636387836535 UNKNOWN.146 
659630272632027956) itemoff 1646352770 itemsize 188954807
         item 19 key (4813797791329885851 UNKNOWN.147 
2988230942665281926) itemoff 2034137186 itemsize 429359084
         item 20 key (11925872190557602809 UNKNOWN.28 
10017979389672184473) itemoff 198274722 itemsize 1654501802
         item 21 key (18089916911465221293 UNKNOWN.215 
130744227189807288) itemoff -938569572 itemsize -322594079
         item 22 key (17582525817082834821 UNKNOWN.133 
14298100207216235213) itemoff 997305640 itemsize 380205383
         item 23 key (2509730330338250179 ORPHAN_ITEM 
8415032273173690331) itemoff 1213495256 itemsize -1813460706
                 orphan item
         item 24 key (17657358590741059587 UNKNOWN.5 
4198714773705203243) itemoff -690501330 itemsize -237182892
         item 25 key (14784171376049469241 UNKNOWN.139 
15453005915765327150) itemoff 1543890422 itemsize 2093403168
         item 26 key (8296048569161577100 UNKNOWN.58 
12559616442258240580) itemoff 927535366 itemsize -620630864
         item 27 key (14738413134752477244 SHARED_BLOCK_REF 
90867799437527556) itemoff -629160915 itemsize 1418942359
                 shared block backref
         item 28 key (17386064595326971933 SHARED_BLOCK_REF 
1813311842215708701) itemoff 1401681450 itemsize -2016124808
                 shared block backref
         item 29 key (12068018374989506977 UNKNOWN.160 
1560146733122974605) itemoff -1145774613 itemsize -490403576
         item 30 key (5611751644962296316 QGROUP_LIMIT 
19245/207762978715732) itemoff -433607332 itemsize -854595036
Segmentation fault (core dumped)

Can I simply rebuild the csum tree (btrfs check --init-csum-tree)? The 
entire contents of the fs are back-up files that are hashed so I can 
verify that the files are correct.

> Please note that this corruption could be caused by bad ram or some old
> kernel bug.
> It's recommend to run a memtest if possible.

The system uses ECC memory and edac-util has not reported any errors. 
However, I will run a memtest anyway.

Thank you,

--Larkin
