Return-Path: <SRS0=+t5r=WR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A477C3A59E
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Aug 2019 14:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76B2F21655
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Aug 2019 14:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfHUOfC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:35:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:41232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728763AbfHUOfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Aug 2019 10:35:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C86A6ABB1;
        Wed, 21 Aug 2019 14:35:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 882E7DA7DB; Wed, 21 Aug 2019 16:35:26 +0200 (CEST)
Date:   Wed, 21 Aug 2019 16:35:26 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Vladimir Panteleev <git@thecybershadow.net>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: Simplify parsing max_inline mount option
Message-ID: <20190821143526.GJ18575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Vladimir Panteleev <git@thecybershadow.net>,
        linux-btrfs@vger.kernel.org
References: <20190815020453.25150-1-git@thecybershadow.net>
 <20190815020453.25150-2-git@thecybershadow.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815020453.25150-2-git@thecybershadow.net>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 15, 2019 at 02:04:53AM +0000, Vladimir Panteleev wrote:
> - Avoid an allocation;
> - Properly handle non-numerical argument and garbage after numerical
>   argument.
> 
> Signed-off-by: Vladimir Panteleev <git@thecybershadow.net>
> ---
>  fs/btrfs/super.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f56617dfb3cf..6fe8ef6667f3 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -426,7 +426,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			unsigned long new_flags)
>  {
>  	substring_t args[MAX_OPT_ARGS];
> -	char *p, *num;
> +	char *p, *retptr;
>  	u64 cache_gen;
>  	int intarg;
>  	int ret = 0;
> @@ -630,22 +630,16 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			info->thread_pool_size = intarg;
>  			break;
>  		case Opt_max_inline:
> -			num = match_strdup(&args[0]);
> -			if (num) {
> -				info->max_inline = memparse(num, NULL);
> -				kfree(num);
> -
> -				if (info->max_inline) {
> -					info->max_inline = min_t(u64,
> -						info->max_inline,
> -						info->sectorsize);
> -				}
> -				btrfs_info(info, "max_inline at %llu",
> -					   info->max_inline);
> -			} else {
> -				ret = -ENOMEM;
> +			info->max_inline = memparse(args[0].from, &retptr);

I don't think this is a good idea, match_strdup takes an opaque type
substring_t that is used by the parser. So accessing ::from directly in
memparse does not respect the API boundary. I've checked some other
usages in the tree and the match_strdup/memparse/kstrtoull is quite
common.
