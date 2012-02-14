From: Timo Nentwig <btrfs@nentwig.biz>
Subject: Re: can't read superblock (but could mount)
Date: Tue, 14 Feb 2012 18:37:16 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202141832420.11051@localhost>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu> <20120210221842.GU8384@shiny> <20120210233959.GV8384@shiny> <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu> <20120213130943.GA1573@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213130943.GA1573@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 13 Feb 2012, Chris Mason wrote:

> btrfs-debug-tree -b 9872289792 /dev/xxx

# btrfs-debug-tree -b 9872289792 /dev/loop1
leaf 9872289792 items 51 free space 0 generation 120351 owner 5
fs uuid 9e9886fc-3e60-4c59-a246-727662769ee2
chunk uuid f7e4ac1e-f4d6-436b-9bda-8409311dcdb6
         item 0 key (923514 DIR_ITEM 2120090750) itemoff 3950 itemsize 45
                 location key (2722082 INODE_ITEM 0) type 1
                 namelen 15 datalen 0 name: UTBI__24.pcf.gz
         item 1 key (923514 DIR_ITEM 2120348073) itemoff 3895 itemsize 55
                 location key (2722204 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: helvB12-ISO8859-14.pcf.gz
         item 2 key (923514 DIR_ITEM 2123806861) itemoff 3840 itemsize 55
                 location key (2723467 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: lutRS08-ISO8859-15.pcf.gz
         item 3 key (923514 DIR_ITEM 2124181825) itemoff 3787 itemsize 53
                 location key (2722901 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: timB10-ISO8859-9.pcf.gz
         item 4 key (923514 DIR_ITEM 2124481083) itemoff 3734 itemsize 53
                 location key (2723388 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: luIS19-ISO8859-9.pcf.gz
         item 5 key (923514 DIR_ITEM 2127941711) itemoff 3679 itemsize 55
                 location key (2722919 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: courBO18-ISO8859-2.pcf.gz
         item 6 key (923514 DIR_ITEM 2128786561) itemoff 3624 itemsize 55
                 location key (2721907 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: helvBO24-ISO8859-1.pcf.gz
         item 7 key (923514 DIR_ITEM 2131308727) itemoff 3569 itemsize 55
                 location key (2723365 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: ncenBI10-ISO8859-2.pcf.gz
         item 8 key (923514 DIR_ITEM 2131961491) itemoff 3515 itemsize 54
                 location key (2723113 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: ncenI10-ISO8859-4.pcf.gz
         item 9 key (923514 DIR_ITEM 2132458601) itemoff 3461 itemsize 54
                 location key (2722426 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: timI24-ISO8859-13.pcf.gz
         item 10 key (923514 DIR_ITEM 2132654723) itemoff 3406 itemsize 55
                 location key (2722242 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: ncenB08-ISO8859-14.pcf.gz
         item 11 key (923514 DIR_ITEM 2136131400) itemoff 3353 itemsize 53
                 location key (2722472 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: lubR10-ISO8859-2.pcf.gz
         item 12 key (923514 DIR_ITEM 2136302367) itemoff 3298 itemsize 55
                 location key (2721978 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: helvR14-ISO8859-15.pcf.gz
         item 13 key (923514 DIR_ITEM 2141157400) itemoff 3244 itemsize 54
                 location key (2721809 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: luRS24-ISO8859-10.pcf.gz
         item 14 key (923514 DIR_ITEM 2143920500) itemoff 3190 itemsize 54
                 location key (2722139 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: lutRS10-ISO8859-4.pcf.gz
         item 15 key (923514 DIR_ITEM 2145353946) itemoff 3137 itemsize 53
                 location key (2722006 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: timR18-ISO8859-9.pcf.gz
         item 16 key (923514 DIR_ITEM 2146914640) itemoff 3082 itemsize 55
                 location key (2723588 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: lutBS12-ISO8859-14.pcf.gz
         item 17 key (923514 DIR_ITEM 2153679091) itemoff 3026 itemsize 56
                 location key (2722231 INODE_ITEM 0) type 1
                 namelen 26 datalen 0 name: UTB___12-ISO8859-10.pcf.gz
         item 18 key (923514 DIR_ITEM 2155361241) itemoff 2971 itemsize 55
                 location key (2721854 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: UTRG__24-ISO8859-3.pcf.gz
         item 19 key (923514 DIR_ITEM 2164008501) itemoff 2917 itemsize 54
                 location key (2723441 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: lubR14-ISO8859-13.pcf.gz
         item 20 key (923514 DIR_ITEM 2164058590) itemoff 2872 itemsize 45
                 location key (2722030 INODE_ITEM 0) type 1
                 namelen 15 datalen 0 name: courBO18.pcf.gz
         item 21 key (923514 DIR_ITEM 2164312387) itemoff 2827 itemsize 45
                 location key (2722107 INODE_ITEM 0) type 1
                 namelen 15 datalen 0 name: ncenBI12.pcf.gz
         item 22 key (923514 DIR_ITEM 2166794582) itemoff 2773 itemsize 54
                 location key (2722054 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: timB08-ISO8859-10.pcf.gz
         item 23 key (923514 DIR_ITEM 2168622352) itemoff 2718 itemsize 55
                 location key (2722318 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: courB18-ISO8859-14.pcf.gz
         item 24 key (923514 DIR_ITEM 2175186950) itemoff 2664 itemsize 54
                 location key (2722350 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: lubBI24-ISO8859-1.pcf.gz
         item 25 key (923514 DIR_ITEM 2176060521) itemoff 2609 itemsize 55
                 location key (2722198 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: lubBI12-ISO8859-10.pcf.gz
         item 26 key (923514 DIR_ITEM 2176776172) itemoff 2566 itemsize 43
                 location key (2721916 INODE_ITEM 0) type 1
                 namelen 13 datalen 0 name: luIS24.pcf.gz
         item 27 key (923514 DIR_ITEM 2177776018) itemoff 2512 itemsize 54
                 location key (2721796 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: courB12-ISO8859-2.pcf.gz
         item 28 key (923514 DIR_ITEM 2178161982) itemoff 2458 itemsize 54
                 location key (2723465 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: helvR14-ISO8859-3.pcf.gz
         item 29 key (923514 DIR_ITEM 2180020900) itemoff 2402 itemsize 56
                 location key (2723052 INODE_ITEM 0) type 1
                 namelen 26 datalen 0 name: helvBO10-ISO8859-14.pcf.gz
         item 30 key (923514 DIR_ITEM 2180297770) itemoff 2348 itemsize 54
                 location key (2722286 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: helvO08-ISO8859-9.pcf.gz
         item 31 key (923514 DIR_ITEM 2181853127) itemoff 2305 itemsize 43
                 location key (2722790 INODE_ITEM 0) type 1
                 namelen 13 datalen 0 name: timB18.pcf.gz
         item 32 key (923514 DIR_ITEM 2184201970) itemoff 2250 itemsize 55
                 location key (2721881 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: courBO12-ISO8859-9.pcf.gz
         item 33 key (923514 DIR_ITEM 2194151326) itemoff 2196 itemsize 54
                 location key (2723089 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: luIS24-ISO8859-14.pcf.gz
         item 34 key (923514 DIR_ITEM 2195147416) itemoff 2142 itemsize 54
                 location key (2722430 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: timB14-ISO8859-10.pcf.gz
         item 35 key (923514 DIR_ITEM 2197069934) itemoff 2089 itemsize 53
                 location key (2723319 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: lubB12-ISO8859-9.pcf.gz
         item 36 key (923514 DIR_ITEM 2198647210) itemoff 2034 itemsize 55
                 location key (2723014 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: helvO18-ISO8859-14.pcf.gz
         item 37 key (923514 DIR_ITEM 2198717947) itemoff 1980 itemsize 54
                 location key (2723004 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: lubR08-ISO8859-13.pcf.gz
         item 38 key (923514 DIR_ITEM 2199518165) itemoff 1925 itemsize 55
                 location key (2722585 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: UTB___12-ISO8859-1.pcf.gz
         item 39 key (923514 DIR_ITEM 2201622119) itemoff 1872 itemsize 53
                 location key (2723195 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: timR12-ISO8859-2.pcf.gz
         item 40 key (923514 DIR_ITEM 2203625663) itemoff 1817 itemsize 55
                 location key (2722069 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: UTBI__10-ISO8859-1.pcf.gz
         item 41 key (923514 DIR_ITEM 2208277171) itemoff 1763 itemsize 54
                 location key (2723509 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: courO10-ISO8859-3.pcf.gz
         item 42 key (923514 DIR_ITEM 2218325165) itemoff 1708 itemsize 55
                 location key (2723549 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: helvB12-ISO8859-13.pcf.gz
         item 43 key (923514 DIR_ITEM 2220510505) itemoff 1654 itemsize 54
                 location key (2722209 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: helvR08-ISO8859-4.pcf.gz
         item 44 key (923514 DIR_ITEM 2222221654) itemoff 1599 itemsize 55
                 location key (2722620 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: luBIS12-ISO8859-14.pcf.gz
         item 45 key (923514 DIR_ITEM 2229258471) itemoff 1546 itemsize 53
                 location key (2723152 INODE_ITEM 0) type 1
                 namelen 23 datalen 0 name: timR08-ISO8859-1.pcf.gz
         item 46 key (923514 DIR_ITEM 2234719731) itemoff 1492 itemsize 54
                 location key (2723557 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: luBIS08-ISO8859-9.pcf.gz
         item 47 key (923514 DIR_ITEM 2235808109) itemoff 1438 itemsize 54
                 location key (2723080 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: timI24-ISO8859-14.pcf.gz
         item 48 key (923514 DIR_ITEM 2235875207) itemoff 1383 itemsize 55
                 location key (2723463 INODE_ITEM 0) type 1
                 namelen 25 datalen 0 name: ncenB08-ISO8859-13.pcf.gz
         item 49 key (923514 DIR_ITEM 2236228503) itemoff 1329 itemsize 54
                 location key (2721755 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: ncenI10-ISO8859-3.pcf.gz
         item 50 key (923514 DIR_ITEM 2239005748) itemoff 1275 itemsize 54
                 location key (2721998 INODE_ITEM 0) type 1
                 namelen 24 datalen 0 name: lutBS10-ISO8859-9.pcf.gz

# btrfsck /dev/loop1
Extent back ref already exists for 9872289792 parent 0 root 5
leaf parent key incorrect 9872289792
bad block 9872289792
ref mismatch on [9872289792 4096] extent item 1, found 2
Incorrect global backref count on 9872289792 found 1 wanted 2
backpointer mismatch on [9872289792 4096]
owner ref check failed [9872289792 4096]
ref mismatch on [9889067008 4096] extent item 1, found 0
Backref 9889067008 root 5 not referenced
Incorrect global backref count on 9889067008 found 1 wanted 0
backpointer mismatch on [9889067008 4096]
owner ref check failed [9889067008 4096]
ref mismatch on [37163102208 65536] extent item 1, found 0
Incorrect local backref count on 37163102208 root 5 owner 3360937 offset 0 found 
0 wanted 1
backpointer mismatch on [37163102208 65536]
owner ref check failed [37163102208 65536]
ref mismatch on [37163814912 36864] extent item 0, found 1
Backref 37163814912 root 5 owner 3360939 offset 0 num_refs 0 not found in extent 
tree
Incorrect local backref count on 37163814912 root 5 owner 3360939 offset 0 found 
1 wanted 0
backpointer mismatch on [37163814912 36864]
found 15491117056 bytes used err is 1
total csum bytes: 14764500
total tree bytes: 366956544
total fs tree bytes: 317714432
btree space waste bytes: 90628933
file data blocks allocated: 16182484992
  referenced 17813028864
Btrfs Btrfs v0.19

# mount /dev/loop1 /tmp/b
mount: block device /dev/loop1 is write-protected, mounting read-only

# ls /tmp/b
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin 
srv  sys  tmp  usr  var  vm

# echo "hooray!"


Please explain :)
