From: Jeff Layton <jlayton@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 15:03:52 -0500
Message-ID: <20101201150352.164007ed@tlielax.poochiereds.net>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 1 Dec 2010 09:21:36 -0500
Josef Bacik <josef@redhat.com> wrote:

> There is one tricky thing.  When you create a subvolume, the directory inode
> that is created in the parent subvolume has the inode number of 256.  So if you
> have a bunch of subvolumes in the same parent subvolume, you are going to have a
> bunch of directories with the inode number of 256.  This is so when users cd
> into a subvolume we can know its a subvolume and do all the normal voodoo to
> start looking in the subvolumes tree instead of the parent subvolumes tree.
> 
> This is where things go a bit sideways.  We had serious problems with NFS, but
> thankfully NFS gives us a bunch of hooks to get around these problems.
> CIFS/Samba do not, so we will have problems there, not to mention any other
> userspace application that looks at inode numbers.

A more common use case than CIFS or samba is going to be things like
backup programs. They commonly look at inode numbers in order to
identify hardlinks and may be horribly confused when there files that
have a link count >1 and inode number collisions with other files.

That probably qualifies as an "enterprise-ready" show stopper...

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
> 
> 2) Do something like NFS's referral mounts when we cd into a subvolume.  Now we
> just do dentry trickery, but that doesn't make the boundary between subvolumes
> clear, so it will confuse people (and samba) when they walk into a subvolume and
> all of a sudden the inode numbers are the same as in the directory behind them.
> With doing the referral mount thing, each subvolume appears to be its own mount
> and that way things like NFS and samba will work properly.
> 

Sounds like you're on the right track.

The key concept is really that an inode number should be unique within
the scope of the st_dev. The simplest solution for you here is simply to
give each subvol its own st_dev and mount it up via a shrinkable mount
automagically when someone walks into the directory. In addition to the
examples of this in NFS, CIFS does this for DFS referrals.

Today, this is mostly done by hijacking the follow_link operation, but
David Howells proposed some patches a while back to do this via a more
formalized interface. It may be reasonable to target this work on top
of that, depending on the state of those changes...

-- 
Jeff Layton <jlayton@redhat.com>
