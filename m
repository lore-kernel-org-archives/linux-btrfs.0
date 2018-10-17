Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6054FECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 11:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C11E2150D
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 11:16:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C11E2150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbeJQTMH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:12:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:45578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726904AbeJQTMH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 15:12:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB365AD21;
        Wed, 17 Oct 2018 11:16:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B54AADAD56; Wed, 17 Oct 2018 13:16:47 +0200 (CEST)
Date:   Wed, 17 Oct 2018 13:16:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 19/42] btrfs: set max_extent_size properly
Message-ID: <20181017111647.GB29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
 <20181012193256.13735-20-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012193256.13735-20-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 03:32:33PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We can't use entry->bytes if our entry is a bitmap entry, we need to use
> entry->max_extent_size in that case.  Fix up all the logic to make this
> consistent.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/free-space-cache.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index e077ad3b4549..2dd773e96530 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1770,6 +1770,13 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
>  	return -1;
>  }
>  
> +static inline u64 get_max_extent_size(struct btrfs_free_space *entry)
> +{
> +	if (entry->bitmap)
> +		return entry->max_extent_size;
> +	return entry->bytes;
> +}

> +			*max_extent_size = max(get_max_extent_size(entry),
> +					       *max_extent_size);

Looks reasonable.

Reviewed-by: David Sterba <dsterba@suse.com>
