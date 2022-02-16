Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07338C433FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Feb 2022 21:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiBPVjM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:39:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBPVjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Feb 2022 16:39:11 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4423328DDC7
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Feb 2022 13:38:58 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EB48D1F37D;
        Wed, 16 Feb 2022 21:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645047536;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LlYnrtwGvDng9oNYIpZbyHIglnevIIacr2jSGjQGNWc=;
        b=XVBlMupumLgwQVfhtdcjowI4ColVU7bnBiMEswaEh0TqhYtCAYmqN2v0nyD65Nndsm4mIX
        B7L4DmAePfS/daAfW7UKhtgI9xtV8OCnKaGZTcXIwXxNffbM7OSZFA6eoaAgs7hodU/Ggb
        RdUhfjMPZ9aBHcmXvol/OX+HkuXi2+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645047536;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LlYnrtwGvDng9oNYIpZbyHIglnevIIacr2jSGjQGNWc=;
        b=rw34Ct97C+clPe5YOtXl+9TRAkKWYpRx5kqQGjZZIFLBC87300ivsRMVjUfEVlk8KjJIhj
        D/a4pqVf1Pz5xTAg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id E4652A3B83;
        Wed, 16 Feb 2022 21:38:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39209DA823; Wed, 16 Feb 2022 22:35:12 +0100 (CET)
Date:   Wed, 16 Feb 2022 22:35:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: check: fix check_global_roots_uptodate
Message-ID: <20220216213512.GQ12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <b7bc0aeae661b1aa87f6e8eb331334c756ecb33e.1644351986.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7bc0aeae661b1aa87f6e8eb331334c756ecb33e.1644351986.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 08, 2022 at 03:26:58PM -0500, Josef Bacik wrote:
> While running make test on other patches I noticed we are now
> segfaulting on the fuzz tests.  This is because when I converted us to a
> rb tree for the global roots we lost the ability to catch that there's
> no extent root at all.  Before we'd populate a dummy
> fs_info->extent_root with a not uptodate node, but now you simply don't
> get an extent root in the rb_tree.  Fix the check_global_roots_uptodate
> helper to count how many roots we find and make sure it matches the
> number we expect.  If it doesn't then we can return -EIO.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to devel, thanks.
