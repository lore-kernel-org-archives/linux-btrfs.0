From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What to do about subvolumes?
Date: Thu, 02 Dec 2010 11:11:29 -0500
Message-ID: <1291306150-sup-7861@think>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <4CF76BB3.3020705@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <4CF76BB3.3020705@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2010-12-02 04:49:39 -0500:
> Josef Bacik wrote:
> > 
> > 1) Scrap the 256 inode number thing.  Instead we'll just put a flag in the inode
> > to say "Hey, I'm a subvolume" and then we can do all of the appropriate magic
> > that way.  This unfortunately will be an incompatible format change, but the
> > sooner we get this adressed the easier it will be in the long run.  Obviously
> > when I say format change I mean via the incompat bits we have, so old fs's won't
> > be broken and such.
> > 
> > 2) Do something like NFS's referral mounts when we cd into a subvolume.  Now we
> > just do dentry trickery, but that doesn't make the boundary between subvolumes
> > clear, so it will confuse people (and samba) when they walk into a subvolume and
> > all of a sudden the inode numbers are the same as in the directory behind them.
> > With doing the referral mount thing, each subvolume appears to be its own mount
> > and that way things like NFS and samba will work properly.
> > 
> 
> What about the alternative and allocating inode numbers globally? The only
> problem would be with snapshots as they share the inum with the source, but
> one could just remap inode numbers in snapshots by sparing some bits at the
> top of this 64 bit field.

The global inode number is possible, it's just another btree that must
be maintained on disk in order to map which inodes are free and which
ones aren't.  It also needs to have a reference count on each inode,
since each snapshot effectively increases the reference count on
every file and directory it contains.

The cost of maintaining that reference count is very very high.

-chris

> 
> Having one mount per subvolume/snapshots is the cleaner solution, but
> quickly leads to situations where you have _lots_ of mounts, especially when
> you export them via NFS and mount it somewhere else. I've seen a machine
> which had to handle > 100,000 mounts from a zfs server. This definitely
> brings it's own problems, so I'd love to see a full fs exported as a single
> mount. This will also keep output from tools like iostat (for nfs mounts)
> and df readable.
> 
> Thanks,
> Arne
