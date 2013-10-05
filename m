Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44236 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3JELcy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Oct 2013 07:32:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VSQ6O-0006Op-JL
	for linux-btrfs@vger.kernel.org; Sat, 05 Oct 2013 13:32:52 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 13:32:52 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 13:32:52 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Sat, 05 Oct 2013 12:32:41 +0100
Message-ID: <l2otcg$mh$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org> <l2k7kd$1dh$1@ger.gmane.org> <l2mnmf$us$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040209070200040604060301"
In-Reply-To: <l2mnmf$us$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040209070200040604060301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

No comment so blindly trying:

btrfsck --repair /dev/sdc

gave the following abort:

btrfsck: extent-tree.c:2736: alloc_reserved_tree_block: Assertion
`!(ret)' failed.

Full output attached.


All on:

3.11.2-gentoo
Btrfs v0.20-rc1-358-g194aa4a

For a 2TB single HDD formatted with defaults.


What next?

Thanks,
Martin




>> In the meantime, trying:
>>
>> btrfsck /dev/sdc
>>
>> gave the following output + abort:
>>
>> parent transid verify failed on 915444523008 wanted 16974 found 13021
>> Ignoring transid failure
>> btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
>> != key->objectid || rec->refs > 1)' failed.
>> id not match free space cache generation (1625)
>> free space inode generation (0) did not match free space cache
>> generation (1607)
>> free space inode generation (0) did not match free space cache
>> generation (1604)
>> free space inode generation (0) did not match free space cache
>> generation (1606)
>> free space inode generation (0) did not match free space cache
>> generation (1620)
>> free space inode generation (0) did not match free space cache
>> generation (1626)
>> free space inode generation (0) did not match free space cache
>> generation (1609)
>> free space inode generation (0) did not match free space cache
>> generation (1653)
>> free space inode generation (0) did not match free space cache
>> generation (1628)
>> free space inode generation (0) did not match free space cache
>> generation (1628)
>> free space inode generation (0) did not match free space cache
>> generation (1649)
>>
>>
>> (There was no syslog output.)
>>
>> Full btrfsck listing attached.
>>
>>
>> Suggestions please?
>>
>> Thanks,
>> Martin



--------------040209070200040604060301
Content-Type: text/x-log;
 name="btrfsck_repair_sdc.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfsck_repair_sdc.log"

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
leaf parent key incorrect 915432701952
bad block 915432701952
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
leaf parent key incorrect 915444678656
bad block 915444678656
leaf parent key incorrect 915444682752
bad block 915444682752
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
leaf parent key incorrect 915444973568
bad block 915444973568
leaf parent key incorrect 915444977664
bad block 915444977664
leaf parent key incorrect 915444981760
bad block 915444981760
parent transid verify failed on 915444973568 wanted 16974 found 13021
parent transid verify failed on 915444973568 wanted 16974 found 13021
parent transid verify failed on 915444977664 wanted 16974 found 13021
parent transid verify failed on 915444977664 wanted 16974 found 13021
parent transid verify failed on 915444981760 wanted 16974 found 13021
parent transid verify failed on 915444981760 wanted 16974 found 13021
parent transid verify failed on 915432701952 wanted 16974 found 16972
parent transid verify failed on 915432701952 wanted 16974 found 16972
parent transid verify failed on 915444678656 wanted 16974 found 13021
parent transid verify failed on 915444678656 wanted 16974 found 13021
parent transid verify failed on 915444682752 wanted 16974 found 13021
parent transid verify failed on 915444682752 wanted 16974 found 13021
deleting pointer to block 915432701952
owner ref check failed [907183771648 4096]
repair deleting extent record: key 907183771648 168 4096
btrfsck: extent-tree.c:2736: alloc_reserved_tree_block: Assertion `!(ret)' failed.
enabling repair mode
Checking filesystem on /dev/sdc
UUID: 38a60270-f9c6-4ed4-8421-4bf1253ae0b3

--------------040209070200040604060301--

