Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D471C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 17:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A7E620865
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 17:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A7E620865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbeJMBEV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 21:04:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:38546 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbeJMBEV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 21:04:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5404CAD83;
        Fri, 12 Oct 2018 17:30:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11915DA862; Fri, 12 Oct 2018 19:30:44 +0200 (CEST)
Date:   Fri, 12 Oct 2018 19:30:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, fdmanana@suse.com
Subject: Re: [PATCH 19/42] btrfs: set max_extent_size properly
Message-ID: <20181012173043.GW29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, fdmanana@suse.com
References: <20181011195431.3441-1-josef@toxicpanda.com>
 <20181011195431.3441-20-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011195431.3441-20-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 03:54:08PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We can't use entry->bytes if our entry is a bitmap entry, we need to use
> entry->max_extent_size in that case.  Fix up all the logic to make this
> consistent.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/free-space-cache.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index e077ad3b4549..2e96ee7da3ec 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1770,6 +1770,18 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
>  	return -1;
>  }
>  
> +static void set_max_extent_size(struct btrfs_free_space *entry,

I find this a bit confusing, in the code it's like

	set_max_extent_size(entry, max_extent_size)

so it reads like 'set max extent size of the entry to value', while the
function does the opposite. That the 2nd parameter is a pointer does not
help either.  A function comment explaining that would not help as it's
confusing at the callsites.

	*max_extent_size = get_max_extent_size(entry, *max_extent_size)

This is more obvious what it does but can't be called an improvement
regarding readability. Other ideas?
