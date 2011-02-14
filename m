From: Yuri D'Elia <wavexx@users.sf.net>
Subject: Re: Question on subvolumes and mount options
Date: Mon, 14 Feb 2011 12:40:33 +0100
Message-ID: <20110214124033.13993f8d.wavexx@users.sf.net>
References: <87oc6fj30p.fsf@savara.sat.thregr.org>
	<20110213173059.GB5484@carfax.org.uk>
	<87ei7bj03d.fsf@savara.sat.thregr.org>
	<20110213191820.GA6321@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 13 Feb 2011 19:18:20 +0000
Hugo Mills <hugo-lkml@carfax.org.uk> wrote:

>    Yes, it's the same piece of storage, just appearing at more than
> one point in your overall filesystem. Similar to the way that bind
> mounts work.

I've noticed that I can also rename subvolumes as well using mv(1).
Can I move/re-arrange subvolumes between them simply using mv?

Does a move between subvolumes involve a copy?

> > So you would recommend creating both /root and /home subvolumes, to be
> > mounted separately, or create /root and /root/home subvolumes?
> 
>    The former.

Thanks. I can see why this is clearly more flexible in the long term.

> > What if I remount the /home subvol into /home2. What happens when I
> > touch a file through /home (nodatasum) and what happens when I use
> > /home2 - since both are available at the same time?
> 
>    They'll stay in sync with respect to the files written to either
> one. I'm not sure what the behaviour of nodatasum is with different
> mounts of the same subvolume.

Can we get an exact answer/behavior for that? :)

I mean, can I mount two different subvolumes in the same file system with different flags (such as ssd, nodatasum, compress)?

