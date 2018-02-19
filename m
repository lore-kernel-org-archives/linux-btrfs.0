Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56321 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbeBSQzT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 11:55:19 -0500
Date: Mon, 19 Feb 2018 17:53:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: delete function btrfs_close_extra_devices()
Message-ID: <20180219165300.GL10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180215050224.21158-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180215050224.21158-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 01:02:24PM +0800, Anand Jain wrote:
> btrfs_close_extra_devices() is not exactly about just closing the opened
> devices, but its also about free-ing the stale devices which may have
> scanned into the btrfs_fs_devices::dev_list. The way it picks devices to
> be freed is by going through the btrfs_fs_devices::dev_list and its seed
> devices, and finding for devices which do not have the flag
> BTRFS_DEV_STATE_IN_FS_METADATA nor if it is part of the replace target.
> 
> However, in the first place the way devices are scanned and added to the
> btrfs_fs_devices::dev_list have changed for a long time now. During scan
> when it finds matching fsid+uuid+devid it would add the device to
> btrfs_fs_devices::dev_list. A matched device with higher generation number
> overwrites the device with lower generation number during.
> 
> Further, the stale devices containing the stale fsid are removed at the
> time of the scan itself.
> 
> So there isn't any opportunity that btrfs_close_extra_devices() can free
> the stale device within the fsid which is being mounted.
> 
> Further about the btrfs_fs_devices::latest_bdev that
> the btrfs_close_extra_devices() function assigns, is already assigned by
> the function __btrfs_open_devices().
> 
> So as this function has no effect, delete it.

I think this is correct. Freeing stale devices as a side effect of mount
does not seem right anyway. I'm still not able to convince myself that
there's not an unexpected interaction of dev scan and dev replace, as
it relies on the state bits and other locks. If you have ideas were to
put some asserts or extra checks, please suggest.

I found only one place where an assert could go:

> -	/*
> -	 * keep the device that is marked to be the target device for the
> -	 * dev_replace procedure
> -	 */
> -	btrfs_close_extra_devices(fs_devices, 0);
> -
> -	if (!fs_devices->latest_bdev) {
> -		btrfs_err(fs_info, "failed to read devices");
> -		goto fail_tree_roots;
> -	}

	ASSERT(fs_devices->latest_bdev);

as latest_bdev could have been touched even by the no-op
btrfs_close_extra_devices. I'll add that.

Reviewed-by: David Sterba <dsterba@suse.com>
