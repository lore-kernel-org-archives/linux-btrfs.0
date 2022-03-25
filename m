Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1A3C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Mar 2022 20:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiCYUkS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiCYUkR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Mar 2022 16:40:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75DB163E2B
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2022 13:38:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A5C72210DF;
        Fri, 25 Mar 2022 20:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648240719;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P1dfwFee91W/PXLR2iXz+ahsMJup4Lx6tOvIw81E1P4=;
        b=GK0uGx8ZDaICh2tt5Y8gN+adiHGIJlBs7MjZ3wHsOJRH87oOFMBk91czznEZnOSoyO+MbF
        UcYGBMOU7zspkPWzT4+qp1T9rLYiuljBtjXb29ewNUq2E3oYxcrGEXE+FMbLsljvv64iOM
        zT+2oztCAriRqzZHZgyiHUmDZWMAX/A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648240719;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P1dfwFee91W/PXLR2iXz+ahsMJup4Lx6tOvIw81E1P4=;
        b=fmO+3QvohZTgkgbgsBcNfuZ4llaWA0PBoCiIHohcmSL4qAOpeOuuHI0QygebCfnTBLMUkS
        3w5tkcH6EL/dARBQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 9CDCCA3B82;
        Fri, 25 Mar 2022 20:38:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2BD65DA7F3; Fri, 25 Mar 2022 21:34:44 +0100 (CET)
Date:   Fri, 25 Mar 2022 21:34:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] btrfs: some speedups around nowait dio
Message-ID: <20220325203443.GN2237@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1648051582.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1648051582.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 23, 2022 at 04:19:22PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This patchset makes our direct IO code behave better for NOWAIT writes,
> avoiding blocking in several places for potentially long periods due to
> waits for IO. It also removes running the same nocow checks twice (which
> can be expensive) and doing extra path allocations. The last patch in
> the series has a test and the results I got before and after applying
> this patchset.
> 
> Filipe Manana (8):
>   btrfs: avoid blocking on page locks with nowait dio on compressed range
>   btrfs: avoid blocking nowait dio when locking file range
>   btrfs: avoid double nocow check when doing nowait dio writes
>   btrfs: stop allocating a path when checking if cross reference exists
>   btrfs: free path at can_nocow_extent() before checking for checksum items
>   btrfs: release path earlier at can_nocow_extent()
>   btrfs: avoid blocking when allocating context for nowait dio read/write
>   btrfs: avoid blocking on space revervation when doing nowait dio writes

Added to misc-next, thanks.
