Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbcCKLWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 06:22:22 -0500
Date: Fri, 11 Mar 2016 12:21:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Dont' stop scanning of devices at first
 failed device
Message-ID: <20160311112159.GN18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457654675-14084-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457654675-14084-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 04:04:35PM -0800, Yauhen Kharuzhy wrote:
> When 'btrfs device scan' command is invoked, it scans all devices,
> check them for btrfs superblock and add devices with btrfs to a list.
> 
> Next, each device from the list is passed to kernel where it is handled
> in the btrfs_scan_one_device() function. This function can, for example,
> return -EBUSY when device contains superblock matched to existing and
> mounted filesystem (if this device was pulled out from RAID and
> connected again after some time).
> 
> btrfs tool stops device scan if any device has been failed to add, so
> other existing devices with (possibly) valid FS will never be reached.
> 
> Fix this by remove stopping at any failure in the btrfs_register_all_devices(),
> just return error count. btrfs_scan_one_device() reports any kind of
> error already.
> 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

Applied, thanks.
