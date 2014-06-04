Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29017 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaFDDYX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 23:24:23 -0400
Message-ID: <538E9226.5090509@oracle.com>
Date: Wed, 04 Jun 2014 11:27:34 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Should btrfs reuse the src_dev's dev UUID when doing dev replacing?
References: <537D5468.3040808@cn.fujitsu.com> <537D6A58.5040907@oracle.com> <538D6B0E.70903@cn.fujitsu.com>
In-Reply-To: <538D6B0E.70903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Qu,

  in-line below.

On 03/06/14 14:28, Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: Re: Should btrfs reuse the src_dev's dev UUID when doing dev
> replacing?
> From: Anand Jain <Anand.Jain@oracle.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs
> <linux-btrfs@vger.kernel.org>
> Date: 2014年05月22日 11:09
>>
>>
>>  Thanks Qu for bringing up this topic. We definitely need some focus
>>  on the btrfs volume management related bugs/features/enhancements.
>>
>>  more inline..
>>
>> On 22/05/14 09:35, Qu Wenruo wrote:
>>> Hi,
>>>
>>> [Current dev replace]
>>> As kernel codes show, 'btrfs dev replace' will swap tgt_dev's uuid with
>>> src_dev's uuid.
>>> This method works fine most of the time, since it doesn't need to change
>>> the chunk tree.
>>>
>>> [Problem with re-appear missing device]
>>> (Anand Jain reported the problem in Jan 2014)
>>> Take the following suitiuation as example:
>>> /dev/sda, /dev/sdb, /dev/sdc as btrfs RAID1.
>>> 1, 2, 3 as their dev id.
>>>
>>> 1)/dev/sdb is missing,
>>> Mount them in degraded mode.
>>>
>>> 2) 'btrfs dev replace start 2 /dev/sdd' will replace missing /dev/sdb.
>>>
>>> 3) /dev/sdb is online again.
>>>
>>> 4) umount /BTRFS/MOUNT/POINT; mount /dev/sda
>>> After mount, btrfs will still use /dev/sdb but not /dev/sdd
>>
>>  Yeah its weird that grouping depends on the mercy of chronological
>>  oder of device probing. The _last_ device probed stays in the list.
>>  But the most weird is if FS is mounted and is followed with the dev
>>  scan it would just overwrite the btrfs_device struct.
>>  I have sent out interim fix to both of these bugs a long time back.
>>
>>> [Cause of the bug]
>>> When this comes to missing device, since the src_dev is missing, neither
>>> UUID swap nor superblock wipe will
>>> work. So if the device reappears, next mount will scan the the fsid and
>>> dev uuid, and if btrfs scan the re-appeared
>>> device first, it will use the re-appeared device.
>>>
>>> [Method to fix]
>>> IMO there are 2 possible method to fix the bug.
>>> 1) Don't reuse the src_dev's dev UUID.
>>> I don't think any of the UUID in btrfs should be reused, so if every
>>> device in btrfs has its own UUID,
>>> it is quite easy to distinguish different devices, and even don't need
>>> to wipe the superblock of src_dev.
>>> (But superblock wipe is still needed for other reasons)
>>
>>  Yep that the right way IMO too. UUID must be unique to disk, even in
>>  the case of replace.
>>
>>> 2) Do generation check in device_list_add.
>>> When multiple devices with same dev UUID is found, only add the one
>>> whose generation is the same with
>>> other deivces.
>>> IMO this is just a workaround.
>>
>>  yes an interim fix, patch was sent out a long time back.

> BTW, I haven't seen a new version patch fixing device_list_add()
> function after Wang's comment.

> What is the process now?
>
> If you are busy working on other bugs, would you mind me making the
> device_list_add() check patch?

  Yes. some challenges to get that based on the generation number.
  too many limitations. and patch created didn't pass all the tests.
  so I didn't send that patch.
  But I was talking about this patch (sorry to confuse you).

    Btrfs: device_list_add() should not update list when mounted

  And as of now when its unmounted we expect user to wipe SB
  of the disk which should not belong to the fsid. which will
  solve the problem as well. but a bit of hard work though.
  (there is a chance to notice the _actual_ disks being used
  after the fs is mounted)

  appreciate your follow up on this. Kindly let me know if
  this plan solves the problem reasonably well. (for now).

Thanks, Anand



> Thanks,
> Qu
>>
>>> I think it is better to be decided before any related patch sent.
>>>
>>> Any suggestions?
>>>
>>> Thanks,
>>> Qu
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
