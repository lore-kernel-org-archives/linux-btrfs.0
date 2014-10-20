Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31737 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaJTISS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 04:18:18 -0400
Message-ID: <5444C536.2070803@oracle.com>
Date: Mon, 20 Oct 2014 16:17:58 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org, lists@colorremedies.com,
        clm@fb.com
Subject: Re: [PATCH v2] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO
 miss-matched with slots
References: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>	 <1408351099-4721-1-git-send-email-anand.jain@oracle.com>	 <1408351099-4721-2-git-send-email-anand.jain@oracle.com>	 <20140904095812.GA5636@twin.jikos.cz> <540854CD.2080106@oracle.com> <1413511097.4054.8.camel@localhost.localdomain>
In-Reply-To: <1413511097.4054.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


inline as below.


On 10/17/2014 09:58 AM, Gui Hecheng wrote:
> On Thu, 2014-09-04 at 20:02 +0800, Anand Jain wrote:
>>
>>
>> On 09/04/2014 05:58 PM, David Sterba wrote:
>>> On Mon, Aug 18, 2014 at 04:38:18PM +0800, Anand Jain wrote:
>>>> ioctl BTRFS_IOC_FS_INFO return num_devices which does _not_ include seed
>>>> device, But the following ioctl BTRFS_IOC_DEV_INFO counts and gets seed
>>>> disk when probed. So in the userland we hit a count-slot missmatch
>>>> bug..
>>>>               get_fs_info()
>>>>               ::
>>>>                       BUG_ON(ndevs >= fi_args->num_devices);
>>>> which hits this bug when we have mounted a seed device.
>>>>
>>>> So to fix this problem here in this patch ioctl BTRFS_IOC_FS_INFO
>>>> will provide total_devices instead of num_devices.
>>>
>>> The ioctl is very unclear what the 'num_device' actually means.
>>
>>    Right. Thats also true in kernel. very messy. very confusing.
>>    tool btrfs-devlist would help understand whats going on.
>>
>> ----
>>    $ egrep num_device *.c | egrep "total_device"
>> ioctl.c:	fi_args->num_devices = fs_devices->total_devices;
>> super.c:		ret = !(fs_devices->num_devices == fs_devices->total_devices);
>> volumes.c:	total_devices = btrfs_super_num_devices(disk_super);
>> ----
>>
>>    By the way about BTRFS_IOC_DEVICES_READY ioctl above its long time
>>    broken with seed/replace, just waiting to get these patches integrated
>>    first so to fix it later.
>>
>>
>>>> This would fix the problem partly. Partly because ealier num_devices
>>>> included the replacing device but now total_device does not include
>>>> the replacing device. Getting a count which includes a transient device
>>>> is rather too in efficient/wrong indeed, because there can be a race
>>>> condition where in the time between ioctl BTRFS_IOC_FS_INFO to
>>>> BTRFS_IOC_DEV_INFO the replace device operation might have been
>>>> completed. So to fix this problem its better that user land btrfs-progs
>>>> probes replacing device (at devid 0) separately.
>>>>
>>>> v2:
>>>> Agree with Wang's comment. Its better to show seed disks under the
>>>> sprout fs, so that user can establish mapping of seed to sprout devices.
>>>>
>>>> So here I am making BTRFS_IOC_FS_INFO to return the total_devices
>>>> which would count the seed devices (but not the replacing device).
>>>
>>> This is even more confusing. I think we need to add another member to
>>> the ioctl struct to reflect the number of regular devices (num_devices)
>>> and the true total number of devices including seeding and replaced
>>> devices.
>>
>>    that will be a better way. thanks.
>>
>>> The difference should be accompanied by a flag that would say
>>> if there's a seeding or replace in progress.
>>>
>>> There are some backward compatibility concerns. Setting num_devices to
>>> total_devices changes semantics of the ioctl, so I think it should stay
>>> as is for now,
>>
>>    As I have tested there is not backward compatibility issue.
>>    But from semantics perspective .. agreed.
>>
>>> but the BUG_ON can be removed and replaced by code that
>>> reallocates the buffer or allocates a few more items in advance.
>>
>>     We don't know how may seed devices are there for a sprout FS.
>>     So thats not possible.
>>
>>    Will review  resubmit.
>>
>> Thanks for commenting.
>
> Hi all,
>
> Firtly, thanks for the fix, Anand, how's the new version going?

> I've been testing the btrfs fi show cmd these days and find that
> this patch has not been merged into linus's tree yet.
>
> Since the suggested way of adding member to the ioctl struct brings
> compatibility issues, it may need more discussion.

  Thanks Gui for commenting.

  Yes discussion is needed. Mainly on our long term plan for a better
  btrfs kernel device and parameter read interface. which also means
  current bugs can wait for this new interface instead of patching the
  old structures and bring in a new compatibility mess.

Thanks, Anand



> But since this fix really incluence much to the user, I consider merging
> this version first to be a good idea.
>
> What do you think, Chris?
>
> Thanks,
> Gui
>
>> Anand
>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
