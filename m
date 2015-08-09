Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34327 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbbHIM3y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Aug 2015 08:29:54 -0400
Received: by qgeg42 with SMTP id g42so65464857qge.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2015 05:29:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 9 Aug 2015 14:29:53 +0200
Message-ID: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
Subject: raid1 on uneven-sized disks
From: Jim MacBaine <jmacbaine@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

How does btrfs handle raid1 on a bunch of uneven sized disks? Can I
just keep adding arbitrarily sized disks to an existing raid1 and
expect the file system to continue to keep two copies of everything,
so I could survive the loss of any single disk without data loss? Does
btrfs work this way?

For backing up several machines at home, I use an old Debian machine
which is equipped with some spare disks I could get my hands on.
Currently that would be 2 x 2TB, 1 x 1.5TB , 3 x 1TB disks.

Traditionally I'm using rsync to create hardlinked backups on ext3/4
on md-raid1. This setup has been working reliably for many years now,
including the survival of two disk failures. But it is quite
cumbersome to reshape the structure of the raids when I get a new
disk, an old one fails, or space requirements change. A single btrfs
with snapshots would be much easier to handle. I'm not aiming for
absolute reliability here -- all the really important stuff is backed
up in a third place as well. But I would rather not like my file
system to be the weakest link in the backup chain.

Regards,
Jim
