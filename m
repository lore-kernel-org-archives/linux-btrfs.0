Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbbIKSzX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 14:55:23 -0400
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
To: Christoph Hellwig <hch@lst.de>, Stefan Priebe <s.priebe@profihost.ag>
References: <55D8B193.8010906@profihost.ag> <20150825090030.GF31630@lst.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <55F32395.6030702@suse.com>
Date: Fri, 11 Sep 2015 14:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <20150825090030.GF31630@lst.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/25/15 5:00 AM, Christoph Hellwig wrote:
> I think this is btrfs using a struct block_device that doesn't
> have a valid queue pointer in it's gendisk for ->s_bdev.  And there
> are some fishy looking ->s_bdev assignments in the code which I
> suspect are related to it:
> 
> fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev ==
> src_device->bdev) fs/btrfs/dev-replace.c:
> fs_info->sb->s_bdev = tgt_device->bdev; fs/btrfs/volumes.c:     if
> (device->bdev == root->fs_info->sb->s_bdev) fs/btrfs/volumes.c:
> root->fs_info->sb->s_bdev = next_device->bdev; fs/btrfs/volumes.c:
> if (tgtdev->bdev == fs_info->sb->s_bdev) fs/btrfs/volumes.c:
> fs_info->sb->s_bdev = next_device->bdev;

The report at https://bugzilla.kernel.org/show_bug.cgi?id=100911
tracks it down a bit further and it's bdev->bd_disk == NULL instead of
the queue in the gendisk. I don't think that the s_bdev stuff is
related, though I'd certainly love to see that bit go away.

If we're calling blk_get_backing_dev_info, that means we're already
using an inode that has blockdev_superblock and the btrfs superblock
isn't even involved.

We're getting there because btrfs_evict_inode ->
btrfs_wait_ordered_range -> btrfs_fdatawrite_range ->
filemap_fdatawrite_range gets called with inode->i_mapping.  That
mapping gets passed down through __filemap_fdatawrite_range to
wbc_attach_fdatawrite_inode where the inode passed is mapping->host --
which will be the block device inode rather than the btrfs device node
inode.  That inode is the one ultimately checked in inode_to_bdi.

So it looks like we're causing writeback on an unrelated block device
that was opened using a device node hosted on btrfs, which is
obviously wrong.

I don't think snapshot removal is even a requirement to trigger this.
 I expect it's possible to trigger with two device nodes for the same
block device where one is getting closed and cleaned up while the
eviction of the other happens.  The device nodes wouldn't even need to
be on the same fs.

Other file systems use &inode->i_data in eviction.  Is it that simple
here?

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJV8yOVAAoJEB57S2MheeWysvMP/0cIPCytKGzQqkNpzjfcBk4b
a4s3xM3xnxZ0BayvAWIpSrCLp/5OR5N30Eu326LNZKIEnC7jbkQHePFLIftnhtJ/
eGWlFe9kOsHGWtdA2HyZO9s6V/Nnh0t7vXKUBfqTjV71T66VL/FP9cfRVJ4Ov5Zb
99dK58glhDuF0tOQhePdfaqw4zym+3YHkD+CJjTUKO9YnpTgr4CQFJ+6v6itGbIt
QRY7qVY0S1nz0w/s8AsKu2g76thILtBvmwsEMik3TYSJI5gHxLgSpR0btk64o67+
N50AGsO/TMJs6u9p8Ad4zMFF8AfylAgTV3g8uH6v2QLI3ILVMhjtqgOwWlT78Aca
dmceWAfhBAdRizYqKQC6ZKq26Qf9GTSEoM0L/3TuBqN5scKtGYx0mvoDzj080i7p
nmPJ955pWwxa2tsmo8wRoPXVjvOXegIyguyHvqTg0wrwzfm4aPtZGTtr7RU65lp2
83fl2KJXan8V1vkOwmZ9n4e1G1g8Gggb+qCMAiv9cLWkfTus2HFdh5GNEZ+jSCJ1
2+QzIjFzLqx0N3wQmneBfkdDiWpQkAbQJjJLPdJykivo4WytV/6Vtvcqbv39JCJj
1awM2EpqB9rKV24BGDH86MiErvVT3HBLjSEEpIa41T8PlBXEsQOH1hsXTZSzyP9o
iO8qclZgSIIUgiN4feV3
=xPuq
-----END PGP SIGNATURE-----
