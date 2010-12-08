From: Neil Brown <neilb@suse.de>
Subject: Re: What to do about subvolumes?
Date: Thu, 9 Dec 2010 10:07:11 +1100
Message-ID: <20101209100711.6e6541e1@notabene.brown>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<20101203214526.GA4508@localhost.localdomain>
	<20101203222756.GF23339@dastard>
	<1291415351-sup-4820@think>
	<20101203224525.GC12491@pad.home.fieldses.org>
	<26801711-6DF9-4122-BCDF-033A1781C3E4@dilger.ca>
	<20101206164844.GA22447@pad.home.fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: "J. Bruce Fields" <bfields@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101206164844.GA22447@pad.home.fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Dec 2010 11:48:45 -0500 "J. Bruce Fields" <bfields@redhat.com>
wrote:

> On Fri, Dec 03, 2010 at 04:01:44PM -0700, Andreas Dilger wrote:
> > On 2010-12-03, at 15:45, J. Bruce Fields wrote:
> > > We're using statfs64.fs_fsid for this; I believe that's both stable
> > > across reboots and distinguishes between subvolumes, so that's OK.
> > > 
> > > (That said, since fs_fsid doesn't work for other filesystems, we depend
> > > on an explicit check for a filesystem type of "btrfs", which is
> > > awful--btrfs won't always be the only filesystem that wants to do this
> > > kind of thing, etc.)
> > 
> > Sigh, I wanted to be able to specify the NFS FSID directly from within the kernel for Lustre many years already.  Glad to see that this is moving forward.
> > 
> > Any chance we can add a ->get_fsid(sb, inode) method to export_operations
> > (or something simiar), that allows the filesystem to generate an FSID based on the volume and inode that is being exported?
> 
> No objection from here.

My standard objection here is that you cannot guarantee that the fsid is 100%
guarantied to be unique across all filesystems in the system (including
filesystems mounted from dm snapshots of filesystems that are currently
mounted).  NFSd needs this uniqueness.

This is only really an objection if user-space cannot over-ride the fsid
provided by the filesystem.

I'd be very happy to see an interface to user-space whereby user-space can
get a reasonably unique fsid for a given filesystem.  Whether this is an
export_operations method or some field in the 'struct super' which gets
copied out doesn't matter to me.

NeilBrown


> 
> (Though I don't understand the inode argument--aren't "subvolumes"
> usually expected to have separate superblocks?)
> 
> --b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

