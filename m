Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759285Ab3BLNz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 08:55:28 -0500
Date: Tue, 12 Feb 2013 14:55:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add static compile target
Message-ID: <20130212135526.GW12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360365569-18996-1-git-send-email-pomac@demius.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360365569-18996-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 09, 2013 at 12:19:29AM +0100, Ian Kumlien wrote:
> +# Define static compilation flags
> +STATIC_CFLAGS = $(CFLAGS) -static -ffunction-sections -fdata-sections
> +STATIC_LDFLAGS = -Wl,--gc-sections
> +STATIC_LIBS = $(LIBS) -lpthread

> +btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects)
> +	@echo "    [LD]     $@"
> +	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
> +		$(static_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)

-static belongs into LDFLAGS, it's propagated to the link phase through
CFLAGS which is not IMO clean. As the point is to make the static
version as small as possible I think it's ok to separate the built
objects and name the binary differently from the normal one. Also, from
distro side, I can build both targets from within one package without
nonstandard build steps (make, copy, clean, make, copy/rename).

I'll fix the -static flag locally and add this patch to integration.

david
