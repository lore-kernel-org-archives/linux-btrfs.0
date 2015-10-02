Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20732 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbJBKsM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 06:48:12 -0400
Message-ID: <560E609B.5090204@oracle.com>
Date: Fri, 02 Oct 2015 18:46:51 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org,
        "quwenruo@cn.fujitsu.com >> Qu Wenruo" <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()
References: <1443163381-12332-1-git-send-email-anand.jain@oracle.com> <20150925103128.GC11442@twin.jikos.cz>
In-Reply-To: <20150925103128.GC11442@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




 > btrfs_std_error() naming is quite confusing for me.
 >
 > Std_error() means more like stderr, for my first glance, I'd think
 > it's just a new printk() warpper, until I checked the code.
 > It does more than printk, but also set FS_STATE_ERROR bit and set fs
 > to readonly.
 > I'd like it to be something like btrfs_handle_err().

David,

  I agree with Qu comment on this patch.

  I am ok change btrfs_std_error to btrfs_handle_error()
  with existing btrfs_handle_error() be renamed to __handle_error()

  If you agree as well, do you want a patch on top of it or a
  replacement patch will do. ?

Thanks, Anand


On 09/25/2015 06:31 PM, David Sterba wrote:
> On Fri, Sep 25, 2015 at 02:43:01PM +0800, Anand Jain wrote:
>> btrfs_error() and btrfs_std_error() does the same thing
>> and calls _btrfs_std_error(), so consolidate them together.
>> And the main motivation is that btrfs_error() is closely
>> named with btrfs_err(), one handles error action the other
>> is to log the error, so don't closely name them.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Suggested-by: David Sterba <dsterba@suse.com>
>
> Reviewed-by: David Sterba <dsterba@suse.com>
>
> I guess we can live with the extra NULL argument, in some cases it does
> not make sense to put a string there.
>
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -4852,7 +4852,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>>   	/* update qgroup status and info */
>>   	err = btrfs_run_qgroups(trans, root->fs_info);
>>   	if (err < 0)
>> -		btrfs_error(root->fs_info, ret,
>> +		btrfs_std_error(root->fs_info, ret,
>
> This looks like a bug, ret instead of err. The value of 'ret' is set by
> add/del qgroup relation which might fail if the relations are there, but
> we do not care. We're likely interested in the return code of
> btrfs_run_qgroups, ie. err. Can you please send a new patch on top of this?
>
>>   			    "failed to update qgroup status and info\n");
>>   	err = btrfs_end_transaction(trans, root);
>>   	if (err && !ret)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
