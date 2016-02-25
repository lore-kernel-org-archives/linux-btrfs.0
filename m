Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38148 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052AbcBYRkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 12:40:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aYztU-00058N-3z
	for linux-btrfs@vger.kernel.org; Thu, 25 Feb 2016 18:40:04 +0100
Received: from 152.96.212.109 ([152.96.212.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 18:40:04 +0100
Received: from rhegner by 152.96.212.109 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 18:40:04 +0100
To: linux-btrfs@vger.kernel.org
From: Hegner Robert <rhegner@hsr.ch>
Subject: btrfs raid1 filesystem on sdcard corrupted
Date: Thu, 25 Feb 2016 18:34:51 +0100
Message-ID: <nandur$4li$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

I'm working on a embedded system (ARM) running from a SDcard. Recently I 
switched to a btrfs-raid1 configuration, hoping to make my system more 
resistant against power failures and flash-memory specific problems.

However today one of my devices wouldn't mount my root filesystem as rw 
anymore.

The main reason I'm asking in this mailing list is not that I want to 
restory data. But I'd like to understand what happened and, even more 
importantly, find out what I have to do so that something like this will 
never happen again.

Here is some info about my system:

root@ObserverOne:~# uname -a
Linux ObserverOne 3.16.0-4-armmp #1 SMP Debian 3.16.7-ckt11-1+deb8u6 
(2015-11-09) armv7l GNU/Linux

root@ObserverOne:~# btrfs --version
Btrfs v3.17

root@ObserverOne:~# btrfs fi show
Label: none  uuid: eef07fbf-77cb-427a-b118-bf5295f25b66
         Total devices 2 FS bytes used 816.80MiB
         devid    1 size 3.45GiB used 3.02GiB path /dev/mmcblk0p2
         devid    2 size 3.45GiB used 3.02GiB path /dev/mmcblk0p3

parent transid verify failed on 4173889536 wanted 804 found 218
parent transid verify failed on 4173889536 wanted 804 found 218
parent transid verify failed on 4173889536 wanted 804 found 218
parent transid verify failed on 4173889536 wanted 804 found 218
Ignoring transid failure
Couldn't setup extent tree
Couldn't setup device tree
Btrfs v3.17

root@ObserverOne:~# btrfs fi df /
Data, RAID1: total=2.48GiB, used=788.41MiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=512.00MiB, used=28.38MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

You can also find the output of dmesg in the attachment.

How would you proceed in investigating this problem? Or do you already 
see a problem in the dmesg output? (I'm not a very experienced linux user).

Best regards
Robert

