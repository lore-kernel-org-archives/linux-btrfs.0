Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbeBTM7K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 07:59:10 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH RESEND] btrfs: delete function btrfs_close_extra_devices()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180215050224.21158-1-anand.jain@oracle.com>
 <20180219165300.GL10193@twin.jikos.cz>
Message-ID: <b858d33d-678c-fc1f-2ef6-8f302e2e64b4@oracle.com>
Date: Tue, 20 Feb 2018 21:00:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180219165300.GL10193@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/20/2018 12:53 AM, David Sterba wrote:
> On Thu, Feb 15, 2018 at 01:02:24PM +0800, Anand Jain wrote:
>> btrfs_close_extra_devices() is not exactly about just closing the opened
>> devices, but its also about free-ing the stale devices which may have
>> scanned into the btrfs_fs_devices::dev_list. The way it picks devices to
>> be freed is by going through the btrfs_fs_devices::dev_list and its seed
>> devices, and finding for devices which do not have the flag
>> BTRFS_DEV_STATE_IN_FS_METADATA nor if it is part of the replace target.
>>
>> However, in the first place the way devices are scanned and added to the
>> btrfs_fs_devices::dev_list have changed for a long time now. During scan
>> when it finds matching fsid+uuid+devid it would add the device to
>> btrfs_fs_devices::dev_list. A matched device with higher generation number
>> overwrites the device with lower generation number during.
>>
>> Further, the stale devices containing the stale fsid are removed at the
>> time of the scan itself.
>>
>> So there isn't any opportunity that btrfs_close_extra_devices() can free
>> the stale device within the fsid which is being mounted.
>>
>> Further about the btrfs_fs_devices::latest_bdev that
>> the btrfs_close_extra_devices() function assigns, is already assigned by
>> the function __btrfs_open_devices().
>>
>> So as this function has no effect, delete it.
> 
> I think this is correct. Freeing stale devices as a side effect of mount
> does not seem right anyway. I'm still not able to convince myself that
> there's not an unexpected interaction of dev scan and dev replace, as
> it relies on the state bits and other locks. If you have ideas were to
> put some asserts or extra checks, please suggest.


  Thanks for comments. I took a fresh look after a long weekend.
  Here I found something new. Following test case [1] can simulate stale
  SB on the missing device which got deleted. Now if we do the fresh
  dev scan and mount the deleted device should not be kept in the
  device_list after the mount because that's stale. And as IN_FS_METADATA
  flag is not set on this device this function helps to clean up those
  devices. The dev scan free_stale can't catch this condition because
  we won't go deeper than the SB read. Sorry, my bad pls ignore this
  patch this is a very corner case or I had gone nuts when I investigated
  this.

[1]
   mkfs.btrfs -fq -mraid1 -draid1 /dev/sde /dev/sdf /dev/sdg
   modprobe -r btrfs
   mount -o degraded,device=/dev/sde /dev/sdf /btrfs
   btrfs dev del 3 /btrfs
   umount /btrfs
   btrfs dev scan /dev/sde /dev/sdf /dev/sdg
   mount /dev/sde /btrfs
   wipefs -a /dev/sdg <-- this should work as sdg is not part of
                          fsid mounted anymore.

  I am thinking to rename this function to btrfs_free_extra_devices()
  and add comments.

  Also about the fs_devices::latest_bdev we certainly assign it in
  __btrfs_open_devices(), but there we don't care if it picks the
  replacing target. And suppose if replacing_target has the highest
  (or equal) generation number compared to other we shall read the sys
  and chunk tree from it. So during the mount context we use and
  reconstruct using the replacing target, but at the end of mount
  context, we use the non-replace target as the latest_bdev.

Thanks, Anand


