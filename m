Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33768 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbcJJN4J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 09:56:09 -0400
Subject: Re: [PATCH] btrfs-progs: btrfstune: Register new UUIDs after uuid
 change
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20161010092101.469-1-quwenruo@cn.fujitsu.com>
 <d74cdd9e-ad05-3d33-111e-92308c7b9775@oracle.com>
 <20161010110855.GI11398@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9551e873-23f6-0e17-f895-cf15513e27f8@oracle.com>
Date: Mon, 10 Oct 2016 21:58:08 +0800
MIME-Version: 1.0
In-Reply-To: <20161010110855.GI11398@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/10/16 19:08, David Sterba wrote:
> On Mon, Oct 10, 2016 at 06:54:08PM +0800, Anand Jain wrote:
>>
>>
>> On 10/10/16 17:21, Qu Wenruo wrote:
>>> For multi-device btrfs, after UUID change we should info kernel, or new
>>> fs can't be mounted due to false alert on missing devices.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>  btrfstune.c | 9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/btrfstune.c b/btrfstune.c
>>> index 15dde90..23d06ce 100644
>>> --- a/btrfstune.c
>>> +++ b/btrfstune.c
>>> @@ -369,6 +369,15 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
>>>  	fs_info->new_fsid = NULL;
>>>  	fs_info->new_chunk_tree_uuid = NULL;
>>>  	printf("Fsid change finished\n");
>>> +
>>> +	/*
>>> +	 * Register new devices, or multi-volume btrfs can't be mounted until
>>> +	 * device scan happens.
>>> +	 * Ignore any error, as such register is optional.
>>> +	 */
>>> +	printf("Register new UUIDs(error can be ignored)\n");
>>
>>   Whats the error in particular in this context. ?
>
> If /dev/btrfs-control cannot be opened by the user, in
> btrfs_register_one_device() .

  I was wondering if there is any error specific to change in FSID ? 
looks like there isn't.

>>> +	btrfs_register_all_devices();
>>
>>   That means after a reboot -> change uuid it will register the devices
>> though the devices weren't registered to the kernel before.
>>
>>   Its fair enough just remind user to run dev scan so that kernel can
>> see them.
>
> This is similar to mkfs that is not able to register the devices for
> the same reason.

  right. inline with mkfs.btrfs -f <old-fsid>

  makes sense.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
