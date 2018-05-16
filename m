Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44144 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbeEPTE0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 15:04:26 -0400
Received: by mail-pg0-f66.google.com with SMTP id c22-v6so18417pgn.11
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 12:04:26 -0700 (PDT)
Date: Wed, 16 May 2018 12:04:24 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Howard McLauchlan <linux@hmclauchlan.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: Re: [RFC PATCH 5/6] btrfs: add send_stream_version attribute to sysfs
Message-ID: <20180516190424.GD29231@vader>
References: <20180509020651.7946-1-linux@hmclauchlan.com>
 <20180509020651.7946-6-linux@hmclauchlan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180509020651.7946-6-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 10:06:50PM -0400, Howard McLauchlan wrote:
> From: Filipe David Borba Manana <fdmanana@gmail.com>
> 
> So that applications can find out what's the highest send stream
> version supported/implemented by the running kernel:
> 
>     $ cat /sys/fs/btrfs/send/stream_version
>     2
> 
> [Howard: rebased on 4.17-rc4]
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/send.h  |  1 +
>  fs/btrfs/sysfs.c | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
> index a5830d216ac1..2f5e25e03def 100644
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -12,6 +12,7 @@
>  #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
>  #define BTRFS_SEND_STREAM_VERSION_1 1
>  #define BTRFS_SEND_STREAM_VERSION_2 2
> +#define BTRFS_SEND_STREAM_VERSION_LATEST BTRFS_SEND_STREAM_VERSION_2
>  
>  #define BTRFS_SEND_BUF_SIZE SZ_64K
>  #define BTRFS_SEND_READ_SIZE (48 * SZ_1K)
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 4848a4318fb5..3c82cba91ff6 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -18,6 +18,7 @@
>  #include "transaction.h"
>  #include "sysfs.h"
>  #include "volumes.h"
> +#include "send.h"
>  
>  static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
>  static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj);
> @@ -884,6 +885,28 @@ static int btrfs_init_debugfs(void)
>  	return 0;
>  }
>  
> +static ssize_t send_stream_version_show(struct kobject *kobj,
> +					struct kobj_attribute *a,
> +					char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			BTRFS_SEND_STREAM_VERSION_LATEST);
> +}
> +
> +BTRFS_ATTR(, stream_version, send_stream_version_show);
> +
> +static struct attribute *btrfs_send_attrs[] = {
> +	BTRFS_ATTR_PTR(, stream_version),
> +	NULL
> +};
> +
> +static const struct attribute_group btrfs_send_attr_group = {
> +	.name = "send",
> +	.attrs = btrfs_send_attrs,
> +};
> +
> +
> +

I know this is Filipe's code, but there are two extra newlines there ;)
Otherwise, assuming you tested this and it works as advertised,

Reviewed-by: Omar Sandoval <osandov@fb.com>

>  int __init btrfs_init_sysfs(void)
>  {
>  	int ret;
> @@ -900,8 +923,13 @@ int __init btrfs_init_sysfs(void)
>  	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
>  	if (ret)
>  		goto out2;
> +	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_send_attr_group);
> +	if (ret)
> +		goto out3;
>  
>  	return 0;
> +out3:
> +	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
>  out2:
>  	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
>  out1:
> @@ -913,6 +941,7 @@ int __init btrfs_init_sysfs(void)
>  void __cold btrfs_exit_sysfs(void)
>  {
>  	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
> +	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_send_attr_group);
>  	kset_unregister(btrfs_kset);
>  	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
>  }
> -- 
> 2.17.0
> 
