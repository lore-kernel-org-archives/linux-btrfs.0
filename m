Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32496 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932987AbaFRCL3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 22:11:29 -0400
Message-ID: <53A0F54F.2060205@fb.com>
Date: Tue, 17 Jun 2014 19:11:27 -0700
From: Jens Axboe <axboe@fb.com>
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: commit 762380a "block: add notion of a chunk size for request
 merging" stops io on btrfs
References: <53A0B491.1040901@gmail.com>
In-Reply-To: <53A0B491.1040901@gmail.com>
Content-Type: multipart/mixed;
	boundary="------------040505080906020503090908"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------040505080906020503090908
Content-Type: text/plain; charset="windows-1253"; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-06-17 14:35, Konstantinos Skarlatos wrote:
> Hi all,
> with 3.16-rc1  rsync stops writing to my btrfs filesystem and stays at a
> D+ state.
> git bisect showed that the problematic commit is:
>
> 762380ad9322951cea4ce9d24864265f9c66a916 is the first bad commit
> commit 762380ad9322951cea4ce9d24864265f9c66a916
> Author: Jens Axboe <axboe@fb.com>
> Date:   Thu Jun 5 13:38:39 2014 -0600
>
>      block: add notion of a chunk size for request merging
>
>      Some drivers have different limits on what size a request should
>      optimally be, depending on the offset of the request. Similar to
>      dividing a device into chunks. Add a setting that allows the driver
>      to inform the block layer of such a chunk size. The block layer will
>      then prevent merging across the chunks.
>
>      This is needed to optimally support NVMe with a non-zero stripe size.
>
>      Signed-off-by: Jens Axboe <axboe@fb.com>

That's odd, should not have any effect since nobody enables stripe sizes 
in the kernel. I'll double check, perhaps it's not always being cleared.

Ah wait, does the attached help?


-- 
Jens Axboe


--------------040505080906020503090908
Content-Type: text/x-patch; name="max-sectors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="max-sectors.patch"

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 31e11051f1ba..713f8b62b435 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -920,7 +920,7 @@ static inline unsigned int blk_max_size_offset(struct request_queue *q,
 					       sector_t offset)
 {
 	if (!q->limits.chunk_sectors)
-		return q->limits.max_hw_sectors;
+		return q->limits.max_sectors;
 
 	return q->limits.chunk_sectors -
 			(offset & (q->limits.chunk_sectors - 1));

--------------040505080906020503090908--
