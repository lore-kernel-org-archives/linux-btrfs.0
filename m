Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbeHHMGx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 08:06:53 -0400
Subject: Re: [PATCH v2 2/4] btrfs: fix race between free_stale_devices and
 close_fs_devices
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180726065334.30594-3-anand.jain@oracle.com>
 <20180801142948.GH3218@twin.jikos.cz>
 <ff16322e-6f2c-1e81-032d-651cfa23877f@oracle.com>
 <20180807145948.GH3218@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <261bd905-7811-0acf-a609-5606a21d8b2e@oracle.com>
Date: Wed, 8 Aug 2018 17:51:31 +0800
MIME-Version: 1.0
In-Reply-To: <20180807145948.GH3218@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/07/2018 10:59 PM, David Sterba wrote:
> On Thu, Aug 02, 2018 at 05:29:12PM +0800, Anand Jain wrote:
>>
>>
>> On 08/01/2018 10:29 PM, David Sterba wrote:
>>> On Thu, Jul 26, 2018 at 02:53:32PM +0800, Anand Jain wrote:
>>>> From: Anand Jain <Anand.Jain@oracle.com>
>>>>
>>>> %fs_devices can be free-ed by btrfs_free_stale_devices() when the
>>>> close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
>>>> tries to access the %fs_devices again without the device_list_mutex.
>>>>
>>>> Fix this by bringing the %fs_devices access with in the device_list_mutex.
>>>
>>> AFAICS this cannot happen anymore because the two calls are serialized
>>> by the uuid_mutex. But this was not the case when syzbot reported the
>>> problem where your patch would apply.
>>>
>>> The parallell access to opened and device list cannot happen when:
>>>
>>> * btrfs_scan_one_device that wants to call btrfs_free_stale_devices
>>> * btrfs_close_devices calls close_fs_devices
>>>
>>> Fixed by the series:
>>>
>>> btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
>>> btrfs: lift uuid_mutex to callers of btrfs_open_devices
>>> btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
>>> btrfs: reorder initialization before the mount locks uuid_mutex
>>> btrfs: fix mount and ioctl device scan ioctl race
>>>
>>> If there's a race I don't see, please describe in more detail.
>>
>>    Right. There is no race with the uuid_mutex patches as above.
>>
>>    And I just found this- can we make close be consistent with its
>>    open part.
>>    btrfs_open_devices() hold device_list_mutex before the update to
>>    fs_devices::opened. So close_fs_device() could do the same, and be
>>    theoretically correct.
> 
> Or it can be the other way around, to push the device_list_mutex only
> around the list_sort and open_fs_devices like:

> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1144,15 +1144,15 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   
>          lockdep_assert_held(&uuid_mutex);
>   
> -       mutex_lock(&fs_devices->device_list_mutex);
>          if (fs_devices->opened) {
>                  fs_devices->opened++;
>                  ret = 0;
>          } else {
> +               mutex_lock(&fs_devices->device_list_mutex);
>                  list_sort(NULL, &fs_devices->devices, devid_cmp);
>                  ret = open_fs_devices(fs_devices, flags, holder);
> +               mutex_unlock(&fs_devices->device_list_mutex);
>          }
> -       mutex_unlock(&fs_devices->device_list_mutex);
>   
>          return ret;
>   }
> 

  Right. That it will be also true in terms of consistency. And I looked
  around I don't find any reason why not.

  Next question - btrfs_free_stale_devices() need a better way to check
  if the device is opened by the FS. Currently it relays on the
  fs_devices::opened.
  And while doing that, both uuid_mutex and device_list_mutex are held
  and since we are depend on uuid_mutex we don't need device_list_mutex.
  uuid_mutex is too gross could stall operation on other FSID.

  We can drop this patch. Do you want a patch to fix the
  btrfs_open_devices() consistency?

Thanks, Anand
