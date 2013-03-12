Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab3CLRx1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:53:27 -0400
Date: Tue, 12 Mar 2013 18:53:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <h.r.mills@reading.ac.uk>
Subject: Re: [PATCH] btrfs-progs: add Makefile rule for static build of
 btrfs-find-root
Message-ID: <20130312175325.GR7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363103051-10207-1-git-send-email-hugo@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363103051-10207-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 03:44:11PM +0000, Hugo Mills wrote:
> From: Hugo Mills <h.r.mills@reading.ac.uk>
> 
> btrfs-find-root isn't yet integrated into the main btrfs tool, and is
> an important recovery tool, so it deserves to be built as a static
> binary.

Thanks, I'll add this now as a separate target, though find-root might
end up merged into 'btrfs' eventually.

> +btrfs-find-root.static: $(static_objects) $(libs) find-root.static.o

I've noticed that the (newly added) mkfs.btrfs.static target does not
depend on $(libs) and this is correct, we don't need $(libs) for .static
targets.  I'll fix both btrfs.static and find-root here.

> +	@echo "    [LD]     $@"
> +	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs-find-root.static find-root.static.o $(static_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
> +
