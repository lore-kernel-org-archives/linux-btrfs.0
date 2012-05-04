From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] sleeping function called from atomic context
Date: Fri, 4 May 2012 11:38:44 -0400
Message-ID: <20120504153844.GC25477@shiny>
References: <4FA3AD0B.7040500@giantdisaster.de>
 <20120504132536.GA25477@shiny>
 <4FA3F3B0.6020902@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA3F3B0.6020902@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2012 at 05:20:16PM +0200, Stefan Behrens wrote:
> On 5/4/2012 3:25 PM, Chris Mason wrote:
> > On Fri, May 04, 2012 at 12:18:51PM +0200, Stefan Behrens wrote:
> >> Looks like after "btrfs read error corrected" of chunk tree block while
> >> reading the chunk tree in open_ctree(), we stay in atomic state (in
> >> 3.4-rc5).
> > 
> > I'm having a hard time reproducing this here.  Do you have lockdep on?
> > It might tell us which lock we're leaving around.
> 
> Next two tries with lockdep and with a reboot before the mount. For the
> first one I was using dd(1) to damage (overwite) one mirror of the chunk
> tree and the issue was there immediately. The second time with some
> writes to the disk in degraded state and a remount with all disks
> afterwards. This time umount was raising the issue.
> 
> And as Dave wrote, SLUB checks whether someone is in atomic state and
> calls kmem_cache_alloc() with __GFP_WAIT. I see no reason for being in
> atomic state at this point, that's the issue.
> 
> 
> BUG: sleeping function called from invalid context at mm/slub.c:937
> in_atomic(): 1, irqs_disabled(): 0, pid: 3650, name: mount
> 2 locks held by mount/3650:
>  #0:  (&type->s_umount_key#32/1){+.+.+.}, at: [<ffffffff811909c8>]
> sget+0x248/0x540
>  #1:  (btrfs-fs-03){++++..}, at: [<ffffffffa010ea12>]
> btrfs_clear_lock_blocking_rw+0x62/0x160 [btrfs]
> Pid: 3650, comm: mount Not tainted 3.3.0+ #58
> Call Trace:
>  [<ffffffff810af591>] __might_sleep+0xe1/0x110
>  [<ffffffff811895bd>] kmem_cache_alloc+0x4d/0x160
>  [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
>  [<ffffffffa00fa8d7>] __set_extent_bit+0x357/0x590 [btrfs]
>  [<ffffffff810d594d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffffa00fab7c>] lock_extent_bits+0x6c/0xa0 [btrfs]
>  [<ffffffffa00ce964>] verify_parent_transid+0x84/0x160 [btrfs]

Oh, that makes sense.  verify_parent_transid can sleep because it
locks the extent, and we're being called with a spinning lock.

Hmmm, let me think on this one.

-chris
