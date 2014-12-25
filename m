Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51991 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaLYBTx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:19:53 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 829003EE0BB
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:19:51 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 583BAAC02DE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:19:50 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 05F1BE08001
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:19:50 +0900 (JST)
Message-ID: <549B662D.8060006@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 10:19:41 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/8] Add -v -q switches to mkfs.btrfs.
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <1418847252-14184-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-2-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 5:14, Goffredo Baroncelli wrote:
> Add -v -q switches to mkfs.btrfs, to control the verbosity of mkfs.btrfs.
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   mkfs.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index e10e62d..a5f19cc 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -288,8 +288,10 @@ static void print_usage(void)
>   	fprintf(stderr, "\t -r --rootdir the source directory\n");
>   	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
>   	fprintf(stderr, "\t -O --features comma separated list of filesystem features\n");
> +	fprintf(stderr, "\t -q --quiet enable quiet mode\n");
>   	fprintf(stderr, "\t -U --uuid specify the filesystem UUID\n");
>   	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
> +	fprintf(stderr, "\t -v --verbose enable verbose mode\n");
>   	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
>   	exit(1);
>   }
> @@ -351,6 +353,8 @@ static struct option long_options[] = {
>   	{ "version", 0, NULL, 'V' },
>   	{ "rootdir", 1, NULL, 'r' },
>   	{ "nodiscard", 0, NULL, 'K' },
> +	{ "verbose", 0, NULL, 'v' },
> +	{ "quiet", 0, NULL, 'q' },
>   	{ "features", 1, NULL, 'O' },
>   	{ "uuid", required_argument, NULL, 'U' },
>   	{ NULL, 0, NULL, 0}
> @@ -998,7 +1002,7 @@ out:
>    * This ignores symlinks with unreadable targets and subdirs that can't
>    * be read.  It's a best-effort to give a rough estimate of the size of
>    * a subdir.  It doesn't guarantee that prepopulating btrfs from this
> - * tree won't still run out of space.
> + * tree won't still run out of space.
>    *
>    * The rounding up to 4096 is questionable.  Previous code used du -B 4096.
>    */
> @@ -1266,6 +1270,8 @@ int main(int ac, char **av)
>   	int discard = 1;
>   	int ssd = 0;
>   	int force_overwrite = 0;
> +	int verbose = 0;
> +	int quiet = 0;
>   
>   	char *source_dir = NULL;
>   	int source_dir_set = 0;
> @@ -1280,7 +1286,7 @@ int main(int ac, char **av)
>   
>   	while(1) {
>   		int c;
> -		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:U:VMK",
> +		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:U:VMKqv",
>   				long_options, &option_index);
>   		if (c < 0)
>   			break;
> @@ -1355,6 +1361,12 @@ int main(int ac, char **av)
>   			case 'K':
>   				discard = 0;
>   				break;
> +			case 'v':
> +				verbose = 1;
> +				break;
> +			case 'q':
> +				quiet = 1;
> +				break;
>   			default:
>   				print_usage();
>   		}
> 

