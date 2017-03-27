Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44821 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753325AbdC0PXR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 11:23:17 -0400
Date: Mon, 27 Mar 2017 17:22:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix an integer overflow check
Message-ID: <20170327152217.GG4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170317205120.GE16505@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170317205120.GE16505@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 17, 2017 at 11:51:20PM +0300, Dan Carpenter wrote:
> This isn't super serious because you need CAP_ADMIN to run this code.
> 
> I added this integer overflow check last year but apparently I am
> rubbish at writing integer overflow checks...  There are two issues.
> First, access_ok() works on unsigned long type and not u64 so on 32 bit
> systems the access_ok() could be checking a truncated size.  The other
> issue is that we should be using a stricter limit so we don't overflow
> the kzalloc() setting ctx->clone_roots later in the function after the
> access_ok():
> 
> 	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
> 	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
> 
> Fixes: f5ecec3ce21f ("btrfs: send: silence an integer overflow warning")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I'll copy parts of the changelog and add as comments, it's not obvious
what the check does.
