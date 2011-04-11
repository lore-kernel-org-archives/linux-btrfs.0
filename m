From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Mon, 11 Apr 2011 13:46:33 -0400
Message-ID: <1302543930-sup-5927@think>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net> <4DA33D99.3050506@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	josef <josef@redhat.com>, miaox <miaox@cn.fujitsu.com>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DA33D99.3050506@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2011-04-11 13:42:49 -0400:
> On 08.02.2011 19:03, Arne Jansen wrote:
> > In a multi device setup, the chunk allocator currently always allocates
> > chunks on the devices in the same order. This leads to a very uneven
> > distribution, especially with RAID1 or RAID10 and an uneven number of
> > devices.
> > This patch always sorts the device before allocating, and allocates the
> > stripes on the devices with the most available space, as long as there
> > is enough space available. In a low space situation, it first tries to
> > maximize striping.
> > The patch also simplifies the allocator and reduces the checks for
> > corner cases. Additionally, alloc_start is now always heeded.
> 
> It's been quite some weeks since this patch has been posted. In the
> meantime several issues popped up that are already addressed by this
> patch.
> Currently multi-device btrfs just don't work as advertised, a 'balance'
> operation does not spread the data evenly over all disks and with
> multiple devices a substantial amount of space can be wasted.
> I'd be happy if someone could have a look at the patch so that chris
> can pull it. Diff did some funny things to it so it's best to just pull
> it in and read the results.

My big complaint about this patch is that it is a feature fix mixed in
with a huge cleanup.  It's hard to differentiate between the two.  Could
you please separate it out so we can review them independently?

-chris
