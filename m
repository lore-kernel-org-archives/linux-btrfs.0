Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52729 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab3K0FiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 00:38:05 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAR5c3dY019902
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 13:38:03 +0800
Message-ID: <52958572.6090103@cn.fujitsu.com>
Date: Wed, 27 Nov 2013 13:38:58 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs-progs: Fix a segfault when using btrfs-corrupt-block
 with "-U"
References: <1385530408-28858-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1385530408-28858-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the wrong patch version.
It is just a normal bug fix, V4 is wrong and not necessary.

Qu

On Wed, 27 Nov 2013 13:33:28 +0800, Qu Wenruo wrote:
> When using "-U" option with btrfs-corrupt-block, it will cause a
> segfault due to a missing break in getopt switch.
>
> Reported-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  btrfs-corrupt-block.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
> index f0c14a9..a2828d4 100644
> --- a/btrfs-corrupt-block.c
> +++ b/btrfs-corrupt-block.c
> @@ -758,6 +758,7 @@ int main(int ac, char **av)
>  				break;
>  			case 'U':
>  				chunk_tree = 1;
> +				break;
>  			case 'i':
>  				inode = atoll(optarg);
>  				if (inode == 0) {


-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

