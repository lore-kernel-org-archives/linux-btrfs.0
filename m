Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38709 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbcC0Kfr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 06:35:47 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so68055168wml.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 03:35:46 -0700 (PDT)
Received: from [192.168.1.33] (221.red-83-52-6.dynamicip.rima-tde.net. [83.52.6.221])
        by smtp.gmail.com with ESMTPSA id y62sm5223232wmg.12.2016.03.27.03.35.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 27 Mar 2016 03:35:44 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Jose Otero <jose.manuel.otero@gmail.com>
Subject: Raid 0 setup doubt.
Message-ID: <56F7B77F.9050306@gmail.com>
Date: Sun, 27 Mar 2016 12:35:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

--------------------------------------
I apologize beforehand if I'm asking a too basic question for the
mailing list, or if it has been already answered at nauseam.
--------------------------------------

I have two hdd (Western Digital 750 GB approx. 700 GiB each), and I
planning to set up a RAID 0 through btrfs. UEFI firmware/boot, no dual
boot, only linux.

My question is, given the UEFI partition plus linux swap partition, I
won't have two equal sized partitions for setting up the RAID 0 array.
So, I'm not quite sure how to do it. I'll have:

/dev/sda:

       16 KiB (GPT partition table)
sda1:  512 MiB (EFI, fat32)
sda2:  16 GiB (linux-swap)
sda3:  rest of the disk /  (btrfs)

/dev/sdb:

sdb1:  (btrfs)

The btrfs partitions on each hdd are not of the same size (admittedly by
an small difference, but still). Even if a backup copy of the EFI
partition is created in the second hdd (i.e. sdb) which it may be, not
sure, because the linux-swap partion is still left out.

Should I stripe both btrfs partitions together no matter the size?

mkfs.btrfs -m raid0 -d raid0 /dev/sda3 /dev/sdb1

How will btrfs manage the difference in size?

Or should I partition out the extra size of /dev/sdb for trying to match
equally sized partions? in other words:

/dev/sdb:

sdb1:  17 GiB approx. free or for whatever I want.
sdb2:  (btrfs)

and then:

mkfs.btrfs -m raid0 -d raid0 /dev/sda3 /dev/sdb2

Again, I'm sorry if it's an idiotic question, but I don't have it quite
clear and I would like to do it properly. So, any hint from more
knowable users would be MUCH appreciate it.

Thanks in advance.

JM.
