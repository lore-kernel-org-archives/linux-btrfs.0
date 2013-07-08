Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab3GHQqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jul 2013 12:46:11 -0400
Date: Mon, 8 Jul 2013 18:46:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix automatic prerequisite generation
Message-ID: <20130708164607.GC18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130706082232.1679715C03A@msa104.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130706082232.1679715C03A@msa104.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 06, 2013 at 05:22:31PM +0900, Kusanagi Kouichi wrote:
> Some files don't compile because of insufficient prerequisite.
> 
> $ make btrfs
> ...
>     [CC]     btrfs.o
> btrfs.c:24:21: fatal error: version.h: No such file or directory
>  #include "version.h"
>                      ^
> compilation terminated.
> make: *** [btrfs.o] Error 1

Works great, thanks. I've noticed that DEPFLAGS is now unused and
removed it.

david
