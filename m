Return-Path: <SRS0=gdyl=Y4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08E7CA9EB5
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFA2320848
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfKDTzV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 14:55:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:47706 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728346AbfKDTzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Nov 2019 14:55:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46B0EAE5E;
        Mon,  4 Nov 2019 19:55:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA5A1DB6FC; Mon,  4 Nov 2019 20:55:27 +0100 (CET)
Date:   Mon, 4 Nov 2019 20:55:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v3 2/3] btrfs: block-group: Refactor
 btrfs_read_block_groups()
Message-ID: <20191104195527.GF3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Anand Jain <anand.jain@oracle.com>
References: <20191010023928.24586-1-wqu@suse.com>
 <20191010023928.24586-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010023928.24586-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 10, 2019 at 10:39:27AM +0800, Qu Wenruo wrote:
> +static int read_one_block_group(struct btrfs_fs_info *info,
> +				struct btrfs_path *path,
> +				int need_clear)
> +{
> +	struct extent_buffer *leaf = path->nodes[0];
> +	struct btrfs_block_group_cache *cache;
> +	struct btrfs_space_info *space_info;
> +	struct btrfs_key key;
> +	int mixed = btrfs_fs_incompat(info, MIXED_GROUPS);
> +	int slot = path->slots[0];
> +	int ret;
> +
> +	btrfs_item_key_to_cpu(leaf, &key, slot);

The first thing done here is the same as in the caller:

> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +		ret = read_one_block_group(info, path, need_clear);

The key can be passed by pointer so it's not on stack and the conversion
can be removed. I left it in the patch, please send a followup. Thanks.
