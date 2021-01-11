Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D24DC433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Jan 2021 22:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E55522D07
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Jan 2021 22:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390167AbhAKWZt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:25:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:39956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390157AbhAKWZs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jan 2021 17:25:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32CD0B76C;
        Mon, 11 Jan 2021 22:25:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3B4BDDA701; Mon, 11 Jan 2021 23:23:15 +0100 (CET)
Date:   Mon, 11 Jan 2021 23:23:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 11/13] btrfs: keep track of the root owner for relocation
 reads
Message-ID: <20210111222315.GN6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1608135557.git.josef@toxicpanda.com>
 <1daf94fcbd66162c6b227404e2e0db257ca1c91c.1608135557.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1daf94fcbd66162c6b227404e2e0db257ca1c91c.1608135557.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 16, 2020 at 11:22:15AM -0500, Josef Bacik wrote:
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -98,6 +98,7 @@ struct tree_block {
>  		u64 bytenr;
>  	}; /* Use rb_simple_node for search/insert */
>  	struct btrfs_key key;
> +	u64 owner;
>  	unsigned int level:8;
>  	unsigned int key_ready:1;

This would probably lead to bad packing, key is 17 bytes and placing
u64 after that adds 7 bytes for proper alignment. The bitfield members
following the key are aligned to a byte so it would work if owner is
before key.
