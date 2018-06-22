Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754543AbeFVV0G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 17:26:06 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC 0/2] Btrfs: fix file data corruptions due to lost
 dirty bits
Date: Fri, 22 Jun 2018 17:25:54 -0400
Message-ID: <EFA3EBA7-D9B0-472E-8D70-96B756AE1677@fb.com>
In-Reply-To: <20180620202431.GH24375@suse.cz>
References: <20180620145612.1644763-1-clm@fb.com>
 <20180620193310.GG24375@twin.jikos.cz>
 <36F766B7-6388-4B93-A39F-A977F6F805D3@fb.com>
 <20180620202431.GH24375@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 Jun 2018, at 16:24, David Sterba wrote:

> On Wed, Jun 20, 2018 at 03:48:08PM -0400, Chris Mason wrote:
>>
>>> generic/095		[18:07:03][ 3769.317862] run fstests generic/095 at
>>> 2018-06-20 18:07:03
>>
>> Hmpf, I pass both 095 and 208 here.
>>
>>> [ 3774.849685] BTRFS: device fsid 
>>> 3acffad9-28e5-43ce-80e1-f5032e334cba
>>> devid 1 transid 5 /dev/vdb
>>> [ 3774.875409] BTRFS info (device vdb): disk space caching is 
>>> enabled
>>> [ 3774.877723] BTRFS info (device vdb): has skinny extents
>>> [ 3774.879371] BTRFS info (device vdb): flagging fs with big 
>>> metadata
>>> feature
>>> [ 3774.885020] BTRFS info (device vdb): checking UUID tree
>>> [ 3775.593329] Page cache invalidation failure on direct I/O.
>>> Possible data corruption due to collision with buffered I/O!
>>> [ 3775.596979] File: /tmp/scratch/file2 PID: 12031 Comm: kworker/1:1
>>> [ 3776.642812] Page cache invalidation failure on direct I/O.
>>> Possible data corruption due to collision with buffered I/O!
>>> [ 3776.645041] File: /tmp/scratch/file2 PID: 12033 Comm: kworker/3:0
>>> [ 3776.920634] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9319
>>> btrfs_destroy_inode+0x1d5/0x290 [btrfs]
>>
>>
>> Which warning is this in your tree?  The file_write patch is more 
>> likely
>> to have screwed up our bits and the fixup worker is more likely to 
>> have
>> screwed up nrpages.
>
>  9311 void btrfs_destroy_inode(struct inode *inode)
>  9312 {
>  9313         struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  9314         struct btrfs_ordered_extent *ordered;
>  9315         struct btrfs_root *root = BTRFS_I(inode)->root;
>  9316
>  9317         WARN_ON(!hlist_empty(&inode->i_dentry));
>  9318         WARN_ON(inode->i_data.nrpages);
>  9319         WARN_ON(BTRFS_I(inode)->block_rsv.reserved);
>
> The branch is the last pull, ie. no other 4.18-rc1 stuff plus your two 
> patches.

The bug came here:

commit a528a24150870c5c16cbbbec69dba7e992b08456
Author: Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed Jun 6 19:54:44 2018 +0530

     btrfs: change return type of btrfs_page_mkwrite to vm_fault_t

When page->mapping != mapping, we improperly return success because ret2 
is zero on goto out_unlock.

I'm running a fix through a full xfstests and I'll post soon.

-chris
