Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752681AbdJ3Q1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 12:27:32 -0400
Date: Mon, 30 Oct 2017 17:25:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove rcu_barrier in btrfs_close_devices
Message-ID: <20171030162541.GA3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010215103.20828-1-bo.li.liu@oracle.com>
 <ad0d4003-ef66-1da7-a27f-03837d839c11@oracle.com>
 <82a3be82-f2a9-d0bd-b34c-71f98df0e571@oracle.com>
 <20171011170249.GC16979@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011170249.GC16979@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 11:02:49AM -0600, Liu Bo wrote:
> On Wed, Oct 11, 2017 at 03:41:23PM +0800, Anand Jain wrote:
> > 
> > 
> > On 10/11/2017 02:11 PM, Anand Jain wrote:
> > > 
> > > 
> > > On 10/11/2017 05:51 AM, Liu Bo wrote:
> > > > It was introduced because btrfs used to do blkdev_put in a deferred
> > > > work, now that btrfs has put blkdev in place, this rcu_barrier can be
> > > > removed.
> > 
> >  On the 2nd thought, modprobe -r btrfs would still need rcu_barrier(), some
> > where else outside of umount context ?
> 
> Thanks a lot for the comments.
> 
> modprobe -r btrfs will do btrfs_cleanup_fs_uuids(), where it cleanup
> every %fs_devices on the list, but when we do btrfs_close_devices(), we
> have replaced the devices on the list with dummy ones which only have
> the same name and uuid, so modprobe -r btrfs will free those instead
> of what we were using, this change won't cause a problem for it.

Added to the changelog.

Reviewed-by: David Sterba <dsterba@suse.com>
