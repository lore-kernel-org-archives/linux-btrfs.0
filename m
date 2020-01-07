Return-Path: <SRS0=KPg5=24=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59C0C33C8C
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jan 2020 11:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89F54207E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jan 2020 11:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgAGL7P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 06:59:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:59630 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgAGL7O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Jan 2020 06:59:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0FBC6AD82;
        Tue,  7 Jan 2020 11:59:13 +0000 (UTC)
Date:   Tue, 7 Jan 2020 05:59:09 -0600
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, darrick.wong@oracle.com,
        fdmanana@kernel.org, nborisov@suse.com, dsterba@suse.cz,
        jthumshirn@suse.de, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/8] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200107115909.h6zdojchvpvqbi2z@fiona>
References: <20191213195750.32184-1-rgoldwyn@suse.de>
 <20191213195750.32184-5-rgoldwyn@suse.de>
 <20191221144226.GA25804@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221144226.GA25804@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  6:42 21/12, Christoph Hellwig wrote:
> So Ilooked into the "unlocked" direct I/O case, and I think the current
> code using dio_sem is really sketchy.  What btrfs really needs to do is
> take i_rwsem shared by default for direct writes, and only upgrade to
> the exclusive lock when needed, similar to xfs and the WIP ext4 code.
> 
> While looking for that I also noticed two other things:
> 
>  - check_direct_IO looks pretty bogus
>  - btrfs_direct_IO really should be split and folded into the two
>    callers
> 
> Untested patches attached.  The first should probably go into a prep
> patch, and the second could be folded into this one.

Testing revealed that removing check_direct_IO will not work. We try and
reserve space as a whole for the entire direct write. These checks
safeguard from requests unaligned to fs_info->sectorsize.

I liked the patch to split and fold the direct_IO code. However to merge
it into this will make it difficult to understand the changes since we
are moving it to a different file rather than changing in-place. A
separate patch would better serve as a cleanup.

-- 
Goldwyn
