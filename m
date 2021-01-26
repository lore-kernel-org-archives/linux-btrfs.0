Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B03C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EBB2072C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314341AbhAZXF1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:05:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:36486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392048AbhAZSII (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jan 2021 13:08:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 78C9DACC6;
        Tue, 26 Jan 2021 18:07:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 96C45DA7D2; Tue, 26 Jan 2021 19:05:37 +0100 (CET)
Date:   Tue, 26 Jan 2021 19:05:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Roman Anasal <roman.anasal@bdsu.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: send: use struct send_ctx *sctx for
 btrfs_compare_trees and changed_cb
Message-ID: <20210126180537.GT1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Roman Anasal <roman.anasal@bdsu.de>,
        linux-btrfs@vger.kernel.org
References: <20210125194325.24269-1-roman.anasal@bdsu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125194325.24269-1-roman.anasal@bdsu.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 25, 2021 at 08:43:25PM +0100, Roman Anasal wrote:
> btrfs_compare_trees and changed_cb use a void *ctx parameter instead of
> struct send_ctx *sctx but when used in changed_cb it is immediately
> casted to `struct send_ctx *sctx = ctx;`.
> 
> changed_cb is only ever called from btrfs_compare_trees and full_send_tree:
> - full_send_tree already passes a struct send_ctx *sctx
> - btrfs_compare_trees is only called by send_subvol with a struct send_ctx *sctx
> - void *ctx in btrfs_compare_trees is only used to be passed to changed_cb
> 
> So casting to/from void *ctx seems unnecessary and directly using
> struct send_ctx *sctx instead provides better type-safety.
> 
> The original reason for using void *ctx in the first place seems to have
> been dropped with
> 1b51d6f ("btrfs: send: remove indirect callback parameter for changed_cb")
> 
> Signed-off-by: Roman Anasal <roman.anasal@bdsu.de>

Makes sense, added to misc-next, thanks.
