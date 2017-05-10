Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:47517 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751301AbdEJJVC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 05:21:02 -0400
Subject: Re: runtime btrfsck
To: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
 <20170510121840.06aa01b2@natsu>
 <39924a38-4c6a-b0ea-81a7-64c1d72cf7be@profihost.ag>
 <20170510074052.GG9701@carfax.org.uk>
 <6b19da67-47a3-6f75-a892-8812b84817ea@profihost.ag>
 <20170510090839.GH9701@carfax.org.uk>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <b959d576-2136-1c0a-93be-0bfbd81ab52c@profihost.ag>
Date: Wed, 10 May 2017 11:20:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170510090839.GH9701@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

here's the output:
# for block in 163316514816 163322413056 163325722624; do echo $block;
btrfs-debug-tree -b $block /dev/mapper/crypt_md0|sed -re 's/(\t| )name:
.*/\1name: HIDDEN/'; done

163316514816
btrfs-progs v4.8.5
leaf 163316514816 items 188 free space 1387 generation 86739 owner 3892
fs uuid 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
chunk uuid b86efe94-ab40-4344-ac6b-46ec59c41b8f
        item 0 key (23760 DIR_ITEM 2479948887) itemoff 16229 itemsize 54
                location key (26923382 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 24
                name: HIDDEN
        item 1 key (23760 DIR_ITEM 2652742785) itemoff 16170 itemsize 59
                location key (28124230 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 2 key (23760 DIR_ITEM 2688971413) itemoff 16119 itemsize 51
                location key (26923386 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 21
                name: HIDDEN
        item 3 key (23760 DIR_ITEM 2764880658) itemoff 16064 itemsize 55
                location key (26923399 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 4 key (23760 DIR_ITEM 2805527189) itemoff 16006 itemsize 58
                location key (28124233 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 28
                name: HIDDEN
        item 5 key (23760 DIR_ITEM 2876464375) itemoff 15957 itemsize 49
                location key (26923393 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 19
                name: HIDDEN
        item 6 key (23760 DIR_ITEM 2951059296) itemoff 15907 itemsize 50
                location key (28124218 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 20
                name: HIDDEN
        item 7 key (23760 DIR_ITEM 3058144963) itemoff 15859 itemsize 48
                location key (26923384 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 18
                name: HIDDEN
        item 8 key (23760 DIR_ITEM 3095440808) itemoff 15804 itemsize 55
                location key (26923394 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 9 key (23760 DIR_ITEM 3124573416) itemoff 15748 itemsize 56
                location key (26923387 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 26
                name: HIDDEN
        item 10 key (23760 DIR_ITEM 3194204932) itemoff 15690 itemsize 58
                location key (26923397 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 28
                name: HIDDEN
        item 11 key (23760 DIR_ITEM 3281114395) itemoff 15637 itemsize 53
                location key (26923388 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 23
                name: HIDDEN
        item 12 key (23760 DIR_ITEM 3353597736) itemoff 15588 itemsize 49
                location key (24944 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 13 key (23760 DIR_ITEM 3389003195) itemoff 15539 itemsize 49
                location key (28124226 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 19
                name: HIDDEN
        item 14 key (23760 DIR_ITEM 3461310858) itemoff 15473 itemsize 66
                location key (26923392 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 36
                name: HIDDEN
        item 15 key (23760 DIR_ITEM 3660173809) itemoff 15422 itemsize 51
                location key (28124225 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 21
                name: HIDDEN
        item 16 key (23760 DIR_ITEM 3678308711) itemoff 15371 itemsize 51
                location key (28124220 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 21
                name: HIDDEN
        item 17 key (23760 DIR_ITEM 3708519009) itemoff 15316 itemsize 55
                location key (28124224 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 18 key (23760 DIR_ITEM 3716314603) itemoff 15258 itemsize 58
                location key (26923396 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 28
                name: HIDDEN
        item 19 key (23760 DIR_ITEM 3958443109) itemoff 15224 itemsize 34
                location key (24016 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 4
                name: HIDDEN
        item 20 key (23760 DIR_INDEX 2) itemoff 15190 itemsize 34
                location key (24016 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 4
                name: HIDDEN
        item 21 key (23760 DIR_INDEX 20) itemoff 15141 itemsize 49
                location key (24944 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 22 key (23760 DIR_INDEX 21) itemoff 15087 itemsize 54
                location key (28124217 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 24
                name: HIDDEN
        item 23 key (23760 DIR_INDEX 22) itemoff 15037 itemsize 50
                location key (28124218 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 20
                name: HIDDEN
        item 24 key (23760 DIR_INDEX 23) itemoff 14989 itemsize 48
                location key (28124219 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 18
                name: HIDDEN
        item 25 key (23760 DIR_INDEX 24) itemoff 14938 itemsize 51
                location key (28124220 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 21
                name: HIDDEN
        item 26 key (23760 DIR_INDEX 25) itemoff 14887 itemsize 51
                location key (28124221 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 21
                name: HIDDEN
        item 27 key (23760 DIR_INDEX 26) itemoff 14831 itemsize 56
                location key (28124222 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 26
                name: HIDDEN
        item 28 key (23760 DIR_INDEX 27) itemoff 14778 itemsize 53
                location key (28124223 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 29 key (23760 DIR_INDEX 28) itemoff 14723 itemsize 55
                location key (28124224 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 30 key (23760 DIR_INDEX 29) itemoff 14672 itemsize 51
                location key (28124225 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 21
                name: HIDDEN
        item 31 key (23760 DIR_INDEX 30) itemoff 14623 itemsize 49
                location key (28124226 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 19
                name: HIDDEN
        item 32 key (23760 DIR_INDEX 31) itemoff 14557 itemsize 66
                location key (28124227 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 36
                name: HIDDEN
        item 33 key (23760 DIR_INDEX 32) itemoff 14508 itemsize 49
                location key (28124228 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 19
                name: HIDDEN
        item 34 key (23760 DIR_INDEX 33) itemoff 14453 itemsize 55
                location key (28124229 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 35 key (23760 DIR_INDEX 34) itemoff 14394 itemsize 59
                location key (28124230 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 36 key (23760 DIR_INDEX 35) itemoff 14336 itemsize 58
                location key (28124231 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 28
                name: HIDDEN
        item 37 key (23760 DIR_INDEX 36) itemoff 14278 itemsize 58
                location key (28124232 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 28
                name: HIDDEN
        item 38 key (23760 DIR_INDEX 37) itemoff 14220 itemsize 58
                location key (28124233 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 28
                name: HIDDEN
        item 39 key (23760 DIR_INDEX 38) itemoff 14165 itemsize 55
                location key (28124234 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 40 key (23760 DIR_INDEX 22) itemoff 14115 itemsize 50
                location key (26923383 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 20
                name: HIDDEN
        item 41 key (23760 DIR_INDEX 23) itemoff 14067 itemsize 48
                location key (26923384 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 18
                name: HIDDEN
        item 42 key (23760 DIR_INDEX 24) itemoff 14016 itemsize 51
                location key (26923385 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 21
                name: HIDDEN
        item 43 key (23760 DIR_INDEX 25) itemoff 13965 itemsize 51
                location key (26923386 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 21
                name: HIDDEN
        item 44 key (23760 DIR_INDEX 26) itemoff 13909 itemsize 56
                location key (26923387 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 26
                name: HIDDEN
        item 45 key (23760 DIR_INDEX 27) itemoff 13856 itemsize 53
                location key (26923388 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 23
                name: HIDDEN
        item 46 key (23760 DIR_INDEX 28) itemoff 13801 itemsize 55
                location key (26923389 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 47 key (23760 DIR_INDEX 29) itemoff 13750 itemsize 51
                location key (26923390 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 21
                name: HIDDEN
        item 48 key (23760 DIR_INDEX 30) itemoff 13701 itemsize 49
                location key (26923391 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 19
                name: HIDDEN
        item 49 key (23760 DIR_INDEX 31) itemoff 13635 itemsize 66
                location key (26923392 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 36
                name: HIDDEN
        item 50 key (23760 DIR_INDEX 32) itemoff 13586 itemsize 49
                location key (26923393 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 19
                name: HIDDEN
        item 51 key (23760 DIR_INDEX 33) itemoff 13531 itemsize 55
                location key (26923394 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 52 key (23760 DIR_INDEX 34) itemoff 13472 itemsize 59
                location key (26923395 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 53 key (23760 DIR_INDEX 35) itemoff 13414 itemsize 58
                location key (26923396 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 28
                name: HIDDEN
        item 54 key (23760 DIR_INDEX 36) itemoff 13356 itemsize 58
                location key (26923397 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 28
                name: HIDDEN
        item 55 key (23760 DIR_INDEX 37) itemoff 13298 itemsize 58
                location key (26923398 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 28
                name: HIDDEN
        item 56 key (23760 DIR_INDEX 38) itemoff 13243 itemsize 55
                location key (26923399 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 57 key (23761 INODE_ITEM 0) itemoff 13083 itemsize 160
                inode generation 10693 transid 74009 size 264 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x11(none)
                atime 1488554072.392072741 (2017-03-03 16:14:32)
                ctime 1488554072.392072741 (2017-03-03 16:14:32)
                mtime 1488525775.691496666 (2017-03-03 08:22:55)
                otime 1479206762.627403857 (2016-11-15 11:46:02)
        item 58 key (23761 INODE_REF 20708) itemoff 13063 itemsize 20
                inode ref index 4 namelen 10 name: HIDDEN
        item 59 key (23761 DIR_ITEM 1609627862) itemoff 13001 itemsize 62
                location key (24989 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 32
                name: HIDDEN
        item 60 key (23761 DIR_ITEM 2494044023) itemoff 12946 itemsize 55
                location key (24990 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 25
                name: HIDDEN
        item 61 key (23761 DIR_ITEM 3889828486) itemoff 12886 itemsize 60
                location key (24992 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 30
                name: HIDDEN
        item 62 key (23761 DIR_ITEM 4148102521) itemoff 12836 itemsize 50
                location key (24117989 INODE_ITEM 0) type FILE
                transid 56612 data_len 0 name_len 20
                name: HIDDEN
        item 63 key (23761 DIR_ITEM 4239818176) itemoff 12781 itemsize 55
                location key (24991 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 25
                name: HIDDEN
        item 64 key (23761 DIR_INDEX 2) itemoff 12719 itemsize 62
                location key (24989 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 32
                name: HIDDEN
        item 65 key (23761 DIR_INDEX 3) itemoff 12664 itemsize 55
                location key (24990 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 25
                name: HIDDEN
        item 66 key (23761 DIR_INDEX 4) itemoff 12609 itemsize 55
                location key (24991 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 25
                name: HIDDEN
        item 67 key (23761 DIR_INDEX 5) itemoff 12549 itemsize 60
                location key (24992 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 30
                name: HIDDEN
        item 68 key (23761 DIR_INDEX 6) itemoff 12499 itemsize 50
                location key (24117989 INODE_ITEM 0) type FILE
                transid 56612 data_len 0 name_len 20
                name: HIDDEN
        item 69 key (23762 INODE_ITEM 0) itemoff 12339 itemsize 160
                inode generation 10693 transid 74009 size 254 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x15(none)
                atime 1488554072.392072741 (2017-03-03 16:14:32)
                ctime 1488554072.392072741 (2017-03-03 16:14:32)
                mtime 1488525775.691496666 (2017-03-03 08:22:55)
                otime 1479206762.627403857 (2016-11-15 11:46:02)
        item 70 key (23762 INODE_REF 20708) itemoff 12321 itemsize 18
                inode ref index 5 namelen 8 name: HIDDEN
        item 71 key (23762 DIR_ITEM 298853244) itemoff 12272 itemsize 49
                location key (24997 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 72 key (23762 DIR_ITEM 1125693785) itemoff 12225 itemsize 47
                location key (24996 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 73 key (23762 DIR_ITEM 1890831256) itemoff 12169 itemsize 56
                location key (24998 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 26
                name: HIDDEN
        item 74 key (23762 DIR_ITEM 2244294244) itemoff 12118 itemsize 51
                location key (24993 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 21
                name: HIDDEN
        item 75 key (23762 DIR_ITEM 2495135672) itemoff 12070 itemsize 48
                location key (24994 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 18
                name: HIDDEN
        item 76 key (23762 DIR_ITEM 2899353060) itemoff 12031 itemsize 39
                location key (25000 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 9
                name: HIDDEN
        item 77 key (23762 DIR_ITEM 3675328486) itemoff 11984 itemsize 47
                location key (24999 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 78 key (23762 DIR_INDEX 2) itemoff 11933 itemsize 51
                location key (24993 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 21
                name: HIDDEN
        item 79 key (23762 DIR_INDEX 3) itemoff 11885 itemsize 48
                location key (24994 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 18
                name: HIDDEN
        item 80 key (23762 DIR_INDEX 5) itemoff 11838 itemsize 47
                location key (24996 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 81 key (23762 DIR_INDEX 6) itemoff 11789 itemsize 49
                location key (24997 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 82 key (23762 DIR_INDEX 7) itemoff 11733 itemsize 56
                location key (24998 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 26
                name: HIDDEN
        item 83 key (23762 DIR_INDEX 8) itemoff 11686 itemsize 47
                location key (24999 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 84 key (23762 DIR_INDEX 9) itemoff 11647 itemsize 39
                location key (25000 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 9
                name: HIDDEN
        item 85 key (23763 INODE_ITEM 0) itemoff 11487 itemsize 160
                inode generation 10693 transid 74009 size 396 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x2c(none)
                atime 1488554072.392072741 (2017-03-03 16:14:32)
                ctime 1488554072.392072741 (2017-03-03 16:14:32)
                mtime 1488525775.699496646 (2017-03-03 08:22:55)
                otime 1479206762.627403857 (2016-11-15 11:46:02)
        item 86 key (23763 INODE_REF 20708) itemoff 11471 itemsize 16
                inode ref index 6 namelen 6 name: HIDDEN
        item 87 key (23763 DIR_ITEM 25713228) itemoff 11423 itemsize 48
                location key (25001 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 18
                name: HIDDEN
        item 88 key (23763 DIR_ITEM 158768072) itemoff 11382 itemsize 41
                location key (25021 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 11
                name: HIDDEN
        item 89 key (23763 DIR_ITEM 178010668) itemoff 11323 itemsize 59
                location key (25015 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 29
                name: HIDDEN
        item 90 key (23763 DIR_ITEM 652355863) itemoff 11274 itemsize 49
                location key (25014 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 91 key (23763 DIR_ITEM 985402740) itemoff 11224 itemsize 50
                location key (25016 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 92 key (23763 DIR_ITEM 1223269786) itemoff 11177 itemsize 47
                location key (25020 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 93 key (23763 DIR_ITEM 1309931892) itemoff 11127 itemsize 50
                location key (25013 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 94 key (23763 DIR_ITEM 1510693483) itemoff 11078 itemsize 49
                location key (25019 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 95 key (23763 DIR_ITEM 1651353734) itemoff 11036 itemsize 42
                location key (25012 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 12
                name: HIDDEN
        item 96 key (23763 DIR_ITEM 2899353060) itemoff 10997 itemsize 39
                location key (25018 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 9
                name: HIDDEN
        item 97 key (23763 DIR_ITEM 3475358764) itemoff 10961 itemsize 36
                location key (19798468 INODE_ITEM 0) type DIR
                transid 35662 data_len 0 name_len 6
                name: HIDDEN
        item 98 key (23763 DIR_ITEM 4145978867) itemoff 10913 itemsize 48
                location key (25017 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 18
                name: HIDDEN
        item 99 key (23763 DIR_INDEX 2) itemoff 10865 itemsize 48
                location key (25001 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 18
                name: HIDDEN
        item 100 key (23763 DIR_INDEX 13) itemoff 10823 itemsize 42
                location key (25012 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 12
                name: HIDDEN
        item 101 key (23763 DIR_INDEX 14) itemoff 10773 itemsize 50
                location key (25013 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 102 key (23763 DIR_INDEX 15) itemoff 10724 itemsize 49
                location key (25014 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 103 key (23763 DIR_INDEX 16) itemoff 10665 itemsize 59
                location key (25015 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 29
                name: HIDDEN
        item 104 key (23763 DIR_INDEX 17) itemoff 10615 itemsize 50
                location key (25016 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 105 key (23763 DIR_INDEX 18) itemoff 10567 itemsize 48
                location key (25017 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 18
                name: HIDDEN
        item 106 key (23763 DIR_INDEX 19) itemoff 10528 itemsize 39
                location key (25018 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 9
                name: HIDDEN
        item 107 key (23763 DIR_INDEX 20) itemoff 10479 itemsize 49
                location key (25019 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 108 key (23763 DIR_INDEX 21) itemoff 10432 itemsize 47
                location key (25020 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 109 key (23763 DIR_INDEX 22) itemoff 10391 itemsize 41
                location key (25021 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 11
                name: HIDDEN
        item 110 key (23763 DIR_INDEX 23) itemoff 10355 itemsize 36
                location key (19798468 INODE_ITEM 0) type DIR
                transid 35662 data_len 0 name_len 6
                name: HIDDEN
        item 111 key (23764 INODE_ITEM 0) itemoff 10195 itemsize 160
                inode generation 10693 transid 86739 size 780 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x1e(none)
                atime 1488554079.216015444 (2017-03-03 16:14:39)
                ctime 1491160501.510094406 (2017-04-02 21:15:01)
                mtime 1491160501.510094406 (2017-04-02 21:15:01)
                otime 1479206762.627403857 (2016-11-15 11:46:02)
        item 112 key (23764 INODE_REF 20708) itemoff 10182 itemsize 13
                inode ref index 7 namelen 3 name: HIDDEN
        item 113 key (23764 DIR_ITEM 39540470) itemoff 10124 itemsize 58
                location key (25027 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 114 key (23764 DIR_ITEM 92716050) itemoff 10070 itemsize 54
                location key (25024 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 115 key (23764 DIR_ITEM 453623459) itemoff 10033 itemsize 37
                location key (24103 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 7
                name: HIDDEN
        item 116 key (23764 DIR_ITEM 676561262) itemoff 9982 itemsize 51
                location key (25031 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 21
                name: HIDDEN
        item 117 key (23764 DIR_ITEM 733805705) itemoff 9933 itemsize 49
                location key (25034 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 118 key (23764 DIR_ITEM 751581007) itemoff 9877 itemsize 56
                location key (25030 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 26
                name: HIDDEN
        item 119 key (23764 DIR_ITEM 807562725) itemoff 9827 itemsize 50
                location key (25028 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 120 key (23764 DIR_ITEM 968764776) itemoff 9770 itemsize 57
                location key (28124253 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 27
                name: HIDDEN
        item 121 key (23764 DIR_ITEM 1132827042) itemoff 9712 itemsize 58
                location key (25025 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 122 key (23764 DIR_ITEM 1729494133) itemoff 9662 itemsize 50
                location key (25026 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 123 key (23764 DIR_ITEM 1827547326) itemoff 9624 itemsize 38
                location key (24104 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 8
                name: HIDDEN
        item 124 key (23764 DIR_ITEM 2229585072) itemoff 9566 itemsize 58
                location key (25035 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 125 key (23764 DIR_ITEM 2526016105) itemoff 9519 itemsize 47
                location key (25023 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 126 key (23764 DIR_ITEM 2899353060) itemoff 9480 itemsize 39
                location key (25032 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 9
                name: HIDDEN
        item 127 key (23764 DIR_ITEM 3136240615) itemoff 9417 itemsize 63
                location key (26923419 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 33
                name: HIDDEN
        item 128 key (23764 DIR_ITEM 3406916022) itemoff 9357 itemsize 60
                location key (25033 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 30
                name: HIDDEN
        item 129 key (23764 DIR_ITEM 3796510897) itemoff 9310 itemsize 47
                location key (25022 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 130 key (23764 DIR_ITEM 3861626263) itemoff 9252 itemsize 58
                location key (25029 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 131 key (23764 DIR_INDEX 2) itemoff 9215 itemsize 37
                location key (24103 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 7
                name: HIDDEN
        item 132 key (23764 DIR_INDEX 3) itemoff 9177 itemsize 38
                location key (24104 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 8
                name: HIDDEN
        item 133 key (23764 DIR_INDEX 4) itemoff 9130 itemsize 47
                location key (25022 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 134 key (23764 DIR_INDEX 5) itemoff 9083 itemsize 47
                location key (25023 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 17
                name: HIDDEN
        item 135 key (23764 DIR_INDEX 6) itemoff 9029 itemsize 54
                location key (25024 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 136 key (23764 DIR_INDEX 7) itemoff 8971 itemsize 58
                location key (25025 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 137 key (23764 DIR_INDEX 8) itemoff 8921 itemsize 50
                location key (25026 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 138 key (23764 DIR_INDEX 9) itemoff 8863 itemsize 58
                location key (25027 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 139 key (23764 DIR_INDEX 10) itemoff 8813 itemsize 50
                location key (25028 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 20
                name: HIDDEN
        item 140 key (23764 DIR_INDEX 11) itemoff 8755 itemsize 58
                location key (25029 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 141 key (23764 DIR_INDEX 12) itemoff 8699 itemsize 56
                location key (25030 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 26
                name: HIDDEN
        item 142 key (23764 DIR_INDEX 13) itemoff 8648 itemsize 51
                location key (25031 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 21
                name: HIDDEN
        item 143 key (23764 DIR_INDEX 14) itemoff 8609 itemsize 39
                location key (25032 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 9
                name: HIDDEN
        item 144 key (23764 DIR_INDEX 15) itemoff 8549 itemsize 60
                location key (25033 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 30
                name: HIDDEN
        item 145 key (23764 DIR_INDEX 16) itemoff 8500 itemsize 49
                location key (25034 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 19
                name: HIDDEN
        item 146 key (23764 DIR_INDEX 17) itemoff 8442 itemsize 58
                location key (25035 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 28
                name: HIDDEN
        item 147 key (23764 DIR_INDEX 18) itemoff 8379 itemsize 63
                location key (26923419 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 33
                name: HIDDEN
        item 148 key (23764 DIR_INDEX 19) itemoff 8322 itemsize 57
                location key (28124253 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 27
                name: HIDDEN
        item 149 key (23765 INODE_ITEM 0) itemoff 8162 itemsize 160
                inode generation 10693 transid 74009 size 8 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x12(none)
                atime 1488554072.456072204 (2017-03-03 16:14:32)
                ctime 1488554072.456072204 (2017-03-03 16:14:32)
                mtime 1488525775.715496603 (2017-03-03 08:22:55)
                otime 1479206762.627403857 (2016-11-15 11:46:02)
        item 150 key (23765 INODE_REF 20708) itemoff 8150 itemsize 12
                inode ref index 8 namelen 2 name: HIDDEN
        item 151 key (23765 DIR_ITEM 3958443109) itemoff 8116 itemsize 34
                location key (24189 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 4
                name: HIDDEN
        item 152 key (23765 DIR_INDEX 2) itemoff 8082 itemsize 34
                location key (24189 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 4
                name: HIDDEN
        item 153 key (23766 INODE_ITEM 0) itemoff 7922 itemsize 160
                inode generation 10693 transid 74010 size 3814 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0xa7(none)
                atime 1488554108.987765468 (2017-03-03 16:15:08)
                ctime 1488554108.987765468 (2017-03-03 16:15:08)
                mtime 1488525775.767496467 (2017-03-03 08:22:55)
                otime 1479206762.627403857 (2016-11-15 11:46:02)
        item 154 key (23766 INODE_REF 20708) itemoff 7903 itemsize 19
                inode ref index 9 namelen 9 name: HIDDEN
        item 155 key (23766 DIR_ITEM 67785749) itemoff 7846 itemsize 57
                location key (25209 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 156 key (23766 DIR_ITEM 102618019) itemoff 7789 itemsize 57
                location key (24481142 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 27
                name: HIDDEN
        item 157 key (23766 DIR_ITEM 120390308) itemoff 7732 itemsize 57
                location key (24481143 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 27
                name: HIDDEN
        item 158 key (23766 DIR_ITEM 171667193) itemoff 7675 itemsize 57
                location key (25205 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 159 key (23766 DIR_ITEM 188848766) itemoff 7618 itemsize 57
                location key (25202 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 160 key (23766 DIR_ITEM 212106518) itemoff 7564 itemsize 54
                location key (25153 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 161 key (23766 DIR_ITEM 458455269) itemoff 7510 itemsize 54
                location key (25185 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 162 key (23766 DIR_ITEM 467611972) itemoff 7456 itemsize 54
                location key (25204 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 163 key (23766 DIR_ITEM 556687511) itemoff 7399 itemsize 57
                location key (25208 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 164 key (23766 DIR_ITEM 582018542) itemoff 7342 itemsize 57
                location key (24481139 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 27
                name: HIDDEN
        item 165 key (23766 DIR_ITEM 649353749) itemoff 7285 itemsize 57
                location key (25212 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 166 key (23766 DIR_ITEM 856075716) itemoff 7231 itemsize 54
                location key (25167 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 167 key (23766 DIR_ITEM 868790074) itemoff 7177 itemsize 54
                location key (25149 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 168 key (23766 DIR_ITEM 907169442) itemoff 7120 itemsize 57
                location key (26923436 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 27
                name: HIDDEN
        item 169 key (23766 DIR_ITEM 954915773) itemoff 7066 itemsize 54
                location key (25161 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 170 key (23766 DIR_ITEM 988707799) itemoff 7012 itemsize 54
                location key (24481141 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 24
                name: HIDDEN
        item 171 key (23766 DIR_ITEM 1005106776) itemoff 6955 itemsize 57
                location key (24481137 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 27
                name: HIDDEN
        item 172 key (23766 DIR_ITEM 1029756489) itemoff 6898 itemsize 57
                location key (25192 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 173 key (23766 DIR_ITEM 1039261919) itemoff 6844 itemsize 54
                location key (25190 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 174 key (23766 DIR_ITEM 1063883568) itemoff 6790 itemsize 54
                location key (25201 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 175 key (23766 DIR_ITEM 1113190242) itemoff 6739 itemsize 51
                location key (25151 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 21
                name: HIDDEN
        item 176 key (23766 DIR_ITEM 1121563156) itemoff 6693 itemsize 46
                location key (20722564 INODE_ITEM 0) type FILE
                transid 39007 data_len 0 name_len 16
                name: HIDDEN
        item 177 key (23766 DIR_ITEM 1209673396) itemoff 6639 itemsize 54
                location key (25127 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 178 key (23766 DIR_ITEM 1324237487) itemoff 6585 itemsize 54
                location key (25179 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 179 key (23766 DIR_ITEM 1337341509) itemoff 6534 itemsize 51
                location key (25133 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 21
                name: HIDDEN
        item 180 key (23766 DIR_ITEM 1400607696) itemoff 6477 itemsize 57
                location key (26923437 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 27
                name: HIDDEN
        item 181 key (23766 DIR_ITEM 1412378508) itemoff 6420 itemsize 57
                location key (25200 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 182 key (23766 DIR_ITEM 1510312565) itemoff 6363 itemsize 57
                location key (25193 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 183 key (23766 DIR_ITEM 1547841903) itemoff 6306 itemsize 57
                location key (25210 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
        item 184 key (23766 DIR_ITEM 1577879943) itemoff 6252 itemsize 54
                location key (25183 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 24
                name: HIDDEN
        item 185 key (23766 DIR_ITEM 1638279751) itemoff 6198 itemsize 54
                location key (24481144 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 24
                name: HIDDEN
        item 186 key (23766 DIR_ITEM 1764671807) itemoff 6144 itemsize 54
                location key (24481127 INODE_ITEM 0) type FILE
                transid 62510 data_len 0 name_len 24
                name: HIDDEN
        item 187 key (23766 DIR_ITEM 1769479548) itemoff 6087 itemsize 57
                location key (25207 INODE_ITEM 0) type FILE
                transid 10694 data_len 0 name_len 27
                name: HIDDEN
163322413056
btrfs-progs v4.8.5
leaf 163322413056 items 113 free space 934 generation 86739 owner 3892
fs uuid 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
chunk uuid b86efe94-ab40-4344-ac6b-46ec59c41b8f
        item 0 key (24011 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 10693 transid 81388 size 1280 nbytes 1280
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.585598188 (2017-03-17 20:38:24)
                ctime 1489779504.585598188 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206765.895362890 (2016-11-15 11:46:05)
        item 1 key (24011 INODE_REF 23010) itemoff 16095 itemsize 28
                inode ref index 3 namelen 18 name: HIDDEN
        item 2 key (24011 EXTENT_DATA 0) itemoff 15607 itemsize 488
                generation 81388 type 0 (inline)
                inline extent data size 467 ram_bytes 1280 compression 1
(zlib)
        item 3 key (24012 INODE_ITEM 0) itemoff 15447 itemsize 160
                inode generation 10693 transid 81388 size 1137 nbytes 1137
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.585598188 (2017-03-17 20:38:24)
                ctime 1489779504.585598188 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206765.899362839 (2016-11-15 11:46:05)
        item 4 key (24012 INODE_REF 23010) itemoff 15420 itemsize 27
                inode ref index 4 namelen 17 name: HIDDEN
        item 5 key (24012 EXTENT_DATA 0) itemoff 14858 itemsize 562
                generation 81388 type 0 (inline)
                inline extent data size 541 ram_bytes 1137 compression 1
(zlib)
        item 6 key (24013 INODE_ITEM 0) itemoff 14698 itemsize 160
                inode generation 10693 transid 81389 size 17210 nbytes 20480
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.597598078 (2017-03-17 20:38:24)
                ctime 1489779504.597598078 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206765.915362639 (2016-11-15 11:46:05)
        item 7 key (24013 INODE_REF 22814) itemoff 14676 itemsize 22
                inode ref index 2 namelen 12 name: HIDDEN
        item 8 key (24013 EXTENT_DATA 0) itemoff 14623 itemsize 53
                generation 81389 type 1 (regular)
                extent data disk byte 817199280128 nr 8192
                extent data offset 0 nr 16384 ram 16384
                extent compression 1 (zlib)
        item 9 key (24013 EXTENT_DATA 16384) itemoff 14570 itemsize 53
                generation 81388 type 1 (regular)
                extent data disk byte 2718249549824 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 10 key (24014 INODE_ITEM 0) itemoff 14410 itemsize 160
                inode generation 10693 transid 81388 size 3049 nbytes 3049
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.597598078 (2017-03-17 20:38:24)
                ctime 1489779504.597598078 (2017-03-17 20:38:24)
                mtime 1489597200.267386664 (2017-03-15 18:00:00)
                otime 1479206765.951362187 (2016-11-15 11:46:05)
        item 11 key (24014 INODE_REF 22815) itemoff 14388 itemsize 22
                inode ref index 3 namelen 12 name: HIDDEN
        item 12 key (24014 EXTENT_DATA 0) itemoff 13271 itemsize 1117
                generation 81388 type 0 (inline)
                inline extent data size 1096 ram_bytes 3049 compression
1 (zlib)
        item 13 key (24015 INODE_ITEM 0) itemoff 13111 itemsize 160
                inode generation 10693 transid 81389 size 23256 nbytes 24576
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.625597821 (2017-03-17 20:38:24)
                ctime 1489779504.625597821 (2017-03-17 20:38:24)
                mtime 1489597200.267386664 (2017-03-15 18:00:00)
                otime 1479206765.955362137 (2016-11-15 11:46:05)
        item 14 key (24015 INODE_REF 22815) itemoff 13090 itemsize 21
                inode ref index 4 namelen 11 name: HIDDEN
        item 15 key (24015 EXTENT_DATA 0) itemoff 13037 itemsize 53
                generation 81389 type 1 (regular)
                extent data disk byte 817199288320 nr 8192
                extent data offset 0 nr 20480 ram 20480
                extent compression 1 (zlib)
        item 16 key (24015 EXTENT_DATA 20480) itemoff 12984 itemsize 53
                generation 81388 type 1 (regular)
                extent data disk byte 2718249553920 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 17 key (24016 INODE_ITEM 0) itemoff 12824 itemsize 160
                inode generation 10693 transid 86739 size 2046 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0xf6(none)
                atime 1488554077.616028878 (2017-03-03 16:14:37)
                ctime 1491160501.510094406 (2017-04-02 21:15:01)
                mtime 1491160501.510094406 (2017-04-02 21:15:01)
                otime 1479206765.959362086 (2016-11-15 11:46:05)
        item 18 key (24016 INODE_REF 23760) itemoff 12810 itemsize 14
                inode ref index 2 namelen 4 name: HIDDEN
        item 19 key (24016 DIR_ITEM 171041720) itemoff 12755 itemsize 55
                location key (26923408 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 20 key (24016 DIR_ITEM 397875306) itemoff 12685 itemsize 70
                location key (28124245 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 40
                name: HIDDEN
        item 21 key (24016 DIR_ITEM 434283743) itemoff 12630 itemsize 55
                location key (28124238 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 22 key (24016 DIR_ITEM 436074757) itemoff 12571 itemsize 59
                location key (28124247 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 23 key (24016 DIR_ITEM 440661832) itemoff 12511 itemsize 60
                location key (26923405 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 30
                name: HIDDEN
        item 24 key (24016 DIR_ITEM 786990448) itemoff 12448 itemsize 63
                location key (28124248 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 33
                name: HIDDEN
        item 25 key (24016 DIR_ITEM 874464475) itemoff 12389 itemsize 59
                location key (28124242 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 26 key (24016 DIR_ITEM 877084487) itemoff 12337 itemsize 52
                location key (26923402 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 22
                name: HIDDEN
        item 27 key (24016 DIR_ITEM 1135627564) itemoff 12267 itemsize 70
                location key (26923410 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 40
                name: HIDDEN
        item 28 key (24016 DIR_ITEM 1306915225) itemoff 12212 itemsize 55
                location key (26923403 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 29 key (24016 DIR_ITEM 1308273731) itemoff 12153 itemsize 59
                location key (26923412 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 30 key (24016 DIR_ITEM 1313120782) itemoff 12093 itemsize 60
                location key (28124240 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 31 key (24016 DIR_ITEM 1580644094) itemoff 12038 itemsize 55
                location key (28124243 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 32 key (24016 DIR_ITEM 1612190109) itemoff 11979 itemsize 59
                location key (26923407 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 33 key (24016 DIR_ITEM 1614834177) itemoff 11927 itemsize 52
                location key (28124237 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 22
                name: HIDDEN
        item 34 key (24016 DIR_ITEM 2062536758) itemoff 11864 itemsize 63
                location key (26923413 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 33
                name: HIDDEN
        item 35 key (24016 DIR_ITEM 2404156764) itemoff 11811 itemsize 53
                location key (28124244 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 36 key (24016 DIR_ITEM 2756039563) itemoff 11756 itemsize 55
                location key (26923404 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 37 key (24016 DIR_ITEM 2793287223) itemoff 11719 itemsize 37
                location key (24040 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 7
                name: HIDDEN
        item 38 key (24016 DIR_ITEM 2813996190) itemoff 11657 itemsize 62
                location key (28124249 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 39 key (24016 DIR_ITEM 2898901948) itemoff 11599 itemsize 58
                location key (28124235 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 28
                name: HIDDEN
        item 40 key (24016 DIR_ITEM 2955576878) itemoff 11537 itemsize 62
                location key (28124251 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 41 key (24016 DIR_ITEM 3041003060) itemoff 11475 itemsize 62
                location key (26923415 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 32
                name: HIDDEN
        item 42 key (24016 DIR_ITEM 3099551727) itemoff 11416 itemsize 59
                location key (26923417 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 43 key (24016 DIR_ITEM 3175140354) itemoff 11362 itemsize 54
                location key (28124236 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 24
                name: HIDDEN
        item 44 key (24016 DIR_ITEM 3181032183) itemoff 11305 itemsize 57
                location key (28124241 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 27
                name: HIDDEN
        item 45 key (24016 DIR_ITEM 3220020725) itemoff 11252 itemsize 53
                location key (28124246 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 46 key (24016 DIR_ITEM 3679178778) itemoff 11199 itemsize 53
                location key (26923409 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 23
                name: HIDDEN
        item 47 key (24016 DIR_ITEM 3779416946) itemoff 11137 itemsize 62
                location key (28124250 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 48 key (24016 DIR_ITEM 3828208488) itemoff 11075 itemsize 62
                location key (26923416 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 32
                name: HIDDEN
        item 49 key (24016 DIR_ITEM 3913783620) itemoff 11021 itemsize 54
                location key (26923401 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 24
                name: HIDDEN
        item 50 key (24016 DIR_ITEM 3919439793) itemoff 10964 itemsize 57
                location key (26923406 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 27
                name: HIDDEN
        item 51 key (24016 DIR_ITEM 3958032563) itemoff 10911 itemsize 53
                location key (26923411 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 23
                name: HIDDEN
        item 52 key (24016 DIR_ITEM 3971494569) itemoff 10852 itemsize 59
                location key (28124252 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 53 key (24016 DIR_ITEM 4030891725) itemoff 10797 itemsize 55
                location key (28124239 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 54 key (24016 DIR_ITEM 4089280984) itemoff 10735 itemsize 62
                location key (26923414 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 32
                name: HIDDEN
        item 55 key (24016 DIR_ITEM 4174311162) itemoff 10677 itemsize 58
                location key (26923400 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 28
                name: HIDDEN
        item 56 key (24016 DIR_INDEX 2) itemoff 10640 itemsize 37
                location key (24040 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 7
                name: HIDDEN
        item 57 key (24016 DIR_INDEX 3) itemoff 10582 itemsize 58
                location key (28124235 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 28
                name: HIDDEN
        item 58 key (24016 DIR_INDEX 4) itemoff 10528 itemsize 54
                location key (28124236 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 24
                name: HIDDEN
        item 59 key (24016 DIR_INDEX 5) itemoff 10476 itemsize 52
                location key (28124237 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 22
                name: HIDDEN
        item 60 key (24016 DIR_INDEX 6) itemoff 10421 itemsize 55
                location key (28124238 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 61 key (24016 DIR_INDEX 7) itemoff 10366 itemsize 55
                location key (28124239 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 62 key (24016 DIR_INDEX 8) itemoff 10306 itemsize 60
                location key (28124240 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 63 key (24016 DIR_INDEX 9) itemoff 10249 itemsize 57
                location key (28124241 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 27
                name: HIDDEN
        item 64 key (24016 DIR_INDEX 10) itemoff 10190 itemsize 59
                location key (28124242 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 65 key (24016 DIR_INDEX 11) itemoff 10135 itemsize 55
                location key (28124243 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 66 key (24016 DIR_INDEX 12) itemoff 10082 itemsize 53
                location key (28124244 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 67 key (24016 DIR_INDEX 13) itemoff 10012 itemsize 70
                location key (28124245 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 40
                name: HIDDEN
        item 68 key (24016 DIR_INDEX 14) itemoff 9959 itemsize 53
                location key (28124246 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 69 key (24016 DIR_INDEX 15) itemoff 9900 itemsize 59
                location key (28124247 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 70 key (24016 DIR_INDEX 16) itemoff 9837 itemsize 63
                location key (28124248 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 33
                name: HIDDEN
        item 71 key (24016 DIR_INDEX 17) itemoff 9775 itemsize 62
                location key (28124249 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 72 key (24016 DIR_INDEX 18) itemoff 9713 itemsize 62
                location key (28124250 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 73 key (24016 DIR_INDEX 19) itemoff 9651 itemsize 62
                location key (28124251 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 74 key (24016 DIR_INDEX 20) itemoff 9592 itemsize 59
                location key (28124252 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 75 key (24016 DIR_INDEX 4) itemoff 9538 itemsize 54
                location key (26923401 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 24
                name: HIDDEN
        item 76 key (24016 DIR_INDEX 5) itemoff 9486 itemsize 52
                location key (26923402 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 22
                name: HIDDEN
        item 77 key (24016 DIR_INDEX 6) itemoff 9431 itemsize 55
                location key (26923403 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 78 key (24016 DIR_INDEX 7) itemoff 9376 itemsize 55
                location key (26923404 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 79 key (24016 DIR_INDEX 8) itemoff 9316 itemsize 60
                location key (26923405 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 30
                name: HIDDEN
        item 80 key (24016 DIR_INDEX 9) itemoff 9259 itemsize 57
                location key (26923406 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 27
                name: HIDDEN
        item 81 key (24016 DIR_INDEX 10) itemoff 9200 itemsize 59
                location key (26923407 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 82 key (24016 DIR_INDEX 11) itemoff 9145 itemsize 55
                location key (26923408 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 25
                name: HIDDEN
        item 83 key (24016 DIR_INDEX 12) itemoff 9092 itemsize 53
                location key (26923409 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 23
                name: HIDDEN
        item 84 key (24016 DIR_INDEX 13) itemoff 9022 itemsize 70
                location key (26923410 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 40
                name: HIDDEN
        item 85 key (24016 DIR_INDEX 14) itemoff 8969 itemsize 53
                location key (26923411 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 23
                name: HIDDEN
        item 86 key (24016 DIR_INDEX 15) itemoff 8910 itemsize 59
                location key (26923412 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 87 key (24016 DIR_INDEX 16) itemoff 8847 itemsize 63
                location key (26923413 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 33
                name: HIDDEN
        item 88 key (24016 DIR_INDEX 17) itemoff 8785 itemsize 62
                location key (26923414 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 32
                name: HIDDEN
        item 89 key (24016 DIR_INDEX 18) itemoff 8723 itemsize 62
                location key (26923415 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 32
                name: HIDDEN
        item 90 key (24016 DIR_INDEX 19) itemoff 8661 itemsize 62
                location key (26923416 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 32
                name: HIDDEN
        item 91 key (24016 DIR_INDEX 20) itemoff 8602 itemsize 59
                location key (26923417 INODE_ITEM 0) type FILE
                transid 74009 data_len 0 name_len 29
                name: HIDDEN
        item 92 key (24018 INODE_ITEM 0) itemoff 8442 itemsize 160
                inode generation 10693 transid 81389 size 51624 nbytes 53248
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.267386664 (2017-03-15 18:00:00)
                otime 1479206765.995361635 (2016-11-15 11:46:05)
        item 93 key (24018 INODE_REF 22815) itemoff 8420 itemsize 22
                inode ref index 5 namelen 12 name: HIDDEN
        item 94 key (24018 EXTENT_DATA 0) itemoff 8367 itemsize 53
                generation 81389 type 1 (regular)
                extent data disk byte 817199296512 nr 16384
                extent data offset 0 nr 49152 ram 49152
                extent compression 1 (zlib)
        item 95 key (24018 EXTENT_DATA 49152) itemoff 8314 itemsize 53
                generation 81388 type 1 (regular)
                extent data disk byte 2718249558016 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 96 key (24019 INODE_ITEM 0) itemoff 8154 itemsize 160
                inode generation 10693 transid 81388 size 989 nbytes 989
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206766.23361285 (2016-11-15 11:46:06)
        item 97 key (24019 INODE_REF 23032) itemoff 8128 itemsize 26
                inode ref index 2 namelen 16 name: HIDDEN
        item 98 key (24019 EXTENT_DATA 0) itemoff 7697 itemsize 431
                generation 81388 type 0 (inline)
                inline extent data size 410 ram_bytes 989 compression 1
(zlib)
        item 99 key (24020 INODE_ITEM 0) itemoff 7537 itemsize 160
                inode generation 10693 transid 81388 size 1598 nbytes 1598
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206766.27361235 (2016-11-15 11:46:06)
        item 100 key (24020 INODE_REF 23032) itemoff 7511 itemsize 26
                inode ref index 3 namelen 16 name: HIDDEN
        item 101 key (24020 EXTENT_DATA 0) itemoff 6829 itemsize 682
                generation 81388 type 0 (inline)
                inline extent data size 661 ram_bytes 1598 compression 1
(zlib)
        item 102 key (24021 INODE_ITEM 0) itemoff 6669 itemsize 160
                inode generation 10693 transid 81388 size 3652 nbytes 3652
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206766.31361184 (2016-11-15 11:46:06)
        item 103 key (24021 INODE_REF 23032) itemoff 6638 itemsize 31
                inode ref index 4 namelen 21 name: HIDDEN
        item 104 key (24021 EXTENT_DATA 0) itemoff 5690 itemsize 948
                generation 81388 type 0 (inline)
                inline extent data size 927 ram_bytes 3652 compression 1
(zlib)
        item 105 key (24022 INODE_ITEM 0) itemoff 5530 itemsize 160
                inode generation 10693 transid 81388 size 3651 nbytes 3651
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.267386664 (2017-03-15 18:00:00)
                otime 1479206766.31361184 (2016-11-15 11:46:06)
        item 106 key (24022 INODE_REF 23032) itemoff 5503 itemsize 27
                inode ref index 5 namelen 17 name: HIDDEN
        item 107 key (24022 EXTENT_DATA 0) itemoff 4554 itemsize 949
                generation 81388 type 0 (inline)
                inline extent data size 928 ram_bytes 3651 compression 1
(zlib)
        item 108 key (24023 INODE_ITEM 0) itemoff 4394 itemsize 160
                inode generation 10693 transid 81388 size 852 nbytes 852
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.267386664 (2017-03-15 18:00:00)
                otime 1479206766.35361134 (2016-11-15 11:46:06)
        item 109 key (24023 INODE_REF 23032) itemoff 4367 itemsize 27
                inode ref index 6 namelen 17 name: HIDDEN
        item 110 key (24023 EXTENT_DATA 0) itemoff 3947 itemsize 420
                generation 81388 type 0 (inline)
                inline extent data size 399 ram_bytes 852 compression 1
(zlib)
        item 111 key (24024 INODE_ITEM 0) itemoff 3787 itemsize 160
                inode generation 10693 transid 81388 size 1904 nbytes 1904
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779504.661597490 (2017-03-17 20:38:24)
                ctime 1489779504.661597490 (2017-03-17 20:38:24)
                mtime 1489597200.263386674 (2017-03-15 18:00:00)
                otime 1479206766.35361134 (2016-11-15 11:46:06)
        item 112 key (24024 INODE_REF 23032) itemoff 3759 itemsize 28
                inode ref index 7 namelen 18 name: HIDDEN
163325722624
btrfs-progs v4.8.5
leaf 163325722624 items 78 free space 6563 generation 86739 owner 3892
fs uuid 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
chunk uuid b86efe94-ab40-4344-ac6b-46ec59c41b8f
        item 0 key (24184 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 10693 transid 81389 size 367 nbytes 367
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779537.385296959 (2017-03-17 20:38:57)
                ctime 1489779537.385296959 (2017-03-17 20:38:57)
                mtime 1489597200.311386560 (2017-03-15 18:00:00)
                otime 1479206768.67335662 (2016-11-15 11:46:08)
        item 1 key (24184 INODE_REF 23135) itemoff 16103 itemsize 20
                inode ref index 48 namelen 10 name: HIDDEN
        item 2 key (24184 EXTENT_DATA 0) itemoff 15715 itemsize 388
                generation 81389 type 0 (inline)
                inline extent data size 367 ram_bytes 367 compression 0
(none)
        item 3 key (24185 INODE_ITEM 0) itemoff 15555 itemsize 160
                inode generation 10693 transid 81389 size 504 nbytes 504
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779537.449296371 (2017-03-17 20:38:57)
                ctime 1489779537.449296371 (2017-03-17 20:38:57)
                mtime 1489597200.323386531 (2017-03-15 18:00:00)
                otime 1479206768.87335411 (2016-11-15 11:46:08)
        item 4 key (24185 INODE_REF 23135) itemoff 15532 itemsize 23
                inode ref index 49 namelen 13 name: HIDDEN
        item 5 key (24185 EXTENT_DATA 0) itemoff 15007 itemsize 525
                generation 81389 type 0 (inline)
                inline extent data size 504 ram_bytes 504 compression 0
(none)
        item 6 key (24186 INODE_ITEM 0) itemoff 14847 itemsize 160
                inode generation 10693 transid 81389 size 209 nbytes 209
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779537.449296371 (2017-03-17 20:38:57)
                ctime 1489779537.449296371 (2017-03-17 20:38:57)
                mtime 1489597200.335386503 (2017-03-15 18:00:00)
                otime 1479206768.91335361 (2016-11-15 11:46:08)
        item 7 key (24186 INODE_REF 23135) itemoff 14828 itemsize 19
                inode ref index 50 namelen 9 name: HIDDEN
        item 8 key (24186 EXTENT_DATA 0) itemoff 14598 itemsize 230
                generation 81389 type 0 (inline)
                inline extent data size 209 ram_bytes 209 compression 0
(none)
        item 9 key (24187 INODE_ITEM 0) itemoff 14438 itemsize 160
                inode generation 10693 transid 81389 size 1052 nbytes 1052
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779537.477296114 (2017-03-17 20:38:57)
                ctime 1489779537.477296114 (2017-03-17 20:38:57)
                mtime 1489597200.311386560 (2017-03-15 18:00:00)
                otime 1479206768.95335310 (2016-11-15 11:46:08)
        item 10 key (24187 INODE_REF 23135) itemoff 14416 itemsize 22
                inode ref index 51 namelen 12 name: HIDDEN
        item 11 key (24187 EXTENT_DATA 0) itemoff 13370 itemsize 1046
                generation 81389 type 0 (inline)
                inline extent data size 1025 ram_bytes 1052 compression
1 (zlib)
        item 12 key (24188 INODE_ITEM 0) itemoff 13210 itemsize 160
                inode generation 10693 transid 81389 size 881 nbytes 881
                block group 0 mode 100644 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0x17(none)
                atime 1489779537.513295783 (2017-03-17 20:38:57)
                ctime 1489779537.513295783 (2017-03-17 20:38:57)
                mtime 1489597200.311386560 (2017-03-15 18:00:00)
                otime 1479206768.99335260 (2016-11-15 11:46:08)
        item 13 key (24188 INODE_REF 23135) itemoff 13190 itemsize 20
                inode ref index 52 namelen 10 name: HIDDEN
        item 14 key (24188 EXTENT_DATA 0) itemoff 12288 itemsize 902
                generation 81389 type 0 (inline)
                inline extent data size 881 ram_bytes 881 compression 0
(none)
        item 15 key (24189 INODE_ITEM 0) itemoff 12128 itemsize 160
                inode generation 10693 transid 86739 size 1802 nbytes 0
                block group 0 mode 40755 links 1 uid 1643 gid 2645 rdev 0
                sequence 0 flags 0xb5(none)
                atime 1488554108.183772218 (2017-03-03 16:15:08)
                ctime 1491160502.146097582 (2017-04-02 21:15:02)
                mtime 1491160502.146097582 (2017-04-02 21:15:02)
                otime 1479206768.99335260 (2016-11-15 11:46:08)
        item 16 key (24189 INODE_REF 23765) itemoff 12114 itemsize 14
                inode ref index 2 namelen 4 name: HIDDEN
        item 17 key (24189 DIR_ITEM 46664211) itemoff 12052 itemsize 62
                location key (28124261 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 18 key (24189 DIR_ITEM 213870030) itemoff 11988 itemsize 64
                location key (28124267 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 34
                name: HIDDEN
        item 19 key (24189 DIR_ITEM 233401760) itemoff 11928 itemsize 60
                location key (26923422 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 30
                name: HIDDEN
        item 20 key (24189 DIR_ITEM 537614813) itemoff 11875 itemsize 53
                location key (26923421 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 23
                name: HIDDEN
        item 21 key (24189 DIR_ITEM 641206763) itemoff 11816 itemsize 59
                location key (28124265 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 22 key (24189 DIR_ITEM 668165067) itemoff 11757 itemsize 59
                location key (28124258 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 23 key (24189 DIR_ITEM 756186210) itemoff 11697 itemsize 60
                location key (26923434 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 30
                name: HIDDEN
        item 24 key (24189 DIR_ITEM 861690622) itemoff 11632 itemsize 65
                location key (28124266 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 35
                name: HIDDEN
        item 25 key (24189 DIR_ITEM 915017506) itemoff 11571 itemsize 61
                location key (28124254 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 31
                name: HIDDEN
        item 26 key (24189 DIR_ITEM 1053847139) itemoff 11514 itemsize 57
                location key (28124257 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 27
                name: HIDDEN
        item 27 key (24189 DIR_ITEM 1103361139) itemoff 11450 itemsize 64
                location key (26923429 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 34
                name: HIDDEN
        item 28 key (24189 DIR_ITEM 1306591788) itemoff 11391 itemsize 59
                location key (26923425 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 29 key (24189 DIR_ITEM 1398550227) itemoff 11331 itemsize 60
                location key (26923430 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 30
                name: HIDDEN
        item 30 key (24189 DIR_ITEM 1400846779) itemoff 11272 itemsize 59
                location key (28124260 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 31 key (24189 DIR_ITEM 1446596434) itemoff 11217 itemsize 55
                location key (28124262 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 32 key (24189 DIR_ITEM 2718406938) itemoff 11162 itemsize 55
                location key (26923428 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 25
                name: HIDDEN
        item 33 key (24189 DIR_ITEM 2793287223) itemoff 11125 itemsize 37
                location key (24190 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 7
                name: HIDDEN
        item 34 key (24189 DIR_ITEM 2806116339) itemoff 11066 itemsize 59
                location key (26923426 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 35 key (24189 DIR_ITEM 2808281243) itemoff 11006 itemsize 60
                location key (28124264 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 36 key (24189 DIR_ITEM 3053265467) itemoff 10942 itemsize 64
                location key (28124263 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 34
                name: HIDDEN
        item 37 key (24189 DIR_ITEM 3118453860) itemoff 10883 itemsize 59
                location key (28124259 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 38 key (24189 DIR_ITEM 3266632042) itemoff 10822 itemsize 61
                location key (26923420 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 31
                name: HIDDEN
        item 39 key (24189 DIR_ITEM 3345124534) itemoff 10757 itemsize 65
                location key (26923432 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 35
                name: HIDDEN
        item 40 key (24189 DIR_ITEM 3404642347) itemoff 10700 itemsize 57
                location key (26923423 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 27
                name: HIDDEN
        item 41 key (24189 DIR_ITEM 3523665827) itemoff 10641 itemsize 59
                location key (26923431 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 42 key (24189 DIR_ITEM 3555571075) itemoff 10582 itemsize 59
                location key (26923424 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 43 key (24189 DIR_ITEM 3560279957) itemoff 10529 itemsize 53
                location key (28124255 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 44 key (24189 DIR_ITEM 3643583018) itemoff 10469 itemsize 60
                location key (28124268 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 45 key (24189 DIR_ITEM 4143373403) itemoff 10407 itemsize 62
                location key (26923427 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 32
                name: HIDDEN
        item 46 key (24189 DIR_ITEM 4169249670) itemoff 10343 itemsize 64
                location key (26923433 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 34
                name: HIDDEN
        item 47 key (24189 DIR_ITEM 4191665128) itemoff 10283 itemsize 60
                location key (28124256 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 48 key (24189 DIR_INDEX 2) itemoff 10246 itemsize 37
                location key (24190 INODE_ITEM 0) type DIR
                transid 10693 data_len 0 name_len 7
                name: HIDDEN
        item 49 key (24189 DIR_INDEX 3) itemoff 10185 itemsize 61
                location key (28124254 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 31
                name: HIDDEN
        item 50 key (24189 DIR_INDEX 4) itemoff 10132 itemsize 53
                location key (28124255 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 23
                name: HIDDEN
        item 51 key (24189 DIR_INDEX 5) itemoff 10072 itemsize 60
                location key (28124256 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 52 key (24189 DIR_INDEX 6) itemoff 10015 itemsize 57
                location key (28124257 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 27
                name: HIDDEN
        item 53 key (24189 DIR_INDEX 7) itemoff 9956 itemsize 59
                location key (28124258 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 54 key (24189 DIR_INDEX 8) itemoff 9897 itemsize 59
                location key (28124259 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 55 key (24189 DIR_INDEX 9) itemoff 9838 itemsize 59
                location key (28124260 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 56 key (24189 DIR_INDEX 10) itemoff 9776 itemsize 62
                location key (28124261 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 32
                name: HIDDEN
        item 57 key (24189 DIR_INDEX 11) itemoff 9721 itemsize 55
                location key (28124262 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 25
                name: HIDDEN
        item 58 key (24189 DIR_INDEX 12) itemoff 9657 itemsize 64
                location key (28124263 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 34
                name: HIDDEN
        item 59 key (24189 DIR_INDEX 13) itemoff 9597 itemsize 60
                location key (28124264 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 60 key (24189 DIR_INDEX 14) itemoff 9538 itemsize 59
                location key (28124265 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 29
                name: HIDDEN
        item 61 key (24189 DIR_INDEX 15) itemoff 9473 itemsize 65
                location key (28124266 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 35
                name: HIDDEN
        item 62 key (24189 DIR_INDEX 16) itemoff 9409 itemsize 64
                location key (28124267 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 34
                name: HIDDEN
        item 63 key (24189 DIR_INDEX 17) itemoff 9349 itemsize 60
                location key (28124268 INODE_ITEM 0) type FILE
                transid 86739 data_len 0 name_len 30
                name: HIDDEN
        item 64 key (24189 DIR_INDEX 4) itemoff 9296 itemsize 53
                location key (26923421 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 23
                name: HIDDEN
        item 65 key (24189 DIR_INDEX 5) itemoff 9236 itemsize 60
                location key (26923422 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 30
                name: HIDDEN
        item 66 key (24189 DIR_INDEX 6) itemoff 9179 itemsize 57
                location key (26923423 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 27
                name: HIDDEN
        item 67 key (24189 DIR_INDEX 7) itemoff 9120 itemsize 59
                location key (26923424 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 68 key (24189 DIR_INDEX 8) itemoff 9061 itemsize 59
                location key (26923425 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 69 key (24189 DIR_INDEX 9) itemoff 9002 itemsize 59
                location key (26923426 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 70 key (24189 DIR_INDEX 10) itemoff 8940 itemsize 62
                location key (26923427 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 32
                name: HIDDEN
        item 71 key (24189 DIR_INDEX 11) itemoff 8885 itemsize 55
                location key (26923428 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 25
                name: HIDDEN
        item 72 key (24189 DIR_INDEX 12) itemoff 8821 itemsize 64
                location key (26923429 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 34
                name: HIDDEN
        item 73 key (24189 DIR_INDEX 13) itemoff 8761 itemsize 60
                location key (26923430 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 30
                name: HIDDEN
        item 74 key (24189 DIR_INDEX 14) itemoff 8702 itemsize 59
                location key (26923431 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 29
                name: HIDDEN
        item 75 key (24189 DIR_INDEX 15) itemoff 8637 itemsize 65
                location key (26923432 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 35
                name: HIDDEN
        item 76 key (24189 DIR_INDEX 16) itemoff 8573 itemsize 64
                location key (26923433 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 34
                name: HIDDEN
        item 77 key (24189 DIR_INDEX 17) itemoff 8513 itemsize 60
                location key (26923434 INODE_ITEM 0) type FILE
                transid 74010 data_len 0 name_len 30
                name: HIDDEN

Stefan
Am 10.05.2017 um 11:08 schrieb Hugo Mills:
> On Wed, May 10, 2017 at 10:40:31AM +0200, Stefan Priebe - Profihost AG wrote:
>> Am 10.05.2017 um 09:40 schrieb Hugo Mills:
>>> On Wed, May 10, 2017 at 09:36:30AM +0200, Stefan Priebe - Profihost AG wrote:
>>>> Hello Roman,
>>>>
>>>> the FS is mountable. It just goes readonly when trying to write some data.
>>>>
>>>> The kernel msgs are:
>>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
>>>> block=163316514816,root=1, slot=39
>>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
>>>> block=163322413056,root=1, slot=74
>>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
>>>> block=163325722624,root=1, slot=63
>>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
>>>> block=163316514816,root=1, slot=39
>>>> BTRFS: error (device dm-2) in btrfs_drop_snapshot:8839: errno=-5 IO failure
>>>> BTRFS info (device dm-2): forced readonly
>>>> BTRFS info (device dm-2): delayed_refs has NO entry
>>>
>>>    Can you show the output of btrfs-debug-tree -b <blocknum>, where
>>> <blocknum> is each of the three "block=" values above?
>>
>> Can do that. But the lists are very long - should i upload them to
>> pastebin? Is it ok to remove the name atribute - which provides filenames?
> 
>    On the mailing list would be preferable, as then the conversation
> is completely preserved in archives. They shouldn't be so long that
> vger rejects them. And yes, if you want to filter out the filenames,
> do so (but _just_ the filename -- don't remove the whole line).
> 
>    Hugo.
> 
>> Stefan
>>
>>
>>>    Hugo.
>>>
>>>> Greets,
>>>> Stefan
>>>> Am 10.05.2017 um 09:18 schrieb Roman Mamedov:
>>>>> On Wed, 10 May 2017 09:02:46 +0200
>>>>> Stefan Priebe - Profihost AG <s.priebe@profihost.ag> wrote:
>>>>>
>>>>>> how to fix bad key ordering?
>>>>>
>>>>> You should clarify does the FS in question mount (read-write? read-only?)
>>>>> and what are the kernel messages if it does not.
>>>>>
>>>
> 
