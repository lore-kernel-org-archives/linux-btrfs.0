Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389418AbeHAQPz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 12:15:55 -0400
Date: Wed, 1 Aug 2018 16:29:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs: fix race between free_stale_devices and
 close_fs_devices
Message-ID: <20180801142948.GH3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180726065334.30594-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180726065334.30594-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2018 at 02:53:32PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> %fs_devices can be free-ed by btrfs_free_stale_devices() when the
> close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
> tries to access the %fs_devices again without the device_list_mutex.
> 
> Fix this by bringing the %fs_devices access with in the device_list_mutex.

AFAICS this cannot happen anymore because the two calls are serialized
by the uuid_mutex. But this was not the case when syzbot reported the
problem where your patch would apply.

The parallell access to opened and device list cannot happen when:

* btrfs_scan_one_device that wants to call btrfs_free_stale_devices
* btrfs_close_devices calls close_fs_devices

Fixed by the series:

btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
btrfs: lift uuid_mutex to callers of btrfs_open_devices
btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
btrfs: reorder initialization before the mount locks uuid_mutex
btrfs: fix mount and ioctl device scan ioctl race

If there's a race I don't see, please describe in more detail.
