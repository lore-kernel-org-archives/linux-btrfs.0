Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24738 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbbIKTev (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 15:34:51 -0400
Date: Fri, 11 Sep 2015 15:34:39 -0400
From: Chris Mason <clm@fb.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: Christoph Hellwig <hch@lst.de>, Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
Message-ID: <20150911193439.GA6308@ret.masoncoding.com>
References: <55D8B193.8010906@profihost.ag>
 <20150825090030.GF31630@lst.de>
 <55F32395.6030702@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55F32395.6030702@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 11, 2015 at 02:55:17PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 8/25/15 5:00 AM, Christoph Hellwig wrote:
> > I think this is btrfs using a struct block_device that doesn't
> > have a valid queue pointer in it's gendisk for ->s_bdev.  And there
> > are some fishy looking ->s_bdev assignments in the code which I
> > suspect are related to it:
> > 
> > fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev ==
> > src_device->bdev) fs/btrfs/dev-replace.c:
> > fs_info->sb->s_bdev = tgt_device->bdev; fs/btrfs/volumes.c:     if
> > (device->bdev == root->fs_info->sb->s_bdev) fs/btrfs/volumes.c:
> > root->fs_info->sb->s_bdev = next_device->bdev; fs/btrfs/volumes.c:
> > if (tgtdev->bdev == fs_info->sb->s_bdev) fs/btrfs/volumes.c:
> > fs_info->sb->s_bdev = next_device->bdev;
> 
> The report at https://bugzilla.kernel.org/show_bug.cgi?id=100911
> tracks it down a bit further and it's bdev->bd_disk == NULL instead of
> the queue in the gendisk. I don't think that the s_bdev stuff is
> related, though I'd certainly love to see that bit go away.
> 
> If we're calling blk_get_backing_dev_info, that means we're already
> using an inode that has blockdev_superblock and the btrfs superblock
> isn't even involved.
> 
> We're getting there because btrfs_evict_inode ->
> btrfs_wait_ordered_range -> btrfs_fdatawrite_range ->
> filemap_fdatawrite_range gets called with inode->i_mapping.  That
> mapping gets passed down through __filemap_fdatawrite_range to
> wbc_attach_fdatawrite_inode where the inode passed is mapping->host --
> which will be the block device inode rather than the btrfs device node
> inode.  That inode is the one ultimately checked in inode_to_bdi.
> 
> So it looks like we're causing writeback on an unrelated block device
> that was opened using a device node hosted on btrfs, which is
> obviously wrong.
> 
> I don't think snapshot removal is even a requirement to trigger this.
>  I expect it's possible to trigger with two device nodes for the same
> block device where one is getting closed and cleaned up while the
> eviction of the other happens.  The device nodes wouldn't even need to
> be on the same fs.
> 
> Other file systems use &inode->i_data in eviction.  Is it that simple
> here?

Oh, ok I'm following now.  This really should explain it.  Jeff
mentioned that he's working on a patch to skip the wait_ordered_range
dance based on i_mode.  Thanks Jeff!

-chris
