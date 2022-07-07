Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75974C433EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Jul 2022 16:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbiGGQge (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 12:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbiGGQgd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2022 12:36:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B2B4D4C7
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2022 09:36:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A32421FE2E;
        Thu,  7 Jul 2022 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657211791;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1Fboi7JfybtZj+SKxbAUkVxj41WGKq7qToDFUedJGM=;
        b=GOuVcK+bx8U/qD1Zm9gIBrtiuoS02ZsRnCcI2xE+e0Tu5RiOyg5wP9LylWieDxNY1TC49M
        LYijdJWllLv5hYff6qcqnn0kasYDMZb77bBnihmavpUZg+E2VVCvMy5aP43MblralJWF8O
        3gyoczlA8rbrKJLq+Dh823tl5hiBorE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657211791;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1Fboi7JfybtZj+SKxbAUkVxj41WGKq7qToDFUedJGM=;
        b=RP8nrrRdU/yWzxwjOqii5cDbTPZao2e44XgIZCjx06aBeirF9zpqXBktUyTqMuwrM0GqDZ
        MXyKDGdSrt+m4QAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 74FAA13A33;
        Thu,  7 Jul 2022 16:36:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vvOgG48Lx2K2aAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 07 Jul 2022 16:36:31 +0000
Date:   Thu, 7 Jul 2022 18:31:44 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 0/3] btrfs: fix a couple sleeps while holding a spinlock
Message-ID: <20220707163144.GG15169@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org, willy@infradead.org
References: <cover.1657097693.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657097693.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Adding Matthew to CC

On Wed, Jul 06, 2022 at 10:09:44AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After the recent conversions of a couple radix trees to XArrays, we now
> can end up attempting to sleep while holding a spinlock.

Ouch, I worked on the asumption that the old preload API is
transparently provided by xarray and that sleeping under spinlock won't
happen, otherwise the conversion from radix to xarray is not just an API
rename. Note that for some time the radix_tree structure was just an
alias for xarray, so this is not a new behaviour.
