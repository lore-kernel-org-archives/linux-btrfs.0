Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60442 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932618AbeF3CNZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 22:13:25 -0400
Subject: Re: [PATCH 3/3] btrfs: fix race between mkfs and mount
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180604150030.12883-1-anand.jain@oracle.com>
 <20180604150030.12883-3-anand.jain@oracle.com>
 <20180607163931.GH3215@twin.jikos.cz> <20180619135301.GQ24375@twin.jikos.cz>
 <eca302a1-5400-504e-f43f-3b8bfcb74e80@oracle.com>
 <20180626121900.GI27958@twin.jikos.cz>
 <b3eca86e-db7a-41fc-e8f9-150d0418ffe8@oracle.com>
 <20180629120627.GP2287@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <8d45e08f-5fd1-6b67-74e0-6a0ddae0c002@oracle.com>
Date: Sat, 30 Jun 2018 10:16:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180629120627.GP2287@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/29/2018 08:06 PM, David Sterba wrote:
> On Tue, Jun 26, 2018 at 10:42:32PM +0800, Anand Jain wrote:
>>>>> Last version of the proposed fix is to extend the uuid_mutex over the
>>>>> whole mount callback and use it around calls to btrfs_scan_one_device.
>>>>> That way we'll be sure the mount will always get to the device it
>>>>> scanned and that will not be freed by the parallel scan.
>>>>
>>>>     That will break the requisite #1 as above.
>>>
>>> I don't see how it breaks 'mount and or scan of two independent fsid+dev
>>> is possible'. It is possible, but the lock does not need to be
>>> filesystem local.
>>>
>>> Concurrent mount or scan will block on the uuid_mutex,
>>
>>    As uuid_mutex is global, if fsid1 is being mounted, the fsid2 mount
>>    will wait upto certain extent with this code.
> 
> Yes it will wait a bit, but the critical section is short. There's some
> IO done and it's reading of 4K in btrfs_read_disk_super. The rest is
> cpu-bound and hardly measurable in practice, in context of concurrent
> mount and scanning.
> 
> I took the approach to fix the bug first and then make it faster or
> cleaner, also to fix it in a way that's still acceptable for current
> development cycle.
>>    My efforts here was to
>>    use uuid_mutex only to protect the fs_uuid update part, in this way
>>    there is concurrency in the mount process of fsid1 and fsid2 and
>>    provides shorter bootup time when the user uses the mount at boot
>>    option.
> 
> The locking can be still improved but the uuid_mutex is not a contended
> lock, mount is an operation that does not happen thousand times a
> second, same for the scanning.

  My concern is about the boot up time when there are larger number of
  LUN configured with independent btrfs FSIDs to mount at boot. Since
  BTRFS is a kind of infrastructure for the servers, we can't rule out
  that these kind of configuration won't exists at all. Anyway as you
  said we can use uuid_mutex for the current development cycle.

  However a review on [1] which does fix your earlier concern of
  returning -EBUSY is appreciated. And pls let me know if going ahead
  with this approach would be accepted in the current development cycle.?

> So even if there are several mounts happening during boot, it's just a
> few and the delay is IMO unnoticeable. If the boot time is longer by
> say 100ms at worst, I'm still ok with my patches as a fix.
> 
> But not as a final fix, so the updates to locking you mentioned are
> still possible. We now have a point of reference where syzbot does is
> not able to reproduce the bugs.


[1]
----------------------------------
When %fs_devices::opened > 0 the device is mounted, %fs_devices is never
freed so its safe to use %fs_devices and it does not need any locks or
flags.

However, when %fs_devices::opened == 0 (idle) that means device is not
yet mounted, and it can be either transition to opened or freed. When
it transitions to freed, fs_devices gets freed and any pointer accessing
will endup with UAF error.

Here are places where we access fs_devcies and it needs locking and
using uuid_mutex is one of method

1.
READY ioctl

2.
Mount

3.
SCAN ioctl

4.
Stale cleanup during SCAN

5.
planned device FORGET ioctl

#4 and #5 may free the fs_devices while #1, #2, and #3 are still
accessing the fs_devices.

using uuid_mutex is one choice however it would slow down the mount
at boot when there are larger number of independent btrfs fsid being
mounted at boot.

Proposed Fix
-------------

This does not return the -EBUSY. If there is any better way
I am ok to use it.

struct btrfs_fs_devices
{
::
    int ref_count;
::
}

To acquire a fs_devices..

volume_devices_excl_state_enter(x)
{
  fs_devices = NULL
  lock uuid_mutex
    if (fs_devices = find fs_devices(x))
         fs_devices::ref_count++
  unlock uuid_mutex
  return fs_devices
}


To release a fs_devices..

volume_devices_excl_state_exit(fs_devices)
{
   lock uuid_mutex
     fs_devices::ref_count--
   unlock uuid_mutex
}


To delete a fs_devices..

again:
  lock uuid_mutex
    find fs_devices
    if (fs_devices::ref_count != 0) {
       unlock uuid_mutex
       goto agin;
    }
    if (fs_devices->opened > 0) {
      unlock uuid_mutex
      return -EBUSY
    }

    free_fs_devices()
  unlock uuid_mutex

------------------------------------------


Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
