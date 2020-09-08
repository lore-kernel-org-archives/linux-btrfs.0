Return-Path: <SRS0=ITJn=CR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000DAC43461
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C649F2087D
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgIHTQ4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:16:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731164AbgIHQDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Sep 2020 12:03:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7314EB012;
        Tue,  8 Sep 2020 12:41:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A620CDA781; Tue,  8 Sep 2020 14:40:03 +0200 (CEST)
Date:   Tue, 8 Sep 2020 14:40:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/4] btrfs: do not create raid sysfs entries under any
 locks
Message-ID: <20200908124003.GE28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1598996236.git.josef@toxicpanda.com>
 <2f140cd79a9738e72fc6da6ef4ba3635962dbf9c.1598996236.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f140cd79a9738e72fc6da6ef4ba3635962dbf9c.1598996236.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 01, 2020 at 05:40:38PM -0400, Josef Bacik wrote:
>  	}
>  
>  	list_for_each_entry(space_info, &info->space_info, list) {
> +		int i;
> +
> +		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
> +			if (list_empty(&space_info->block_groups[i]))
> +				continue;
> +			cache = list_first_entry(&space_info->block_groups[i],
> +						 struct btrfs_block_group,
> +						 list);
> +			btrfs_sysfs_add_block_group_type(cache);
> +		}
> +

I had the previous version of the patch pass fstests, with no lockdep
warnings and then realized it's not the v2 that depends on the 3rd patch
removing RCU from this list traversal.

btrfs_sysfs_add_block_group_type does not seem to be conflicting RCU in
this loop so now I'm undecided if v1 is ok or if we really need v2, sice
the patch 3 removing RCU seems suspicious.
