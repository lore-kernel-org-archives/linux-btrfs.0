Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12776 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbaFEJcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 05:32:13 -0400
Message-ID: <1401958994.3962.2.camel@localhost.localdomain>
Subject: Re: =?ISO-8859-1?Q?=B7=5Bping=5D=5BPATCH?= v3] lib: add size unit
 t/p/e to memparse
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <akpm@linux-foundation.org>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 5 Jun 2014 17:03:14 +0800
In-Reply-To: <1396428877-24089-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1396428877-24089-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-04-02 at 16:54 +0800, Gui Hecheng wrote:
> For modern filesystems such as btrfs, t/p/e size level operations
> are common.
> add size unit t/p/e parsing to memparse
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
> changelog
> 	v1->v2: replace kilobyte with kibibyte, and others
> 	v2->v3: add missing unit "bytes" in comment
> ---
>  lib/cmdline.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/cmdline.c b/lib/cmdline.c
> index eb67911..511b9be 100644
> --- a/lib/cmdline.c
> +++ b/lib/cmdline.c
> @@ -119,11 +119,17 @@ char *get_options(const char *str, int nints, int *ints)
>   *	@retptr: (output) Optional pointer to next char after parse completes
>   *
>   *	Parses a string into a number.  The number stored at @ptr is
> - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> - *	1073741824).  If the number is suffixed with K, M, or G, then
> - *	the return value is the number multiplied by one kilobyte, one
> - *	megabyte, or one gigabyte, respectively.
> + *	potentially suffixed with
> + *	%K (for kibibytes, or 1024 bytes),
> + *	%M (for mebibytes, or 1048576 bytes),
> + *	%G (for gibibytes, or 1073741824 bytes),
> + *	%T (for tebibytes, or 1099511627776 bytes),
> + *	%P (for pebibytes, or 1125899906842624 bytes),
> + *	%E (for exbibytes, or 1152921504606846976 bytes).
> + *	If the number is suffixed with K, M, G, T, P, E, then
> + *	the return value is the number multiplied by one kibibyte, one
> + *	mebibyte, one gibibyte, one tebibyte, one pebibyte, one exbibyte,
> + *	respectively.
>   */
>  
>  unsigned long long memparse(const char *ptr, char **retptr)
> @@ -133,6 +139,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
>  	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
>  
>  	switch (*endptr) {
> +	case 'E':
> +	case 'e':
> +		ret <<= 10;
> +	case 'P':
> +	case 'p':
> +		ret <<= 10;
> +	case 'T':
> +	case 't':
> +		ret <<= 10;
>  	case 'G':
>  	case 'g':
>  		ret <<= 10;


