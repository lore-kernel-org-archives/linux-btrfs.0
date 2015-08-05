Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56025 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbbHEHX6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 03:23:58 -0400
Subject: Re: Why subvolume and not just volume?
To: Martin <sha256sum@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAK4jXzy8OpRMnF=hYEamZVxiumH9Xn_8uDo_xOQhYfLf3cA9dA@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55C1BA0A.8090804@cn.fujitsu.com>
Date: Wed, 5 Aug 2015 15:23:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAK4jXzy8OpRMnF=hYEamZVxiumH9Xn_8uDo_xOQhYfLf3cA9dA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Martin wrote on 2015/08/05 09:06 +0200:
> Hi,
>
> Does anyone know the reason subvolumes are not called just volumes? I
> mean, the top subvolume is not called a volume, so there is nothing to
> be "sub" of.
Because normally a volume is referred as a complete filesystem.
So from this respect, subvolume is not a full filesystem, it still need 
a lot of extra data from other trees to build its contents.

So, that's why there is "sub" prefix.
Although it acts much like a volume as it can be mounted like a 
filesystem, but it's still not a full filesystem.
>
> Also, what is the penalty of a subvolume compared to a directory? From
> a design perspective, couldn't all directories just be subvolumes?
Yes, subvolume has its overhead, and when it comes as many as 
directories, the overhead won't be small.

The overhead that I can remember is shown below.
Use empty tree as an example for its size, and default mkfs options.
The '+' after number means it will increase with snapshots

1) Empty tree block: 16K
    Of course takes more if its child file/dir grows
2) ROOT_ITEM in tree root: 439bytes
3) ROOT_BACKREF in tree root: 22+bytes
5) extent backref for tree block:
     33+bytes for skinny metadata
     53+bytes without skinny metadata

Alone with other trees like log tree, one for each subvolume if fsync is 
called.

Not to mention other run-time overhead.
For example, to search a inode in one subvolume.
Search_slot would be enough to find the INODE_ITEM.

But to search a inode across subvolume boundary, need to first found the 
subvolume boundary and loop until we reach the subvolume containing the 
inode, then do the above search_slot to locate the INODE_ITEM.

Although the overhead is already small, but not that small to make all 
directories to be subvolume.

Thanks,
Qu
>
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
