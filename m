Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936208AbeF2MG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 08:06:29 -0400
Date: Fri, 29 Jun 2018 14:06:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: fix race between mkfs and mount
Message-ID: <20180629120627.GP2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180604150030.12883-1-anand.jain@oracle.com>
 <20180604150030.12883-3-anand.jain@oracle.com>
 <20180607163931.GH3215@twin.jikos.cz>
 <20180619135301.GQ24375@twin.jikos.cz>
 <eca302a1-5400-504e-f43f-3b8bfcb74e80@oracle.com>
 <20180626121900.GI27958@twin.jikos.cz>
 <b3eca86e-db7a-41fc-e8f9-150d0418ffe8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b3eca86e-db7a-41fc-e8f9-150d0418ffe8@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2018 at 10:42:32PM +0800, Anand Jain wrote:
> >>> Last version of the proposed fix is to extend the uuid_mutex over the
> >>> whole mount callback and use it around calls to btrfs_scan_one_device.
> >>> That way we'll be sure the mount will always get to the device it
> >>> scanned and that will not be freed by the parallel scan.
> >>
> >>    That will break the requisite #1 as above.
> > 
> > I don't see how it breaks 'mount and or scan of two independent fsid+dev
> > is possible'. It is possible, but the lock does not need to be
> > filesystem local.
> > 
> > Concurrent mount or scan will block on the uuid_mutex,
> 
>   As uuid_mutex is global, if fsid1 is being mounted, the fsid2 mount
>   will wait upto certain extent with this code.

Yes it will wait a bit, but the critical section is short. There's some
IO done and it's reading of 4K in btrfs_read_disk_super. The rest is
cpu-bound and hardly measurable in practice, in context of concurrent
mount and scanning.

I took the approach to fix the bug first and then make it faster or
cleaner, also to fix it in a way that's still acceptable for current
development cycle.

>   My efforts here was to
>   use uuid_mutex only to protect the fs_uuid update part, in this way
>   there is concurrency in the mount process of fsid1 and fsid2 and
>   provides shorter bootup time when the user uses the mount at boot
>   option.

The locking can be still improved but the uuid_mutex is not a contended
lock, mount is an operation that does not happen thousand times a
second, same for the scanning.

So even if there are several mounts happening during boot, it's just a
few and the delay is IMO unnoticeable. If the boot time is longer by
say 100ms at worst, I'm still ok with my patches as a fix.

But not as a final fix, so the updates to locking you mentioned are
still possible. We now have a point of reference where syzbot does is
not able to reproduce the bugs.
