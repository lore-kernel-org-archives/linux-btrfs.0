Return-Path: <SRS0=7Ay/=BY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF169C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Aug 2020 14:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90185207DA
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Aug 2020 14:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgHNOmr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 10:42:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgHNOmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Aug 2020 10:42:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3C97CABE2;
        Fri, 14 Aug 2020 14:43:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6E5D4DA6EF; Fri, 14 Aug 2020 16:41:43 +0200 (CEST)
Date:   Fri, 14 Aug 2020 16:41:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 09/17] btrfs: add nesting tags to the locking helpers
Message-ID: <20200814144143.GX2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200810154242.782802-1-josef@toxicpanda.com>
 <20200810154242.782802-10-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810154242.782802-10-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 10, 2020 at 11:42:34AM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/locking.h
> +++ b/fs/btrfs/locking.h
> @@ -16,12 +16,18 @@
>  #define BTRFS_WRITE_LOCK_BLOCKING 3
>  #define BTRFS_READ_LOCK_BLOCKING 4
>  
> +enum btrfs_lock_nesting {
> +	BTRFS_NESTING_NORMAL = 0,

It should be safe to use the enum auto numbering, that starts from 0.
