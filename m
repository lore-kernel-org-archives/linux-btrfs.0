Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3DWRFQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 13:05:16 -0400
Date: Tue, 23 Apr 2013 19:05:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3] btrfs: move leak debug code to functions
Message-ID: <20130423170513.GX16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517387F8.506@redhat.com>
 <5175616F.1010007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5175616F.1010007@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 11:12:31AM -0500, Eric Sandeen wrote:
> Clean up the leak debugging in extent_io.c by moving
> the debug code into functions.  This also removes the
> list_heads used for debugging from the extent_buffer
> and extent_state structures when debug is not enabled.
> 
> Since we need a global debug config to do that last
> part, implement CONFIG_BTRFS_DEBUG to accommodate.
> 
> Thanks to Dave Sterba for the Kconfig bit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> Now we can move other #ifdef DEBUG under this same
> config, but not all of them; some look like they
> would be way too chatty.  I'll need to review those
> before ending another patch to add any of them
> under CONFIG_BTRFS_DEBUG.

Agreed. The number of extra checks should be reasonable so the fs is still
usable.

david
