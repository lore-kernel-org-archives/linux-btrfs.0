Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeFZOj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 10:39:28 -0400
Subject: Re: [PATCH 3/3] btrfs: fix race between mkfs and mount
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180604150030.12883-1-anand.jain@oracle.com>
 <20180604150030.12883-3-anand.jain@oracle.com>
 <20180607163931.GH3215@twin.jikos.cz> <20180619135301.GQ24375@twin.jikos.cz>
 <eca302a1-5400-504e-f43f-3b8bfcb74e80@oracle.com>
 <20180626121900.GI27958@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b3eca86e-db7a-41fc-e8f9-150d0418ffe8@oracle.com>
Date: Tue, 26 Jun 2018 22:42:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180626121900.GI27958@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/26/2018 08:19 PM, David Sterba wrote:
> On Tue, Jun 26, 2018 at 02:25:11PM +0800, Anand Jain wrote:
>>
>>
>> (sorry for the delay in reply due to my vacation and, other
>>    urgent things took my priority too).
>>
>>    Please see inline below.
>>
>> On 06/19/2018 09:53 PM, David Sterba wrote:
>>> On Thu, Jun 07, 2018 at 06:39:32PM +0200, David Sterba wrote:
>>>> On Mon, Jun 04, 2018 at 11:00:30PM +0800, Anand Jain wrote:
>>>>> In an instrumented testing it is possible that the mount and
>>>>> a newer mkfs.btrfs thread on the same device can race and if the new
>>>>> mkfs.btrfs wins it will free the older fs_devices, then the mount thread
>>>>> will lead to oops.
>>>>>
>>>>> Thread1						Thread2
>>>>> -------						-------
>>>>> mkfs.btrfs -fq /dev/sdb
>>>>> mount /dev/sdb /btrfs
>>>>> |_btrfs_mount_root()
>>>>>     |_btrfs_scan_one_device(... &fs_devices)
>>>>>
>>>>> 						mkfs.btrfs -fq /dev/sdb
>>>>> 						|_btrfs_contol_ioctl()
>>>>> 						  |_btrfs_scan_one_device(... &fs_devices)
>>>>> 						    |_::
>>>>> 						      |_btrfs_free_stale_devices()
>>>>>
>>>>>     |_btrfs_open_devices(fs_devices ..) <-- stale fs_devices.
>>>>>
>>>>> Fix this with a mutually exclusive flag BTRFS_VOL_FLAG_EXCL_OPS.
>>>>
>>>> I'm not sure this is the right way to fix it, adding another bit to the
>>>> uuid_mutex and device_list_mutex combo.
>>
>>    Hmm I wonder why?
>>
>>>> To fix the race between mount and mkfs we can add a bit of logic to the
>>>> device scanning so that mount calling scan will track the purpose and
>>>> mkfs scan will not be allowed to free that device.
>>
>>    Right. To implement such a logic requisites are..
>>     #1 The lock must be FSID local so that concurrent mount and or scan
>>        of two independent FSID+DEV is possible.
>>     #2 It should not return EBUSY when either of scan or mount is in
>>        progress but smart enough to complete the (re)scan and or mount
>>        in parallel
>>
>>    #1 is must, but #2 is good to have and if EBUSY is returned its not
>>    wrong as well.
>>
>>
>>> Last version of the proposed fix is to extend the uuid_mutex over the
>>> whole mount callback and use it around calls to btrfs_scan_one_device.
>>> That way we'll be sure the mount will always get to the device it
>>> scanned and that will not be freed by the parallel scan.
>>
>>    That will break the requisite #1 as above.
> 
> I don't see how it breaks 'mount and or scan of two independent fsid+dev
> is possible'. It is possible, but the lock does not need to be
> filesystem local.
> 
> Concurrent mount or scan will block on the uuid_mutex,

  As uuid_mutex is global, if fsid1 is being mounted, the fsid2 mount
  will wait upto certain extent with this code. My efforts here was to
  use uuid_mutex only to protect the fs_uuid update part, in this way
  there is concurrency in the mount process of fsid1 and fsid2 and
  provides shorter bootup time when the user uses the mount at boot
  option.

Thanks, Anand

> so all callers
> will proceed once the lock is released and there's no unexpected
> behaviour.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
