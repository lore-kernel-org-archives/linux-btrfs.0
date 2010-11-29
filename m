From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -V2 3/3] btrfs: fix panic caused by direct IO
Date: Sun, 28 Nov 2010 20:55:28 -0500
Message-ID: <1290995089-sup-4112@think>
References: <4CE9DDCB.7060706@cn.fujitsu.com> <1290395921-sup-5232@think>
Content-Type: text/plain; charset=UTF-8
Cc: Miao Xie <miaox@cn.fujitsu.com>, Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1290395921-sup-5232@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2010-11-21 22:18:54 -0500:
> Great, I'll test this and the others overnight.  Thanks!
> 
> -chris
> 
> Excerpts from Miao Xie's message of 2010-11-21 22:04:43 -0500:
> > V1->V2 Changes:
> > change the fix method. we split bios in btrfs_submit_direct() to fix this
> > problem now.
> > 
> > btrfs paniced when we write >64KB data by direct IO at one time.
> > 
> > Reproduce steps:
> >  # mkfs.btrfs /dev/sda5 /dev/sda6
> >  # mount /dev/sda5 /mnt
> >  # dd if=/dev/zero of=/mnt/tmpfile bs=100K count=1 oflag=direct

Thanks again for coding this up, the implementation looks good to me.

This easily passed the basic tests, but I ran into trouble when I tried
using it to server my virtual machines.  The problem is that we create
ordered extents in the DIO get_blocks call, but the generic DIO code
may create a single bio to span more than one ordered extent by merging
adjacent ranges.  I've fixed it here by walking forward through the
ordered extents in the end_io processing.

I've pushed these changes out to the next-rc branch of the btrfs
unstable tree, and the last commit is here:

Could you please take a look and verify it still works with your tests?

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=163cf09c2a0ee5cac6285f9347975bd1e97725da

-chris
