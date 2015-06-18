Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39135 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932328AbbFRP6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 11:58:01 -0400
Date: Thu, 18 Jun 2015 11:57:46 -0400
From: Facebook <clm@fb.com>
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Message-ID: <1434643066.28534.0@mail.thefacebook.com>
In-Reply-To: <55822008.1090305@cn.fujitsu.com>
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
	<557B076B.7050500@fb.com> <557E86A9.8040207@cn.fujitsu.com>
	<20150615131507.GL6761@twin.jikos.cz> <557F7A5F.5010206@cn.fujitsu.com>
	<557F8C78.7080304@cn.fujitsu.com> <55822008.1090305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, Jun 17, 2015 at 9:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
wrote:
> Ping?
> 
> New new comments?

As our block sizes get bigger, it makes sense to think about more fine 
grained checksums.  We're using crcs for:

1) memory corruption on the way down to the storage.  We could be very 
small (bitflips) or smaller chunks (dma corrupting the whole bio).  The 
places I've seen this in production, the partial crcs might help save a 
percentage of the blocks, but overall the corruptions were just too 
pervasive to get back the data.

2) incomplete writes.  We're sending down up to 64K btree blocks, the 
storage might only write some of them.

3) IO errors from the drive.  These are likely to fail in much bigger 
chunks and the partial csums probably won't help at all.

I think the best way to repair all of these is with replication, either 
RAID5/6 or some number of mirrored copies.  It's more reliable than 
trying to stitch together streams from multiple copies, and the code 
complexity is much lower.

But, where I do find the partial crcs interesting is the ability to 
more accurately detect those three failure modes with our larger block 
sizes.  That's pure statistics based on the crc we've chosen and the 
size of the block.  The right answer might just be a different crc, but 
I'm more than open to data here.

-chris


