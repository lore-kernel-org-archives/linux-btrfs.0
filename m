Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55864 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3JCQ5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Oct 2013 12:57:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VRmD3-0007pK-Tm
	for linux-btrfs@vger.kernel.org; Thu, 03 Oct 2013 18:57:05 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 18:57:05 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 18:57:05 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Thu, 03 Oct 2013 17:56:54 +0100
Message-ID: <l2k7kd$1dh$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000801040308000201070404"
In-Reply-To: <l2ietn$jv1$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000801040308000201070404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/10/13 01:49, Martin wrote:

> Summary:
> 
> Mounting "-o recovery,noatime" worked well and allowed a diff check to
> complete for all but one directory tree. So very nearly all the data is
> fine.
> 
> Deleting the failed directory tree caused a call stack dump and eventually:
> 
> kernel: parent transid verify failed on 915444822016 wanted 16974 found
> 13021
> kernel: BTRFS info (device sdc): failed to delete reference to
> eggdrop-1.6.19.ebuild, inode 2096893 parent 5881667
> kernel: BTRFS error (device sdc) in __btrfs_unlink_inode:3662: errno=-5
> IO failure
> kernel: BTRFS info (device sdc): forced readonly
> 
> 
> Greater detail listed below.
> 
> What next best to try?
> 
> Safer to try again but this time with with "no_space_cache,no_inode_cache"?
> 
> Thanks,
> Martin


> Next best step to try?
> 
> Remount "-o recovery,noatime" again?


In the meantime, trying:

btrfsck /dev/sdc

gave the following output + abort:

parent transid verify failed on 915444523008 wanted 16974 found 13021
Ignoring transid failure
btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
!= key->objectid || rec->refs > 1)' failed.
id not match free space cache generation (1625)
free space inode generation (0) did not match free space cache
generation (1607)
free space inode generation (0) did not match free space cache
generation (1604)
free space inode generation (0) did not match free space cache
generation (1606)
free space inode generation (0) did not match free space cache
generation (1620)
free space inode generation (0) did not match free space cache
generation (1626)
free space inode generation (0) did not match free space cache
generation (1609)
free space inode generation (0) did not match free space cache
generation (1653)
free space inode generation (0) did not match free space cache
generation (1628)
free space inode generation (0) did not match free space cache
generation (1628)
free space inode generation (0) did not match free space cache
generation (1649)


(There was no syslog output.)

Full btrfsck listing attached.


Suggestions please?

Thanks,
Martin


