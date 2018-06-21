Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43098 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932747AbeFUPBS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 11:01:18 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC 0/2] Btrfs: fix file data corruptions due to lost
 dirty bits
Date: Thu, 21 Jun 2018 11:01:06 -0400
Message-ID: <D8C57277-E51B-47C7-9371-66EF2B5623E9@fb.com>
In-Reply-To: <20180620193310.GG24375@twin.jikos.cz>
References: <20180620145612.1644763-1-clm@fb.com>
 <20180620193310.GG24375@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20 Jun 2018, at 15:33, David Sterba wrote:

> On Wed, Jun 20, 2018 at 07:56:10AM -0700, Chris Mason wrote:
>> We've been hunting the root cause of data crc errors here at FB for a 
>> while.
>> We'd find one or two corrupted files, usually displaying crc errors 
>> without any
>> corresponding IO errors from the storage.  The bug was rare enough 
>> that we'd
>> need to watch a large number of machines for a few days just to catch 
>> it
>> happening.
>>
>> We're still running these patches through testing, but the fixup 
>> worker bug
>> seems to account for the vast majority of crc errors we're seeing in 
>> the fleet.
>> It's cleaning pages that were dirty, and creating a window where they 
>> can be
>> reclaimed before we finish processing the page.
>
> I'm having flashbacks when I see 'fixup worker', and the test 
> generic/208 does
> not make it better:
>
> generic/095		[18:07:03][ 3769.317862] run fstests generic/095 at 
> 2018-06-20 18:07:03
> [ 3774.849685] BTRFS: device fsid 3acffad9-28e5-43ce-80e1-f5032e334cba 
> devid 1 transid 5 /dev/vdb
> [ 3774.875409] BTRFS info (device vdb): disk space caching is enabled
> [ 3774.877723] BTRFS info (device vdb): has skinny extents
> [ 3774.879371] BTRFS info (device vdb): flagging fs with big metadata 
> feature
> [ 3774.885020] BTRFS info (device vdb): checking UUID tree
> [ 3775.593329] Page cache invalidation failure on direct I/O.  
> Possible data corruption due to collision with buffered I/O!
> [ 3775.596979] File: /tmp/scratch/file2 PID: 12031 Comm: kworker/1:1
> [ 3776.642812] Page cache invalidation failure on direct I/O.  
> Possible data corruption due to collision with buffered I/O!
> [ 3776.645041] File: /tmp/scratch/file2 PID: 12033 Comm: kworker/3:0
> [ 3776.920634] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9319 
> btrfs_destroy_inode+0x1d5/0x290 [btrfs]
> [ 3776.924182] Modules linked in: btrfs libcrc32c xor zstd_decompress 
> zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
> [ 3776.927703] CPU: 0 PID: 12036 Comm: umount Not tainted 
> 4.17.0-rc7-default+ #153
> [ 3776.929164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> [ 3776.931006] RIP: 0010:btrfs_destroy_inode+0x1d5/0x290 [btrfs]

Running generic/095 on current Linus git (without my patches), I'm 
seeing this same warning.  This makes me a little happy because I have 
my patches in prod, but mostly sad because it's easier to find when the 
suspect pool is small.  I'll bisect.

-chris
