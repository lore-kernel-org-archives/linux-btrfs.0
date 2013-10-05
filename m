Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53158 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab3JENTK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Oct 2013 09:19:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VSRl5-0003cj-1i
	for linux-btrfs@vger.kernel.org; Sat, 05 Oct 2013 15:18:59 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 15:18:59 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 15:18:59 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Sat, 05 Oct 2013 14:18:43 +0100
Message-ID: <l2p3ja$v8r$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org> <l2k7kd$1dh$1@ger.gmane.org> <l2mnmf$us$1@ger.gmane.org> <l2otcg$mh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000707060807070906040100"
In-Reply-To: <l2otcg$mh$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000707060807070906040100
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

So...

The hint there is "btrfsck: extent-tree.c:2736", so trying:

btrfsck --repair --init-extent-tree /dev/sdc

That ran for a while until:

kernel: btrfsck[16610]: segfault at cc ip 000000000041d2a7 sp
00007fffd2c2d710 error 4 in btrfsck[400000+4d000]

There's no other messages in the syslog.

The output attached.


What next?


Thanks,
Martin



On 05/10/13 12:32, Martin wrote:
> No comment so blindly trying:
> 
> btrfsck --repair /dev/sdc
> 
> gave the following abort:
> 
> btrfsck: extent-tree.c:2736: alloc_reserved_tree_block: Assertion
> `!(ret)' failed.
> 
> Full output attached.
> 
> 
> All on:
> 
> 3.11.2-gentoo
> Btrfs v0.20-rc1-358-g194aa4a
> 
> For a 2TB single HDD formatted with defaults.
> 
> 
> What next?
> 
> Thanks,
> Martin
> 
> 
> 
> 
>>> In the meantime, trying:
>>>
>>> btrfsck /dev/sdc
>>>
>>> gave the following output + abort:
>>>
>>> parent transid verify failed on 915444523008 wanted 16974 found 13021
>>> Ignoring transid failure
>>> btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
>>> != key->objectid || rec->refs > 1)' failed.
>>> id not match free space cache generation (1625)
>>> free space inode generation (0) did not match free space cache
>>> generation (1607)
>>> free space inode generation (0) did not match free space cache
>>> generation (1604)
>>> free space inode generation (0) did not match free space cache
>>> generation (1606)
>>> free space inode generation (0) did not match free space cache
>>> generation (1620)
>>> free space inode generation (0) did not match free space cache
>>> generation (1626)
>>> free space inode generation (0) did not match free space cache
>>> generation (1609)
>>> free space inode generation (0) did not match free space cache
>>> generation (1653)
>>> free space inode generation (0) did not match free space cache
>>> generation (1628)
>>> free space inode generation (0) did not match free space cache
>>> generation (1628)
>>> free space inode generation (0) did not match free space cache
>>> generation (1649)
>>>
>>>
>>> (There was no syslog output.)
>>>
>>> Full btrfsck listing attached.
>>>
>>>
>>> Suggestions please?
>>>
>>> Thanks,
>>> Martin



--------------000707060807070906040100
Content-Type: text/x-log;
 name="btrfsck_repair_extent-tree_sdc.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfsck_repair_extent-tree_sdc.log"

btrfs unable to find ref byte nr 912043257856 parent 0 root 1  owner 2 offset 0
btrfs unable to find ref byte nr 912043343872 parent 0 root 1  owner 1 offset 1
btrfs unable to find ref byte nr 912044331008 parent 0 root 1  owner 0 offset 1
btrfs unable to find ref byte nr 912043261952 parent 0 root 1  owner 1 offset 1
btrfs unable to find ref byte nr 912043266048 parent 0 root 1  owner 0 offset 1
checking extents
leaf parent key incorrect 907183771648
bad block 907183771648
leaf parent key incorrect 907183779840
bad block 907183779840
leaf parent key incorrect 907183882240
bad block 907183882240
leaf parent key incorrect 907185160192
bad block 907185160192
leaf parent key incorrect 907185201152
bad block 907185201152
leaf parent key incorrect 915432497152
bad block 915432497152
leaf parent key incorrect 915432509440
bad block 915432509440
leaf parent key incorrect 915432513536
bad block 915432513536
leaf parent key incorrect 915432529920
bad block 915432529920
leaf parent key incorrect 915433058304
bad block 915433058304
leaf parent key incorrect 915437543424
bad block 915437543424
leaf parent key incorrect 915437563904
bad block 915437563904
leaf parent key incorrect 915444469760
bad block 915444469760
leaf parent key incorrect 915444473856
bad block 915444473856
leaf parent key incorrect 915444506624
bad block 915444506624
leaf parent key incorrect 915444518912
bad block 915444518912
leaf parent key incorrect 915444523008
bad block 915444523008
leaf parent key incorrect 915444527104
bad block 915444527104
leaf parent key incorrect 915444539392
bad block 915444539392
leaf parent key incorrect 915444543488
bad block 915444543488
leaf parent key incorrect 915444547584
bad block 915444547584
leaf parent key incorrect 915444551680
bad block 915444551680
leaf parent key incorrect 915444555776
bad block 915444555776
leaf parent key incorrect 915444559872
bad block 915444559872
leaf parent key incorrect 915444563968
bad block 915444563968
leaf parent key incorrect 915444572160
bad block 915444572160
leaf parent key incorrect 915444576256
bad block 915444576256
leaf parent key incorrect 915444580352
bad block 915444580352
leaf parent key incorrect 915444584448
bad block 915444584448
leaf parent key incorrect 915444588544
bad block 915444588544
leaf parent key incorrect 915444793344
bad block 915444793344
leaf parent key incorrect 915444797440
bad block 915444797440
leaf parent key incorrect 915444813824
bad block 915444813824
leaf parent key incorrect 915444817920
bad block 915444817920
leaf parent key incorrect 915444822016
bad block 915444822016
leaf parent key incorrect 915444826112
bad block 915444826112
leaf parent key incorrect 915444830208
bad block 915444830208
leaf parent key incorrect 915444834304
bad block 915444834304
leaf parent key incorrect 915444924416
bad block 915444924416
ref mismatch on [12582912 8065024] extent item 0, found 1
btrfs unable to find ref byte nr 912014393344 parent 0 root 2  owner 0 offset 0
adding new data backref on 12582912 root 5 owner 1903 offset 0 found 1
Backref 12582912 root 5 owner 1903 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 12582912 root 5 owner 1903 offset 0 found 1 wanted 0 back 0x1abd230
backpointer mismatch on [12582912 8065024]
ref mismatch on [20647936 12288] extent item 0, found 1
adding new data backref on 20647936 root 5 owner 1911 offset 0 found 1
Backref 20647936 root 5 owner 1911 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20647936 root 5 owner 1911 offset 0 found 1 wanted 0 back 0x1a83e60
backpointer mismatch on [20647936 12288]
ref mismatch on [20660224 90112] extent item 0, found 1
adding new data backref on 20660224 root 5 owner 1919 offset 0 found 1
Backref 20660224 root 5 owner 1919 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20660224 root 5 owner 1919 offset 0 found 1 wanted 0 back 0x620844c0
backpointer mismatch on [20660224 90112]
ref mismatch on [20750336 102400] extent item 0, found 1
adding new data backref on 20750336 root 5 owner 1925 offset 0 found 1
Backref 20750336 root 5 owner 1925 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20750336 root 5 owner 1925 offset 0 found 1 wanted 0 back 0x62084be0
backpointer mismatch on [20750336 102400]
ref mismatch on [20852736 28672] extent item 0, found 1
adding new data backref on 20852736 root 5 owner 1936 offset 0 found 1
Backref 20852736 root 5 owner 1936 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20852736 root 5 owner 1936 offset 0 found 1 wanted 0 back 0x10e6f480
backpointer mismatch on [20852736 28672]
ref mismatch on [20881408 28672] extent item 0, found 1
adding new data backref on 20881408 root 5 owner 1959 offset 0 found 1
Backref 20881408 root 5 owner 1959 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20881408 root 5 owner 1959 offset 0 found 1 wanted 0 back 0x10143d60
backpointer mismatch on [20881408 28672]
ref mismatch on [20910080 8192] extent item 0, found 1
adding new data backref on 20910080 root 5 owner 1977 offset 0 found 1
Backref 20910080 root 5 owner 1977 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20910080 root 5 owner 1977 offset 0 found 1 wanted 0 back 0xec22ec0
backpointer mismatch on [20910080 8192]
ref mismatch on [20918272 8192] extent item 0, found 1
adding new data backref on 20918272 root 5 owner 1985 offset 0 found 1
Backref 20918272 root 5 owner 1985 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20918272 root 5 owner 1985 offset 0 found 1 wanted 0 back 0x62fc1d00
backpointer mismatch on [20918272 8192]
ref mismatch on [20926464 8192] extent item 0, found 1
adding new data backref on 20926464 root 5 owner 1994 offset 0 found 1
Backref 20926464 root 5 owner 1994 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20926464 root 5 owner 1994 offset 0 found 1 wanted 0 back 0x877ba00
backpointer mismatch on [20926464 8192]
ref mismatch on [20934656 8192] extent item 0, found 1
adding new data backref on 20934656 root 5 owner 2002 offset 0 found 1
Backref 20934656 root 5 owner 2002 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20934656 root 5 owner 2002 offset 0 found 1 wanted 0 back 0x877b7a0
backpointer mismatch on [20934656 8192]
ref mismatch on [20942848 24576] extent item 0, found 1
adding new data backref on 20942848 root 5 owner 2064 offset 0 found 1
Backref 20942848 root 5 owner 2064 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20942848 root 5 owner 2064 offset 0 found 1 wanted 0 back 0xa79e490
backpointer mismatch on [20942848 24576]
ref mismatch on [20967424 4096] extent item 0, found 1
adding new data backref on 20967424 root 5 owner 2241 offset 0 found 1
Backref 20967424 root 5 owner 2241 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 20967424 root 5 owner 2241 offset 0 found 1 wanted 0 back 0xc0cba20
backpointer mismatch on [20967424 4096]
ref mismatch on [20983808 4096] extent item 0, found 1
adding new tree backref on start 20983808 len 4096 parent 3 root 3
Backref 20983808 parent 3 root 3 not found in extent tree
backpointer mismatch on [20983808 4096]
ref mismatch on [20987904 4096] extent item 0, found 1
adding new tree backref on start 20987904 len 4096 parent 3 root 3
Backref 20987904 parent 3 root 3 not found in extent tree
backpointer mismatch on [20987904 4096]
ref mismatch on [20992000 4096] extent item 0, found 1
adding new tree backref on start 20992000 len 4096 parent 3 root 3
Backref 20992000 parent 3 root 3 not found in extent tree
backpointer mismatch on [20992000 4096]
ref mismatch on [20996096 4096] extent item 0, found 1
adding new tree backref on start 20996096 len 4096 parent 3 root 3
Backref 20996096 parent 3 root 3 not found in extent tree
backpointer mismatch on [20996096 4096]
ref mismatch on [21000192 4096] extent item 0, found 1
adding new tree backref on start 21000192 len 4096 parent 3 root 3
Backref 21000192 parent 3 root 3 not found in extent tree
backpointer mismatch on [21000192 4096]
ref mismatch on [21004288 4096] extent item 0, found 1
adding new tree backref on start 21004288 len 4096 parent 3 root 3
Backref 21004288 parent 3 root 3 not found in extent tree
backpointer mismatch on [21004288 4096]
ref mismatch on [21008384 4096] extent item 0, found 1
adding new tree backref on start 21008384 len 4096 parent 3 root 3
Backref 21008384 parent 3 root 3 not found in extent tree
backpointer mismatch on [21008384 4096]
ref mismatch on [21012480 4096] extent item 0, found 1
adding new tree backref on start 21012480 len 4096 parent 3 root 3
Backref 21012480 parent 3 root 3 not found in extent tree
backpointer mismatch on [21012480 4096]
ref mismatch on [21016576 4096] extent item 0, found 1
adding new tree backref on start 21016576 len 4096 parent 3 root 3
Backref 21016576 parent 3 root 3 not found in extent tree
backpointer mismatch on [21016576 4096]
ref mismatch on [21020672 4096] extent item 0, found 1
adding new tree backref on start 21020672 len 4096 parent 3 root 3
Backref 21020672 parent 3 root 3 not found in extent tree
backpointer mismatch on [21020672 4096]
ref mismatch on [21024768 4096] extent item 0, found 1
adding new tree backref on start 21024768 len 4096 parent 3 root 3
Backref 21024768 parent 3 root 3 not found in extent tree
backpointer mismatch on [21024768 4096]
ref mismatch on [21028864 4096] extent item 0, found 1
adding new tree backref on start 21028864 len 4096 parent 3 root 3
Backref 21028864 parent 3 root 3 not found in extent tree
backpointer mismatch on [21028864 4096]
ref mismatch on [21032960 4096] extent item 0, found 1
adding new tree backref on start 21032960 len 4096 parent 3 root 3
Backref 21032960 parent 3 root 3 not found in extent tree
backpointer mismatch on [21032960 4096]
ref mismatch on [21037056 4096] extent item 0, found 1
adding new tree backref on start 21037056 len 4096 parent 3 root 3
Backref 21037056 parent 3 root 3 not found in extent tree
backpointer mismatch on [21037056 4096]
ref mismatch on [21041152 4096] extent item 0, found 1

--------------000707060807070906040100--

