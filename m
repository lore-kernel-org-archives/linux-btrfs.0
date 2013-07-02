Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab3GBQbd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 12:31:33 -0400
Date: Tue, 2 Jul 2013 18:31:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs requires version.h
Message-ID: <20130702163131.GJ18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51c54096000d1fdf00004a0d00004a10a000000e44ba@amlmta037.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51c54096000d1fdf00004a0d00004a10a000000e44ba@amlmta037.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 22, 2013 at 03:13:42PM +0900, Kusanagi Kouichi wrote:
> $ make btrfs
...
>     [CC]     btrfs.o
> btrfs.c:24:21: fatal error: version.h: No such file or directory
>  #include "version.h"

Not only the 'btrfs' target, but also mkfs.btrfs (both dynamic and
static) and the other targets that include version.h and are not covered
by the generic rules.

I'd rather see the dependency added for all of them in one patch.

thanks,
david
