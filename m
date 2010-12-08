From: "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 8 Dec 2010 12:27:33 -0500
Message-ID: <20101208172732.GD2677@pad.home.fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101203214526.GA4508@localhost.localdomain>
 <20101203222756.GF23339@dastard>
 <20101207165128.GB21375@lst.de>
 <1291741327.3049.7.camel@heimdal.trondhjem.org>
 <1994A21A-98DF-4D6A-BDDE-5E40AF6F53AD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	ssorce@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1994A21A-98DF-4D6A-BDDE-5E40AF6F53AD@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 08, 2010 at 10:16:29AM -0700, Andreas Dilger wrote:
> On 2010-12-07, at 10:02, Trond Myklebust wrote:
> 
> > On Tue, 2010-12-07 at 17:51 +0100, Christoph Hellwig wrote:
> >> It's just as stable as a real dev_t in the times of hotplug and udev.
> >> As long as you don't touch anything including not upgrading the kernel
> >> it's remain stable, otherwise it will break.  That's why modern
> >> nfs-utils default to using the uuid-based filehandle schemes instead of
> >> the dev_t based ones.  At least that's what I told - I really hope it's
> >> using the real UUIDs from the filesystem and not the horrible fsid hack
> >> that was once added - for some filesystems like XFS that field does not
> >> actually have any relation to the UUID historically.  And while we
> >> could have changed that it's too late now that nfs was hacked into
> >> abusing that field.
> > 
> > IIRC, NFS uses the full true uuid for NFSv3 and NFSv4 filehandles, but
> > they won't fit into the NFSv2 32-byte filehandles, so there is an
> > '8-byte fsid' and '4-byte fsid + inode number' workaround for that...
> > 
> > See the mk_fsid() helper in fs/nfsd/nfsfh.h
> 
> It looks like mk_fsid() is only actually using the UUID if it is specified in the /etc/exports file (AFAICS, this depends on ex_uuid being set from a uuid="..." option).

No, if you look at the nfs-utils source you'll find mountd sets a uuid
by default (in utils/mountd/cache.c:uuid_by_path()).

> There was a patch in the open_by_handle() patch series that added an s_uuid field to the superblock, that could be used if no uuid= option is specified in the /etc/exports file.

Agreed that doing this in the kernel would probably be simpler.

--b.
