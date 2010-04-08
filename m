From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance with qemu
Date: Thu, 8 Apr 2010 11:26:15 -0400
Message-ID: <20100408152615.GI1400@think>
References: <201003281718.03699.diegocg@gmail.com>
 <20100330125623.GB13190@think>
 <4BBDEF09.70306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBDEF09.70306@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 05:58:17PM +0300, Avi Kivity wrote:
> On 03/30/2010 03:56 PM, Chris Mason wrote:
> >On Sun, Mar 28, 2010 at 05:18:03PM +0200, Diego Calleja wrote:
> >>Hi, I'm using KVM, and the virtual disk (a 20 GB file using the "raw"
> >>qemu format according to virt-manager and, of course, placed on a btrfs
> >>filesystem, running the latest mainline git) is awfully slow, no matter
> >>what OS is running inside the VM. The PCBSD installer says it's copying
> >>data at a 40-50 KB/s rate. Is someone using KVM and having better numbers
> >>than me? How can I help to debug this workload?
> >The problem is that qemu uses O_SYNC by default, which makes btrfs do
> >log commits for every write.
> 
> Problem is, btrfs takes the 50 KB/s guest rate and inflates it to
> something much larger (megabytes/sec).  Are there plans to reduce
> the amount of O_SYNC overhead writes?
> 
> I saw this too, but with 2.6.31 or 2.6.32 IIRC.

With O_DIRECT the writeback rates are very reasonable.  I'll work up a
way to pass the barrier down from the guest to btrfs to force logging of
updated metadata when required.

> 
> >Once the O_DIRECT read patch is in, you can switch to that, or tell qemu
> >to use a writeback cache instead.
> 
> Even with writeback qemu will issue a lot of fsyncs.

Oh, I didn't see that when I was testing, when does it fsync?

-chris

