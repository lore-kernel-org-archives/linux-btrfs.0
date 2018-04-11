Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37455 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752327AbeDKIlh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:41:37 -0400
Subject: Re: [PATCH] btrfs-progs: configure: check if xmlto exists at
 configure time
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <29b3fdcb-afbc-b3b3-41c3-825f778ccecd@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <272e4be1-7b82-dde4-9623-ca7fbf8051de@gmx.com>
Date: Wed, 11 Apr 2018 16:41:27 +0800
MIME-Version: 1.0
In-Reply-To: <29b3fdcb-afbc-b3b3-41c3-825f778ccecd@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月11日 16:29, Misono Tomohiro wrote:
> AC_PATH_PROG won't fail even if it fails to find command path.
> xmlto is required for document build and we should report error
> if it doesn't exist at configure time.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  configure.ac | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index af13a959..a4c98b31 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -93,7 +93,11 @@ AC_SUBST([DISABLE_DOCUMENTATION])
>  dnl detect tools to build documentation
>  ASCIIDOC_TOOL="none"
>  if test "x$enable_documentation" = xyes; then
> -	AC_PATH_PROG([XMLTO], [xmlto], [xmlto])
> +	AC_PATH_PROG([XMLTO], [xmlto])
> +	if test -z "$XMLTO"; then
> +		AC_MSG_ERROR([cannot find xmlto, cannot build documentation])
> +	fi
> +
>  	AC_PATH_PROG([GZIP], [gzip], [gzip])
>  	AC_PATH_PROG([MV], [mv], [mv])
>  	AC_PROG_SED
> 
