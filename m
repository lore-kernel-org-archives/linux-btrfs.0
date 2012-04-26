From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH v2] Btrfs: improve space count for files with
 fragments
Date: Thu, 26 Apr 2012 13:14:30 -0400
Message-ID: <20120426171430.GP22794@shiny>
References: <1335422363-31198-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335422363-31198-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 02:39:23PM +0800, Liu Bo wrote:
> Here is a simple scenario:
> $ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=20;sync
> $ btrfs fi df /mnt/btrfs
> 
> we get 20K used, but then
> $ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=4 seek=4 conv=notrunc;sync
> $ btrfs fi df /mnt/btrfs
> 
> we get 24K used.
> Here is the problem, it is possible that an _unshared_ file with lots of
> fragments costs nearly double space than its i_size, like:
> 0k              20k
> | --- extent --- |      turned to be on disk    <---  extent --->  <-- A -->
>      | - A - |                                  | -------------- | | ----- |
>      1k      19k                                       20k + 18k = 38k
> 
>                         but what users want is  <---  extent --->  <-- A -->
>                                                 | --- |     | -- | | ----- |
>                                                     1k + 1k + 18k = 20k
> so 18k is wasted.
> 
> With the current backref design, there is no easy way to fix this, because it
> needs to touch several subtle parts, such as delayed ref stuff, extent backref.
> 
> So here I give it a try by splitting the extent which we're processing(the idea
> comes from Chris :)).
> 
> The benifits:
> As the above example shows, we'll get three individual extents: 1k + 1k + 18k,
> with their checksums are well splitted.
> 
> The defects:
> Yes, it makes the code much uglier.  And since we've disabled the merging of
> delayed refs, we'll get some performance regression.
> 
> NOTE:
> The patch may still have some bugs since we need more time to tune the subtle
> things.

Thanks for working on this.  Could you please explain in detail what the
pinned extents do?

-chris
