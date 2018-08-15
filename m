Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729125AbeHOQwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 12:52:54 -0400
Date: Wed, 15 Aug 2018 16:00:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: clean up scrub is_dev_replace parameter
Message-ID: <20180815140024.GP24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <340268ad4d290b780616010ae3a75347723ebf10.1534270161.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <340268ad4d290b780616010ae3a75347723ebf10.1534270161.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2018 at 11:09:52AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> struct scrub_ctx has an ->is_dev_replace member, so there's no point in
> passing around is_dev_replace where sctx is available.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

There's still id_dev_replace passed to scrub_workers_get but it's a
small and static helper. I don't think it's necessary to drop that
parameter too, the fs_info or scrub context would have to be adjusted
anyway.
