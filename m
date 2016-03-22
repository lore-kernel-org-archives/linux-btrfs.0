Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43893 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbcCVID6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 04:03:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiHIC-0001AK-9j
	for linux-btrfs@vger.kernel.org; Tue, 22 Mar 2016 09:03:56 +0100
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 09:03:56 +0100
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 09:03:56 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: csum errors in VirtualBox VDI files
Date: Tue, 22 Mar 2016 09:03:42 +0100
Message-ID: <20160322090342.595fefac@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

Since one of the last kernel updates (I don't know which exactly), I'm
experiencing csum errors within VDI files when running VirtualBox. A
side effect of this is, as soon as dmesg shows these errors, commands
like "du" and "df" hang until reboot.

I've now restored the file from backup but it happens over and over
again.

On another machine I'm also seeing errors with big files in the
following scenario (apparently an older kernel, 4.1.x I afair):

# ntfsclone --save /dev/md126p2 -o rescue.ntfs.img
                   ^ big NTFS partition   ^ file on btrfs

results in a write error and the file system goes read-only.

Both systems have in common they are using btrfs on bcache with
compress=lzo,autodefrag,nossd,discard (mraid=1,draid=0 and
mraid=1,draid=single).

The system mentioned first is running Kernel 4.5.0 with Gentoo
patch-set. I upgraded from the last 4.4.x kernel when I first
experienced this problem. The first time the problem resulted in a
duplicate extent which btrfsck wasn't able to fix, that's when I first
restored from backup. But now I'm getting csum errors in this file over
a over again, plus when rsync has run for backup, the system no longer
responds to "du" and "df" commands - it just hangs.

Known problem? Does it help if I send debug info? If so, please
instruct.

-- 
Regards,
Kai

Replies to list-only preferred.

