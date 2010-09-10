From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: 2.6.35.4 fumble-spolision
Date: Fri, 10 Sep 2010 16:21:16 +0800
Message-ID: <AANLkTinDu0Rw+E+0-D1u3ZCXtUtd=G0Y0R3Aa=UCg_8W@mail.gmail.com>
References: <20100910001703.GF26862@hostway.ca>
	<20100910004909.GX3227@think>
	<20100910075417.GA28151@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100910075417.GA28151@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 10, 2010 at 3:54 PM, Simon Kirby <sim@hostway.ca> wrote:
> Sorry, I meant to change that subject. :)
>
> On Thu, Sep 09, 2010 at 08:49:09PM -0400, Chris Mason wrote:
>
>> What does btrfsck say? =A0Does the problem go away in 2.6.33?
>
> Will try 2.6.33 again tomorrow. =A0btrfsck runs for about 44 seconds =
and
> then outputs as copied below.
>
> Simon-
>
> # btrfsck /dev/bu002/vol02
> leaf 1933822619648 items 34 free space 1204 generation 139228 owner 2
> fs uuid 9625dc9e-5df9-45b2-b4e5-9ff0ee48b685
> chunk uuid a5b6bb39-74bd-4100-bf27-382a2be92b3c
> =A0 =A0 =A0 =A0item 0 key (1923814113280 EXTENT_ITEM 4096) itemoff 39=
44 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 1656705680)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 1 key (1923814117376 EXTENT_ITEM 4096) itemoff 38=
93 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 127137 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9962448 c 4962881) lev=
el 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 877
> =A0 =A0 =A0 =A0item 2 key (1923814121472 EXTENT_ITEM 4096) itemoff 38=
42 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 127137 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9962449 c 4962881) lev=
el 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 877
> =A0 =A0 =A0 =A0item 3 key (1923814125568 EXTENT_ITEM 4096) itemoff 37=
91 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 2955399006)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 4 key (1923814129664 EXTENT_ITEM 4096) itemoff 37=
40 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 116477 flags 258
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9800957 1 0) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shared block backref parent 1923811577=
856
> =A0 =A0 =A0 =A0item 5 key (1923814141952 EXTENT_ITEM 4096) itemoff 35=
90 itemsize 150
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 12 gen 125542 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (7531027 54 1917354214)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 903
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 900
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 897
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 894
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 891
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 888
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 885
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 882
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 879
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 876
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 873
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 870
> =A0 =A0 =A0 =A0item 6 key (1923814146048 EXTENT_ITEM 4096) itemoff 35=
39 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 122991 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9906069 6c 0) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 860
> =A0 =A0 =A0 =A0item 7 key (1923814150144 EXTENT_ITEM 4096) itemoff 34=
88 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 857432055) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 8 key (1923814162432 EXTENT_ITEM 4096) itemoff 34=
37 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 122991 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9906102 c 4410415) lev=
el 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 860
> =A0 =A0 =A0 =A0item 9 key (1923814166528 EXTENT_ITEM 4096) itemoff 33=
86 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 1452385142)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 10 key (1923814170624 EXTENT_ITEM 4096) itemoff 3=
335 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 119662 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9722750 54 3027202615)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 848
> =A0 =A0 =A0 =A0item 11 key (1923814178816 EXTENT_ITEM 4096) itemoff 3=
284 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 2446004769)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 12 key (1923814182912 EXTENT_ITEM 4096) itemoff 3=
233 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 125542 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (7531027 54 123386258) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 870
> =A0 =A0 =A0 =A0item 13 key (1923814187008 EXTENT_ITEM 4096) itemoff 3=
182 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 116478 flags 258
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9801939 c 2769739) lev=
el 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shared block backref parent 1923847979=
008
> =A0 =A0 =A0 =A0item 14 key (1923814195200 EXTENT_ITEM 4096) itemoff 3=
131 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 116468 flags 258
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9723214 c 9722994) lev=
el 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 838
> =A0 =A0 =A0 =A0item 15 key (1923814199296 EXTENT_ITEM 4096) itemoff 3=
080 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 116468 flags 258
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9723567 1 0) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shared block backref parent 1923814195=
200
> =A0 =A0 =A0 =A0item 16 key (1923814203392 EXTENT_ITEM 4096) itemoff 3=
029 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 3511333701)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 17 key (1923814207488 EXTENT_ITEM 4096) itemoff 2=
978 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 127137 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9962449 1 0) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 877
> =A0 =A0 =A0 =A0item 18 key (1923814211584 EXTENT_ITEM 4096) itemoff 2=
927 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 119662 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9722750 54 1542337137)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 848
> =A0 =A0 =A0 =A0item 19 key (1923814215680 EXTENT_ITEM 4096) itemoff 2=
876 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 119662 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9722750 54 1633150225)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 848
> =A0 =A0 =A0 =A0item 20 key (1923814219776 EXTENT_ITEM 4096) itemoff 2=
825 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 116478 flags 258
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (2769869 54 1517502465)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shared block backref parent 1923805945=
856
> =A0 =A0 =A0 =A0item 21 key (1923814223872 EXTENT_ITEM 4096) itemoff 2=
693 itemsize 132
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 10 gen 118289 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (10471699 1 0) level 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 879
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 873
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 867
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 864
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 861
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 855
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 852
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 849
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 846
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 843
> =A0 =A0 =A0 =A0item 22 key (1923814240256 EXTENT_ITEM 4096) itemoff 2=
642 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 127137 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9962452 1 0) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 877
> =A0 =A0 =A0 =A0item 23 key (1923814244352 EXTENT_ITEM 4096) itemoff 2=
591 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 2250929569)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 24 key (1923814248448 EXTENT_ITEM 4096) itemoff 2=
540 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 2530040045)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 25 key (1923814252544 EXTENT_ITEM 4096) itemoff 2=
489 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 693460895) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 26 key (1923814256640 EXTENT_ITEM 4096) itemoff 2=
438 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 4250039336)=
 level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 27 key (1923814264832 EXTENT_ITEM 4096) itemoff 2=
387 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 125542 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (7531027 54 716511755) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 870
> =A0 =A0 =A0 =A0item 28 key (1923814268928 EXTENT_ITEM 4096) itemoff 2=
336 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 583696754) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 29 key (1923814273024 EXTENT_ITEM 4096) itemoff 2=
285 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 846280235) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 30 key (1923814277120 EXTENT_ITEM 4096) itemoff 2=
234 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 54 108099388) =
level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 31 key (1923814281216 EXTENT_ITEM 4096) itemoff 2=
183 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 116704 flags 258
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (9759696 60 2) level 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 839
> =A0 =A0 =A0 =A0item 32 key (1923814285312 EXTENT_ITEM 4096) itemoff 2=
105 itemsize 78
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 4 gen 123524 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (4962881 60 1452615) le=
vel 0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 892
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 868
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 865
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 862
> =A0 =A0 =A0 =A0item 33 key (1923814293504 EXTENT_ITEM 4096) itemoff 2=
054 itemsize 51
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 1 gen 121426 flags 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block key (5643880 60 602) level =
0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tree block backref root 853
> failed to find block number 1923814297600
> Abort

How large is the FS ? Is it possible to run btrfs-image and send the
output file to us?

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
