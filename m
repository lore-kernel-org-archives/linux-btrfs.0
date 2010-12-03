From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: What to do about subvolumes?
Date: Fri, 3 Dec 2010 16:01:44 -0700
Message-ID: <26801711-6DF9-4122-BCDF-033A1781C3E4@dilger.ca>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <20101203222756.GF23339@dastard> <1291415351-sup-4820@think> <20101203224525.GC12491@pad.home.fieldses.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: "J. Bruce Fields" <bfields@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101203224525.GC12491@pad.home.fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-12-03, at 15:45, J. Bruce Fields wrote:
> We're using statfs64.fs_fsid for this; I believe that's both stable
> across reboots and distinguishes between subvolumes, so that's OK.
> 
> (That said, since fs_fsid doesn't work for other filesystems, we depend
> on an explicit check for a filesystem type of "btrfs", which is
> awful--btrfs won't always be the only filesystem that wants to do this
> kind of thing, etc.)

Sigh, I wanted to be able to specify the NFS FSID directly from within the kernel for Lustre many years already.  Glad to see that this is moving forward.

Any chance we can add a ->get_fsid(sb, inode) method to export_operations
(or something simiar), that allows the filesystem to generate an FSID based on the volume and inode that is being exported?

Cheers, Andreas





