Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D201C432BE
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Aug 2021 11:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF18560FD8
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Aug 2021 11:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhHaLCo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 07:02:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40296 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhHaLCn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Aug 2021 07:02:43 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BEE2A20155;
        Tue, 31 Aug 2021 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630407707;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ik/ID/vRcgjxYFgpaTTJGjLSR5TRtTdkZ7Lm3eOAAw=;
        b=Vjy7HIENH6JOsTKERd9ATPfpt2O1S3KtETICaQHGREk/OWsSA0c0cToyrWy9du/VWmFk5j
        TDHtmgfWuzFSIPMAU44k6HnCrM8Zu6yFRGmS5Rlcv7sp4jQmOZiUSGXJbBAHLj99vj632G
        dQYsNRUHEcpB1N7l8uHuKJwSIVBVYiI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630407707;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ik/ID/vRcgjxYFgpaTTJGjLSR5TRtTdkZ7Lm3eOAAw=;
        b=kSKlwYnEvzyfU/4gJuIx9NgP/dmihS4MoBWtBXqhd4MFf70PyLfbD/22w7SJQ3lIcBCKSf
        vZVAsNWBMhUMJmBA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id B990DA3B9C;
        Tue, 31 Aug 2021 11:01:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04E41DA733; Tue, 31 Aug 2021 12:58:56 +0200 (CEST)
Date:   Tue, 31 Aug 2021 12:58:56 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: change wrong header in misc.h
Message-ID: <20210831105856.GD3379@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Kari Argillander <kari.argillander@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20210830215152.269516-1-kari.argillander@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830215152.269516-1-kari.argillander@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 31, 2021 at 12:51:52AM +0300, Kari Argillander wrote:
> asm/do_div.h is probably for div_u64, but it is found in math64.h. This
> change will make compiler job easier and prevent compiler errors in
> situation where compiler will not find math64.h from another paths.
> 
> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>

Added to misc-next, thanks.
