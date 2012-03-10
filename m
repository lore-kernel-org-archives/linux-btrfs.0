From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH] Btrfs: hold enough space for global_rsv
Date: Sat, 10 Mar 2012 21:12:44 +0100
Message-ID: <20120310211244.079e1c5f@fem.tu-ilmenau.de>
References: <1326793919-2712-1-git-send-email-liubo2009@cn.fujitsu.com>
	<20120227142904.18c5df56@fem.tu-ilmenau.de>
	<4F4C3696.8010804@cn.fujitsu.com>
	<20120306145032.697641a3@fem.tu-ilmenau.de>
	<20120308202225.01ad2ffd@fem.tu-ilmenau.de>
	<4F595CD8.7000900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F595CD8.7000900@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 09 Mar 2012 09:28:56 +0800
schrieb Liu Bo <liubo2009@cn.fujitsu.com>:

> On 03/09/2012 03:22 AM, Johannes Hirte wrote:
> > Am Tue, 6 Mar 2012 14:50:32 +0100
> > schrieb Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>:
> > 
> >> I've backed up the filesystem, deleted the subvolumes, recreated
> >> them and copied the data back. Now everything seems to work again.
> >> I've also a full image of the damaged filesystem for further
> >> investigation. If someone has an idea for testing, I'm happy to try
> >> it.
> > 
> > It's much worse than I thought. After a short time the same error
> > happened again (no space left on device). So recreated the
> > filesystem (mkbtrfs with default values) and copied the data from
> > the backup back, but the error still came back. I'm now on kernel
> > 3.2 which seems to work. I'll try to bisect the bad commit. For
> > info, df says:
> > 
> 
> OK, plz show us the results after your bisect, let's narrow down
> where goes wrong.
> 
> thanks,
> liubo

Bisect points again to:

5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf is the first bad commit
commit 5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf
Author: Liu Bo <liubo2009@cn.fujitsu.com>
Date:   Thu Feb 23 10:49:04 2012 -0500

    Btrfs: increase the global block reserve estimates
    
    When doing IO with large amounts of data fragmentation, the global
    block reserve calulations are too low.  This increases them to avoid
    ENOSPC crashes.
    
    Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

The revision before is working and reverting this commit from master
works too. But as mentioned before, I'm not sure if this is root cause.
First time I've seen the error it happened without this patch too later
on.
