Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20607 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbaFRQEp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 12:04:45 -0400
Message-ID: <53A1B82A.4040906@fb.com>
Date: Wed, 18 Jun 2014 09:02:50 -0700
From: Jens Axboe <axboe@fb.com>
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: commit 762380a "block: add notion of a chunk size for request
 merging" stops io on btrfs
References: <53A0B491.1040901@gmail.com> <53A0F54F.2060205@fb.com> <53A13DE9.4020001@gmail.com>
In-Reply-To: <53A13DE9.4020001@gmail.com>
Content-Type: text/plain; charset="windows-1253"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-06-18 00:21, Konstantinos Skarlatos wrote:
> On 18/6/2014 5:11 рм, Jens Axboe wrote:
>> On 2014-06-17 14:35, Konstantinos Skarlatos wrote:
>>> Hi all,
>>> with 3.16-rc1  rsync stops writing to my btrfs filesystem and stays at a
>>> D+ state.
>>> git bisect showed that the problematic commit is:
>>>
>>> 762380ad9322951cea4ce9d24864265f9c66a916 is the first bad commit
>>> commit 762380ad9322951cea4ce9d24864265f9c66a916
>>> Author: Jens Axboe <axboe@fb.com>
>>> Date:   Thu Jun 5 13:38:39 2014 -0600
>>>
>>>      block: add notion of a chunk size for request merging
>>>
>>>      Some drivers have different limits on what size a request should
>>>      optimally be, depending on the offset of the request. Similar to
>>>      dividing a device into chunks. Add a setting that allows the driver
>>>      to inform the block layer of such a chunk size. The block layer
>>> will
>>>      then prevent merging across the chunks.
>>>
>>>      This is needed to optimally support NVMe with a non-zero stripe
>>> size.
>>>
>>>      Signed-off-by: Jens Axboe <axboe@fb.com>
>>
>> That's odd, should not have any effect since nobody enables stripe
>> sizes in the kernel. I'll double check, perhaps it's not always being
>> cleared.
>>
>> Ah wait, does the attached help?
>
> Yes, it works! I recompiled at commit
> 762380ad9322951cea4ce9d24864265f9c66a916 with your patch and it looks
> ok. Rebooted back to the unpatched kernel and the bug showed up again
> immediately.
>
> The funny thing is that the problem only showed on my (multi-disk) btrfs
> filesystem. / which is on ext4 seems to work fine.

Probably because the multi-disk setup doesn't have hw_sectors set, I'm 
guessing. But great, I'll get this upstream asap. Thanks for testing!

-- 
Jens Axboe

