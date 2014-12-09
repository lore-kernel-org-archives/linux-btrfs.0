Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbaLIK13 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 05:27:29 -0500
Date: Tue, 9 Dec 2014 11:27:28 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Avoid to consider lvm snapshots when scanning
 devices.
Message-ID: <20141209102728.GA20595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
 <1417718382-6753-2-git-send-email-kreijack@inwind.it>
 <548506A3.3010409@cn.fujitsu.com>
 <5485BC81.5000906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5485BC81.5000906@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 08, 2014 at 03:58:09PM +0100, Goffredo Baroncelli wrote:
> In another patch set, I proposed a mount.btrfs helper which is
> in position to perform these analysis and to pick the "right"
> device (even with the user suggestion).
> 
> Today the lvm-snapshot and btrfs behave very poor: it is not
> predictable which device is pick (the original or the snapshot). 
> These patch *avoid* most problems skipping the snapshots, which
> to me seems a reasonable default.
> For the other case the user is still able to mount any disks
> [combination] passing them directly via command line (
> mount /dev/sdX -o device=/dev/sdY,device=/dev/sdz...  );

Beware that passing 'device' does not mean that btrfs will use that
device to assemble the filesystem. It only says to scan the device the
same way any preceding 'btrfs dev scan' would do.

super.c:
 822                 case Opt_device:
 823                         device_name = match_strdup(&args[0]);
 824                         if (!device_name) {
 825                                 error = -ENOMEM;
 826                                 goto out;
 827                         }
 828                         error = btrfs_scan_one_device(device_name,
 829                                         flags, holder, fs_devices);
 830                         kfree(device_name);
 831                         if (error)
 832                                 goto out;
 833                         break;

> Anyway I think for these kind of setup (btrfs on lvm-snapshot), 
> passing the disks explicitly is the only solution; [...]

... for which you'd need another mount option and update the code that
selects the devices accordingly.

