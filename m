Return-Path: <SRS0=avBk=YQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8513BCA9EB9
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 16:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A1821906
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 16:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfJWQuw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 12:50:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:57684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726360AbfJWQuw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Oct 2019 12:50:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2C83AEEC;
        Wed, 23 Oct 2019 16:50:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 27165DA734; Wed, 23 Oct 2019 18:51:03 +0200 (CEST)
Date:   Wed, 23 Oct 2019 18:51:02 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: save i_size in compress_file_range
Message-ID: <20191023165102.GC3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <20191011130354.8232-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130354.8232-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 11, 2019 at 09:03:54AM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -474,6 +474,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
>  	u64 start = async_chunk->start;
>  	u64 end = async_chunk->end;
>  	u64 actual_end;
> +	loff_t i_size = i_size_read(inode);
>  	int ret = 0;
>  	struct page **pages = NULL;
>  	unsigned long nr_pages;
> @@ -488,7 +489,13 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
>  	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
>  			SZ_16K);
>  
> -	actual_end = min_t(u64, i_size_read(inode), end + 1);
> +	/*
> +	 * We need to save i_size before now because it could change in between
> +	 * us evaluating the size and assigning it.  This is because we lock and
> +	 * unlock the page in truncate and fallocate, and then modify the i_size
> +	 * later on.
> +	 */
> +	actual_end = min_t(u64, i_size, end + 1);

Ping. This is not a future proof fix, please update the changelog and
code according to the reply I sent.
