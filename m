Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF67C2D0DC
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 15:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE712084D
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 15:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgABPVW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 10:21:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:52288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbgABPVW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jan 2020 10:21:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A70F1AD14;
        Thu,  2 Jan 2020 15:21:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F2EFADA790; Thu,  2 Jan 2020 16:21:12 +0100 (CET)
Date:   Thu, 2 Jan 2020 16:21:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Move and unexport btrfs_rmap_block
Message-ID: <20200102152112.GI3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191126155354.GH2734@twin.jikos.cz>
 <20191210175751.1618-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210175751.1618-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 10, 2019 at 07:57:51PM +0200, Nikolay Borisov wrote:
> It's used only during initial block group reading to map physical
> address of super block to a list of logical ones. Make it private to
> block-group.c, add proper kernel doc and ensure it's exported only for
> tests.

Btw that's not proper kernel doc formatting, I've fixed it.

> +/*

/**

> + * btrfs_rmap_block - Maps a particular @physical disk address to a list of @logical

One line with brief description

> + * addresses. Used primarily to exclude those portions of a block group that
> + * contain super block copies.
> + *
> + * chunk_start - Logical address of block group

@argument: description

> + * physical - Physical address to map to logical addresses
> + * logical - Return array of logical addresses which map to @physical
> + * naddrs - Length of @logical
> + * stripe_len - size of IO stripe for the given block group

And the long description is here

> + */
