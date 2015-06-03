Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:31644 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbFCIko (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 04:40:44 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 84CE8AC01D7
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 17:40:41 +0900 (JST)
Message-ID: <556EBD7C.8000603@jp.fujitsu.com>
Date: Wed, 03 Jun 2015 17:40:28 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: qgroup: allow user to clear some limitation
 on qgroup.
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1433314653-548-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1433314653-548-3-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/06/03 15:57, Dongsheng Yang wrote:
> Currently, we can not clear a limitation on a qgroup. Although
> there is a 'none' choice provided to user to do it, it does not
> work well.
> 
> It does not set the flag which user want to clear, then kernel
> will never know what the user want to do at all.
> 
> *Without this commit*
>   # ./btrfs qgroup show -re /mnt
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> 0/5           2.19GiB      2.19GiB      5.00GiB         none
> 0/257       100.02MiB    100.02MiB         none         none
>   # ./btrfs qgroup limit none /mnt
>   # ./btrfs qgroup show -re /mnt
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> 0/5           2.19GiB      2.19GiB      5.00GiB         none
> 0/257       100.02MiB    100.02MiB         none         none
> 
> This patch will set the flag user want to clear and pass a
> size=-1 to kernel. Then kernel will clear it correctly.
> 
> *With this commit*
>   # ./btrfs qgroup show -re /mnt
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> 0/5           2.19GiB      2.19GiB      5.00GiB         none
> 0/257       100.02MiB    100.02MiB         none         none
>   # ./btrfs qgroup limit none /mnt
>   # ./btrfs qgroup show -re /mnt
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> 0/5           2.19GiB      2.19GiB         none         none
> 0/257       100.02MiB    100.02MiB         none         none
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   cmds-qgroup.c | 23 +++++++++++------------
>   1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
> index b073250..00cc089 100644
> --- a/cmds-qgroup.c
> +++ b/cmds-qgroup.c
> @@ -110,9 +110,10 @@ static int parse_limit(const char *p, unsigned long long *s)
>   {
>   	char *endptr;
>   	unsigned long long size;
> +	unsigned long long CLEAR_VALUE = -1;

Even if a negative value is specified, it doesn't become an error...
So, it doesn't make an error of the following command.

# btrfs qg lim -- -1 sub1
# btrfs qg show -prce /test1
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/259         8.86GiB      7.88GiB         none         none ---     ---
# btrfs qg lim -- -2 sub1
# btrfs qg show -prce /test1
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/259         8.86GiB      7.88GiB     16.00EiB         none ---     ---

Otherwise OK,

Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>


>   
>   	if (strcasecmp(p, "none") == 0) {
> -		*s = 0;
> +		*s = CLEAR_VALUE;
>   		return 1;
>   	}
>   	size = strtoull(p, &endptr, 10);
> @@ -406,17 +407,15 @@ static int cmd_qgroup_limit(int argc, char **argv)
>   	}
>   
>   	memset(&args, 0, sizeof(args));
> -	if (size) {
> -		if (compressed)
> -			args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
> -					  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
> -		if (exclusive) {
> -			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
> -			args.lim.max_exclusive = size;
> -		} else {
> -			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
> -			args.lim.max_referenced = size;
> -		}
> +	if (compressed)
> +		args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
> +				  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
> +	if (exclusive) {
> +		args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
> +		args.lim.max_exclusive = size;
> +	} else {
> +		args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
> +		args.lim.max_referenced = size;
>   	}
>   
>   	if (argc - optind == 2) {
> 


