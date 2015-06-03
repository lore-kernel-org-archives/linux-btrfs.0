Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:63151 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbbFCIYu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 04:24:50 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 7F3FDAC0DC6
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 17:14:34 +0900 (JST)
Message-ID: <556EB757.9040409@jp.fujitsu.com>
Date: Wed, 03 Jun 2015 17:14:15 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: qgroup: show 'none' when we did not
 limit it on this qgroup
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/06/03 15:57, Dongsheng Yang wrote:
> There are two understanding of the '0' value in btrfs qgroup show.
> (1) is no-limitation on this qgroup. (2) is the max-limitation is 0.
> 
> This patch make it showing in different way.
> 
> (1). max-limitation for 0 is still showing '0'.
> (2). no-limitation will show 'none'.
> 
> qgroupid         rfer         excl     max_rfer     max_excl parent
> --------         ----         ----     --------     -------- ------
> 0/5           2.19GiB      2.19GiB         none         none ---
> 0/257       100.02MiB    100.02MiB         none         none ---
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

> ---
>   qgroup.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/qgroup.c b/qgroup.c
> index 53815b5..dc04b03 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -237,10 +237,16 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>   		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
>   		break;
>   	case BTRFS_QGROUP_MAX_RFER:
> -		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
> +		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
> +			len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
> +		else
> +			len = printf("%*s", max_len, "none");
>   		break;
>   	case BTRFS_QGROUP_MAX_EXCL:
> -		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
> +		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
> +			len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
> +		else
> +			len = printf("%*s", max_len, "none");
>   		break;
>   	case BTRFS_QGROUP_CHILD:
>   		len = print_child_column(qgroup);
> 


