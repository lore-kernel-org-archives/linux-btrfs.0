Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34732 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdDAF6g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 01:58:36 -0400
Received: by mail-pf0-f193.google.com with SMTP id o126so3295467pfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 22:58:35 -0700 (PDT)
Received: from crass-Ideapad-Z570 ([2602:306:358f:6080::41])
        by smtp.gmail.com with ESMTPSA id p189sm13632860pfb.128.2017.03.31.22.58.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Mar 2017 22:58:34 -0700 (PDT)
Date: Sat, 1 Apr 2017 00:58:19 -0500
From: Glenn Washburn <development@efficientek.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: force btrfs to release underlying block device(s)
Message-ID: <20170401005819.46dd9442@crass-Ideapad-Z570>
Reply-To: development@efficientek.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've run into a frustrating problem with a btrfs volume just now.  I
have a USB drive which has many partitions, two of which are luks
encrypted, which can be unlocked as a single, multi-device btrfs
volume.  For some reason the drive logically disconnected at the USB
protocol level, but not physically.  Then it reconnected.  This caused
the mount point to be removed at the vfs layer, however I could not
close the luks devices.

When looking in /sys/fs/btrfs, I see a directory with the UUID of the
offending volume, which shows the luks devices under the devices
directory.  So I presume the btrfs module is still holding references
to the block devices, not allowing them to be closed.  I know I can do
a "dmsetup remove --force" to force closing the luks devices, but I
doubt that will cause the btrfs module to release the offending block
devices.  So if I do that and then open the luks devices again and try
to remount the btrfs volume, I'm guessing insanity will ensue.

I can't unload/reload the btrfs module because the root fs among others
are using it.  Obviously, I can reboot, but that's a windows solution.
Anyone have a solution to this issue?  Is anyone looking into ways to
prevent this from happening?  I think this situation should be trivial
to reproduce.

Any help would be welcome,
Glenn

PS. I'm on a 4.10 kernel
