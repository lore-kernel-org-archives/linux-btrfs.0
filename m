Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:36174 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaFWBbO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 21:31:14 -0400
Message-ID: <53A78351.4060804@jp.fujitsu.com>
Date: Mon, 23 Jun 2014 10:30:57 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, Chris Mason <clm@fb.com>
CC: Josef Bacik <jbacik@fb.com>, Sasha Levin <sasha.levin@oracle.com>,
        <linux-btrfs@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] Btrfs: fix error code in btrfs_init_test_fs()
References: <20140620192010.GB19824@mwanda>
In-Reply-To: <20140620192010.GB19824@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/06/21 4:20), Dan Carpenter wrote:
> We had intended to return a negative error code here, but we use the
> wrong variable so it returns success.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

>
> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
> index 9626252..8e7225f 100644
> --- a/fs/btrfs/tests/btrfs-tests.c
> +++ b/fs/btrfs/tests/btrfs-tests.c
> @@ -65,7 +65,7 @@ int btrfs_init_test_fs(void)
>   	if (IS_ERR(test_mnt)) {
>   		printk(KERN_ERR "btrfs: cannot mount test file system\n");
>   		unregister_filesystem(&test_type);
> -		return ret;
> +		return PTR_ERR(test_mnt);
>   	}
>   	return 0;
>   }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

