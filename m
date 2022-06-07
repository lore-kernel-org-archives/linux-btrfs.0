Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606BDC43334
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jun 2022 15:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344411AbiFGPuS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344343AbiFGPuD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2022 11:50:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A10EAD31
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Jun 2022 08:50:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EBB301F989;
        Tue,  7 Jun 2022 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654617000;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HD9/2AwfrVZs6iM0c+K36RUv1jldHCmPEiW4BcgatSw=;
        b=WH0ehtzfIP6RD6h8ndtrTZF1qAU0fZugw3Q7eGmjZNq2ujZm7/8hDLxOlyUaUu8gtkluZc
        GA2GYnSSfi3JsiwJdwnit/njY0cKfguYHCMcAymv3RiSJLpRCu5lt+O++aGajflu/kGRZl
        WisN6vxdqmOO73UZY/5cMLUr/3kalDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654617000;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HD9/2AwfrVZs6iM0c+K36RUv1jldHCmPEiW4BcgatSw=;
        b=ENvrZ1JzA2+RSL5zfeq5GhX3e4BOm+hpttOli9JsuP6dOMlnYGeJzl/YyzAJ2Qwu+7+Wcq
        xxyS1C57qpRdNEAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA43B13638;
        Tue,  7 Jun 2022 15:50:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NeDFK6hzn2K/agAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 07 Jun 2022 15:50:00 +0000
Date:   Tue, 7 Jun 2022 17:45:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: make btrfs_super_block::log_root_transid
 deprecated
Message-ID: <20220607154531.GK20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
References: <d271efe6a00ed1b8de9150e96399636dedd38e3c.1654602650.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d271efe6a00ed1b8de9150e96399636dedd38e3c.1654602650.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 07, 2022 at 07:50:59PM +0800, Qu Wenruo wrote:
> When using "btrfs inspect-internal dump-super" to inspect an fs with
> dirty log, it always shows the log_root_transid as 0:
> 
>  log_root                30474240
>  log_root_transid        0 <<<
>  log_root_level          0
> 
> It turns out that, btrfs_super_block::log_root_transid is never really
> utilized (even no read for it).
> 
> This can date back to the introduction of btrfs into upstream kernel.
> 
> In fact, when reading log tree root, we always use
> btrfs_super_block::generation + 1 as the expected generation.
> So here we're completely safe to mark this member deprecated.
> 
> In theory we can easily reuse this member for other purposes, but to be
> extra safe, here we follow the leafsize way, by adding "__unused_" for
> log_root_transid.
> And we can safely remove the accessors, since there is no such callers
> from the very beginning.
> 
> Cc: Chris Mason <clm@fb.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
