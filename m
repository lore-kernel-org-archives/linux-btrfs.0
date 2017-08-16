Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60798 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752593AbdHPARl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 20:17:41 -0400
Subject: Re: [PATCH] btrfs-progs: fix cross-compile build
To: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Hallo32@gmx.net, David Sterba <dsterba@suse.com>
References: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9a81d05e-68ab-45a1-a4dc-386b89f4c733@gmx.com>
Date: Wed, 16 Aug 2017 08:17:00 +0800
MIME-Version: 1.0
In-Reply-To: <8f01ac45-1b6e-be1d-b6e3-48fe6cdc4833@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月16日 02:11, Eric Sandeen wrote:
> The mktables binary needs to be build with the host
> compiler at built time, not the target compiler, because
> it runs at build time to generate the raid tables.
> 
> Copy auto-fu from xfsprogs and modify Makefile to
> accomodate this.
> 
> Reported-by: Hallo32 <Hallo32@gmx.net>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks better than my previous patch.
With @BUILD_CLFAGS support and better BUILD_CC/CLFAGS detection for 
native build environment.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu
> ---
> 
> diff --git a/Makefile b/Makefile
> index b3e2b63..2647b95 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -323,7 +323,7 @@ version.h: version.sh version.h.in configure.ac
>   
>   mktables: kernel-lib/mktables.c
>   	@echo "    [CC]     $@"
> -	$(Q)$(CC) $(CFLAGS) $< -o $@
> +	$(Q)$(BUILD_CC) $(BUILD_CFLAGS) $< -o $@
>   
>   kernel-lib/tables.c: mktables
>   	@echo "    [TABLE]  $@"
> diff --git a/Makefile.inc.in b/Makefile.inc.in
> index 4e1b68c..0570bf8 100644
> --- a/Makefile.inc.in
> +++ b/Makefile.inc.in
> @@ -4,6 +4,8 @@
>   export
>   
>   CC = @CC@
> +BUILD_CC = @BUILD_CC@
> +BUILD_CFLAGS = @BUILD_CFLAGS@
>   LN_S = @LN_S@
>   AR = @AR@
>   RM = @RM@
> diff --git a/configure.ac b/configure.ac
> index 30055f8..bc590cc 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -26,6 +26,23 @@ AC_CONFIG_SRCDIR([btrfs.c])
>   AC_PREFIX_DEFAULT([/usr/local])
>   
>   AC_PROG_CC
> +AC_ARG_VAR(BUILD_CC, [C compiler for build tools])
> +if test "${BUILD_CC+set}" != "set"; then
> +  if test $cross_compiling = no; then
> +    BUILD_CC="$CC"
> +  else
> +    AC_CHECK_PROGS(BUILD_CC, gcc cc) > +  fi
> +fi
> +AC_ARG_VAR(BUILD_CFLAGS, [C compiler flags for build tools])
> +if test "${BUILD_CFLAGS+set}" != "set"; then
> +  if test $cross_compiling = no; then
> +    BUILD_CFLAGS="$CFLAGS"
> +  else
> +    BUILD_CFLAGS="-g -O2"
> +  fi
> +fi
> +
>   AC_CANONICAL_HOST
>   AC_C_CONST
>   AC_C_VOLATILE
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
