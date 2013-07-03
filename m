Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50738 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3GCORE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 10:17:04 -0400
Received: by mail-bk0-f49.google.com with SMTP id mz10so104811bkb.36
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 07:17:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1372857920-4678-3-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
	<1372857920-4678-3-git-send-email-miaox@cn.fujitsu.com>
Date: Wed, 3 Jul 2013 15:17:02 +0100
Message-ID: <CAL3q7H5gxGg8p2JbtVtFcrgL9cMpD4S=LSf9aQ+2Y4wbz-ks6A@mail.gmail.com>
Subject: Re: [PATCH 02/12] Btrfs-progs: don't close the file descriptor 0 when
 closing a device
From: Filipe David Manana <fdmanana@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 3, 2013 at 2:25 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>
> +++ b/disk-io.c
> @@ -1270,12 +1270,13 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>         while (!list_empty(list)) {
>                 device = list_entry(list->next, struct btrfs_device, dev_list);
>                 list_del_init(&device->dev_list);
> -               if (device->fd) {
> +               if (device->fd != -1) {
>                         fsync(device->fd);
>                         if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
>                                 fprintf(stderr, "Warning, could not drop caches\n");
> +                       close(device->fd);
> +                       device->fd = -1;
>                 }
> -               close(device->fd);
>                 kfree(device->name);
>                 kfree(device->label);
>                 kfree(device);

I deal with this part too at https://patchwork.kernel.org/patch/2787291/
Is there any reason to set device->fd to -1 if we just kfree(device)
shortly after?

thanks


--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
