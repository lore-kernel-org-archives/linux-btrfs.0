Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43394 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2GYPqv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 11:46:51 -0400
MIME-Version: 1.0
In-Reply-To: <1343229134-29487-8-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
	<1343229134-29487-8-git-send-email-artem.bityutskiy@linux.intel.com>
Date: Wed, 25 Jul 2012 09:46:49 -0600
Message-ID: <CAE5mzvg178UUj4eRmL-VE+=jXSnBJvAUgNPooY3f2ihbwSbBOg@mail.gmail.com>
Subject: Re: [PATCH 07/16] btrfs: nuke write_super from comments
From: cwillu <cwillu@cwillu.com>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ecaad40..9f2416c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1738,10 +1738,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>
>         device->fs_devices = root->fs_info->fs_devices;
>
> -       /*
> -        * we don't want write_supers to jump in here with our device
> -        * half setup
> -        */
>         mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
>         list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
>         list_add(&device->dev_alloc_list,

Is the locking still required for approximately the same reason?
