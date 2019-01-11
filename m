Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4164CC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 13:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C0392084C
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 13:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbfAKNsi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 08:48:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:36556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732206AbfAKNsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 08:48:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5A04CAE86;
        Fri, 11 Jan 2019 13:48:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DE3ACDA780; Fri, 11 Jan 2019 14:48:04 +0100 (CET)
Date:   Fri, 11 Jan 2019 14:48:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1] Btrfs: Switch to use new generic UUID API
Message-ID: <20190111134803.GB27146@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <20190110181653.66048-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110181653.66048-1-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 10, 2019 at 08:16:53PM +0200, Andy Shevchenko wrote:
> There are new types and helpers that are supposed to be used in new code.
> 
> As a preparation to get rid of legacy types and API functions do
> the conversion here.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> - not tested on actual FS
>  fs/btrfs/disk-io.c     |  6 +++---
>  fs/btrfs/ioctl.c       | 12 ++----------
>  fs/btrfs/root-tree.c   |  4 +---
>  fs/btrfs/transaction.c |  7 +++----
>  4 files changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e0ad52804c26..f618661f5fa4 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1259,7 +1259,6 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *root;
>  	struct btrfs_key key;
>  	int ret = 0;
> -	uuid_le uuid = NULL_UUID_LE;
>  
>  	root = btrfs_alloc_root(fs_info, GFP_KERNEL);
>  	if (!root)
> @@ -1293,8 +1292,9 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>  	btrfs_set_root_last_snapshot(&root->root_item, 0);
>  	btrfs_set_root_dirid(&root->root_item, 0);
>  	if (is_fstree(objectid))
> -		uuid_le_gen(&uuid);
> -	memcpy(root->root_item.uuid, uuid.b, BTRFS_UUID_SIZE);
> +		guid_gen((guid_t *)&root->root_item.uuid);
> +	else
> +		guid_copy((guid_t *)&root->root_item.uuid, &guid_null);

I don't like the type casts, a simple wrapper would be better I think.
