From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kmemleak influence on write btrfs performance
Date: Tue, 14 Jul 2009 09:52:26 -0400
Message-ID: <20090714135226.GH3783@think>
References: <4A55CF91.90708@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A55CF91.90708@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 09, 2009 at 02:08:01PM +0300, Piavlo wrote:
>  Hi,
> 
> I'm running 2.6.31-rc2 and noticed that then kmemleak is enabled it
> lowers the sequential disk write benchmark performance by an order of
> two for btrfs
> while for other files systems like ext4 the change is barely noticeable
> (around 1%)
> While for both btrfs and ext4 the system cpu load rises very high with
> kmemleak enabled - but only write btrfs performance suffers.
> Does someone have an explanation for this behavior?

Sorry for the delay.  The short answer (without diving deeply into it)
is that btrfs hammers on the slab cache much more than the other
filesystems.  So, it isn't surprising that kmemleak slows btrfs down
significantly.

-chris
