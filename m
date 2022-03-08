Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046CFC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Mar 2022 17:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiCHR4P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 12:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiCHR4P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2022 12:56:15 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D005623D
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Mar 2022 09:55:18 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7117C1F380;
        Tue,  8 Mar 2022 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646762117;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vXvvgIfkDreH0C53P5yoBbOV9evTPQv34z1VwHVYRLY=;
        b=TflOSj5CDEev5UhQ7KCxXS22NFF4SHk9HplxF+cpXEBYLn1ispV/VVV/qDczbXOHLNTv3E
        aZdD46wFXshqVFP/ilgVvhvBcADZNVfdo2u+bNmbW7zsY4i9+WU3Zg933z9rg4d02Uvant
        GX+28IT4Xs6WG/sjYcSsARt5X95JaqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646762117;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vXvvgIfkDreH0C53P5yoBbOV9evTPQv34z1VwHVYRLY=;
        b=5KSOaRajzkDg+1RNcHuHuOYDOG7MGKI/fZ3lPiIgcPXAK6Bh6CyCw3a24CmOzP9Q5R+hgZ
        Ti+TXoO7ym5e+ZAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 670C9A3B85;
        Tue,  8 Mar 2022 17:55:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 49FACDA7DE; Tue,  8 Mar 2022 18:51:22 +0100 (CET)
Date:   Tue, 8 Mar 2022 18:51:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/2][RESEND] btrfs-progs: handle orphan directories
 properly
Message-ID: <20220308175122.GS12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1645568638.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645568638.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 22, 2022 at 05:24:29PM -0500, Josef Bacik wrote:
> v1->v2:
> - use "is_orphan" not "has_orphan_item" in the mode-lowmem code.  Somehow the
>   compiler didn't warn me of this until I switched to a different branch.
> 
> --- Original email ---
> Hello,
> 
> While implementing the garbage collection tree I started getting btrfsck errors
> when a test would do rm -rf DIRECTORY and then immediately unmount.  This is
> because we stop processing GC items during umount, and thus we left the
> directory with an nlink == 0 and all of its children in the fs tree.
> 
> However this isn't a problem with just the GC tree, we can have this happen if
> we fail to do the eviction work at evict time, and we leave the orphan entry in
> place on disk.  btrfsck properly ignores problems with inodes that have orphan
> items, except for directory inodes.
> 
> Fix this by making sure we don't add any backrefs we find from directory inodes
> that we've find the inode item for and have an nlink == 0.
> 
> I generated a test image for this by simply skipping the
> btrfs_truncate_inode_items() work in evict in a kernel and rm -rf'ing a
> directory on a test file system.
> 
> With this patch both make test-check and make test-check-lowmem pass all the
> tests, including the new testcase.  Thanks,
> 
> Josef
> 
> Josef Bacik (2):
>   btrfs-progs: handle orphan directories properly
>   btrfs-progs: add a test to check orphaned directories

Added to devel, thanks.
