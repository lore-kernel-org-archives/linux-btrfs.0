Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7B4C11F64
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Jul 2021 19:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0076140D
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Jul 2021 19:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhGAT02 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Jul 2021 15:26:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50864 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbhGAT02 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jul 2021 15:26:28 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5E3BB22948;
        Thu,  1 Jul 2021 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1625167436;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ec1Wvm1jBgCIeh/XOZ2vSygh1qfV1SrngVLWjTq73UE=;
        b=2McERlLUjasVzZOOcCiJhbHnDbv/bum0B4GG7pI1ggRjb6gh/dghbDOxs5fl4gxnWRksIR
        16IH4yuutX5aRz+ntoQYezoHHggmW94tDUThphNe4C7w7kiyCibnmdkmPANAuL9pJsnHEf
        6Apee5XpZ+8JJosuJu/1NUIhH6ElWME=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1625167436;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ec1Wvm1jBgCIeh/XOZ2vSygh1qfV1SrngVLWjTq73UE=;
        b=21Uv5bU0W6EVWp5novF0lM8jTyIQRSm8zfsL+V9tvBWmnmnwraCsmc29lVzsvDEkP3LLVa
        FUET2RcVzKCBvIAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 57C2DA3B89;
        Thu,  1 Jul 2021 19:23:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ADE79DA6FD; Thu,  1 Jul 2021 21:21:25 +0200 (CEST)
Date:   Thu, 1 Jul 2021 21:21:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Dave Sterba <DSterba@suse.com>
Subject: Re: [PATCH] btrfs-progs: Correct check_running_fs_exclop() return
 value
Message-ID: <20210701192125.GA2610@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Dave Sterba <DSterba@suse.com>
References: <20210628194000.org5zuvytk34yvwy@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628194000.org5zuvytk34yvwy@fiona>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 28, 2021 at 02:40:00PM -0500, Goldwyn Rodrigues wrote:
> check_running_fs_exclop() can return 1 when exclop is changed to "none"
> The ret is set by the return value of the select() operation. Checking
> the exclusive op changes just the exclop variable while ret is still
> set to 1.
> 
> Set ret = 0 if exclop is set to BTRFS_EXCL_NONE or BTRFS_EXCL_UNKNOWN.
> Remove unnecessary continue statement at the end of the block.

That's describing what the code does in words, but there must be some
user visible effects like failed command. Do you have some reproducer?

I've applied patch as it's a fix but would still like to update the
changelog.
