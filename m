Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50239 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbaHSTt2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 15:49:28 -0400
Message-ID: <53F3AA34.7030809@fb.com>
Date: Tue, 19 Aug 2014 15:49:08 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: [PATCH] Btrfs: fix crash on endio of reading corrupted block
References: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/19/2014 11:33 AM, Liu Bo wrote:
> The crash is
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent_io.c:2124!
> [...]
> Workqueue: btrfs-endio normal_work_helper [btrfs]
> RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
> 
> This is in fact a regression.
> 
> It is because we forgot to increase @offset properly in reading corrupted block,
> so that the @offset remains, and this leads to checksum errors while reading
> left blocks queued up in the same bio, and then ends up with hiting the above
> BUG_ON.

Thanks Chris and Liu, this is queued.

-chris
