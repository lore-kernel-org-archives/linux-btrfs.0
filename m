From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] sleeping function called from atomic context
Date: Fri, 4 May 2012 11:50:45 -0400
Message-ID: <20120504155045.GD25477@shiny>
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

Ok, what we need to do is make a non-blocking version of
verify_parent_transid for the (likely) case where everything is ok.
Pass it a gfp_mask arg and if it is a non-waiting call it needs to
return -EAGAIN.

I'll add it this weekend unless someone beats me to it.

-chris
