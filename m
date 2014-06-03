Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59468 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbaFCG1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 02:27:14 -0400
Message-ID: <538D6B00.8020302@cn.fujitsu.com>
Date: Tue, 3 Jun 2014 14:28:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Should btrfs reuse the src_dev's dev UUID when doing dev replacing?
References: <537D5468.3040808@cn.fujitsu.com> <537D6A58.5040907@oracle.com>
In-Reply-To: <537D6A58.5040907@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Should btrfs reuse the src_dev's dev UUID when doing dev 
replacing?
From: Anand Jain <Anand.Jain@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs 
<linux-btrfs@vger.kernel.org>
Date: 2014年05月22日 11:09
>
>
>  Thanks Qu for bringing up this topic. We definitely need some focus
>  on the btrfs volume management related bugs/features/enhancements.
>
>  more inline..
>
> On 22/05/14 09:35, Qu Wenruo wrote:
>> Hi,
>>
>> [Current dev replace]
>> As kernel codes show, 'btrfs dev replace' will swap tgt_dev's uuid with
>> src_dev's uuid.
>> This method works fine most of the time, since it doesn't need to change
>> the chunk tree.
>>
>> [Problem with re-appear missing device]
>> (Anand Jain reported the problem in Jan 2014)
>> Take the following suitiuation as example:
>> /dev/sda, /dev/sdb, /dev/sdc as btrfs RAID1.
>> 1, 2, 3 as their dev id.
>>
>> 1)/dev/sdb is missing,
>> Mount them in degraded mode.
>>
>> 2) 'btrfs dev replace start 2 /dev/sdd' will replace missing /dev/sdb.
>>
>> 3) /dev/sdb is online again.
>>
>> 4) umount /BTRFS/MOUNT/POINT; mount /dev/sda
>> After mount, btrfs will still use /dev/sdb but not /dev/sdd
>
>  Yeah its weird that grouping depends on the mercy of chronological
>  oder of device probing. The _last_ device probed stays in the list.
>  But the most weird is if FS is mounted and is followed with the dev
>  scan it would just overwrite the btrfs_device struct.
>  I have sent out interim fix to both of these bugs a long time back.
>
>> [Cause of the bug]
>> When this comes to missing device, since the src_dev is missing, neither
>> UUID swap nor superblock wipe will
>> work. So if the device reappears, next mount will scan the the fsid and
>> dev uuid, and if btrfs scan the re-appeared
>> device first, it will use the re-appeared device.
>>
>> [Method to fix]
>> IMO there are 2 possible method to fix the bug.
>> 1) Don't reuse the src_dev's dev UUID.
>> I don't think any of the UUID in btrfs should be reused, so if every
>> device in btrfs has its own UUID,
>> it is quite easy to distinguish different devices, and even don't need
>> to wipe the superblock of src_dev.
>> (But superblock wipe is still needed for other reasons)
>
>  Yep that the right way IMO too. UUID must be unique to disk, even in
>  the case of replace.
>
>> 2) Do generation check in device_list_add.
>> When multiple devices with same dev UUID is found, only add the one
>> whose generation is the same with
>> other deivces.
>> IMO this is just a workaround.
>
>  yes an interim fix, patch was sent out a long time back.
BTW, I haven't seen a new version patch fixing device_list_add() 
function after Wang's comment.

What is the process now?

If you are busy working on other bugs, would you mind me making the 
device_list_add() check patch?

Thanks,
Qu
>
>> I think it is better to be decided before any related patch sent.
>>
>> Any suggestions?
>>
>> Thanks,
>> Qu
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html

