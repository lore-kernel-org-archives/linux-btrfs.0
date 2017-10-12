Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752796AbdJLMjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 08:39:55 -0400
Date: Thu, 12 Oct 2017 14:38:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: set include path relatively
Message-ID: <20171012123809.GF3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171012022224.28376-1-naota@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171012022224.28376-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 11:22:24AM +0900, Naohiro Aota wrote:
> Currently, gcc is passed the include directory with full path. As a result,
> dependency files (*.o.d) also record the full path at the build time. Such
> full path dependency is annoying for sharing the source between multiple
> machines, containers, or anything the path differ.
> 
> And this is the same way what other program using autotools e.g. e2fsprogs
> is doing:
> 
> $ grep top_builddir Makefile
> top_builddir = .
> CPPFLAGS = -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib
> BUILD_CFLAGS = -g -O2  -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib -DHAVE_CONFIG_H
> <snip>

Makes sense for the header files. TOPDIR is also used for linking, can
it cause similar problems, where the library search path is set as -L$(TOPDIR) ?

I wonder if we should do the same as in the example above and set
default value of TOPDIR to '.', instead of `pwd`.


> Signed-off-by: Naohiro Aota <naota@elisp.net>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index b1f3388..69b94fb 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -70,8 +70,8 @@ CFLAGS = $(SUBST_CFLAGS) \
>  	 -D_XOPEN_SOURCE=700  \
>  	 -fno-strict-aliasing \
>  	 -fPIC \
> -	 -I$(TOPDIR) \
> -	 -I$(TOPDIR)/kernel-lib \
> +	 -I. \
> +	 -I./kernel-lib \
>  	 $(EXTRAWARN_CFLAGS) \
>  	 $(DEBUG_CFLAGS_INTERNAL) \
>  	 $(EXTRA_CFLAGS)
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
