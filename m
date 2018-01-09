Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbeAIRi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 12:38:29 -0500
Date: Tue, 9 Jan 2018 18:36:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: dsterba@suse.com, clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] btrfs: use correct string length
Message-ID: <20180109173620.GS13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515412282-57381-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515412282-57381-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 08, 2018 at 07:51:22PM +0800, Xiongfeng Wang wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> 
> gcc-8 reports
> 
> fs/btrfs/ioctl.c: In function 'btrfs_ioctl':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 1024 equals destination size [-Wstringop-truncation]
> 
> We need one less byte or call strlcpy() to make it a nul-terminated
> string.

The null termination is on the following line, so this patch fixes
namely the gcc warning:

> -		strncpy(di_args->path, name->str, sizeof(di_args->path));
> +		strncpy(di_args->path, name->str, sizeof(di_args->path) - 1);
>  		rcu_read_unlock();
>  		di_args->path[sizeof(di_args->path) - 1] = 0;

Reviewed-by: David Sterba <dsterba@suse.com>

