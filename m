Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20416 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbCIRLB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:11:01 -0400
Message-ID: <54FDD416.8090506@oracle.com>
Date: Tue, 10 Mar 2015 01:10:46 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 22/24] Btrfs: sysfs: don't fail seeding for the sake of
 sysfs kobject issue
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com> <1423439785-10260-23-git-send-email-anand.jain@oracle.com> <20150211184057.GJ28877@twin.jikos.cz> <54DC1C7E.6050309@oracle.com> <20150213161533.GL8720@twin.jikos.cz>
In-Reply-To: <20150213161533.GL8720@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/13/2015 11:15 AM, David Sterba wrote:
> On Thu, Feb 12, 2015 at 11:22:38AM +0800, Anand Jain wrote:
>>
>>
>> On 02/12/2015 02:40 AM, David Sterba wrote:
>>> On Mon, Feb 09, 2015 at 07:56:23AM +0800, Anand Jain wrote:
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>>    fs/btrfs/volumes.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index 51873ec..1490723 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -2249,7 +2249,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>>>>    						root->fs_info->fsid);
>>>>    		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
>>>>    								fsid_buf))
>>>> -			goto error_trans;
>>>> +			printk(KERN_WARNING\
>>>> +			"BTRFS: sysfs: failed to create fsid for sprout\n");
>>>
>>> You can safely use btrfs_warn here.
>>>
>>
>> right. I tried to know what to use before, but wasn't sure.
>
> There's already btrfs_error used in the function. The only context where
> the message macros are not usable is during mount when fs_info is not
> available.
>
>> would you be
>> able to accept it as it is ? OR I can send a new patch to correct this.
>> Just that changing this commit would fail further commits like
>>     Btrfs: sysfs: support seed devices in the sysfs layout.
>
> But this patch also needs to apply the same sort of change, please
> resend. Thanks.

I got this in my local ws. Will be sending it out.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
