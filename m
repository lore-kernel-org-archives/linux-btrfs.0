Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B195FC64ED6
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Feb 2023 18:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjB0StI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 13:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjB0StH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2023 13:49:07 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB54021A32
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2023 10:49:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7D8201FD79;
        Mon, 27 Feb 2023 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677523745;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kGeUBBFymblrhJljNI/nzFINYw+DIYzrJsObTOFJSmA=;
        b=g3Vl+wSOdIOx1sQfM/IJlKhXD9+t1WiRDbZ9wad97DeUqeCgbTJRnhdiYCThI07Zn81KeS
        fzB3CSZ/SAYw3IRkmHOtAQUcHqT5OpAAEYi9h7Y7VJW9/j+B7d4csOTsmp3oJbLMdImmhN
        s5zD+JZFep9jdY4Yt2YsrwSpe7+bABA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677523745;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kGeUBBFymblrhJljNI/nzFINYw+DIYzrJsObTOFJSmA=;
        b=ksnTO2Dbe0G9ZIzA2hZI2KCmCCOp2Zrc5WHFpqvScuMCE3l4Nm/0X/Jw6peLs+xInvA/TD
        dRiREV2D4+CXbTCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5FEE413A43;
        Mon, 27 Feb 2023 18:49:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gEJIFiH7/GOIAwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 27 Feb 2023 18:49:05 +0000
Date:   Mon, 27 Feb 2023 19:43:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix extent map logging bit not cleared for split
 maps after dropping range
Message-ID: <20230227184306.GG10580@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <252e68aaa353859c8041305443a988866350cb3c.1677502380.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <252e68aaa353859c8041305443a988866350cb3c.1677502380.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 27, 2023 at 12:53:56PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At btrfs_drop_extent_map_range() we are clearing the EXTENT_FLAG_LOGGING
> bit on a 'flags' variable that was not initialized. This makes static
> checkers complain about it, so initialize the 'flags' variable before
> clearing the bit.
> 
> In practice this has no consequences, because EXTENT_FLAG_LOGGING should
> not be set when btrfs_drop_extent_map_range() is called, as an fsync locks
> the inode in exclusive mode, locks the inode's mmap semaphore in exclusive
> mode too and it always flushes all delalloc.
> 
> Also add a comment about why we clear EXTENT_FLAG_LOGGING on a copy of the
> flags of the split extent map.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/Y%2FyipSVozUDEZKow@kili/
> Fixes: db21370bffbc ("btrfs: drop extent map range more efficiently")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
