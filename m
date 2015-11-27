Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26833 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753692AbbK0CVt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 21:21:49 -0500
Subject: Re: implications of mixed mode
To: Lukas Pirl <btrfs@lukas-pirl.de>, <linux-btrfs@vger.kernel.org>
References: <56579BD1.4030401@lukas-pirl.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5657BE2B.10209@cn.fujitsu.com>
Date: Fri, 27 Nov 2015 10:21:31 +0800
MIME-Version: 1.0
In-Reply-To: <56579BD1.4030401@lukas-pirl.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Lukas Pirl wrote on 2015/11/27 12:54 +1300:
> Dear list,
>
> if a larger RAID file system (say disk space of 8 TB in total) is
> created in mixed mode, what are the implications?
>
>  From reading the mailing list and the Wiki, I can think of the following:
>
> + less hassle with "false positive" ENOSPC

If your "false positive" means unbalanced DATA/METADATA chunk 
allocation, then yes.

> - data and metadata have to have the same replication level
>    forever (e.g. RAID 1)
> - higher fragmentation
>    (does this reduce with no(dir)atime?)
>    -> more work for autodefrag

They are also true.

And some extra pros and cons due to fixed(4K) small(compared to 16K 
default) nodesize:

+ A little higher performance
   node/leaf size is restricted to sectorsize, smaller node/leaf,
   smaller range to lock.
   In our SSD test, operations with high concurrency, the performance is
   overall 10% better than 16K nodesize.
   And in extreme metadata operation case, like high concurrency on
   sequence write into small files, it can be 8 times the performance of
   default 16K nodesize.

- Smaller subvolume size
   Since the tree block are smaller, but tree level stays the same(level
   0 - 7), the up limit of a subvolume is reduced hugely be smaller
   node/leaf size.
   Although it's quite hard to hit that up limit though.

- (Possible) less developer interest.
   Other developers are trying remove default mixed-bg, so I'd like to
   consider the trend will be less mixed-bg focused developers.
   And hidden bugs are more and more hard to hit and fixed.

>
> Is that roughly what is to be expected? Any implications on recovery etc.?

As long as your chunk tree and extent tree is OK, it shouldn't be much 
different from normal fs, at least for now.

Thanks,
Qu
>
> In the specific case, the file system usage is as follows:
> * data spread over ~20 subvolumes
>    * snapshotted with various frequencies
>    * compression is used
> * mostly archive storage
>    * write once
>    * read infrequently
> * ~500GB of daily rsync'ed system backup
>
> Thanks in advance,
>
> Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


