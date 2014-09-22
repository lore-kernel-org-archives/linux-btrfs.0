Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaIVMXW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 08:23:22 -0400
Date: Mon, 22 Sep 2014 14:23:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: linux-btrfs@vger.kernel.org, Luk Claes <luk@debian.org>
Subject: Re: [PATCH 2/4] Fixes FTBFS with --no-add-needed.
Message-ID: <20140922122319.GL9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
 <1411261282-26831-2-git-send-email-xnox@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411261282-26831-2-git-send-email-xnox@debian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 21, 2014 at 02:01:20AM +0100, Dimitri John Ledkov wrote:
> --- a/Makefile
> +++ b/Makefile
> @@ -26,7 +26,7 @@ TESTS = fsck-tests.sh convert-tests.sh
>  INSTALL = install
>  prefix ?= /usr/local
>  bindir = $(prefix)/bin
> -lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
> +lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -lcom_err -L.

This will add the com_err library to all binaries, while it's actually
used only by the btrfs-convert utility and this dependency has been
properly added in ef85e7e285daf (released in 3.12).

One can add a per-target libraries like

btrfs_convert_libs = -lext2fs -lcom_err

Also please be more descriptive what the actual error is in the
changelog itself so I don't have to look it up in the referenced bug.
