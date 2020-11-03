Return-Path: <SRS0=hn/e=EJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83859C388F9
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Nov 2020 13:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4277520731
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Nov 2020 13:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgKCND7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:03:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:60524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729179AbgKCNDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Nov 2020 08:03:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F4A4AC6F;
        Tue,  3 Nov 2020 13:03:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BE834DA7D2; Tue,  3 Nov 2020 14:01:23 +0100 (CET)
Date:   Tue, 3 Nov 2020 14:01:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v9 10/41] btrfs: disallow mixed-bg in ZONED mode
Message-ID: <20201103130123.GU6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <cover.1604065156.git.naohiro.aota@wdc.com>
 <1aec842d98f9b38674aebce12606b9267f475164.1604065695.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aec842d98f9b38674aebce12606b9267f475164.1604065695.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 30, 2020 at 10:51:17PM +0900, Naohiro Aota wrote:
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -257,6 +257,13 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
>  		goto out;
>  	}
>  
> +	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS)) {
> +		btrfs_err(fs_info,
> +			  "ZONED mode is not allowed for mixed block groups");

		"zoned: mixed block groups not supported"

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	fs_info->zone_size = zone_size;
>  	fs_info->max_zone_append_size = max_zone_append_size;
>  
> -- 
> 2.27.0
