Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B916BC433EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Apr 2022 15:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiDGPCa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 11:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiDGPC3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2022 11:02:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3725A1EFE11
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Apr 2022 08:00:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E28E41FDB6;
        Thu,  7 Apr 2022 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649343627;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UnKOMqoRRrfkhDUYPLS34Q8wFmUSnW/AcTZ7AMKvopY=;
        b=nom1LCmWGRis4Lg48is5Ql7jx7P4ev5ak9LFGW7OJZWotN469eV371O2P0/UQrjRyYy+Dj
        2NaJ04w1samSZzPrCTtS2OA1tgaeWWEijoH+Dss9K5f5o/ehTXYbAblgsOD03787sF4mVx
        jvM48nWRoN8GLedTtA/K7vkvnkT9SS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649343627;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UnKOMqoRRrfkhDUYPLS34Q8wFmUSnW/AcTZ7AMKvopY=;
        b=1Ng5P2/lLmkXzhbqPlBIBsg8GvNWL10o7vv2B+Ft+dcjmdoku4Iw+7neGmbdRtg0GRK1FD
        y7jTh3CzMfmcqfBA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id DBA82A3B8A;
        Thu,  7 Apr 2022 15:00:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ACB41DA80E; Thu,  7 Apr 2022 16:56:25 +0200 (CEST)
Date:   Thu, 7 Apr 2022 16:56:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix leaked plug after failure syncing log on
 zoned filesystems
Message-ID: <20220407145625.GG15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <c766f439fa12967383d8e62c6f5883bd1f62c483.1649245880.git.fdmanana@suse.com>
 <7950a1a3db370ab5f38e8da4f43b002e11397b18.1649261167.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7950a1a3db370ab5f38e8da4f43b002e11397b18.1649261167.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 06, 2022 at 05:07:54PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> On a zoned filesystem, if we fail to allocate the root node for the log
> root tree while syncing the log, we end up returning without finishing
> the IO plug we started before, resulting in leaking resources as we
> have started writeback for extent buffers of a log tree before. That
> allocation failure, which typically is either -ENOMEM or -ENOSPC, is not
> fatal and the fsync can safely fallback to a full transaction commit.
> 
> So release the IO plug if we fail to allocate the extent buffer for the
> root of the log root tree when syncing the log on a zoned filesystem.
> 
> Fixes: 3ddebf27fcd3a9 ("btrfs: zoned: reorder log node allocation on zoned filesystem")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Fixed typo in the subject, updated changelog.

Added to misc-next, thanks.
