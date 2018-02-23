Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbeBWW6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:58:04 -0500
Date: Fri, 23 Feb 2018 23:55:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: fix NPD when target device is missing
Message-ID: <20180223225545.GP1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180220144625.8909-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180220144625.8909-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 20, 2018 at 10:46:25PM +0800, Anand Jain wrote:
> The replace target device can be missing in which case we don't
> allocate a missing btrfs_device when mounted with the -o degraded.
> So check the device before access.
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0

Please don't use uncommon acronyms, NPD is quite confusing, null pointer
deref should be fine.

> IP: btrfs_destroy_dev_replace_tgtdev+0x43/0xf0 [btrfs]
> Call Trace:
> btrfs_dev_replace_cancel+0x15f/0x180 [btrfs]
> btrfs_ioctl+0x2216/0x2590 [btrfs]
> do_vfs_ioctl+0x625/0x650
> SyS_ioctl+0x4e/0x80
> do_syscall_64+0x5d/0x160
> entry_SYSCALL64_slow_path+0x25/0x25

Do you have a reproducer for that?
