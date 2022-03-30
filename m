Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2692C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349131AbiC3REX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347451AbiC3REW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Mar 2022 13:04:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06E3488B9;
        Wed, 30 Mar 2022 10:02:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6A19B1F37B;
        Wed, 30 Mar 2022 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648659755;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VasfWrK3j7IlwreFKwcLkVkctNFHSVe9eECMM7KKVk0=;
        b=SeScyn5F+d+mTlvsj79GjU0n0u5yr7BdDqjHQmkNGvqq88l0IaBR810NRiwF5ZMvh3wJZ2
        F1yGt4NbmvBUyC7o6JjYD0FtsQMk04jmVYnuUuYJLLbENPnfyyUbrtPF6Ar12/1hcj8QxI
        r01N1lFD0oWsGBOkotkx8wMBuhugb1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648659755;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VasfWrK3j7IlwreFKwcLkVkctNFHSVe9eECMM7KKVk0=;
        b=eBzgWcrujYbBcLoSAtCHXstgalLAqtPXfG2zn9HYzhh7mFu87JMTXNliQ7CknrnzL0g1wl
        XvT9sefOPI47tRDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 5D44DA3B83;
        Wed, 30 Mar 2022 17:02:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5AC53DA7F3; Wed, 30 Mar 2022 18:58:37 +0200 (CEST)
Date:   Wed, 30 Mar 2022 18:58:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Nick Terrell <terrelln@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/2] btrfs: allocate page arrays more efficiently
Message-ID: <20220330165837.GH2237@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Nick Terrell <terrelln@fb.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1648658235.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1648658235.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:44:05PM -0400, Sweet Tea Dorminy wrote:
> In several places, btrfs allocates an array of pages, one at a time.  In
> addition to duplicating code, the mm subsystem provides a helper to
> allocate multiple pages at once into an array which is suited for our
> usecase. In the fast path, the batching can result in better allocation
> decisions and less locking. This changeset first adjusts the users to
> call a common array-of-pages allocation function, then adjusts that
> common function to use the batch page allocator.
> 
> v2: moved new helper to extent_io.[ch]. Fixed title format.

It does not address comments from
https://lore.kernel.org/linux-btrfs/20220328230909.GW2237@twin.jikos.cz
