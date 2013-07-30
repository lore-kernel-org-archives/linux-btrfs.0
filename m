Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab3G3Dje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 23:39:34 -0400
Message-ID: <51F735AE.2050902@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 11:40:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Azat Khuzhin <a3at.mail@gmail.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: use list_for_each_entry_safe() when delete items
References: <1374919965-11690-1-git-send-email-a3at.mail@gmail.com> <CAG5DWoi_BQvHYcPySZBLQpB3wbYeqvYj_CE1RvEBSB8xibtrDw@mail.gmail.com>
In-Reply-To: <CAG5DWoi_BQvHYcPySZBLQpB3wbYeqvYj_CE1RvEBSB8xibtrDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 29 Jul 2013 11:48:32 +0400, Azat Khuzhin wrote:
> On Sat, Jul 27, 2013 at 2:12 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
>> Replace list_for_each_entry() by list_for_each_entry_safe() in
>> __btrfs_close_devices()
>>
>> There is another place that delete items lock_stripe_add(), but there we
>> don't need safe version, because after deleting we exit from loop.
>>
>> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
>> ---
>>  fs/btrfs/volumes.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 78b8717..1d1b595 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -616,13 +616,13 @@ static void free_device(struct rcu_head *head)
>>
>>  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>  {
>> -       struct btrfs_device *device;
>> +       struct btrfs_device *device, *next;
>>
>>         if (--fs_devices->opened > 0)
>>                 return 0;
>>
>>         mutex_lock(&fs_devices->device_list_mutex);
>> -       list_for_each_entry(device, &fs_devices->devices, dev_list) {
>> +       list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
>>                 struct btrfs_device *new_device;
>>                 struct rcu_string *name;
> 
> There is "kfree(device);" at the end of loop, maybe there must "goto
> again;" after it?
> (instead of this patch)

Your fix is right, we needn't search from the head once again.

The other fix way is:
	call_rcu(&device->rcu, free_device);
+	device = new_device;
 }
but from the viewpoint of the readability, this way is not so good.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> 
>>
>> --
>> 1.7.10.4
>>
> 
> 
> 

