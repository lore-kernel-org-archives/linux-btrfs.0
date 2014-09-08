Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:56547 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaIHRIy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 13:08:54 -0400
Message-ID: <540DE427.4040008@inwind.it>
Date: Mon, 08 Sep 2014 19:15:19 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: dsterba@suse.cz, Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Scan all devices to build fs device list
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com> <540B6900.7000307@fb.com> <20140908090946.GI5636@twin.jikos.cz> <540D8D45.6000608@oracle.com>
In-Reply-To: <540D8D45.6000608@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/08/2014 01:04 PM, Anand Jain wrote:
> 
> 
> On 08/09/2014 17:09, David Sterba wrote:
>> On Sat, Sep 06, 2014 at 04:05:20PM -0400, Chris Mason wrote:
>>> On 09/03/2014 09:36 AM, Miao Xie wrote:
>>>> This patchset implements device list automatic building function. As we
>>>> know, currently we need scan the devices to build device list by a user tool
>>>> before mounting the filesystem, especially mount the filesystem after
>>>> we re-install btrfs module. It is not convenient. This patchset can improve
>>>> that problem. With this patchset, we will scan all the devices in the
>>>> system to build the device list if we find the number of the devices
>>>> is not right when we mount the filesystem. By this way, we needn't scan
>>>> the device by the user tool and reduce the mount failure probability due
>>>> to the incomplete device list.
>>>
>>> Thanks for working on these patches, but I really prefer that we do
>>> these scans from userspace.
>>
>> I agree. The userspace approach gives more control of when and how the
>> scanning is done. Yes the scan has to be done after the module is
>> inserted, but distros have that in initrd. Reinstalling module is not
>> something a normal user does and developers know how to workaround.
>>
>> Automatic scanning in usperspace can be done via the mount helper and
>> this is IMO the way to go. There's a patch for that from Goffredo, not
>> merged yet, the patch backlog is still too long.
> 
> 
>  Since we are on the topic of scanning. A point on improving the
>  btrfs-progs scan method which I am working on...
> 
>    - Scan of all system devices is an expensive task. But btrfs-progs
>      do it very liberally. Due to this there are some serious problem
>      like - btrfs fi show is too slow when scrub is running.
> 
>    - The worst is Single btrfs-progs thread scans for btrfs
>      devices multiple times. Mainly because most of the functions
>      uses check_mounted() which in turn calls scan, think of
>      multi device btrfs config.

Using libblkid (see your proposal below) would help in this case, 
because the values would be cached.
> 
>    - The problem would be more prominent in larger server with 1000's
>      of LUNs / devices.
> 
>    - lblkid can be the only method to scan for devices. (The other
>      method we have as of now is of canning /proc/partitions, which
>      lblkid also does).
> 
>   what I am planning -
>     Use btrfs control ioctl to help btrfs-progs check_mounted() to know
>       if a (multi) device is mounted.
>     Build kernel's fs_devices list in the user-space using btrfs
>       control ioctl.
>     Do device scan only once per btrfs-progs thread.

You are talking about a ioctl: why not use (extending them when needed) 
the sysfs information ?

> 
> Any comments ?


> 
> Thanks, Anand
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
