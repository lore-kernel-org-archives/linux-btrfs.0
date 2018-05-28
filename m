Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41326 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934027AbeE1Wyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 18:54:54 -0400
Subject: Re: [PATCH 2nd try v4] btrfs: drop uuid_mutex in
 btrfs_free_extra_devids()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180528144329.7790-1-anand.jain@oracle.com>
 <20180528154030.GD6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6daefb49-195a-71c1-7f9f-4c8b13136e31@oracle.com>
Date: Tue, 29 May 2018 06:57:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180528154030.GD6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/28/2018 11:40 PM, David Sterba wrote:
> On Mon, May 28, 2018 at 10:43:29PM +0800, Anand Jain wrote:
>> btrfs_free_extra_devids() is called only in the mount context which
>> traverses through the fs_devices::devices and frees the orphan devices
>> devices in the given %fs_devices if any. As the search for the orphan
>> device is limited to fs_devices::devices so we don't need the global
>> uuid_mutex.
>>
>> There can't be any mount-point based ioctl threads in this context as
>> the mount thread is not yet returned. But there can be the btrfs-control
>> based scan ioctls thread which calls device_list_add().
>>
>> Here in the mount thread the fs_devices::opened is incremented way before
>> btrfs_free_extra_devids() is called and in the scan context the fs_devices
>> which are already opened neither be freed or alloc-able at
>> device_list_add().
>>
>> But lets say you change the device-path and call the scan again, then scan
>> would update the new device path and this operation could race against the
>> btrfs_free_extra_devids() thread, which might be in the process of
>> free-ing the same device. So synchronize it by using the
>> device_list_mutex.
>>
>> This scenario is a very corner case, and practically the scan and mount
>> are anyway serialized by the usage so unless the race is instrumented its
>> very difficult to achieve.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> (I didn't see this email in the mailing list, so trying again).
>> v3->v4: As we traverse through the seed device, fs_device gets updated with
>> 	the child seed fs_devices, so make sure we use the same fs_devices
>> 	pointer for the mutex_unlock as used for the mutex_lock.
> 
> Well, now that I see the change, shouldn't we always hold the
> device_list_mutex of the fs_devices that's being processed? Ie. each
> time it's switched, the previous is unlocked and new one locked.

  No David. That's because we organize seed device under its parent
  fs_devices ((fs_devices::seed)::seed)..so on, and they are a local
  cloned copy of the original seed fs_devices. So parent's
  fs_devices::device_list_mutex lock will suffice.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
