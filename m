Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab3HBApB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 20:45:01 -0400
Date: Fri, 2 Aug 2013 02:44:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix closing of opendir()
Message-ID: <20130802004459.GG24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373888210-5351-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373888210-5351-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> --- a/utils.c
> +++ b/utils.c
> @@ -1476,11 +1475,11 @@ u64 parse_size(char *s)
>  	return strtoull(s, NULL, 10) * mult;
>  }
>  
> -int open_file_or_dir(const char *fname)
> +int open_file_or_dir(const char *fname, DIR **dirstream)
>  {
>  	int ret;
>  	struct stat st;
> -	DIR *dirstream = NULL;
> +	*dirstream = NULL;

This is imho not needed, all call sites explicitly set dirstream to NULL
which is more clear than hiding it inside a function as a sideefect, so
I'll drop that line.

>  	int fd;
>  
>  	ret = stat(fname, &st);
