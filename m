Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:34675
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab2IQUqK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 16:46:10 -0400
Date: Mon, 17 Sep 2012 13:38:56 -0700
From: Vladi Gergov <vladi@aresgate.net>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: btrfs raid1 degraded in need of chuck tree rebuild
Message-ID: <20120917203855.GA6930@gypsyops.denof.sin>
References: <20101029205340.GA10326@gypsyops.denof.sin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101029205340.GA10326@gypsyops.denof.sin>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Below is my original post about my fs. Just wondering if anyone knows if
I can at this point get my data back or cut my losses. Is an fsck cable
of getting this fixed close or has my 2 year wait been in vain. Thanks
in advance!

Excerpts from Vladi Gergov's message of 2010-10-29 16:53:42 -0400:
> >>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
> Password: 
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> [  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
> [  684.595150] btrfs: allowing degraded mounts
> [  684.595594] btrfs: failed to read chunk root on sdb
> [  684.604110] btrfs: open_ctree failed
> 
> >>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
> btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)'
> failed.

Ok, I dug through this and found the bug responsible for your
unmountable FS.  When we're mounted in degraded mode, and we don't have
enough drives available to do raid1,10, we're can use the wrong raid
level for new allocations.

I'm fixing the kernel side so this doesn't happen anymore, but I'll need
to rebuild the chunk tree (and probably a few others) off your good disk
to
fix things.

I've got it reproduced here though, so I'll make an fsck that can scan
for the correct trees and fix it for you.

Since you're basically going to be my first external fsck customer, is
there anyway you can do a raw device based backup of the blocks?  This
way if I do mess things up we can repeat the experiment.

-chris

-- 

,-| Vladi
`-| Gergov
