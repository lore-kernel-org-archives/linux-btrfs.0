From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: What to do about subvolumes?
Date: Tue, 07 Dec 2010 12:02:07 -0500
Message-ID: <1291741327.3049.7.camel@heimdal.trondhjem.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	 <20101203214526.GA4508@localhost.localdomain>
	 <20101203222756.GF23339@dastard>  <20101207165128.GB21375@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, ssorce@redhat.com, bfields@redhat.com
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101207165128.GB21375@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-12-07 at 17:51 +0100, Christoph Hellwig wrote:
> On Sat, Dec 04, 2010 at 09:27:56AM +1100, Dave Chinner wrote:
> > A property of NFS fileshandles is that they must be stable across
> > server reboots. Is this anon dev_t used as part of the NFS
> > filehandle and if so how can you guarantee that it is stable?
> 
> It's just as stable as a real dev_t in the times of hotplug and udev.
> As long as you don't touch anything including not upgrading the kernel
> it's remain stable, otherwise it will break.  That's why modern
> nfs-utils default to using the uuid-based filehandle schemes instead of
> the dev_t based ones.  At least that's what I told - I really hope it's
> using the real UUIDs from the filesystem and not the horrible fsid hack
> that was once added - for some filesystems like XFS that field does not
> actually have any relation to the UUID historically.  And while we could
> have changed that it's too late now that nfs was hacked into abusing
> that field.

IIRC, NFS uses the full true uuid for NFSv3 and NFSv4 filehandles, but
they won't fit into the NFSv2 32-byte filehandles, so there is an
'8-byte fsid' and '4-byte fsid + inode number' workaround for that...

See the mk_fsid() helper in fs/nfsd/nfsfh.h

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

