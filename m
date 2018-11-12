Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232CCC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 19:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B9822419
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 19:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2B9822419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbeKME5p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:57:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:53492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbeKME5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 23:57:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4DCAEAFFB
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 19:03:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 48501DAFAE; Mon, 12 Nov 2018 20:02:57 +0100 (CET)
Date:   Mon, 12 Nov 2018 20:02:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Remove unused extent_state argument from
 btrfs_writepage_endio_finish_ordered
Message-ID: <20181112190257.GP24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108081808.16920-1-nborisov@suse.com>
 <20181108081808.16920-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108081808.16920-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 08, 2018 at 10:18:08AM +0200, Nikolay Borisov wrote:
> This parameter was never used, yet was part of the interface of the
> function ever since its introduction as extent_io_ops::writepage_end_io_hook
> in e6dcd2dc9c48 ("Btrfs: New data=ordered implementation"). Now that
> NULL is passed everywhere as a value for this parameter let's remove it
> for good. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/compression.c |  6 ++++--
>  fs/btrfs/ctree.h       |  4 ++--
>  fs/btrfs/extent_io.c   | 12 +++++-------
>  fs/btrfs/inode.c       |  7 +++----
>  4 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index bde8d0487bbb..717d9300dd18 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -251,8 +251,10 @@ static void end_compressed_bio_write(struct bio *bio)
>  	tree = &BTRFS_I(inode)->io_tree;
>  	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
>  	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
> -			cb->start, cb->start + cb->len - 1, NULL,
> -			bio->bi_status ? BLK_STS_OK : BLK_STS_NOTSUPP);
> +					     cb->start,
> +					     cb->start + cb->len - 1,
> +					     bio->bi_status ?
> +					     BLK_STS_OK : BLK_STS_NOTSUPP);

Please not how the ternary operator had to be split to two lines just to
satisfy the 'arguments align under opening brace' formatting, that I
don't like but tolerate in many cases unless it looks too ugly or breaks
expression unnecessarily.
