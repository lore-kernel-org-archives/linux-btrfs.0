Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0CAC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Apr 2022 13:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346346AbiDANbw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 09:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiDANbu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2022 09:31:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C73276FBE;
        Fri,  1 Apr 2022 06:30:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7C173210EC;
        Fri,  1 Apr 2022 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648819799;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pbRJr7IPn8qeEu81RK3Y+vqOSQRcbz2LMBzi+HgbIr8=;
        b=TPMSwncJZtNw918WLa+hnrGEKvZieut+mublksy1AsW1fKAp3kqDx6QhzYCm0gjr3DjKGN
        YIDrpzZHz16i7J5g8VXY6aFuHmhgqgL8UI1CrMfMNrvT18N2Fzp1rLZ811jHeJ9xjbbRKS
        sBU+HNsM4/tzebwGmFzotiQvkWHA6QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648819799;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pbRJr7IPn8qeEu81RK3Y+vqOSQRcbz2LMBzi+HgbIr8=;
        b=PnsAKlVlpalyVK/QMAf1uoZqLPQbGAE63ACdZs5Q8Waq0BcpDskylPQby35lqHnyrLZvYw
        itMrDdGmwU/ZZODg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 6F8B4A3B93;
        Fri,  1 Apr 2022 13:29:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 64C3DDA7F3; Fri,  1 Apr 2022 15:26:00 +0200 (CEST)
Date:   Fri, 1 Apr 2022 15:26:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Nick Terrell <terrelln@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 2/2] btrfs: allocate page arrays using bulk page
 allocator
Message-ID: <20220401132600.GI15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Nick Terrell <terrelln@fb.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Nikolay Borisov <nborisov@suse.com>
References: <cover.1648669832.git.sweettea-kernel@dorminy.me>
 <ede1d39f7878ee2ed12c1526cc2ec358a2d862cf.1648669832.git.sweettea-kernel@dorminy.me>
 <20220331173525.GF15609@twin.jikos.cz>
 <f9493291-9981-d684-bf49-a551aaf08061@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9493291-9981-d684-bf49-a551aaf08061@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 31, 2022 at 02:19:07PM -0400, Sweet Tea Dorminy wrote:
> > Also in the xfs code there's memalloc_retry_wait() which is supposed to be
> > called when repeated memory allocation is retried. What was the reason
> > you removed it?
> 
> Trying to keep the behavior as close as possible to the existing behavior.

I see, makes sense.

> The current behavior of each alloc_page loop is to fail if alloc_page() 
> fails; in the worst case, alloc_pages_bulk_array() calls alloc_page() 
> after trying to get a batch, so I figured the worst case is still 
> basically a loop calling alloc_page() and failing if it ever fails.
> 
> Reading up on it, though, arguably the memalloc_retry_wait() should 
> already be in all the callsites, so maybe I should insert a patch in the 
> middle that just adds the memalloc_retry_wait() into 
> btrfs_alloc_page_array()? Since it's an orthogonal fixup to either the 
> refactoring or the conversion to alloc_pages_bulk_array()?

Yeah a separate patch with the reasonig about the potential effects is
better. The v3 is now in misc-next with the suggested loop refactoring,
so please send the memalloc_retry_wait() update on top of that. Thanks.
