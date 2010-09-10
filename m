From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.35.4 fumble-spolision
Date: Thu, 9 Sep 2010 20:49:09 -0400
Message-ID: <20100910004909.GX3227@think>
References: <20100910001703.GF26862@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100910001703.GF26862@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 09, 2010 at 05:17:03PM -0700, Simon Kirby wrote:
> Hello!
> 
> We seem to have done something to our backup volumes while switching
> between 2.6.33.2 and 2.6.35.4 which is now causing this crash while
> booting either kernel and mounting one of the volumes.  Crash from
> 3.6.35.4 plus Li Zefan's free-space-cache.c patches.  extent-tree.c
> is untouched, but if needed, we can try again with clean 2.6.35.4.

What does btrfsck say?  Does the problem go away in 2.6.33?

-chris
