Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37052 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3KTUvd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 15:51:33 -0500
Received: by mail-bk0-f43.google.com with SMTP id mz12so15078bkb.16
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 12:51:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <528CF92D.6070400@suse.com>
References: <1384877267-32046-1-git-send-email-fdmanana@gmail.com>
	<528CF92D.6070400@suse.com>
Date: Wed, 20 Nov 2013 20:51:32 +0000
Message-ID: <CAL3q7H4SABx6j-6Yv9Y7-cwZNZdPq01ebPEFRcMC-HK=aytCHA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: add missing sysfs group remove / fix leak
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 6:02 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 11/19/13, 11:07 AM, Filipe David Borba Manana wrote:
>> From kmemleak:
>>
>>   hex dump (first 32 bytes):
>>     03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffff8175f5f6>] kmemleak_alloc+0x26/0x50
>>     [<ffffffff8118f284>] kmem_cache_alloc+0x114/0x200
>>     [<ffffffff81219281>] sysfs_new_dirent+0x51/0x130
>>     [<ffffffff812196d2>] create_dir+0x42/0xd0
>>     [<ffffffff812199ff>] sysfs_create_subdir+0x1f/0x30
>>     [<ffffffff8121b50e>] internal_create_group+0x5e/0x270
>>     [<ffffffff8121b753>] sysfs_create_group+0x13/0x20
>>     [<ffffffffa069c99e>] btrfs_sysfs_add_one+0x7e/0x280 [btrfs]
>>     [<ffffffffa0682792>] open_ctree+0x17d2/0x21f0 [btrfs]
>>     [<ffffffffa065883a>] btrfs_mount+0x53a/0x7d0 [btrfs]
>>     [<ffffffff811a3ad3>] mount_fs+0x43/0x1b0
>>     [<ffffffff811bfa56>] vfs_kern_mount+0x76/0x120
>>     [<ffffffff811c1d77>] do_mount+0x237/0xa70
>>     [<ffffffff811c2640>] SyS_mount+0x90/0xe0
>>     [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
>>     [<ffffffffffffffff>] 0xffffffffffffffff
>> unreferenced object 0xffff8804e37d45b8 (size 160):
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>  fs/btrfs/sysfs.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 669fdf7..9576771 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -424,6 +424,8 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
>>       kobject_put(fs_info->device_dir_kobj);
>>       kobject_del(fs_info->space_info_kobj);
>>       kobject_put(fs_info->space_info_kobj);
>> +     sysfs_remove_group(&fs_info->super_kobj,
>> +                        &btrfs_feature_attr_group);
>>       kobject_del(&fs_info->super_kobj);
>>       kobject_put(&fs_info->super_kobj);
>>       wait_for_completion(&fs_info->kobj_unregister);
>>
>
> Oops, this isn't actually enough. It'll still leak the unknown feature
> attributes, which wouldn't have shown up in your testing. There are a
> few other failure cases that need to be handled as well. I'll work up a fix.

Ok, that was the only trace I got when running xfstests.
Thanks Jeff.

>
> -Jeff
>
> --
> Jeff Mahoney
> SUSE Labs
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
