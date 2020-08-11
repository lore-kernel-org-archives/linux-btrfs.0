Return-Path: <SRS0=M5eb=BV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF109C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Aug 2020 14:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C937920782
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Aug 2020 14:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgHKOX1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:23:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:36334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgHKOX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Aug 2020 10:23:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 46FBBAECB;
        Tue, 11 Aug 2020 14:23:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1B1A0DA83C; Tue, 11 Aug 2020 16:22:25 +0200 (CEST)
Date:   Tue, 11 Aug 2020 16:22:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH] btrfs: super.c: Set compress_level=0 when using
 compress=lzo
Message-ID: <20200811142224.GS2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <marcos@mpdesouza.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>
References: <20200803195501.30528-1-marcos@mpdesouza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803195501.30528-1-marcos@mpdesouza.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 03, 2020 at 04:55:01PM -0300, Marcos Paulo de Souza wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -614,6 +614,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
>  				compress_type = "lzo";
>  				info->compress_type = BTRFS_COMPRESS_LZO;
> +				/* lzo does not expose compression levels */
> +				info->compress_level = 0;

I had that as a fixup in patches fixing the other message errors, with
info->compress_level = 1.

With level 0 it'll print

	btrfs_info(info, "%s %s compression, level %d",
		   (compress_force) ? "force" : "use",
		   compress_type, info->compress_level);


	"use lzo compression, level 0"

Which might be confusing as well, but super.c:btrfs_show_options will
not print the level in that case so I think it's fine with 0.
