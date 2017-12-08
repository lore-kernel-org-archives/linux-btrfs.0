Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58503 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbdLHIN2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 03:13:28 -0500
Subject: Re: [PATCH 5/5] btrfs: Greatly simplify btrfs_read_dev_super
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-6-git-send-email-nborisov@suse.com>
 <96aafd8d-a1e8-2846-0aa3-59b3ff97edb7@oracle.com>
 <f08faba1-2c79-bd80-34f5-f8f85e927464@suse.com>
 <20171204141337.GX3553@twin.jikos.cz>
 <897b7a95-1fd6-9647-f959-1d5f8f275685@suse.com>
 <20171206162448.GD3553@twin.jikos.cz>
 <24281483-900c-ab1b-c407-5fa6983f5311@oracle.com>
Message-ID: <acf7906d-3284-eaf2-a954-3acb8017dbbf@oracle.com>
Date: Fri, 8 Dec 2017 16:13:49 +0800
MIME-Version: 1.0
In-Reply-To: <24281483-900c-ab1b-c407-5fa6983f5311@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/07/2017 11:07 PM, Anand Jain wrote:
> 
> 
> On 12/07/2017 12:24 AM, David Sterba wrote:
>> On Mon, Dec 04, 2017 at 06:20:09PM +0200, Nikolay Borisov wrote:
>>>>> I don't understand what problem *should* be solved here...
>>>>
>>>> Without any further checks and validation, we cannot simply iterate 
>>>> over
>>>> all superblocks and try to mount anything that looks ok. Even if the
>>>> offsets exist on the block device.  The fsid should be at least 
>>>> checked,
>>>> but that's still not enough to ensure the 1st copy is what we want to
>>>> mount.
>>>
>>> I'm more inclined to agree with Anand here, that if the users wants to
>>> mount with -t btrfs then the filesystem should assume it's correct to
>>> use any of the additional superblocks.
>>
>> If and only if the additional superblocks are valid. And if we can't
>> read the primary superblock, we don't have enough information to
>> establish the validation.  EIO?  We don't have anything.  CRC mismatch?
>> Can't trust the whole data.  We need FSID and total_size at least. Other
>> actions are limited from inside kernel.

  ext4 has mount option -o sb=<copy_num> to specify the copy num to use.

  Not sure if I have dug enough but as of now I don't find any pitfall.
  Only funny thing is you can mount a device even after wipefs -a and
  recover its primary SB, to which my view is that the problem is at
  the wipefs -a end, not able to wipe all SB copies.

  I sent out an experimental RFC patch here:
    [PATCH RFC] btrfs: self heal from SB fail

  Pls try out, any problem that you could think off by this approach.

Thanks, Anand
