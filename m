Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbeHBLQF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 07:16:05 -0400
Subject: Re: [PATCH v2 2/4] btrfs: fix race between free_stale_devices and
 close_fs_devices
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180726065334.30594-3-anand.jain@oracle.com>
 <20180801142948.GH3218@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ff16322e-6f2c-1e81-032d-651cfa23877f@oracle.com>
Date: Thu, 2 Aug 2018 17:29:12 +0800
MIME-Version: 1.0
In-Reply-To: <20180801142948.GH3218@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/01/2018 10:29 PM, David Sterba wrote:
> On Thu, Jul 26, 2018 at 02:53:32PM +0800, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> %fs_devices can be free-ed by btrfs_free_stale_devices() when the
>> close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
>> tries to access the %fs_devices again without the device_list_mutex.
>>
>> Fix this by bringing the %fs_devices access with in the device_list_mutex.
> 
> AFAICS this cannot happen anymore because the two calls are serialized
> by the uuid_mutex. But this was not the case when syzbot reported the
> problem where your patch would apply.
> 
> The parallell access to opened and device list cannot happen when:
> 
> * btrfs_scan_one_device that wants to call btrfs_free_stale_devices
> * btrfs_close_devices calls close_fs_devices
> 
> Fixed by the series:
> 
> btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
> btrfs: lift uuid_mutex to callers of btrfs_open_devices
> btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
> btrfs: reorder initialization before the mount locks uuid_mutex
> btrfs: fix mount and ioctl device scan ioctl race
> 
> If there's a race I don't see, please describe in more detail.

  Right. There is no race with the uuid_mutex patches as above.

  And I just found this- can we make close be consistent with its
  open part.
  btrfs_open_devices() hold device_list_mutex before the update to
  fs_devices::opened. So close_fs_device() could do the same, and be
  theoretically correct.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
