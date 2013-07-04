Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17588 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3GDB3p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 21:29:45 -0400
Message-ID: <51D4D04E.8070408@cn.fujitsu.com>
Date: Thu, 04 Jul 2013 09:30:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 02/12] Btrfs-progs: don't close the file descriptor 0
 when closing a device
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com> <1372857920-4678-3-git-send-email-miaox@cn.fujitsu.com> <CAL3q7H5gxGg8p2JbtVtFcrgL9cMpD4S=LSf9aQ+2Y4wbz-ks6A@mail.gmail.com>
In-Reply-To: <CAL3q7H5gxGg8p2JbtVtFcrgL9cMpD4S=LSf9aQ+2Y4wbz-ks6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 3 Jul 2013 15:17:02 +0100, Filipe David Manana wrote:
> On Wed, Jul 3, 2013 at 2:25 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>
>> +++ b/disk-io.c
>> @@ -1270,12 +1270,13 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>>         while (!list_empty(list)) {
>>                 device = list_entry(list->next, struct btrfs_device, dev_list);
>>                 list_del_init(&device->dev_list);
>> -               if (device->fd) {
>> +               if (device->fd != -1) {
>>                         fsync(device->fd);
>>                         if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
>>                                 fprintf(stderr, "Warning, could not drop caches\n");
>> +                       close(device->fd);
>> +                       device->fd = -1;
>>                 }
>> -               close(device->fd);
>>                 kfree(device->name);
>>                 kfree(device->label);
>>                 kfree(device);
> 
> I deal with this part too at https://patchwork.kernel.org/patch/2787291/

Sorry, I don't know you have dealt with it. But your patch didn't fix the problem completely,
there are still some functions that you didn't deal with.

> Is there any reason to set device->fd to -1 if we just kfree(device)
> shortly after?

Right, I will update my patch.

Thanks
Miao

> thanks
> 
> 
> --
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

