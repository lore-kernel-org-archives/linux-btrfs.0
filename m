Return-Path: <SRS0=sQVi=6Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B381AC47255
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 May 2020 19:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99CA320752
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 May 2020 19:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgEKTV6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 May 2020 15:21:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:38908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgEKTV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 May 2020 15:21:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4CE7EB115;
        Mon, 11 May 2020 19:22:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1A23CDA82A; Mon, 11 May 2020 21:21:06 +0200 (CEST)
Date:   Mon, 11 May 2020 21:21:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] btrfs: Introduce new incompat feature
 SKINNY_BG_TREE to hugely reduce mount time
Message-ID: <20200511192106.GZ18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200504235825.4199-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504235825.4199-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 05, 2020 at 07:58:18AM +0800, Qu Wenruo wrote:
> Qu Wenruo (7):
>   btrfs: block-group: Don't set the wrong READA flag for
>     btrfs_read_block_groups()
>   btrfs: block-group: Refactor how we read one block group item
>   btrfs: block-group: Refactor how we delete one block group item
>   btrfs: block-group: Refactor how we insert a block group item
>   btrfs: block-group: Rename write_one_cahce_group()
>   btrfs: Introduce new incompat feature, SKINNY_BG_TREE, to hugely
>     reduce mount time
>   btrfs: tree-checker: Introduce checks for skinny block group item

Patches 1-5 added to misc-next as they're good cleanups.
