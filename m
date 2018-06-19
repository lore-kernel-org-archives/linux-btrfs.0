Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45727 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965615AbeFSNzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 09:55:52 -0400
Date: Tue, 19 Jun 2018 15:53:01 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: fix race between mkfs and mount
Message-ID: <20180619135301.GQ24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180604150030.12883-1-anand.jain@oracle.com>
 <20180604150030.12883-3-anand.jain@oracle.com>
 <20180607163931.GH3215@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180607163931.GH3215@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 06:39:32PM +0200, David Sterba wrote:
> On Mon, Jun 04, 2018 at 11:00:30PM +0800, Anand Jain wrote:
> > In an instrumented testing it is possible that the mount and
> > a newer mkfs.btrfs thread on the same device can race and if the new
> > mkfs.btrfs wins it will free the older fs_devices, then the mount thread
> > will lead to oops.
> > 
> > Thread1						Thread2
> > -------						-------
> > mkfs.btrfs -fq /dev/sdb
> > mount /dev/sdb /btrfs
> > |_btrfs_mount_root()
> >   |_btrfs_scan_one_device(... &fs_devices)
> > 
> > 						mkfs.btrfs -fq /dev/sdb
> > 						|_btrfs_contol_ioctl()
> > 						  |_btrfs_scan_one_device(... &fs_devices)
> > 						    |_::
> > 						      |_btrfs_free_stale_devices()
> > 
> >   |_btrfs_open_devices(fs_devices ..) <-- stale fs_devices.
> > 
> > Fix this with a mutually exclusive flag BTRFS_VOL_FLAG_EXCL_OPS.
> 
> I'm not sure this is the right way to fix it, adding another bit to the
> uuid_mutex and device_list_mutex combo.
> 
> To fix the race between mount and mkfs we can add a bit of logic to the
> device scanning so that mount calling scan will track the purpose and
> mkfs scan will not be allowed to free that device.

Last version of the proposed fix is to extend the uuid_mutex over the
whole mount callback and use it around calls to btrfs_scan_one_device.
That way we'll be sure the mount will always get to the device it
scanned and that will not be freed by the parallel scan.
