Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13909 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbbKBVFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 16:05:08 -0500
Date: Mon, 2 Nov 2015 16:03:47 -0500
From: Chris Mason <clm@fb.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Neil Brown <neil@brown.name>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] make btrfs subvol mounts appear in /proc/mounts
Message-ID: <20151102210347.GA20170@ret.masoncoding.com>
References: <87oafkc5kp.fsf@notabene.neil.brown.name>
 <20151102205012.GA26986@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151102205012.GA26986@fieldses.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 03:50:12PM -0500, J. Bruce Fields wrote:
> On Wed, Oct 28, 2015 at 07:25:10AM +0900, Neil Brown wrote:
> > 
> > If you create a subvolume in btrfs and access it (by name) without
> > mounting it, then the subvolume looks like a separate mount to some
> > extent, returning a different st_dev to stat(), but it doesn't look like
> > a separate mount in that it isn't listed in /proc/mounts. This
> > inconsistency can confuse tools.
> > 
> > This patch causes these subvolumes to become separate mounts by using
> > the VFS' automount functionality, much like NFS uses automount when it
> > discovered mountpoints on the server.
> > 
> > The VFS currently makes it impossible to auto-mount a directory on to itself
> > (i.e. a bind mount).  For NFS this isn't a problem as a new superblock
> > is created for the child filesystem so there are two separate dentries
> > (and inodes) for the one directory: one in the parent filesystem, one in
> > the child (note that the two superblocks share a common connection to
> > the server so there is still a lot of commonality).
> > 
> > BTRFS has chosen instead to use a single superblock for all subvolumes.
> 
> Naive question: was there a reason for that choice?

They are really all part of the same FS, the single super better fits.
Or said another way, it felt like there would be dramatically more duct
tape around supers-per-subvolume than there was abusing st_dev.

Neil's patch came up after I told him a few of us had tried to do the
same thing and failed to find clean vfs changes to make it possible...he
took it as a challenge.  Now I have to remember what it was about our
past attempts that I didn't like.

I'll test this and queue for 4.5 if it all works out, thanks Neil!

-chris

