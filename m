Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753431AbaIRJYT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 05:24:19 -0400
Message-ID: <1411032216.25255.13.camel@localhost.localdomain>
Subject: Re: [PATCH] Btrfs-progs: super-recover: fix double free fs_devices
 memory
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>,
        "Chris Murphy" <lists@colorremedies.com>
Date: Thu, 18 Sep 2014 17:23:36 +0800
In-Reply-To: <1411030872-2235-1-git-send-email-wangshilong1991@gmail.com>
References: <5419BE1E.2020607@redhat.com>
	 <1411030872-2235-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-09-18 at 05:01 -0400, Wang Shilong wrote:
> super-recover collects btrfs devices infomation using existed
> functions scan_one_devices().
> 
> Problem is fs_devices is freed twice in close_ctree() and
> free_recover_superblock() for super correction path.
> 
> Fix this problem by checking whether fs_devices memory
> have been freed before we free it.
> 
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
> ---
>  super-recover.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/super-recover.c b/super-recover.c
> index 767de4b..419b86a 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -69,21 +69,11 @@ void init_recover_superblock(struct btrfs_recover_superblock *recover)
>  static
>  void free_recover_superblock(struct btrfs_recover_superblock *recover)
>  {
> -	struct btrfs_device *device;
>  	struct super_block_record *record;
>  
>  	if (!recover->fs_devices)
>  		return;
>  
> -	while (!list_empty(&recover->fs_devices->devices)) {
> -		device = list_entry(recover->fs_devices->devices.next,
> -				struct btrfs_device, dev_list);
> -		list_del_init(&device->dev_list);
> -		free(device->name);
> -		free(device);
> -	}
> -	free(recover->fs_devices);
> -
>  	while (!list_empty(&recover->good_supers)) {
>  		record = list_entry(recover->good_supers.next,
>  				struct super_block_record, list);
> @@ -341,6 +331,9 @@ int btrfs_recover_superblocks(const char *dname,
>  no_recover:
>  	recover_err_str(ret);
>  	free_recover_superblock(&recover);
> +	/* check if we have freed fs_deivces in close_ctree() */
> +	if (!root)
> +		btrfs_close_devices(recover.fs_devices);
>  	return ret;
>  }
>  

nice catch! "+20, recorded". ^_^

