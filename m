Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57091 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbbIVFSm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 01:18:42 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 22 Sep 2015 10:48:39 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Date: Tue, 22 Sep 2015 10:48:32 +0530
Message-ID: <2034993.iSlvTmyeNT@localhost.localdomain>
In-Reply-To: <55F230A3.2070300@cn.fujitsu.com>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com> <2500094.kBUgEuDpMB@localhost.localdomain> <55F230A3.2070300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 11 Sep 2015 09:38:43 Qu Wenruo wrote:

Qu, Sorry for the late response. My email client's filtering had broken and
hence I did not see your response until now.

> Hi Chandan,
> 
> Although the reply may be a little late, but I think it's still better
> to fix the bug in mkfs.btrfs.
> 
> The core problem is, why mkfs.btrfs is insisting on make the fs into
> mixed-bg.
> 
> Auto detection for small device and make it into mixed-bg should be a
> "OPTIONAL" feature, not a "mandatory" one.
> 
> So IMHO, the best method is to disable mixed-bg when nodesize/sectorsize
> is given and differs and user doesn't force mkfs to create mixed-bg.
> 

My understanding of the chunk allocator (i.e. __btrfs_alloc_chunk()) was
incomplete. Looking into the code more thoroughly I now realize that 'small 
filesystem detection and mixed-bg creation' can be made optional. Thanks for
the suggestion.

-- 
chandan

