From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 01 Dec 2010 11:00:12 -0500
Message-ID: <1291219052-sup-2404@think>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2010-12-01 09:21:36 -0500:
> Hello,
> 
> Various people have complained about how BTRFS deals with subvolumes recently,
> specifically the fact that they all have the same inode number, and there's no
> discrete seperation from one subvolume to another.  Christoph asked that I lay
> out a basic design document of how we want subvolumes to work so we can hash
> everything out now, fix what is broken, and then move forward with a design that
> everybody is more or less happy with.  I apologize in advance for how freaking
> long this email is going to be.  I assume that most people are generally
> familiar with how BTRFS works, so I'm not going to bother explaining in great
> detail some stuff.

Thanks for writing this up.

> === What do we do? ===
> 
> This is where I expect to see the most discussion.  Here is what I want to do
> 
> 1) Scrap the 256 inode number thing.  Instead we'll just put a flag in the inode
> to say "Hey, I'm a subvolume" and then we can do all of the appropriate magic
> that way.  This unfortunately will be an incompatible format change, but the
> sooner we get this adressed the easier it will be in the long run.  Obviously
> when I say format change I mean via the incompat bits we have, so old fs's won't
> be broken and such.

If they don't have inode number 256, what inode number do they have?
I'm assuming you mean the subvolume is given an inode number in the
parent directory just like any other dir,  but this doesn't get rid of
the duplicate inode problem.  I think it ends up making it less clear,
but I'm open to suggestions ;)

We could give each subvol a different devt, which is something Christoph
had asked about as well.

-chris
