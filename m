Return-Path: <SRS0=yEAK=XS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ED8C4CECF
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Sep 2019 16:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CEFC207FD
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Sep 2019 16:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbfIWQgM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 12:36:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:56892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732803AbfIWQgM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Sep 2019 12:36:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8CEE9AECA;
        Mon, 23 Sep 2019 16:36:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B82EADA871; Mon, 23 Sep 2019 18:36:32 +0200 (CEST)
Date:   Mon, 23 Sep 2019 18:36:32 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Small code style cleanup for ctree.c
Message-ID: <20190923163632.GL2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190910074019.23158-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910074019.23158-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 10, 2019 at 03:40:16PM +0800, Qu Wenruo wrote:
> Some small enhance found during the btrfs_verify_level_key() rework.
> 
> Qu Wenruo (3):
>   btrfs: ctree: Reduce one indent level for btrfs_search_slot()
>   btrfs: ctree: Reduce one indent level for btrfs_search_old_slot()
>   btrfs: ctree: Remove stalled comment of setting up path lock

Added to misc-next with some adjustments, thanks.
