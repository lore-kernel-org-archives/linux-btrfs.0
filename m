Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60055 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3GNN6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 09:58:09 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so10034053pdi.27
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 06:58:08 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2] Btrfs-progs: fix memory leak in open_file_or_dir()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1373791722-29998-1-git-send-email-anand.jain@oracle.com>
Date: Sun, 14 Jul 2013 21:58:03 +0800
Cc: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        "wangsl.fnst@cn.fujitsu.com" <wangsl.fnst@cn.fujitsu.com>
Message-Id: <4C2AE033-0C93-419A-9FD2-C8E0B0A7A942@gmail.com>
References: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com> <1373791722-29998-1-git-send-email-anand.jain@oracle.com>
To: anand jain <anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand and David,

I use the tool valgrind to whether there exists memory leak:

valgrind  --tool=memcheck  --trace-origins=yes --leak-chek=full btrfs sub list /mnt
There still exists memory leak related to open_file_or_dir() (After applying this patch).

I guess it is because we should call closedir(dirstram) rather than close(fd) if opening a directory.
Maybe we can make open_file_or_dir() something like:

open_file_or_dir(char *name, DIR **dirstream)

if we opened a directory, we close it by calling closeidr(dirstream).
elsewise, close(fd) is ok!..

I am wondering why close(fd) can not just finish this work¡­¡­


Thanks,
Wang
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> After calling opendir() successfully, closedir() should be
> also called to free memory. Otherwise, memory leak happens.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> ---
> utils.c |    6 ++++--
> 1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/utils.c b/utils.c
> index d3bec9b..4b3c778 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1503,7 +1503,7 @@ int open_file_or_dir(const char *fname)
> {
> 	int ret;
> 	struct stat st;
> -	DIR *dirstream;
> +	DIR *dirstream = NULL;
> 	int fd;
> 
> 	ret = stat(fname, &st);
> @@ -1520,7 +1520,9 @@ int open_file_or_dir(const char *fname)
> 		fd = open(fname, O_RDWR);
> 	}
> 	if (fd < 0) {
> -		return -3;
> +		fd = -3;
> +		if (dirstream)
> +			closedir(dirstream);
> 	}
> 	return fd;
> }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

