Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50595 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752156AbcLGWQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Dec 2016 17:16:42 -0500
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
CC: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <ad5694be-df94-f1ed-46ac-96ef19d8007d@fb.com>
Date: Wed, 7 Dec 2016 17:15:42 -0500
MIME-Version: 1.0
In-Reply-To: <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/07/2016 04:45 PM, Liu Bo wrote:
> This has implemented DAX support for btrfs with nocow and single-device.
>
> DAX is developed for block devices that are memory-like in order to avoid
> double buffer in both page cache and the storage, so DAX can performs reads and
> writes directly to the storage device, and for those who prefer to using
> filesystem, filesystem dax support can help to map the storage into userspace
> for file-mapping.
>
> Since I haven't figure out how to map multiple devices to userspace without
> pagecache, this DAX support is only for single-device, and I don't think
> DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
> this by setting nodatacow in dax mount option.

Interesting, this is a nice small start.  It might make more sense to 
limit snapshots to readonly in DAX mode until we can figure out how to 
cow properly.  I think it can be done, I just need to sit down with the 
dax code to do a good review.

But bigger picture, if we can't cow and we can't crc and we can't 
multi-device, I'd rather let XFS/ext4 sort out the dax space until we 
pull in more of the btrfs features too.

-chris
