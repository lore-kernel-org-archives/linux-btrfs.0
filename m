Return-Path: <SRS0=hLwB=EC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4E9C55178
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Oct 2020 11:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3855E204FD
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Oct 2020 11:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898281AbgJ0LSH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 07:18:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:42110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508741AbgJ0LSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Oct 2020 07:18:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1679AB2E5;
        Tue, 27 Oct 2020 11:18:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32A57DA6E2; Tue, 27 Oct 2020 12:16:32 +0100 (CET)
Date:   Tue, 27 Oct 2020 12:16:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 18/68] btrfs: extent_io: calculate inline extent
 buffer page size based on page size
Message-ID: <20201027111632.GB6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201021062554.68132-1-wqu@suse.com>
 <20201021062554.68132-19-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021062554.68132-19-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 21, 2020 at 02:25:04PM +0800, Qu Wenruo wrote:
> -#define INLINE_EXTENT_BUFFER_PAGES 16
> -#define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE)
> +/*
> + * The SZ_64K is BTRFS_MAX_METADATA_BLOCKSIZE, here just to avoid circle
> + * including "ctree.h".

This should be moved to features.h instead of the duplicate definition.

> + */
> +#define INLINE_EXTENT_BUFFER_PAGES (SZ_64K / PAGE_SIZE)

