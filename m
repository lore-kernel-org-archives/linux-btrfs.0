Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4441C4338F
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Aug 2021 16:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9865361357
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Aug 2021 16:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhHXQLi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 12:11:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42042 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhHXQLh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Aug 2021 12:11:37 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A0D9D22114;
        Tue, 24 Aug 2021 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629821452;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iMByRvLHqLb8ptphpEOjwAm4bnWLeqfkO/xkMu/4vsw=;
        b=ZynHjnnsMgf30GM6nSUSwtQpsR/w2KviQD2O2aQA3W+OOdDdMG151segIPWK7vnUGf6H/D
        iR6Y2zJCx4uOs67aiGNG8T/WX27OAKbnHGGBSPE0uEd5fBDRt8Pf2HR6dpmTrmV4HysioP
        7Znut2ncqxdr5Wd22VChqwEF86ItJyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629821452;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iMByRvLHqLb8ptphpEOjwAm4bnWLeqfkO/xkMu/4vsw=;
        b=O9Ztmed9stxNN0AkDZQR4ZFFh3blnS2dKvtm+7qd+zn0ZCMKOfK80lry2t82fas7u845AP
        ae7TU9NrCz+B33Cg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 9848DA3B8A;
        Tue, 24 Aug 2021 16:10:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9BDEADA85B; Tue, 24 Aug 2021 18:08:05 +0200 (CEST)
Date:   Tue, 24 Aug 2021 18:08:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 0/4] btrfs-progs: image: new data dump feature
Message-ID: <20210824160805.GC3379@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210824074108.44759-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824074108.44759-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 24, 2021 at 03:41:04PM +0800, Qu Wenruo wrote:
> v7:
> - Rebased to latest devel branch
>   No conflicts at all.
> 
> - Hide the data dump feature behind the experimental features
>   Now to make "btrfs-image -d" work, one must enable experimental
>   features, or "btrfs-image -d" will only output an error message.
> 
>   And if experimental features are not enabled, the new header format
>   will also be disabled, so that btrfs-image can't detect the new format
>   either.
> 
>   Although the "-d" option is still enabled for the non-experimental
>   build.

Thanks.  I've created issue #394 for tracking, with label 'experimental'
so we know what's in progress. If there are separate tasks related to
that then they could be tracked in other issues and referenced from that
one.
