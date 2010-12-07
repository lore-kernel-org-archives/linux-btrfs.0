From: Christoph Hellwig <hch@lst.de>
Subject: Re: What to do about subvolumes?
Date: Tue, 7 Dec 2010 17:51:28 +0100
Message-ID: <20101207165128.GB21375@lst.de>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <20101203222756.GF23339@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com, bfields@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101203222756.GF23339@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 04, 2010 at 09:27:56AM +1100, Dave Chinner wrote:
> A property of NFS fileshandles is that they must be stable across
> server reboots. Is this anon dev_t used as part of the NFS
> filehandle and if so how can you guarantee that it is stable?

It's just as stable as a real dev_t in the times of hotplug and udev.
As long as you don't touch anything including not upgrading the kernel
it's remain stable, otherwise it will break.  That's why modern
nfs-utils default to using the uuid-based filehandle schemes instead of
the dev_t based ones.  At least that's what I told - I really hope it's
using the real UUIDs from the filesystem and not the horrible fsid hack
that was once added - for some filesystems like XFS that field does not
actually have any relation to the UUID historically.  And while we could
have changed that it's too late now that nfs was hacked into abusing
that field.

