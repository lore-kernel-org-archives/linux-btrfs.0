Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57328 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3HEW10 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Aug 2013 18:27:26 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so1187529bkc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 15:27:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130805221059.GJ12314@lenny.home.zabbo.net>
References: <1375555397-10886-1-git-send-email-fdmanana@gmail.com>
	<20130805221059.GJ12314@lenny.home.zabbo.net>
Date: Mon, 5 Aug 2013 23:27:24 +0100
Message-ID: <CAL3q7H6yq=Y_iX4w40t5k0-UOmnghphTRc7T56jn-PAeK5HzWA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: race free update of super flags
From: Filipe David Manana <fdmanana@gmail.com>
To: Zach Brown <zab@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 5, 2013 at 11:10 PM, Zach Brown <zab@redhat.com> wrote:
> On Sat, Aug 03, 2013 at 07:43:17PM +0100, Filipe David Borba Manana wrote:
>> Before updating the super block's flags, which is a non-atomic
>> operation, grab the super_lock in the fs_info structure. At
>> the moment only 2 different code paths can update these flags
>> in parallel:
>
> Hmm.  You say "the" super block, but it's not clear to me that it's that
> simple.
>
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3357,8 +3357,10 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
>>               memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
>>               memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
>>
>> +             spin_lock(&root->fs_info->super_lock);
>>               flags = btrfs_super_flags(sb);
>>               btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
>> +             spin_unlock(&root->fs_info->super_lock);
>
>         sb = root->fs_info->super_for_commit;
>
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1862,9 +1862,11 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
>>       generate_random_uuid(fs_devices->fsid);
>>       memcpy(root->fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
>>       memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
>> +     spin_lock(&root->fs_info->super_lock);
>>       super_flags = btrfs_super_flags(disk_super) &
>>                     ~BTRFS_SUPER_FLAG_SEEDING;
>>       btrfs_set_super_flags(disk_super, super_flags);
>> +     spin_unlock(&root->fs_info->super_lock);
>
>         struct btrfs_super_block *disk_super = root->fs_info->super_copy;
>
> Can you explain why the lock is needed given the different super blocks
> and the mutexes that each path holds?

I guess got confused, must have thought both referred to
root->fs_info->super_copy.
Thanks for the heads up and review.

So yes, just ignore this as it's useless.

>
> What lead you to write this patch?
>
> - z
