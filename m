Return-Path: <SRS0=SPQA=3Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC84C35247
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 22:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 650252082E
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgBDWF2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 17:05:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:40752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgBDWF2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Feb 2020 17:05:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AF377AD07;
        Tue,  4 Feb 2020 22:05:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 19370DA80D; Tue,  4 Feb 2020 23:05:12 +0100 (CET)
Date:   Tue, 4 Feb 2020 23:05:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH 01/44] btrfs: push __setup_root into btrfs_alloc_root
Message-ID: <20200204220512.GH2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
References: <20200124143301.2186319-1-josef@toxicpanda.com>
 <20200124143301.2186319-2-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124143301.2186319-2-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 24, 2020 at 09:32:18AM -0500, Josef Bacik wrote:
> @@ -2645,8 +2639,10 @@ int __cold open_ctree(struct super_block *sb,
>  	int clear_free_space_tree = 0;
>  	int level;
>  
> -	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
> -	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
> +	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info,
> +					BTRFS_ROOT_TREE_OBJECTID, GFP_KERNEL);
> +	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info,
> +					BTRFS_CHUNK_TREE_OBJECTID, GFP_KERNEL);

Chaned assignments should be split to individual assignments when the code
is changed. Updated.
