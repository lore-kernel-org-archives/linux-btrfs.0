Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41805 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbbBFFUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 00:20:46 -0500
Message-ID: <54D44F2A.8090108@cn.fujitsu.com>
Date: Fri, 6 Feb 2015 13:20:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Lutz Vieweg <lvml@5t9.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: Can I get a checksum for a file from btrfs (without reading the
 whole file)?
References: <mavhab$f8m$1@ger.gmane.org>
In-Reply-To: <mavhab$f8m$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Can I get a checksum for a file from btrfs (without reading the 
whole file)?
From: Lutz Vieweg <lvml@5t9.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年02月05日 18:40
> Hi,
>
> use case: You have two huge files on a btrfs, you assume they contain 
> the same bytes,
> but you do not know for sure.
>
> Is there a way to get a checksum of both files from btrfs with less 
> effort than
> reading the whole of both files and computing a hash sum?
For short, NO.

For long:
For current implement, btrfs use calculate 4K sector into 4bytes(32bit) 
crc32 and restore it into csum tree.

So, for large files, e.g. 1G(already quite small for modern storage), 
its checksum will be 1M in size.
Which means even using crc32 (same as kernel and crc32(a+b) = crc32(a) + 
crc32(b)), you still needs to
do crc32 on the all 1M crc32.
And if you want other checksum like md5/sha256, you have no choice but 
read them all and calculate.


But there is still some case btrfs can help you determine whether the 
files are the same in a faster way.
Prerequisite:
The two files are copied using clone(cp --reflink command) or 
deduplicated(see btrfs 
wiki:https://btrfs.wiki.kernel.org/index.php/Deduplication)

Method:
If cloned/deduplicated, file will share same file extents (one can up to 
128M).
So you can compare file extents to compare the whole file.
Per 128M compare will be definitely faster. (if not modified after cp 
--clone or deduplication)

I didn't see such implement yet, so it's just a concept...

Thanks,
Qu
>
> (I was thinking that the btrfs-internal CRCs might be of use, here...)
>
> Regards,
>
> Lutz Vieweg
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

