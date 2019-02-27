Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B78EC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A2ED2133D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfB0NfL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:35:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:46008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730073AbfB0NfK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 08:35:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB10DAF3A;
        Wed, 27 Feb 2019 13:35:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9212DDA83C; Wed, 27 Feb 2019 14:36:30 +0100 (CET)
Date:   Wed, 27 Feb 2019 14:36:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH 1/5] btrfs: extent_io: Add comment about the return value
 of alloc_extent_buffer()
Message-ID: <20190227133630.GJ24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <20190222101645.4403-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222101645.4403-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 22, 2019 at 06:16:40PM +0800, Qu Wenruo wrote:
> To inform later developers how to check the return value of it.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent_io.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 52abe4082680..b28a75546700 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4890,6 +4890,13 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>  }
>  #endif
>  
> +/*
> + * Allocate an extent buffer structure, with all its pages attached and locked.
> + *
> + * Return valid pointer if nothing goes wrong.
> + * Return PTR_ERR() if failed.
> + * Will never return NULL.

I'd rather drop this as it depends on another function and the
GFP_NOFAIL flag that will be removed eventually. The PTR_ERR covers
ENOMEM and allocation failures.
