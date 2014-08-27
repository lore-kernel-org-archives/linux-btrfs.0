Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59470 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933257AbaH0NAJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 09:00:09 -0400
Message-ID: <53FDD651.3080600@fb.com>
Date: Wed, 27 Aug 2014 09:00:01 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <toralf.foerster@gmx.de>
Subject: Re: [PATCH RFC] Btrfs: fix warning of insert_state() when doing lseek
References: <1409066130-29948-1-git-send-email-bo.li.liu@oracle.com> <53FCA7F9.90709@fb.com> <20140827083709.GB15994@localhost.localdomain>
In-Reply-To: <20140827083709.GB15994@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/27/2014 04:37 AM, Liu Bo wrote:
> On Tue, Aug 26, 2014 at 11:30:01AM -0400, Chris Mason wrote:
>>
>>
>> On 08/26/2014 11:15 AM, Liu Bo wrote:
>>> An user reported this, it is because that lseek's SEEK_SET/SEEK_CUR/SEEK_END
>>> allow a negative value for @offset, but btrfs's SEEK_DATA/SEEK_HOLE don't
>>> prepare for that and convert the negative @offset into unsigned type,
>>> so we get (end < start) warning.
>>>
>>> [ 1269.835374] ------------[ cut here ]------------
>>> [ 1269.836809] WARNING: CPU: 0 PID: 1241 at fs/btrfs/extent_io.c:430 insert_state+0x11d/0x140()
>>> [ 1269.838816] BTRFS: end < start 4094 18446744073709551615
>>> [ 1269.840334] CPU: 0 PID: 1241 Comm: a.out Tainted: G        W      3.16.0+ #306
>>> [ 1269.858229] Call Trace:
>>> [ 1269.858612]  [<ffffffff81801a69>] dump_stack+0x4e/0x68
>>> [ 1269.858952]  [<ffffffff8107894c>] warn_slowpath_common+0x8c/0xc0
>>> [ 1269.859416]  [<ffffffff81078a36>] warn_slowpath_fmt+0x46/0x50
>>> [ 1269.859929]  [<ffffffff813b0fbd>] insert_state+0x11d/0x140
>>> [ 1269.860409]  [<ffffffff813b1396>] __set_extent_bit+0x3b6/0x4e0
>>> [ 1269.860805]  [<ffffffff813b21c7>] lock_extent_bits+0x87/0x200
>>> [ 1269.861697]  [<ffffffff813a5b28>] btrfs_file_llseek+0x148/0x2a0
>>> [ 1269.862168]  [<ffffffff811f201e>] SyS_lseek+0xae/0xc0
>>> [ 1269.862620]  [<ffffffff8180b212>] system_call_fastpath+0x16/0x1b
>>> [ 1269.862970] ---[ end trace 4d33ea885832054b ]---
>>>
>>> This adds a check for that, if we find the unsigned type @offset is greater
>>> than inode's size, we get to skip trying to find extent maps.
>>
>> Dave Jones hit something similar with his fuzzer.  Fixing it up was on
>> my list for rc4.  Thanks for taking a look.
>>
>>>
>>> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>>  fs/btrfs/file.c | 12 ++++++++++--
>>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 1f2b99c..a370916 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>> @@ -2644,6 +2644,13 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
>>>  	u64 len = i_size_read(inode);
>>>  	int ret = 0;
>>
>>
>> We also check if (lockend <= lockstart), but that doesn't cover the case
>> where lockend == lockstart == (u64)-1).  We should also be sector
>> aligning everything we send down to lock_extent_bits.
> 
> Hmm...I don't understand how (lockend == lockstart == (u64)-1) could happen,
> lockend is assigned by i_size_read(inode), will it be -1?

Well, it's an unsigned....Dave's fuzzer can send lots of evil values.

> 
> Yeah, I'm taking care of the align stuff, perhaps doing it in another patch is a
> good idea?

I'd do it all in one, Btrfs: fix up bounds checking in lseek

-chris

