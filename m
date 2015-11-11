Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35606 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbbKKRa6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 12:30:58 -0500
Received: by qgec40 with SMTP id c40so28331196qge.2
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 09:30:57 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Nov 2015 11:30:57 -0600
Message-ID: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
Subject: Potential to loose data in case of disk failure
From: Jim Murphy <srlinuxadmin@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

What am I missing or misunderstanding?  I have a newly
purchased laptop I want/need to multi boot different OSs
on.  As a result after partitioning I have ended up with two
partitions on each of the two internal drives(sda3, sda8,
sdb3 and sdb8).  FWIW, sda3 and sdb3 are the same size
and sda8 and sdb8 are the same size.  As an end result
I want one btrfs raid1 filesystem.  For lack of better terms,
sda3 and sda8 "concatenated" together, sdb3 and sdb8
"concatenated" together and then mirroring "sda" to "sdb"
using only btrfs.  So far have found no use-case to cover
this.

If I create a raid1 btrfs volume using all 4 "devices" as I
understand it I would loose data if I were to loose a drive
because two mirror possibilities would be:

sda3 mirrored to sda8
sdb3 mirrored to sdb8

Is what I want to do possible without using MD-RAID and/or
LVM?  If so would someone point me to the documentation
I missed.  For whatever reason, I don't want to believe that
this can't be done.  I want to believe that the code in btrfs
is smart enough to know that sda3 and sda8 are on the same
drive and would not try to mirror data between them except in
a test setup.  I hope  I just missed some documentation,
somewhere.

Thanks in advance for your help.  And last but not least,
thanks to all for your work on btrfs.

Jim
