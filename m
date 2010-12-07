From: "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Tue, 7 Dec 2010 15:45:48 -0500
Message-ID: <20101207204547.GA3759@pad.home.fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101203214526.GA4508@localhost.localdomain>
 <20101203222756.GF23339@dastard>
 <1291415351-sup-4820@think>
 <20101203224525.GC12491@pad.home.fieldses.org>
 <20101207165212.GC21375@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ssorce <ssorce@redhat.com>
To: hch <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101207165212.GC21375@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 07, 2010 at 05:52:13PM +0100, hch wrote:
> On Fri, Dec 03, 2010 at 05:45:26PM -0500, J. Bruce Fields wrote:
> > We're using statfs64.fs_fsid for this; I believe that's both stable
> > across reboots and distinguishes between subvolumes, so that's OK.
> 
> It's a field that doesn't have any useful specification and basically
> contains random garbage that a filesystem put into it.  Using it is a
> very bad idea.

I meant the above statement to apply only to btrfs; and nfs-utils is
using fs_fsid only in the case where the filesystem type is "btrfs".  So
I believe the current code does work.

But I agree that constructing filehandles differently based on a
strcmp() of the filesystem type is not a sustainable design, to say the
least.

--b.
