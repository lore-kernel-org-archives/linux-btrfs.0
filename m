From: Arne Jansen <sensille@gmx.net>
Subject: Re: What to do about subvolumes?
Date: Thu, 02 Dec 2010 10:49:39 +0100
Message-ID: <4CF76BB3.3020705@gmx.net>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
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

What about the alternative and allocating inode numbers globally? The only
problem would be with snapshots as they share the inum with the source, but
one could just remap inode numbers in snapshots by sparing some bits at the
top of this 64 bit field.

Having one mount per subvolume/snapshots is the cleaner solution, but
quickly leads to situations where you have _lots_ of mounts, especially when
you export them via NFS and mount it somewhere else. I've seen a machine
which had to handle > 100,000 mounts from a zfs server. This definitely
brings it's own problems, so I'd love to see a full fs exported as a single
mount. This will also keep output from tools like iostat (for nfs mounts)
and df readable.

Thanks,
Arne
