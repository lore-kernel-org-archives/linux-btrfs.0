From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v1 05/10] Btrfs: add nested locking mode for paths
Date: Thu, 22 Dec 2011 14:16:17 -0500
Message-ID: <20111222191617.GH19266@shiny>
References: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
 <108c7352f9047f90144360a5609816464b33afff.1324568416.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com, sensille@gmx.net
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <108c7352f9047f90144360a5609816464b33afff.1324568416.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 22, 2011 at 05:03:19PM +0100, Jan Schmidt wrote:
> From: Arne Jansen <sensille@gmx.net>
> 
> This patch adds the possibilty to read-lock an extent even if it is already
> write-locked from the same thread. btrfs_find_all_roots() needs this
> capability.

I'd rather not add a nested flag to the locking code, lets just make the
nesting explicitly allowed.

You shouldn't need locks around lock->owner.  Either your process owns
the lock (and it won't change away from your pid), or you don't own it
and it won't be your pid.  Just make sure the owner field gets cleared
when you do your final unlock.

So, if you are the owner of a write lock, you can add more write locks
or a read lock as required.

Could you please describe the case where btrfs_find_all_roots needs
this?

-chris
