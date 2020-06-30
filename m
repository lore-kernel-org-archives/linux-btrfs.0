Return-Path: <SRS0=P7ik=AL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB288C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 08:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E0E8206BE
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 08:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbgF3InD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 04:43:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:57326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgF3InD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jun 2020 04:43:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3906AD5C;
        Tue, 30 Jun 2020 08:43:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4629CDA790; Tue, 30 Jun 2020 10:42:46 +0200 (CEST)
Date:   Tue, 30 Jun 2020 10:42:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 6/8] btrfs: Use shared inode lock for direct writes
 within EOF
Message-ID: <20200630084245.GT27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20200622162017.21773-1-rgoldwyn@suse.de>
 <20200622162017.21773-7-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622162017.21773-7-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 22, 2020 at 11:20:15AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This is to parallelize direct writes within EOF or with direct I/O
> reads. This covers the race with truncate() accidentally increasing the
> filesize.

Please describe the race condition in more detail and how the DIO/EOF
parallelization is supposed to work.

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/file.c | 25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index aa6be931620b..c446a4aeb867 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1957,12 +1957,18 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	loff_t endbyte;
>  	int err;
>  	size_t count = 0;
> -	bool relock = false;
>  	int flags = IOMAP_DIOF_PGINVALID_FAIL;
>  	int ilock_flags = 0;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		ilock_flags |= BTRFS_ILOCK_TRY;
> +	/*
> +	 * If the write DIO within EOF,  use a shared lock
> +	 */
> +	if (pos + count <= i_size_read(inode))

Inode size is now read outside of the inode lock, so it could change
until the lock is taken a few lines below.

> +		ilock_flags |= BTRFS_ILOCK_SHARED;
> +	else if (iocb->ki_flags & IOCB_NOWAIT)
> +		return -EAGAIN;
>  
>  	err = btrfs_inode_lock(inode, ilock_flags);

Is it necessary to revalidate that 'pos + count < i_size' still holds
when the lock was taken as SHARED?
