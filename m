Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21978 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243AbcCPD5y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 23:57:54 -0400
Subject: Re: [PATCH] btrfs: btrfs_assert fix coding style
To: linux-btrfs@vger.kernel.org
References: <1458089715-597-1-git-send-email-anand.jain@oracle.com>
Cc: dsterba@suse.cz, clm@fb.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56E8D9B7.8030204@oracle.com>
Date: Wed, 16 Mar 2016 11:57:43 +0800
MIME-Version: 1.0
In-Reply-To: <1458089715-597-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Ignore. NACK.

Thanks, Anand


On 03/16/2016 08:55 AM, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/ctree.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c9fb7b9ca8a4..5b5002a242e4 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -4283,8 +4283,8 @@ static inline void assfail(char *expr, char *file, int line)
>   #define ASSERT(expr)	((void)0)
>   #endif
>
> -#define btrfs_assert()
> -__printf(5, 6)
> +#define btrfs_assert() __printf(5, 6)
> +
>   __cold
>   void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>   		     unsigned int line, int errno, const char *fmt, ...);
>
