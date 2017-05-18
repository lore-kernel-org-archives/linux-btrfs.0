Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21203 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754764AbdERJ2b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 05:28:31 -0400
Subject: Re: [PATCH] btrfs: add mount umount logs
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170516084149.10147-1-anand.jain@oracle.com>
 <392158e2-14a1-6499-5005-19dd5497e18b@cn.fujitsu.com>
Cc: dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2c7ff425-4029-e1d1-3b95-86c08499c9b6@oracle.com>
Date: Thu, 18 May 2017 17:34:15 +0800
MIME-Version: 1.0
In-Reply-To: <392158e2-14a1-6499-5005-19dd5497e18b@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2017 05:25 PM, Qu Wenruo wrote:
> Yes, this is indeed a nice feature.
>
> But what about only outputting this info when BTRFS_DEBUG is selected?
> I'm sure there will be some guys not liking such kernel message flooding
> everywhere when doing testing.

  Thanks. Will keep in mind to make that changes if received confirmed 
objection.

Thanks. Anand


> Thanks,
> Qu
>
> At 05/16/2017 04:41 PM, Anand Jain wrote:
>> By looking at the logs we should be able to know when the FS was
>> mounted and unmounted and the options used, so to help forensic
>> investigations.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/super.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 827a8305da50..a123bc46b521 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1408,6 +1408,17 @@ static char *setup_root_args(char *args)
>>       return buf;
>>   }
>>   +static void print_mount_info(struct btrfs_fs_info *info, int flag,
>> char *opt,
>> +        char *prefix)
>> +{
>> +    char f[10] = {0};
>> +
>> +    if (flag & MS_RDONLY)
>> +        strcpy(f, "rdonly");
>
> Isn't "ro" more common?
>
> Thanks,
> Qu
>
>> +
>> +    btrfs_notice(info, "%s: flags:%s opt:%s\n", prefix, f, opt);
>> +}
>> +
>>   static struct dentry *mount_subvol(const char *subvol_name, u64
>> subvol_objectid,
>>                      int flags, const char *device_name,
>>                      char *data)
>> @@ -1502,6 +1513,8 @@ static struct dentry *mount_subvol(const char
>> *subvol_name, u64 subvol_objectid,
>>               dput(root);
>>               root = ERR_PTR(ret);
>>               deactivate_locked_super(s);
>> +        } else {
>> +            print_mount_info(fs_info, flags, data, "mount");
>>           }
>>       }
>>   @@ -1882,6 +1895,9 @@ static int btrfs_remount(struct super_block
>> *sb, int *flags, char *data)
>>   out:
>>       wake_up_process(fs_info->transaction_kthread);
>>       btrfs_remount_cleanup(fs_info, old_opts);
>> +
>> +    print_mount_info(fs_info, *flags, data, "remount");
>> +
>>       return 0;
>>     restore:
>> @@ -2212,6 +2228,7 @@ static int btrfs_statfs(struct dentry *dentry,
>> struct kstatfs *buf)
>>   static void btrfs_kill_super(struct super_block *sb)
>>   {
>>       struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>> +    btrfs_notice(fs_info, "%s\n", "unmount");
>>       kill_anon_super(sb);
>>       free_fs_info(fs_info);
>>   }
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
