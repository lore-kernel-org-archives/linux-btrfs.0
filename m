Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47951 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932427AbcLIOXf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Dec 2016 09:23:35 -0500
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
To: Dave Chinner <david@fromorbit.com>, Liu Bo <bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
 <20161209051359.GO4219@dastard>
CC: <linux-btrfs@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <9b47dc14-5ab2-b5d4-f697-32b8a25614aa@fb.com>
Date: Fri, 9 Dec 2016 09:23:18 -0500
MIME-Version: 1.0
In-Reply-To: <20161209051359.GO4219@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/09/2016 12:13 AM, Dave Chinner wrote:
> On Wed, Dec 07, 2016 at 01:45:08PM -0800, Liu Bo wrote:
>> Since I haven't figure out how to map multiple devices to userspace without
>> pagecache, this DAX support is only for single-device, and I don't think
>> DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
>> this by setting nodatacow in dax mount option.
>
> DAX can be made to work with COW quite easily - it's already been
> done, in fact. Go look up Nova for how it works with DAX:
>
> https://github.com/Andiry/nova
>
> Essentially, it has a set of "temporary pages" it links to the inode
> where writes are done directly, and when a synchronisation event
> occurs it pulls them from the per-inode list, does whatever
> transformations are needed (e.g. CRC calculation, mirroring, etc)
> and marks them them as current in the inode extent list.
>
> When a new overwrite comes along, it allocates a new block in the
> temporary page list, copies the existing data into it, and then uses
> that block for DAX until the next synchronisation event occurs.
>
> For XFS, CoW for DAX through read/write isn't really any different
> to the direct IO path we currently already have. And for page write
> faults on shared extents, instead of zeroing the newly allocated
> block we simply copy the original data into the new block before the
> allocation returns. It does mean, however, that XFS does not have
> the capability for data transformations in the IO path. This limits
> us to atomic write devices (software raid 0 or hardware redundancy
> such as DIMM mirroring), but we can still do out-of-band online data
> transformations and movement (e.g. dedupe, defrag) with DAX.
>
> Yes, I know these methods are very different to how btrfs uses COW.
> However, my point is that DAX and CoW and/or mulitple devices are
> not incompatible if the architecture is correctly structured. i.e
> DAX should be able to work even with most of btrfs's special magic
> still enabled.

Thanks for the pointer Dave, I'll check that out.  I'd much rather wait 
on DAX for btrfs until we have something that keeps all the features.

-chris
