Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C4BC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Sep 2021 12:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2CB961268
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Sep 2021 12:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344283AbhIXMsv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 08:48:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58890 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344141AbhIXMr7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Sep 2021 08:47:59 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 769B822432;
        Fri, 24 Sep 2021 12:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632487585;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lWxt7iwi1AeXYGhgO1Lus9VshDVak1305I+XWfLG//c=;
        b=z/CtKcS9zFG4Y1dfj/x9HbjbeGbhFoaCmgdUBYLrnxI/AsQgKwP25pnRDski++DmbbsKW7
        kAIluRY/RF1u/MjCwu1h7aie6pSJ80TaRyVbcYOHJgVuJueVVyaABkkegMzNKSdPA8GzrS
        +dk6pBjVmqNOuVdgTcqoKUwUuitFdAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632487585;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lWxt7iwi1AeXYGhgO1Lus9VshDVak1305I+XWfLG//c=;
        b=iVq7BS7C5Dw7EUSv0r/rk/A0hdL+mJzkeyLhIyKU99cFtS5otFSCUcH4/rV6gBKn3zOZ+2
        eanM5ap39A5WrqDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay1.suse.de (Postfix) with ESMTP id 6F2ED25D5E;
        Fri, 24 Sep 2021 12:46:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82588DA799; Fri, 24 Sep 2021 14:46:11 +0200 (CEST)
Date:   Fri, 24 Sep 2021 14:46:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2 1/2] btrfs: make sure btrfs_io_context::fs_info is
 always initialized
Message-ID: <20210924124610.GB9286@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20210924053053.16100-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924053053.16100-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 24, 2021 at 01:30:52PM +0800, Qu Wenruo wrote:
> Currently btrfs_io_context::fs_info is only initialized in
> btrfs_map_bio(), but there are call sites like btrfs_map_sblock()
> which calls __btrfs_map_block() directly, leaving bioc::fs_info
> uninitialized (NULL).
> 
> Currently this is fine, but later cleanup will rely on bioc::fs_info to
> grab fs_info, and this can be a hidden problem for such usage.
> 
> This patch will remove such hidden uninitialized member by always
> assigning bioc::fs_info at alloc_btrfs_io_context().
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Fix the wrong function name in the commit message

I fixed that in v1 already, but made sure v2 is the same code-wise. Now
in misc-next, thanks.
