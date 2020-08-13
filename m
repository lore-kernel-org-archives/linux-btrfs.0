Return-Path: <SRS0=PX3t=BX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3721C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 16:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C858520774
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 16:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgHMQvW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:51:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:53338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgHMQvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Aug 2020 12:51:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 87F53AB89;
        Thu, 13 Aug 2020 16:51:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DD2FBDA6EF; Thu, 13 Aug 2020 18:50:18 +0200 (CEST)
Date:   Thu, 13 Aug 2020 18:50:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH 15/23] btrfs: use ticketing for data space reservations
Message-ID: <20200813165018.GP2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Nikolay Borisov <nborisov@suse.com>
References: <20200721142234.2680-1-josef@toxicpanda.com>
 <20200721142234.2680-16-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721142234.2680-16-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 21, 2020 at 10:22:26AM -0400, Josef Bacik wrote:
> +static void priority_reclaim_data_space(struct btrfs_fs_info *fs_info,
> +					struct btrfs_space_info *space_info,
> +					struct reserve_ticket *ticket,
> +					const enum btrfs_flush_state *states,
> +					int states_nr)
> +{
> +	int flush_state = 0;
> +	int commit_cycles = 2;
> +
> +	while (!space_info->full) {
> +		flush_space(fs_info, space_info, U64_MAX, ALLOC_CHUNK_FORCE);
> +		spin_lock(&space_info->lock);
> +		if (ticket->bytes == 0) {
> +			spin_unlock(&space_info->lock);
> +			return;
> +		}
> +		spin_unlock(&space_info->lock);
> +	}

->full is checked unlocked, IIRC this is not a problem as it's sticky
once it's 1 then it won't change until the flushing is done and
everything else locks the space infos. So a comment would be good here.
