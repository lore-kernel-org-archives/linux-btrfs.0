Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7790BC433F5
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 May 2022 19:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbiEIUBx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 May 2022 16:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiEIUBx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2022 16:01:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9790115EA57
        for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2022 12:57:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4BE0C1FA25;
        Mon,  9 May 2022 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652126276;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cdcyl0rXQTRSyRFi9cvKLlpgkB0u6F6ye+aFA1UPqJw=;
        b=lA/9ijGMM76bc8XB6X2GHBTqm71KBzJSBUEKTr0hVXTw+FadM0X54g8QRlUOWPIJ/KOl+L
        LI5U17N0VHzGc4uyvX/oNC5dmhEy/JW3sfEgVcgJmiJ8/huTa4xr9UpwPtR2S3+xKkbWVY
        hcBdGa2ZGO+LGFPxqHVzgchciFYoF+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652126276;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cdcyl0rXQTRSyRFi9cvKLlpgkB0u6F6ye+aFA1UPqJw=;
        b=0GfywTPnQX+vR8/F1zSIXwTy7vBnkSIov4I9Y5SH9fdeOI0siQbW7YG66N/9bmVlPZlhRQ
        TPEeGX5b/IruttBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2F45C132C0;
        Mon,  9 May 2022 19:57:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id H+WXCkRyeWJeCgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 09 May 2022 19:57:56 +0000
Date:   Mon, 9 May 2022 21:53:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not account twice for inode ref when reserving
 metadata units
Message-ID: <20220509195342.GH18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <bf988d76ebcb9003a16c6b3cd5d25ca94872b93e.1652109795.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf988d76ebcb9003a16c6b3cd5d25ca94872b93e.1652109795.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 09, 2022 at 04:29:14PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When reserving metadata units for creating an inode, we don't need to
> reserve one extra unit for the inode ref item because when creating the
> inode, at btrfs_create_new_inode(), we always insert the inode item and
> the inode ref item in a single batch (a single btree insert operation,
> and both ending up in the same leaf).
> 
> As we have accounted already one unit for the inode item, the extra unit
> for the inode ref item is superfluous, it only makes us reserve more
> metadata than necessary and often adding more reclaim pressure if we are
> low on available metadata space.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
