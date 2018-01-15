Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52971 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750718AbeAOT2Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 14:28:25 -0500
Date: Mon, 15 Jan 2018 20:26:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4 2/4] btrfs: cleanup btrfs_mount() using
 btrfs_mount_root()
Message-ID: <20180115192615.GF13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
 <eba24d5a-d5ad-b928-27b8-3c7f0b6a0e43@jp.fujitsu.com>
 <28c4963f-9e87-ce42-7c6a-85d32cd71951@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <28c4963f-9e87-ce42-7c6a-85d32cd71951@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 06:14:40PM +0800, Anand Jain wrote:
> 
> Misono,
> 
>   This change is causing subsequent (subvol) mount to fail when device
>   option is specified. The simplest eg for failure is ..
>     mkfs.btrfs -qf /dev/sdc /dev/sdb
>     mount -o device=/dev/sdb /dev/sdc /btrfs
>     mount -o device=/dev/sdb /dev/sdc /btrfs1
>        mount: /dev/sdc is already mounted or /btrfs1 busy
> 
>    Looks like
>      blkdev_get_by_path() <-- is failing.
>      btrfs_scan_one_device()
>      btrfs_parse_early_options()
>      btrfs_mount()
> 
>   Which is due to different holders (viz. btrfs_root_fs_type and
>   btrfs_fs_type) one is used for vfs_mount and other for scan,
>   so they form different holders and can't let EXCL open which
>   is needed for both scan and open.

This looks close to what I see in the random test failures. I've
reverted your patch "btrfs: optimize move uuid_mutex closer to the
critical section" as I bisected to it. The uuid mutex around
blkdev_get_path probably protected the concurrent mount and scan so they
did not ask for EXCL at the same time.

Reverting (or removing the patch from the current misc-next) queue is
simpler for me ATM as I want to get to a stable base now, we can add it
later if we understand the issue with the mount/scan.
