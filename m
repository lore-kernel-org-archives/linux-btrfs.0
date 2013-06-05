Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab3FEP0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 11:26:17 -0400
Date: Wed, 5 Jun 2013 17:26:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger Fischer <hoo.mb@web.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-tools: debian/patches/02-ftbfs.patch
Message-ID: <20130605152615.GD18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <519A1E2F.5050207@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <519A1E2F.5050207@web.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 20, 2013 at 02:59:27PM +0200, Holger Fischer wrote:
> Dear BTRFS-Community,
> 
> as far as I understand I believe it would make sense to apply that one upstream:

Thanks for bringing it up.

> like described, it ...  Fixes FTBFS on alpha and ia64 ...
> 
> >cat 02-ftbfs.patch
> Authors:
>  Luca Bruno <lucab@debian.org>
>  Alexander Kurtz <kurtz.alex@googlemail.com>
>  Daniel Baumann <daniel.baumann@progress-technologies.net>
> Description:
>  Patch to properly cast and avoiding compiler warnings. Fixes FTBFS on alpha
>  and ia64 (Closes: #539433, #583768).
> 
> Index: b/convert.c
> ===================================================================
> --- a/convert.c
> +++ b/convert.c
> @@ -2512,7 +2512,7 @@ int do_rollback(const char *devname, int
>         ext2_root = btrfs_read_fs_root(root->fs_info, &key);
>         if (!ext2_root || IS_ERR(ext2_root)) {
>                 fprintf(stderr, "unable to open subvol %llu\n",
> -                       key.objectid);
> +                       (unsigned long long) key.objectid);

There are way more instances of a missing (unsigned long long) casts,
quick grep from the ia64 build log counted ~100.  I prefer to fixem all
in one or at least separate by pure-userspace/-kernel code so we could
apply the bits on kernel too.


david
