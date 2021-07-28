Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A6EC4338F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jul 2021 12:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAB360FC2
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jul 2021 12:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbhG1MuQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 08:50:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42324 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbhG1MuP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jul 2021 08:50:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 60CDD1FFA6;
        Wed, 28 Jul 2021 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627476613;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tKv8fl5qQxSCbokW1Zc/e1B2jFRjIjFKdYiMDzPPLdE=;
        b=BSxTJI+qwHLnzA8CZkfWutD1+bxUZam1AKg0VXSXzi0y3iNifp3JUD1O+Sf+agPhXtIeeW
        CRRUMGD217do1c4BpHrxXLYd7lgO0Q7XbN7EwznRmqP5Tepne/GE+0AJVt4ik7x93RtpVs
        x/QZa/rfn3ICjfXM3MNiZC0y6tgZHJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627476613;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tKv8fl5qQxSCbokW1Zc/e1B2jFRjIjFKdYiMDzPPLdE=;
        b=1FZUZgqCQVM17jkrxgh7Ytf9+5Kg29vojEkNcORo0UqVttYf/oH4Tp2ubI8WekJ5dhUMeb
        wJ1SM59JTpjNx3Cg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 58248A3B84;
        Wed, 28 Jul 2021 12:50:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32D3DDA8A7; Wed, 28 Jul 2021 14:47:28 +0200 (CEST)
Date:   Wed, 28 Jul 2021 14:47:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove the dead comment in writepage_delalloc()
Message-ID: <20210728124727.GC5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210728060505.105119-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728060505.105119-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 28, 2021 at 02:05:05PM +0800, Qu Wenruo wrote:
> When btrfs_run_delalloc_range() failed, we will error out.
> 
> But there is a strange comment mentioning that
> btrfs_run_delalloc_range() could have return value >0 to indicate the IO
> has already started.
> 
> Commit 40f765805f08 ("Btrfs: split up __extent_writepage to lower stack
> usage") introduced the comment, but unfortunately at that time, we are
> already using @page_started to indicate that case, and still return 0.
> 
> Furthermore, even if that comment is right (which is not), we would
> return -EIO if the IO is already started.
> 
> By all means the comment is incorrect, just remove the comment along
> with the dead check.
> 
> Just to be extra safe, add an ASSERT() in btrfs_run_delalloc_range() to
> make sure we either return 0 or error, no positive return value.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
