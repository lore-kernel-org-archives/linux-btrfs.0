Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53565 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3CCRmn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 12:42:43 -0500
Received: by mail-vc0-f169.google.com with SMTP id n10so2926172vcn.14
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 09:42:42 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 3 Mar 2013 11:42:42 -0600
Message-ID: <CAKZbza-1ypztCV+EjN051EfJOgzTGBF2qMoEDcjkXyrjNeenkQ@mail.gmail.com>
Subject: Unable To Resize btrfs Partition
From: Miles McLean <mills00013@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to shrink a btrfs partition I have. Using latest gparted
live, gparted will fail during the fsck of the drive. The output has
something similar to "root 338 inode 7861227 errors 1000" and "found
46242054144 bytes used err is 1". I can run "btrfsck --repair" on the
device and the output changes to "...used err is 0" but then btrfsck
still says the same thing. I've tried to manually resize using parted,
but, of course, parted does not yet support btrfs.

I can resize the filesystem using the btrfs filesystem resize command
successfully but the partition itself won't change obviously when I do
this which makes it irrelevant.

Can anyone advise on next steps? Thanks!
