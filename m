From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issues with KVM
Date: Mon, 25 Jul 2011 12:22:57 -0400
Message-ID: <20110725162257.GA31516@infradead.org>
References: <4E29D318.7050602@haypocalc.com>
 <CAGAVQTGdEQdS+rE-D=fd4GXgaufpdR6J5xgNUjRa+N402Ge5-g@mail.gmail.com>
 <4E2D7801.80207@haypocalc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Victor Stinner <victor.stinner@haypocalc.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2D7801.80207@haypocalc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 25, 2011 at 04:04:49PM +0200, Victor Stinner wrote:
> According to agraf__ on IRC (#kvm on FreeNode), the cache mode has
> the following effect:
> 
>  - cache=writethrough calls fsync() after every write()

It uses O_DSYNC, which an be appromiately described as an fdatasync
after every write.  Not that it makes a different for most workloads on
btrfs.

>  - cache=none uses O_DIRECT
>  - cache=writeback calls fsync() when the guest issues a barrier()
> (don't use O_DIRECT)

Issue a cache flush.  Barriers were an Linux-internal concept that
is now gone.  And there never was a barriere() call.

> FreeBSD installation in VirtualBox is as fast (or maybe a little bit
> slower) than the installation in kvm using cache=unsafe. I suppose
> that VirtualBox uses something like cache=unsafe or cache=writeback.

What filesystem do you use in FreeBSD?  FFS traditionally never issued
cache flushes, so cache=writeback is equal to cache=unsafe for it.  ZFS
can issue cache flushes on Solaris, but I'm not sure if this was ported
correctly to FreeBSD.
