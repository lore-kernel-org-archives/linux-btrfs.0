Return-Path: <SRS0=S4e4=CL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790E9C433E7
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B24E20639
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgIBPld (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:41:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:37406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgIBNoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Sep 2020 09:44:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F0E3B609;
        Wed,  2 Sep 2020 13:44:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C8005DA7CF; Wed,  2 Sep 2020 15:42:59 +0200 (CEST)
Date:   Wed, 2 Sep 2020 15:42:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH 1/2] btrfs: enumerate the type of exclusive operation in
 progress
Message-ID: <20200902134259.GJ28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Nikolay Borisov <nborisov@suse.com>
References: <20200825150233.30294-1-rgoldwyn@suse.de>
 <20200825150233.30294-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825150233.30294-2-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 25, 2020 at 10:02:32AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Instead of using a flag bit for exclusive operation, use an atomic_t
> variable to store if the exclusive operation is being performed.
> Introduce an API to start and finish an exclusive operation.

I think we don't need it to be atomic_t, the change must be atomic but
for that cmpxchg should be sufficient.

> +enum btrfs_exclusive_operation_t {
> +	BTRFS_EXCLOP_NONE = 0,
> +	BTRFS_EXCLOP_BALANCE,
> +	BTRFS_EXCLOP_DEV_ADD,
> +	BTRFS_EXCLOP_DEV_REPLACE,
> +	BTRFS_EXCLOP_DEV_REMOVE,
> +	BTRFS_EXCLOP_SWAP_ACTIVATE,
> +	BTRFS_EXCLOP_RESIZE,

Yeah this is much better than the single bit.
