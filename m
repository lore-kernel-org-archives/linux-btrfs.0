Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbIKTFm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 15:05:42 -0400
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
To: Christoph Hellwig <hch@lst.de>, Stefan Priebe <s.priebe@profihost.ag>
References: <55D8B193.8010906@profihost.ag> <20150825090030.GF31630@lst.de>
 <55F32395.6030702@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <55F32600.6080201@suse.com>
Date: Fri, 11 Sep 2015 15:05:36 -0400
MIME-Version: 1.0
In-Reply-To: <55F32395.6030702@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/11/15 2:55 PM, Jeff Mahoney wrote:
> On 8/25/15 5:00 AM, Christoph Hellwig wrote:
>> I think this is btrfs using a struct block_device that doesn't 
>> have a valid queue pointer in it's gendisk for ->s_bdev.  And
>> there are some fishy looking ->s_bdev assignments in the code
>> which I suspect are related to it:
> 
>> fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev == 
>> src_device->bdev) fs/btrfs/dev-replace.c: fs_info->sb->s_bdev =
>> tgt_device->bdev; fs/btrfs/volumes.c:     if (device->bdev ==
>> root->fs_info->sb->s_bdev) fs/btrfs/volumes.c: 
>> root->fs_info->sb->s_bdev = next_device->bdev;
>> fs/btrfs/volumes.c: if (tgtdev->bdev == fs_info->sb->s_bdev)
>> fs/btrfs/volumes.c: fs_info->sb->s_bdev = next_device->bdev;
> 
> The report at https://bugzilla.kernel.org/show_bug.cgi?id=100911 
> tracks it down a bit further and it's bdev->bd_disk == NULL instead
> of the queue in the gendisk. I don't think that the s_bdev stuff
> is related, though I'd certainly love to see that bit go away.
> 
> If we're calling blk_get_backing_dev_info, that means we're
> already using an inode that has blockdev_superblock and the btrfs
> superblock isn't even involved.
> 
> We're getting there because btrfs_evict_inode -> 
> btrfs_wait_ordered_range -> btrfs_fdatawrite_range -> 
> filemap_fdatawrite_range gets called with inode->i_mapping.  That 
> mapping gets passed down through __filemap_fdatawrite_range to 
> wbc_attach_fdatawrite_inode where the inode passed is mapping->host
> -- which will be the block device inode rather than the btrfs
> device node inode.  That inode is the one ultimately checked in
> inode_to_bdi.
> 
> So it looks like we're causing writeback on an unrelated block
> device that was opened using a device node hosted on btrfs, which
> is obviously wrong.
> 
> I don't think snapshot removal is even a requirement to trigger
> this. I expect it's possible to trigger with two device nodes for
> the same block device where one is getting closed and cleaned up
> while the eviction of the other happens.  The device nodes wouldn't
> even need to be on the same fs.
> 
> Other file systems use &inode->i_data in eviction.  Is it that
> simple here?

Incidentally, this explanation also covers why I was unable to
reproduce it locally.  SLES systems use devtmpfs and I just bind
mounted it into my chroot environment like I normally would.  When I
cp'd /dev into the test environment, I was able to reproduce immediately
.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJV8yYAAAoJEB57S2MheeWy2BwP+QGdpsErIfyHJcx95LLrvsxu
n0kBoI4Jd5yfNxp8m+Ll3xgUdsd6rKHJV2Muq8aRdNEdzf1E0DFrRcE0d1W5UrJy
lPzrA8QxCVaLf5jFysFp0xygKbLKHGmOAv2KnAGYFw6exIjb344UnZb6aiw5Uekm
DqrTmEq+0Yb/mE04GVpWMylK6pkDOhgkOzFVZa1Pff0eKY4E61G5GtmA2kNAUP9v
CsoZ0FO1WdF2Fc9ONSPjq7FdZLKH+OmIVakHnaELa8EEM3W7NU+mxLRabznBV25e
L/KPjr+awzkhV1ieyAAww/dddE3bN5nmDOq+OgvA9WPgaRvvwne2tHVTFaxHoiHg
d8oHDLkC1/Z1MqINLi5dZNsSuIWMvRhIMV9Th5F2rdWxrBCSRvID7N+Z2HHh6mJC
Q9rgSOyYKclTam6IF7yX8lDWIqkAnoA6OxvOKRccgr3hS/u4DzVtRmWHO9RblEi+
a9dF2FCP+v+Lgdb8C5n7XUixrtF5H6BWHhmArgjmxD6iyeXOmphyGrgqmSLdY1s9
sakvLrSB9i3O27CKoup2OHyF6MOdgsaa90FZLPLt6BDrCTWAscd0LDy8MbaKgKCR
kjfSTiwNydzZfkJixH71U/1mGbuB9nqf6jrNWCQdE5f57MSCEwiFqQvaD1KK+Uug
ZW2Bz1VQxkOvGbYiJ4HV
=ic4+
-----END PGP SIGNATURE-----
