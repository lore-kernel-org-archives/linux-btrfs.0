From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] Btrfs: improve space count for files with fragments
Date: Thu, 12 Apr 2012 08:16:23 -0400
Message-ID: <20120412121623.GI29506@shiny>
References: <1334221502-9222-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334221502-9222-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 05:05:02PM +0800, Liu Bo wrote:
> Here is a simple scenario:
> 
> $ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=20;sync
> $ btrfs fi df /mnt/btrfs
> 
> we get 20K used, but then
> 
> $ dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k count=4 seek=4 conv=notrunc;sync
> $ btrfs fi df /mnt/btrfs
> 
> we get 24K used.
> 
> Here is the problem, it is possible that a file with lots of fragments costs
> nearly double space than its i_size, like:
> 
> 0k              20k
> | --- extent --- |      turned to be on disk    <---  extent --->  <-- A -->
>      | - A - |                                  | -------------- | | ----- |
>      1k      19k                                       20k + 18k = 38k
> 
>                         but what users want is  <---  extent --->  <-- A -->
>                                                 | --- |     | -- | | ----- |
>                                                     1k + 1k + 18k = 20k
> 
> 18K is wasted.

Thanks for working on this.  I'd prefer that when we create the bookend
extents, we just split the original (20K extent in your case) as long as
there are no other references.

That would allow us to fully free the parts that are no actually used.

-chris
