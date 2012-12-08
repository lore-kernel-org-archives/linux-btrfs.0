Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44768 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2LHPIO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Dec 2012 10:08:14 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so978903pbc.19
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Dec 2012 07:08:14 -0800 (PST)
Message-ID: <50C357D6.5000409@gmail.com>
Date: Sat, 08 Dec 2012 23:08:06 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make sure fs_info is not null before its field
 is used in __btrfs_panic
References: <n> <1354894924-13050-1-git-send-email-shhuiw@gmail.com> <50C31218.6070807@huawei.com>
In-Reply-To: <50C31218.6070807@huawei.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012Äê12ÔÂ08ÈÕ 18:10, Li Zefan wrote:
> On 2012/12/7 23:42, Wang Sheng-Hui wrote:
>> We should make sure fs_info is not null before we refer to its field.
>> Add simple check here.
> Why? Is there any caller passing NULL @fs_info to this function?

At least for code clean now.

In __btrfs_panic, we have:
276 if (fs_info)
277 s_id = fs_info->sb->s_id;
So for the ->mount_opt field access, we'd better do the check first.

>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/btrfs/super.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 915ac14..c6a3633 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -280,7 +280,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
>>  	vaf.va = &args;
>>  
>>  	errstr = btrfs_decode_error(fs_info, errno, nbuf);
>> -	if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
>> +	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
>>  		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
>>  			s_id, function, line, &vaf, errstr);
>>  
>>

