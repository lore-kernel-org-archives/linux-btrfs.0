Return-Path: <SRS0=krxf=BK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74EFC433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 14:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C32762087C
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 14:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbgGaOIj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:08:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:58870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbgGaOIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Jul 2020 10:08:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AF599B5D4;
        Fri, 31 Jul 2020 14:08:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6C2F9DA82B; Fri, 31 Jul 2020 16:08:07 +0200 (CEST)
Date:   Fri, 31 Jul 2020 16:08:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v4] btrfs: trim: fix underflow in trim length to prevent
 access beyond device boundary
Message-ID: <20200731140807.GM3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20200731112911.115665-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731112911.115665-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jul 31, 2020 at 07:29:11PM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4720,6 +4720,18 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  	}
>  
>  	mutex_lock(&fs_info->chunk_mutex);
> +	/*
> +	 * Also clear any CHUNK_TRIMMED and CHUNK_ALLOCATED bits beyond the
> +	 * current device boundary.
> +	 * This shouldn't fail, as alloc_state should only utilize those two
> +	 * bits, thus we shouldn't alloc new memory for clearing the status.

If this fails or not depends on implementation details of
clear_extent_bits and this comment will get out of sync eventually, so I
don't think it should be that specific.

If the new_size is somewhere in the middle of an existing state, it'll
need to be split anyway, no?

alloc_state |-----+++++|
clear             |------------------------- ... (u64)-1|

So we'd need to keep the state "-" and unset bits only from "+", and
this will require a split.

But I still have doubts about just clearing the range, why are there any
device->alloc_state entries at all after device is shrunk? Using
clear_extent_bits here is not wrong if we look at the end result of
clearing the range, but otherwise it leaves some state information
and allocated memory behind.