--------------000801040308000201070404
Content-Type: text/x-log;
 name="btrfsck_sdc.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfsck_sdc.log"

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
owner ref check failed [907183771648 4096]
owner ref check failed [907183779840 4096]
owner ref check failed [907183882240 4096]
owner ref check failed [907185160192 4096]
owner ref check failed [907185201152 4096]
owner ref check failed [915432497152 4096]
owner ref check failed [915432509440 4096]
owner ref check failed [915432513536 4096]
owner ref check failed [915432529920 4096]
owner ref check failed [915432701952 4096]
owner ref check failed [915433058304 4096]
owner ref check failed [915437543424 4096]
owner ref check failed [915437563904 4096]
owner ref check failed [915444469760 4096]
owner ref check failed [915444473856 4096]
owner ref check failed [915444506624 4096]
owner ref check failed [915444518912 4096]
owner ref check failed [915444523008 4096]
owner ref check failed [915444527104 4096]
owner ref check failed [915444539392 4096]
owner ref check failed [915444543488 4096]
owner ref check failed [915444547584 4096]
owner ref check failed [915444551680 4096]
owner ref check failed [915444555776 4096]
owner ref check failed [915444559872 4096]
owner ref check failed [915444563968 4096]
owner ref check failed [915444572160 4096]
owner ref check failed [915444576256 4096]
owner ref check failed [915444580352 4096]
owner ref check failed [915444584448 4096]
owner ref check failed [915444588544 4096]
owner ref check failed [915444678656 4096]
owner ref check failed [915444682752 4096]
owner ref check failed [915444793344 4096]
owner ref check failed [915444797440 4096]
owner ref check failed [915444813824 4096]
owner ref check failed [915444817920 4096]
owner ref check failed [915444822016 4096]
owner ref check failed [915444826112 4096]
owner ref check failed [915444830208 4096]
owner ref check failed [915444834304 4096]
owner ref check failed [915444924416 4096]
owner ref check failed [915444973568 4096]
owner ref check failed [915444977664 4096]
owner ref check failed [915444981760 4096]
ref mismatch on [918767419392 4096] extent item 0, found 1
Backref 918767419392 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767419392 4096]
ref mismatch on [918767443968 4096] extent item 0, found 1
Backref 918767443968 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767443968 4096]
ref mismatch on [918767448064 4096] extent item 0, found 1
Backref 918767448064 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767448064 4096]
ref mismatch on [918767452160 4096] extent item 0, found 1
Backref 918767452160 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767452160 4096]
ref mismatch on [918767472640 4096] extent item 0, found 1
Backref 918767472640 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767472640 4096]
ref mismatch on [918767489024 4096] extent item 0, found 1
Backref 918767489024 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767489024 4096]
ref mismatch on [918767497216 4096] extent item 0, found 1
Backref 918767497216 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767497216 4096]
ref mismatch on [918767509504 4096] extent item 0, found 1
Backref 918767509504 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767509504 4096]
ref mismatch on [918767525888 4096] extent item 0, found 1
Backref 918767525888 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767525888 4096]
ref mismatch on [918767566848 4096] extent item 0, found 1
Backref 918767566848 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767566848 4096]
ref mismatch on [918767575040 4096] extent item 0, found 1
Backref 918767575040 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767575040 4096]
ref mismatch on [918767579136 4096] extent item 0, found 1
Backref 918767579136 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767579136 4096]
ref mismatch on [918767611904 4096] extent item 0, found 1
Backref 918767611904 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767611904 4096]
ref mismatch on [918767616000 4096] extent item 0, found 1
Backref 918767616000 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767616000 4096]
ref mismatch on [918767620096 4096] extent item 0, found 1
Backref 918767620096 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767620096 4096]
ref mismatch on [918767648768 4096] extent item 0, found 1
Backref 918767648768 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767648768 4096]
ref mismatch on [918767669248 4096] extent item 0, found 1
Backref 918767669248 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767669248 4096]
ref mismatch on [918767677440 4096] extent item 0, found 1
Backref 918767677440 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767677440 4096]
ref mismatch on [918767681536 4096] extent item 0, found 1
Backref 918767681536 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767681536 4096]
ref mismatch on [918767742976 4096] extent item 0, found 1
Backref 918767742976 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767742976 4096]
ref mismatch on [918767771648 4096] extent item 0, found 1
Backref 918767771648 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767771648 4096]
ref mismatch on [918767788032 4096] extent item 0, found 1
Backref 918767788032 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767788032 4096]
ref mismatch on [918767796224 4096] extent item 0, found 1
Backref 918767796224 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767796224 4096]
ref mismatch on [918767845376 4096] extent item 0, found 1
Backref 918767845376 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767845376 4096]
ref mismatch on [918767849472 4096] extent item 0, found 1
Backref 918767849472 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767849472 4096]
ref mismatch on [918767878144 4096] extent item 0, found 1
Backref 918767878144 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767878144 4096]
ref mismatch on [918767902720 4096] extent item 0, found 1
Backref 918767902720 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767902720 4096]
ref mismatch on [918767906816 4096] extent item 0, found 1
Backref 918767906816 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767906816 4096]
ref mismatch on [918767910912 4096] extent item 0, found 1
Backref 918767910912 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767910912 4096]
ref mismatch on [918767915008 4096] extent item 0, found 1
Backref 918767915008 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767915008 4096]
ref mismatch on [918767919104 4096] extent item 0, found 1
Backref 918767919104 parent 5 root 5 not found in extent tree
backpointer mismatch on [918767919104 4096]
ref mismatch on [921135570944 4096] extent item 0, found 1
Backref 921135570944 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135570944 4096]
ref mismatch on [921135575040 4096] extent item 0, found 1
Backref 921135575040 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135575040 4096]
ref mismatch on [921135579136 4096] extent item 0, found 1
Backref 921135579136 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135579136 4096]
ref mismatch on [921135587328 4096] extent item 0, found 1
Backref 921135587328 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135587328 4096]
ref mismatch on [921135591424 4096] extent item 0, found 1
Backref 921135591424 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135591424 4096]
ref mismatch on [921135595520 4096] extent item 0, found 1
Backref 921135595520 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135595520 4096]
ref mismatch on [921135599616 4096] extent item 0, found 1
Backref 921135599616 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135599616 4096]
ref mismatch on [921135603712 4096] extent item 0, found 1
Backref 921135603712 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135603712 4096]
ref mismatch on [921135607808 4096] extent item 0, found 1
Backref 921135607808 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135607808 4096]
ref mismatch on [921135611904 4096] extent item 0, found 1
Backref 921135611904 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135611904 4096]
ref mismatch on [921135616000 4096] extent item 0, found 1
Backref 921135616000 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135616000 4096]
ref mismatch on [921135620096 4096] extent item 0, found 1
Backref 921135620096 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135620096 4096]
ref mismatch on [921135624192 4096] extent item 0, found 1
Backref 921135624192 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135624192 4096]
ref mismatch on [921135628288 4096] extent item 0, found 1
Backref 921135628288 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135628288 4096]
ref mismatch on [921135632384 4096] extent item 0, found 1
Backref 921135632384 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135632384 4096]
ref mismatch on [921135636480 4096] extent item 0, found 1
Backref 921135636480 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135636480 4096]
ref mismatch on [921135640576 4096] extent item 0, found 1
Backref 921135640576 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135640576 4096]
ref mismatch on [921135644672 4096] extent item 0, found 1
Backref 921135644672 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135644672 4096]
ref mismatch on [921135648768 4096] extent item 0, found 1
Backref 921135648768 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135648768 4096]
ref mismatch on [921135652864 4096] extent item 0, found 1
Backref 921135652864 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135652864 4096]
ref mismatch on [921135656960 4096] extent item 0, found 1
Backref 921135656960 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135656960 4096]
ref mismatch on [921135661056 4096] extent item 0, found 1
Backref 921135661056 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135661056 4096]
ref mismatch on [921135665152 4096] extent item 0, found 1
Backref 921135665152 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135665152 4096]
ref mismatch on [921135669248 4096] extent item 0, found 1
Backref 921135669248 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135669248 4096]
ref mismatch on [921135673344 4096] extent item 0, found 1
Backref 921135673344 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135673344 4096]
ref mismatch on [921135677440 4096] extent item 0, found 1
Backref 921135677440 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135677440 4096]
ref mismatch on [921135681536 4096] extent item 0, found 1
Backref 921135681536 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135681536 4096]
ref mismatch on [921135685632 4096] extent item 0, found 1
Backref 921135685632 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135685632 4096]
ref mismatch on [921135689728 4096] extent item 0, found 1
Backref 921135689728 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135689728 4096]
ref mismatch on [921135693824 4096] extent item 0, found 1
Backref 921135693824 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135693824 4096]
ref mismatch on [921135697920 4096] extent item 0, found 1
Backref 921135697920 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135697920 4096]
ref mismatch on [921135702016 4096] extent item 0, found 1
Backref 921135702016 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135702016 4096]
ref mismatch on [921135706112 4096] extent item 0, found 1
Backref 921135706112 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135706112 4096]
ref mismatch on [921135710208 4096] extent item 0, found 1
Backref 921135710208 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135710208 4096]
ref mismatch on [921135714304 4096] extent item 0, found 1
Backref 921135714304 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135714304 4096]
ref mismatch on [921135718400 4096] extent item 0, found 1
Backref 921135718400 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135718400 4096]
ref mismatch on [921135726592 4096] extent item 0, found 1
Backref 921135726592 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135726592 4096]
ref mismatch on [921135837184 4096] extent item 0, found 1
Backref 921135837184 parent 2 root 2 not found in extent tree
backpointer mismatch on [921135837184 4096]
ref mismatch on [921135882240 4096] extent item 0, found 1
Backref 921135882240 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135882240 4096]
ref mismatch on [921135886336 4096] extent item 0, found 1
Backref 921135886336 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135886336 4096]
ref mismatch on [921135890432 4096] extent item 0, found 1
Backref 921135890432 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135890432 4096]
ref mismatch on [921135894528 4096] extent item 0, found 1
Backref 921135894528 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135894528 4096]
ref mismatch on [921135906816 4096] extent item 0, found 1
Backref 921135906816 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135906816 4096]
ref mismatch on [921135910912 4096] extent item 0, found 1
Backref 921135910912 parent 5 root 5 not found in extent tree
backpointer mismatch on [921135910912 4096]
ref mismatch on [921136025600 4096] extent item 0, found 1
Backref 921136025600 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136025600 4096]
ref mismatch on [921136029696 4096] extent item 0, found 1
Backref 921136029696 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136029696 4096]
ref mismatch on [921136037888 4096] extent item 0, found 1
Backref 921136037888 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136037888 4096]
ref mismatch on [921136078848 4096] extent item 0, found 1
Backref 921136078848 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136078848 4096]
ref mismatch on [921136123904 4096] extent item 0, found 1
Backref 921136123904 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136123904 4096]
ref mismatch on [921136160768 4096] extent item 0, found 1
Backref 921136160768 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136160768 4096]
ref mismatch on [921136168960 4096] extent item 0, found 1
Backref 921136168960 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136168960 4096]
ref mismatch on [921136205824 4096] extent item 0, found 1
Backref 921136205824 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136205824 4096]
ref mismatch on [921136214016 4096] extent item 0, found 1
Backref 921136214016 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136214016 4096]
ref mismatch on [921136242688 4096] extent item 0, found 1
Backref 921136242688 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136242688 4096]
ref mismatch on [921136250880 4096] extent item 0, found 1
Backref 921136250880 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136250880 4096]
ref mismatch on [921136259072 4096] extent item 0, found 1
Backref 921136259072 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136259072 4096]
ref mismatch on [921136263168 4096] extent item 0, found 1
Backref 921136263168 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136263168 4096]
ref mismatch on [921136287744 4096] extent item 0, found 1
Backref 921136287744 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136287744 4096]
ref mismatch on [921136300032 4096] extent item 0, found 1
Backref 921136300032 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136300032 4096]
ref mismatch on [921136304128 4096] extent item 0, found 1
Backref 921136304128 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136304128 4096]
ref mismatch on [921136308224 4096] extent item 0, found 1
Backref 921136308224 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136308224 4096]
ref mismatch on [921136312320 4096] extent item 0, found 1
Backref 921136312320 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136312320 4096]
ref mismatch on [921136316416 4096] extent item 0, found 1
Backref 921136316416 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136316416 4096]
ref mismatch on [921136320512 4096] extent item 0, found 1
Backref 921136320512 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136320512 4096]
ref mismatch on [921136332800 4096] extent item 0, found 1
Backref 921136332800 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136332800 4096]
ref mismatch on [921136336896 4096] extent item 0, found 1
Backref 921136336896 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136336896 4096]
ref mismatch on [921136340992 4096] extent item 0, found 1
Backref 921136340992 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136340992 4096]
ref mismatch on [921136345088 4096] extent item 0, found 1
Backref 921136345088 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136345088 4096]
ref mismatch on [921136349184 4096] extent item 0, found 1
Backref 921136349184 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136349184 4096]
ref mismatch on [921136353280 4096] extent item 0, found 1
Backref 921136353280 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136353280 4096]
ref mismatch on [921136357376 4096] extent item 0, found 1
Backref 921136357376 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136357376 4096]
ref mismatch on [921136369664 4096] extent item 0, found 1
Backref 921136369664 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136369664 4096]
ref mismatch on [921136398336 4096] extent item 0, found 1
Backref 921136398336 parent 5 root 5 not found in extent tree
backpointer mismatch on [921136398336 4096]
ref mismatch on [926297280512 4096] extent item 0, found 1
Backref 926297280512 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297280512 4096]
ref mismatch on [926297284608 4096] extent item 0, found 1
Backref 926297284608 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297284608 4096]
ref mismatch on [926297288704 4096] extent item 0, found 1
Backref 926297288704 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297288704 4096]
ref mismatch on [926297292800 4096] extent item 0, found 1
Backref 926297292800 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297292800 4096]
ref mismatch on [926297305088 4096] extent item 0, found 1
Backref 926297305088 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297305088 4096]
ref mismatch on [926297341952 4096] extent item 0, found 1
Backref 926297341952 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297341952 4096]
ref mismatch on [926297382912 4096] extent item 0, found 1
Backref 926297382912 parent 2 root 2 not found in extent tree
backpointer mismatch on [926297382912 4096]
ref mismatch on [926297399296 4096] extent item 0, found 1
Backref 926297399296 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297399296 4096]
ref mismatch on [926297415680 4096] extent item 0, found 1
Backref 926297415680 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297415680 4096]
ref mismatch on [926297423872 4096] extent item 0, found 1
Backref 926297423872 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297423872 4096]
ref mismatch on [926297468928 4096] extent item 0, found 1
Backref 926297468928 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297468928 4096]
ref mismatch on [926297481216 4096] extent item 0, found 1
Backref 926297481216 parent 2 root 2 not found in extent tree
backpointer mismatch on [926297481216 4096]
ref mismatch on [926297526272 4096] extent item 0, found 1
Backref 926297526272 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297526272 4096]
ref mismatch on [926297530368 4096] extent item 0, found 1
Backref 926297530368 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297530368 4096]
ref mismatch on [926297542656 4096] extent item 0, found 1
Backref 926297542656 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297542656 4096]
ref mismatch on [926297575424 4096] extent item 0, found 1
Backref 926297575424 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297575424 4096]
ref mismatch on [926297600000 4096] extent item 0, found 1
Backref 926297600000 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297600000 4096]
ref mismatch on [926297604096 4096] extent item 0, found 1
Backref 926297604096 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297604096 4096]
ref mismatch on [926297608192 4096] extent item 0, found 1
Backref 926297608192 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297608192 4096]
ref mismatch on [926297616384 4096] extent item 0, found 1
Backref 926297616384 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297616384 4096]
ref mismatch on [926297665536 4096] extent item 0, found 1
Backref 926297665536 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297665536 4096]
ref mismatch on [926297686016 4096] extent item 0, found 1
Backref 926297686016 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297686016 4096]
ref mismatch on [926297735168 4096] extent item 0, found 1
Backref 926297735168 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297735168 4096]
ref mismatch on [926297743360 4096] extent item 0, found 1
Backref 926297743360 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297743360 4096]
ref mismatch on [926297800704 4096] extent item 0, found 1
Backref 926297800704 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297800704 4096]
ref mismatch on [926297841664 4096] extent item 0, found 1
Backref 926297841664 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297841664 4096]
ref mismatch on [926297866240 4096] extent item 0, found 1
Backref 926297866240 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297866240 4096]
ref mismatch on [926297915392 4096] extent item 0, found 1
Backref 926297915392 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297915392 4096]
ref mismatch on [926297919488 4096] extent item 0, found 1
Backref 926297919488 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297919488 4096]
ref mismatch on [926297944064 4096] extent item 0, found 1
Backref 926297944064 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297944064 4096]
ref mismatch on [926297976832 4096] extent item 0, found 1
Backref 926297976832 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297976832 4096]
ref mismatch on [926297980928 4096] extent item 0, found 1
Backref 926297980928 parent 5 root 5 not found in extent tree
backpointer mismatch on [926297980928 4096]
ref mismatch on [926298050560 4096] extent item 0, found 1
Backref 926298050560 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298050560 4096]
ref mismatch on [926298087424 4096] extent item 0, found 1
Backref 926298087424 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298087424 4096]
ref mismatch on [926298296320 4096] extent item 0, found 1
Backref 926298296320 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298296320 4096]
ref mismatch on [926298378240 4096] extent item 0, found 1
Backref 926298378240 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298378240 4096]
ref mismatch on [926298411008 4096] extent item 0, found 1
Backref 926298411008 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298411008 4096]
ref mismatch on [926298423296 4096] extent item 0, found 1
Backref 926298423296 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298423296 4096]
ref mismatch on [926298521600 4096] extent item 0, found 1
Backref 926298521600 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298521600 4096]
ref mismatch on [926298562560 4096] extent item 0, found 1
Backref 926298562560 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298562560 4096]
ref mismatch on [926298566656 4096] extent item 0, found 1
Backref 926298566656 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298566656 4096]
ref mismatch on [926298570752 4096] extent item 0, found 1
Backref 926298570752 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298570752 4096]
ref mismatch on [926298632192 4096] extent item 0, found 1
Backref 926298632192 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298632192 4096]
ref mismatch on [926298636288 4096] extent item 0, found 1
Backref 926298636288 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298636288 4096]
ref mismatch on [926298734592 4096] extent item 0, found 1
Backref 926298734592 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298734592 4096]
ref mismatch on [926298738688 4096] extent item 0, found 1
Backref 926298738688 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298738688 4096]
ref mismatch on [926298763264 4096] extent item 0, found 1
Backref 926298763264 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298763264 4096]
ref mismatch on [926298836992 4096] extent item 0, found 1
Backref 926298836992 parent 5 root 5 not found in extent tree
backpointer mismatch on [926298836992 4096]
ref mismatch on [934315782144 4096] extent item 0, found 1
Backref 934315782144 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315782144 4096]
ref mismatch on [934315786240 4096] extent item 0, found 1
Backref 934315786240 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315786240 4096]
ref mismatch on [934315790336 4096] extent item 0, found 1
Backref 934315790336 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315790336 4096]
ref mismatch on [934315794432 4096] extent item 0, found 1
Backref 934315794432 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315794432 4096]
ref mismatch on [934315810816 4096] extent item 0, found 1
Backref 934315810816 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315810816 4096]
ref mismatch on [934315814912 4096] extent item 0, found 1
Backref 934315814912 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315814912 4096]
ref mismatch on [934315823104 4096] extent item 0, found 1
Backref 934315823104 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315823104 4096]
ref mismatch on [934315827200 4096] extent item 0, found 1
Backref 934315827200 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315827200 4096]
ref mismatch on [934315831296 4096] extent item 0, found 1
Backref 934315831296 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315831296 4096]
ref mismatch on [934315835392 4096] extent item 0, found 1
Backref 934315835392 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315835392 4096]
ref mismatch on [934315839488 4096] extent item 0, found 1
Backref 934315839488 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315839488 4096]
ref mismatch on [934315843584 4096] extent item 0, found 1
Backref 934315843584 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315843584 4096]
ref mismatch on [934315855872 4096] extent item 0, found 1
Backref 934315855872 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315855872 4096]
ref mismatch on [934315859968 4096] extent item 0, found 1
Backref 934315859968 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315859968 4096]
ref mismatch on [934315864064 4096] extent item 0, found 1
Backref 934315864064 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315864064 4096]
ref mismatch on [934315868160 4096] extent item 0, found 1
Backref 934315868160 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315868160 4096]
ref mismatch on [934315872256 4096] extent item 0, found 1
Backref 934315872256 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315872256 4096]
ref mismatch on [934315880448 4096] extent item 0, found 1
Backref 934315880448 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315880448 4096]
ref mismatch on [934315884544 4096] extent item 0, found 1
Backref 934315884544 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315884544 4096]
ref mismatch on [934315888640 4096] extent item 0, found 1
Backref 934315888640 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315888640 4096]
ref mismatch on [934315913216 4096] extent item 0, found 1
Backref 934315913216 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315913216 4096]
ref mismatch on [934315917312 4096] extent item 0, found 1
Backref 934315917312 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315917312 4096]
ref mismatch on [934315921408 4096] extent item 0, found 1
Backref 934315921408 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315921408 4096]
ref mismatch on [934315925504 4096] extent item 0, found 1
Backref 934315925504 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315925504 4096]
ref mismatch on [934315937792 4096] extent item 0, found 1
Backref 934315937792 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315937792 4096]
ref mismatch on [934315954176 4096] extent item 0, found 1
Backref 934315954176 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315954176 4096]
ref mismatch on [934315962368 4096] extent item 0, found 1
Backref 934315962368 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315962368 4096]
ref mismatch on [934315974656 4096] extent item 0, found 1
Backref 934315974656 parent 5 root 5 not found in extent tree
backpointer mismatch on [934315974656 4096]
ref mismatch on [934316003328 4096] extent item 0, found 1
Backref 934316003328 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316003328 4096]
ref mismatch on [934316007424 4096] extent item 0, found 1
Backref 934316007424 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316007424 4096]
ref mismatch on [934316011520 4096] extent item 0, found 1
Backref 934316011520 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316011520 4096]
ref mismatch on [934316019712 4096] extent item 0, found 1
Backref 934316019712 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316019712 4096]
ref mismatch on [934316032000 4096] extent item 0, found 1
Backref 934316032000 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316032000 4096]
ref mismatch on [1448539918336 16384] extent item 1, found 0
Incorrect local backref count on 1448539918336 root 5 owner 1846729 offset 0 found 0 wanted 1 back 0x7d8f6aa0
Backref disk bytenr does not match extent record, bytenr=1448539918336, ref bytenr=12105675801913647264
backpointer mismatch on [1448539918336 16384]
owner ref check failed [1448539918336 16384]
ref mismatch on [1454133108736 16384] extent item 1, found 0
Incorrect local backref count on 1454133108736 root 5 owner 2096890 offset 0 found 0 wanted 1 back 0x5ec25860
Backref disk bytenr does not match extent record, bytenr=1454133108736, ref bytenr=272
backpointer mismatch on [1454133108736 16384]
owner ref check failed [1454133108736 16384]
Errors found in extent allocation tree or chunk allocation
checking free space cache
Checking filesystem on /dev/sdc
UUID: 38a60270-f9c6-4ed4-8421-4bf1253ae0b3
free space inode generation (0) did not match free space cache generation (505)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (484)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (484)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (484)
free space inode generation (0) did not match free space cache generation (516)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (487)
free space inode generation (0) did not match free space cache generation (486)
free space inode generation (0) did not match free space cache generation (501)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (498)
free space inode generation (0) did not match free space cache generation (498)
free space inode generation (0) did not match free space cache generation (484)
free space inode generation (0) did not match free space cache generation (532)
free space inode generation (0) did not match free space cache generation (502)
free space inode generation (0) did not match free space cache generation (532)
free space inode generation (0) did not match free space cache generation (502)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (304)
free space inode generation (0) did not match free space cache generation (313)
free space inode generation (0) did not match free space cache generation (312)
free space inode generation (0) did not match free space cache generation (315)
free space inode generation (0) did not match free space cache generation (315)
free space inode generation (0) did not match free space cache generation (320)
free space inode generation (0) did not match free space cache generation (317)
free space inode generation (0) did not match free space cache generation (364)
free space inode generation (0) did not match free space cache generation (370)
free space inode generation (0) did not match free space cache generation (376)
free space inode generation (0) did not match free space cache generation (370)
free space inode generation (0) did not match free space cache generation (342)
free space inode generation (0) did not match free space cache generation (370)
free space inode generation (0) did not match free space cache generation (342)
free space inode generation (0) did not match free space cache generation (342)
free space inode generation (0) did not match free space cache generation (343)
free space inode generation (0) did not match free space cache generation (342)
free space inode generation (0) did not match free space cache generation (370)
free space inode generation (0) did not match free space cache generation (370)
free space inode generation (0) did not match free space cache generation (396)
free space inode generation (0) did not match free space cache generation (342)
free space inode generation (0) did not match free space cache generation (400)
free space inode generation (0) did not match free space cache generation (399)
free space inode generation (0) did not match free space cache generation (351)
free space inode generation (0) did not match free space cache generation (381)
free space inode generation (0) did not match free space cache generation (378)
free space inode generation (0) did not match free space cache generation (402)
free space inode generation (0) did not match free space cache generation (373)
free space inode generation (0) did not match free space cache generation (377)
free space inode generation (0) did not match free space cache generation (380)
free space inode generation (0) did not match free space cache generation (380)
free space inode generation (0) did not match free space cache generation (380)
free space inode generation (0) did not match free space cache generation (379)
free space inode generation (0) did not match free space cache generation (380)
free space inode generation (0) did not match free space cache generation (380)
free space inode generation (0) did not match free space cache generation (409)
free space inode generation (0) did not match free space cache generation (398)
free space inode generation (0) did not match free space cache generation (398)
free space inode generation (0) did not match free space cache generation (409)
free space inode generation (0) did not match free space cache generation (414)
free space inode generation (0) did not match free space cache generation (420)
free space inode generation (0) did not match free space cache generation (428)
free space inode generation (0) did not match free space cache generation (420)
free space inode generation (0) did not match free space cache generation (409)
free space inode generation (0) did not match free space cache generation (432)
free space inode generation (0) did not match free space cache generation (432)
free space inode generation (0) did not match free space cache generation (394)
free space inode generation (0) did not match free space cache generation (447)
free space inode generation (0) did not match free space cache generation (457)
free space inode generation (0) did not match free space cache generation (458)
free space inode generation (0) did not match free space cache generation (417)
free space inode generation (0) did not match free space cache generation (407)
free space inode generation (0) did not match free space cache generation (459)
free space inode generation (0) did not match free space cache generation (468)
free space inode generation (0) did not match free space cache generation (542)
free space inode generation (0) did not match free space cache generation (465)
free space inode generation (0) did not match free space cache generation (514)
free space inode generation (0) did not match free space cache generation (568)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (519)
free space inode generation (0) did not match free space cache generation (532)
free space inode generation (0) did not match free space cache generation (525)
free space inode generation (0) did not match free space cache generation (457)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (569)
free space inode generation (0) did not match free space cache generation (461)
free space inode generation (0) did not match free space cache generation (612)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (505)
free space inode generation (0) did not match free space cache generation (502)
free space inode generation (0) did not match free space cache generation (532)
free space inode generation (0) did not match free space cache generation (569)
free space inode generation (0) did not match free space cache generation (542)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (532)
free space inode generation (0) did not match free space cache generation (539)
free space inode generation (0) did not match free space cache generation (567)
free space inode generation (0) did not match free space cache generation (540)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (484)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (519)
free space inode generation (0) did not match free space cache generation (539)
free space inode generation (0) did not match free space cache generation (613)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (482)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (502)
free space inode generation (0) did not match free space cache generation (505)
free space inode generation (0) did not match free space cache generation (531)
free space inode generation (0) did not match free space cache generation (503)
free space inode generation (0) did not match free space cache generation (502)
free space inode generation (0) did not match free space cache generation (502)
free space inode generation (0) did not match free space cache generation (541)
free space inode generation (0) did not match free space cache generation (539)
free space inode generation (0) did not match free space cache generation (532)
free space inode generation (0) did not match free space cache generation (539)
free space inode generation (0) did not match free space cache generation (615)
free space inode generation (0) did not match free space cache generation (624)
free space inode generation (0) did not match free space cache generation (630)
free space inode generation (0) did not match free space cache generation (568)
free space inode generation (0) did not match free space cache generation (567)
free space inode generation (0) did not match free space cache generation (567)
free space inode generation (0) did not match free space cache generation (613)
free space inode generation (0) did not match free space cache generation (614)
free space inode generation (0) did not match free space cache generation (614)
free space inode generation (0) did not match free space cache generation (606)
free space inode generation (0) did not match free space cache generation (605)
free space inode generation (0) did not match free space cache generation (605)
free space inode generation (0) did not match free space cache generation (606)
free space inode generation (0) did not match free space cache generation (606)
free space inode generation (0) did not match free space cache generation (607)
free space inode generation (0) did not match free space cache generation (621)
free space inode generation (0) did not match free space cache generation (631)
free space inode generation (0) did not match free space cache generation (626)
free space inode generation (0) did not match free space cache generation (647)
free space inode generation (0) did not match free space cache generation (659)
free space inode generation (0) did not match free space cache generation (661)
free space inode generation (0) did not match free space cache generation (660)
free space inode generation (0) did not match free space cache generation (665)
free space inode generation (0) did not match free space cache generation (673)
free space inode generation (0) did not match free space cache generation (680)
free space inode generation (0) did not match free space cache generation (689)
free space inode generation (0) did not match free space cache generation (693)
free space inode generation (0) did not match free space cache generation (702)
free space inode generation (0) did not match free space cache generation (716)
free space inode generation (0) did not match free space cache generation (717)
free space inode generation (0) did not match free space cache generation (720)
free space inode generation (0) did not match free space cache generation (727)
free space inode generation (0) did not match free space cache generation (739)
free space inode generation (0) did not match free space cache generation (744)
free space inode generation (0) did not match free space cache generation (759)
free space inode generation (0) did not match free space cache generation (762)
free space inode generation (0) did not match free space cache generation (770)
free space inode generation (0) did not match free space cache generation (780)
free space inode generation (0) did not match free space cache generation (786)
free space inode generation (0) did not match free space cache generation (787)
free space inode generation (0) did not match free space cache generation (807)
free space inode generation (0) did not match free space cache generation (808)
free space inode generation (0) did not match free space cache generation (816)
free space inode generation (0) did not match free space cache generation (821)
free space inode generation (0) did not match free space cache generation (819)
free space inode generation (0) did not match free space cache generation (817)
free space inode generation (0) did not match free space cache generation (824)
free space inode generation (0) did not match free space cache generation (854)
free space inode generation (0) did not match free space cache generation (843)
free space inode generation (0) did not match free space cache generation (852)
free space inode generation (0) did not match free space cache generation (846)
free space inode generation (0) did not match free space cache generation (852)
free space inode generation (0) did not match free space cache generation (861)
free space inode generation (0) did not match free space cache generation (883)
free space inode generation (0) did not match free space cache generation (873)
free space inode generation (0) did not match free space cache generation (879)
free space inode generation (0) did not match free space cache generation (884)
free space inode generation (0) did not match free space cache generation (890)
free space inode generation (0) did not match free space cache generation (928)
free space inode generation (0) did not match free space cache generation (916)
free space inode generation (0) did not match free space cache generation (929)
free space inode generation (0) did not match free space cache generation (931)
free space inode generation (0) did not match free space cache generation (934)
free space inode generation (0) did not match free space cache generation (937)
free space inode generation (0) did not match free space cache generation (949)
free space inode generation (0) did not match free space cache generation (945)
free space inode generation (0) did not match free space cache generation (956)
free space inode generation (0) did not match free space cache generation (960)
free space inode generation (0) did not match free space cache generation (971)
free space inode generation (0) did not match free space cache generation (983)
free space inode generation (0) did not match free space cache generation (996)
free space inode generation (0) did not match free space cache generation (1014)
free space inode generation (0) did not match free space cache generation (1150)
free space inode generation (0) did not match free space cache generation (1146)
free space inode generation (0) did not match free space cache generation (1149)
free space inode generation (0) did not match free space cache generation (1077)
free space inode generation (0) did not match free space cache generation (1093)
free space inode generation (0) did not match free space cache generation (1106)
free space inode generation (0) did not match free space cache generation (1118)
free space inode generation (0) did not match free space cache generation (1126)
free space inode generation (0) did not match free space cache generation (1137)
free space inode generation (0) did not match free space cache generation (1151)
free space inode generation (0) did not match free space cache generation (1152)
free space inode generation (0) did not match free space cache generation (1163)
free space inode generation (0) did not match free space cache generation (1181)
free space inode generation (0) did not match free space cache generation (1193)
free space inode generation (0) did not match free space cache generation (1221)
free space inode generation (0) did not match free space cache generation (1240)
free space inode generation (0) did not match free space cache generation (1238)
free space inode generation (0) did not match free space cache generation (1295)
free space inode generation (0) did not match free space cache generation (1298)
free space inode generation (0) did not match free space cache generation (1296)
free space inode generation (0) did not match free space cache generation (1337)
free space inode generation (0) did not match free space cache generation (1335)
free space inode generation (0) did not match free space cache generation (1341)
free space inode generation (0) did not match free space cache generation (1350)
free space inode generation (0) did not match free space cache generation (1354)
free space inode generation (0) did not match free space cache generation (1376)
free space inode generation (0) did not match free space cache generation (1396)
free space inode generation (0) did not match free space cache generation (1397)
free space inode generation (0) did not match free space cache generation (1403)
free space inode generation (0) did not match free space cache generation (1413)
free space inode generation (0) did not match free space cache generation (1426)
free space inode generation (0) did not match free space cache generation (1425)
free space inode generation (0) did not match free space cache generation (1445)
free space inode generation (0) did not match free space cache generation (1454)
free space inode generation (0) did not match free space cache generation (1474)
free space inode generation (0) did not match free space cache generation (1479)
free space inode generation (0) did not match free space cache generation (1479)
free space inode generation (0) did not match free space cache generation (1542)
free space inode generation (0) did not match free space cache generation (1588)
free space inode generation (0) did not match free space cache generation (1593)
free space inode generation (0) did not match free space cache generation (1594)
free space inode generation (0) did not match free space cache generation (1601)
free space inode generation (0) did not match free space cache generation (1598)
free space inode generation (0) did not match free space cache generation (1607)
free space inode generation (0) did not match free space cache generation (1599)
free space inode generation (0) did not match free space cache generation (1612)
free space inode generation (0) did not match free space cache generation (1612)
free space inode generation (0) did not match free space cache generation (1612)
free space inode generation (0) did not match free space cache generation (1613)
free space inode generation (0) did not match free space cache generation (1599)
free space inode generation (0) did not match free space cache generation (1606)
free space inode generation (0) dparent transid verify failed on 915444973568 wanted 16974 found 13021
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
checking fs roots
parent transid verify failed on 915444523008 wanted 16974 found 13021
parent transid verify failed on 915444523008 wanted 16974 found 13021
parent transid verify failed on 915444523008 wanted 16974 found 13021
parent transid verify failed on 915444523008 wanted 16974 found 13021
Ignoring transid failure
btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino != key->objectid || rec->refs > 1)' failed.
id not match free space cache generation (1625)
free space inode generation (0) did not match free space cache generation (1607)
free space inode generation (0) did not match free space cache generation (1604)
free space inode generation (0) did not match free space cache generation (1606)
free space inode generation (0) did not match free space cache generation (1620)
free space inode generation (0) did not match free space cache generation (1626)
free space inode generation (0) did not match free space cache generation (1609)
free space inode generation (0) did not match free space cache generation (1653)
free space inode generation (0) did not match free space cache generation (1628)
free space inode generation (0) did not match free space cache generation (1628)
free space inode generation (0) did not match free space cache generation (1649)

--------------000801040308000201070404--

