Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:52845 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161513Ab3FUQqS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 12:46:18 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so3445907bkc.7
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 09:46:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130621161123.GC30620@localhost.localdomain>
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
	<1370908356-31792-1-git-send-email-fdmanana@gmail.com>
	<20130621161123.GC30620@localhost.localdomain>
Date: Fri, 21 Jun 2013 17:46:17 +0100
Message-ID: <CAL3q7H6tR5vdi9QuzDq+HettCo7xagqS+7MvLkB5cXd44vK_Vg@mail.gmail.com>
Subject: Re: [PATCH 1/5 v2] Btrfs-progs: fix closing of devices
From: Filipe David Manana <fdmanana@gmail.com>
To: bo.li.liu@oracle.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 21, 2013 at 5:11 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -116,6 +116,7 @@ static int device_list_add(const char *path,
>>                       /* we can safely leave the fs_devices entry around */
>>                       return -ENOMEM;
>>               }
>> +             device->fd = -1;
>
> One nit here,
> I think it's ok without this since if we get the right device->name, it
> means this device is not missing and its fd will be valid.

Good point.
Only reason I left it like that, is because besides being more clear
(subjective) there seems to be possible to have device.name as
non-null but no valid fd - i.e. the open() call in
volumes.c:btrfs_open_devices() failed.

thanks


>
> thanks,
> liubo
