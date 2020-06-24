Return-Path: <SRS0=nWHZ=AF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A79C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 07:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC37E206E2
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 07:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389889AbgFXHhP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:37:15 -0400
Received: from bang.steev.me.uk ([81.2.120.65]:46295 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389583AbgFXHhP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jun 2020 03:37:15 -0400
Received: from smtp.steev.me.uk ([2001:8b0:162c:10::25] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.93.0.4)
        id 1jnzy5-003a5W-Nh; Wed, 24 Jun 2020 08:37:13 +0100
MIME-Version: 1.0
Date:   Wed, 24 Jun 2020 08:37:13 +0100
From:   Steven Davies <btrfs-list@steev.me.uk>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: start deprecation of mount option inode_cache
In-Reply-To: <20200623185032.14983-1-dsterba@suse.com>
References: <20200623185032.14983-1-dsterba@suse.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <076d047d33676d78e882feb74a2f0c4f@steev.me.uk>
X-Sender: btrfs-list@steev.me.uk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2020-06-23 19:50, David Sterba wrote:
> @@ -827,6 +827,8 @@ int btrfs_parse_options(struct btrfs_fs_info
> *info, char *options,
>  			}
>  			break;
>  		case Opt_inode_cache:
> +			btrfs_warn(info,
> +	"the 'inode_cache' option is deprecated and will be stop working in 
> 5.11");

"will stop working", but perhaps "will have no effect from" might be 
more explicit.

-- 
Steven Davies
