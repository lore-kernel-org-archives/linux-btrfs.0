Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:51096
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933009AbdEOIiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 04:38:06 -0400
Date: Mon, 15 May 2017 14:06:54 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170515083653.GA5902@giis.co.in>
References: <20170513125632.GA10846@giis.co.in>
 <b9f29fde-1e8a-d481-971a-b1951bf9b2a8@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b9f29fde-1e8a-d481-971a-b1951bf9b2a8@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 15, 2017 at 09:40:29AM +0800, Qu Wenruo wrote:
> >bug: https://bugzilla.kernel.org/show_bug.cgi?id=194795
> 
> Errr, it seems that you forgot to update ext2_open_fs() to update how we get
> cctx->block_counts.
> 
> Without that update, we still get wrong total size of original fs, so
> converted image will be corrupted.
> 
> In this 22T case, it can't pass convert test since after conversion,
> converted image can't pass e2fsck.
> 
> Thanks,
> Qu
> 

Thanks for pointing out the issue. So we need to update 
common.h/cctx->block_count from u32 to u64?

do we also need to change other fields like inodes_count and
free_inode_count?

Cheers.
Lakshmipathi.G
