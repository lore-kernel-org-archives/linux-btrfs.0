From: Simon Kirby <sim@hostway.ca>
Subject: Re: 2.6.35.4 fumble-spolision
Date: Fri, 10 Sep 2010 00:54:17 -0700
Message-ID: <20100910075417.GA28151@hostway.ca>
References: <20100910001703.GF26862@hostway.ca> <20100910004909.GX3227@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100910004909.GX3227@think>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I meant to change that subject. :)

On Thu, Sep 09, 2010 at 08:49:09PM -0400, Chris Mason wrote:

> What does btrfsck say?  Does the problem go away in 2.6.33?

Will try 2.6.33 again tomorrow.  btrfsck runs for about 44 seconds and
then outputs as copied below.

Simon-

# btrfsck /dev/bu002/vol02
leaf 1933822619648 items 34 free space 1204 generation 139228 owner 2
fs uuid 9625dc9e-5df9-45b2-b4e5-9ff0ee48b685
chunk uuid a5b6bb39-74bd-4100-bf27-382a2be92b3c
        item 0 key (1923814113280 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 1656705680) level 0
                tree block backref root 862
        item 1 key (1923814117376 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
                extent refs 1 gen 127137 flags 2
                tree block key (9962448 c 4962881) level 0
                tree block backref root 877
        item 2 key (1923814121472 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
                extent refs 1 gen 127137 flags 2
                tree block key (9962449 c 4962881) level 0
                tree block backref root 877
        item 3 key (1923814125568 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 2955399006) level 0
                tree block backref root 862
        item 4 key (1923814129664 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
                extent refs 1 gen 116477 flags 258
                tree block key (9800957 1 0) level 0
                shared block backref parent 1923811577856
        item 5 key (1923814141952 EXTENT_ITEM 4096) itemoff 3590 itemsize 150
                extent refs 12 gen 125542 flags 2
                tree block key (7531027 54 1917354214) level 0
                tree block backref root 903
                tree block backref root 900
                tree block backref root 897
                tree block backref root 894
                tree block backref root 891
                tree block backref root 888
                tree block backref root 885
                tree block backref root 882
                tree block backref root 879
                tree block backref root 876
                tree block backref root 873
                tree block backref root 870
        item 6 key (1923814146048 EXTENT_ITEM 4096) itemoff 3539 itemsize 51
                extent refs 1 gen 122991 flags 2
                tree block key (9906069 6c 0) level 0
                tree block backref root 860
        item 7 key (1923814150144 EXTENT_ITEM 4096) itemoff 3488 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 857432055) level 0
                tree block backref root 862
        item 8 key (1923814162432 EXTENT_ITEM 4096) itemoff 3437 itemsize 51
                extent refs 1 gen 122991 flags 2
                tree block key (9906102 c 4410415) level 0
                tree block backref root 860
        item 9 key (1923814166528 EXTENT_ITEM 4096) itemoff 3386 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 1452385142) level 0
                tree block backref root 862
        item 10 key (1923814170624 EXTENT_ITEM 4096) itemoff 3335 itemsize 51
                extent refs 1 gen 119662 flags 2
                tree block key (9722750 54 3027202615) level 0
                tree block backref root 848
        item 11 key (1923814178816 EXTENT_ITEM 4096) itemoff 3284 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 2446004769) level 0
                tree block backref root 862
        item 12 key (1923814182912 EXTENT_ITEM 4096) itemoff 3233 itemsize 51
                extent refs 1 gen 125542 flags 2
                tree block key (7531027 54 123386258) level 0
                tree block backref root 870
        item 13 key (1923814187008 EXTENT_ITEM 4096) itemoff 3182 itemsize 51
                extent refs 1 gen 116478 flags 258
                tree block key (9801939 c 2769739) level 0
                shared block backref parent 1923847979008
        item 14 key (1923814195200 EXTENT_ITEM 4096) itemoff 3131 itemsize 51
                extent refs 1 gen 116468 flags 258
                tree block key (9723214 c 9722994) level 1
                tree block backref root 838
        item 15 key (1923814199296 EXTENT_ITEM 4096) itemoff 3080 itemsize 51
                extent refs 1 gen 116468 flags 258
                tree block key (9723567 1 0) level 0
                shared block backref parent 1923814195200
        item 16 key (1923814203392 EXTENT_ITEM 4096) itemoff 3029 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 3511333701) level 0
                tree block backref root 862
        item 17 key (1923814207488 EXTENT_ITEM 4096) itemoff 2978 itemsize 51
                extent refs 1 gen 127137 flags 2
                tree block key (9962449 1 0) level 0
                tree block backref root 877
        item 18 key (1923814211584 EXTENT_ITEM 4096) itemoff 2927 itemsize 51
                extent refs 1 gen 119662 flags 2
                tree block key (9722750 54 1542337137) level 0
                tree block backref root 848
        item 19 key (1923814215680 EXTENT_ITEM 4096) itemoff 2876 itemsize 51
                extent refs 1 gen 119662 flags 2
                tree block key (9722750 54 1633150225) level 0
                tree block backref root 848
        item 20 key (1923814219776 EXTENT_ITEM 4096) itemoff 2825 itemsize 51
                extent refs 1 gen 116478 flags 258
                tree block key (2769869 54 1517502465) level 0
                shared block backref parent 1923805945856
        item 21 key (1923814223872 EXTENT_ITEM 4096) itemoff 2693 itemsize 132
                extent refs 10 gen 118289 flags 2
                tree block key (10471699 1 0) level 1
                tree block backref root 879
                tree block backref root 873
                tree block backref root 867
                tree block backref root 864
                tree block backref root 861
                tree block backref root 855
                tree block backref root 852
                tree block backref root 849
                tree block backref root 846
                tree block backref root 843
        item 22 key (1923814240256 EXTENT_ITEM 4096) itemoff 2642 itemsize 51
                extent refs 1 gen 127137 flags 2
                tree block key (9962452 1 0) level 0
                tree block backref root 877
        item 23 key (1923814244352 EXTENT_ITEM 4096) itemoff 2591 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 2250929569) level 0
                tree block backref root 862
        item 24 key (1923814248448 EXTENT_ITEM 4096) itemoff 2540 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 2530040045) level 0
                tree block backref root 862
        item 25 key (1923814252544 EXTENT_ITEM 4096) itemoff 2489 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 693460895) level 0
                tree block backref root 862
        item 26 key (1923814256640 EXTENT_ITEM 4096) itemoff 2438 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 4250039336) level 0
                tree block backref root 862
        item 27 key (1923814264832 EXTENT_ITEM 4096) itemoff 2387 itemsize 51
                extent refs 1 gen 125542 flags 2
                tree block key (7531027 54 716511755) level 0
                tree block backref root 870
        item 28 key (1923814268928 EXTENT_ITEM 4096) itemoff 2336 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 583696754) level 0
                tree block backref root 862
        item 29 key (1923814273024 EXTENT_ITEM 4096) itemoff 2285 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 846280235) level 0
                tree block backref root 862
        item 30 key (1923814277120 EXTENT_ITEM 4096) itemoff 2234 itemsize 51
                extent refs 1 gen 123524 flags 2
                tree block key (4962881 54 108099388) level 0
                tree block backref root 862
        item 31 key (1923814281216 EXTENT_ITEM 4096) itemoff 2183 itemsize 51
                extent refs 1 gen 116704 flags 258
                tree block key (9759696 60 2) level 0
                tree block backref root 839
        item 32 key (1923814285312 EXTENT_ITEM 4096) itemoff 2105 itemsize 78
                extent refs 4 gen 123524 flags 2
                tree block key (4962881 60 1452615) level 0
                tree block backref root 892
                tree block backref root 868
                tree block backref root 865
                tree block backref root 862
        item 33 key (1923814293504 EXTENT_ITEM 4096) itemoff 2054 itemsize 51
                extent refs 1 gen 121426 flags 2
                tree block key (5643880 60 602) level 0
                tree block backref root 853
failed to find block number 1923814297600
Abort
