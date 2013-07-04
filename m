Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:41845 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab3GDIaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 04:30:19 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so483973bkc.9
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 01:30:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <51D4D04E.8070408@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
	<1372857920-4678-3-git-send-email-miaox@cn.fujitsu.com>
	<CAL3q7H5gxGg8p2JbtVtFcrgL9cMpD4S=LSf9aQ+2Y4wbz-ks6A@mail.gmail.com>
	<51D4D04E.8070408@cn.fujitsu.com>
Date: Thu, 4 Jul 2013 09:30:18 +0100
Message-ID: <CAL3q7H78FdcJet-j1-uJxcfexBd6xxDt4FWZ=96gAGosmzpRHQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] Btrfs-progs: don't close the file descriptor 0 when
 closing a device
From: Filipe David Manana <fdmanana@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 4, 2013 at 2:30 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On wed, 3 Jul 2013 15:17:02 +0100, Filipe David Manana wrote:
>> On Wed, Jul 3, 2013 at 2:25 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>
>>> +++ b/disk-io.c
>>> @@ -1270,12 +1270,13 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>>>         while (!list_empty(list)) {
>>>                 device = list_entry(list->next, struct btrfs_device, dev_list);
>>>                 list_del_init(&device->dev_list);
>>> -               if (device->fd) {
>>> +               if (device->fd != -1) {
>>>                         fsync(device->fd);
>>>                         if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
>>>                                 fprintf(stderr, "Warning, could not drop caches\n");
>>> +                       close(device->fd);
>>> +                       device->fd = -1;
>>>                 }
>>> -               close(device->fd);
>>>                 kfree(device->name);
>>>                 kfree(device->label);
>>>                 kfree(device);
>>
>> I deal with this part too at https://patchwork.kernel.org/patch/2787291/
>
> Sorry, I don't know you have dealt with it. But your patch didn't fix the problem completely,
> there are still some functions that you didn't deal with.

Yes, I was addressing a different problem. My comment was relative
only to this change in disk-io.c:close_all_devices().

thanks

>
>> Is there any reason to set device->fd to -1 if we just kfree(device)
>> shortly after?
>
> Right, I will update my patch.
>
> Thanks
> Miao
>
>> thanks
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
