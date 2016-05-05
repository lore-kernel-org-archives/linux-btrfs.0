Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29817 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754654AbcEEBI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 21:08:59 -0400
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
To: <bo.li.liu@oracle.com>, <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <vegard.nossum@oracle.com>, <sterba@suse.com>
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
 <20160504132329.GT29353@twin.jikos.cz>
 <20160504174436.GB14909@localhost.localdomain>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a7811da3-06f5-2ff2-06e4-19be9fd31410@cn.fujitsu.com>
Date: Thu, 5 May 2016 09:08:54 +0800
MIME-Version: 1.0
In-Reply-To: <20160504174436.GB14909@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2016/05/04 10:44 -0700:
> On Wed, May 04, 2016 at 03:23:29PM +0200, David Sterba wrote:
>> On Tue, May 03, 2016 at 09:02:56AM +0800, Qu Wenruo wrote:
>>>
>>>
>>> Liu Bo wrote on 2016/05/02 11:15 -0700:
>>>> This adds valid checks for super_total_bytes, super_bytes_used and
>>>> super_stripesize.
>>>>
>>>> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
>>>> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
>>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>>> ---
>>>>  fs/btrfs/disk-io.c | 14 ++++++++++++++
>>>>  1 file changed, 14 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 4e47849..988d03f 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -4120,6 +4120,20 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>>>>  	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
>>>>  	 * done later
>>>>  	 */
>>>> +	if (btrfs_super_total_bytes(sb) == 0) {
>>>> +		printk(KERN_ERR "BTRFS: total bytes is zero\n");
>>>> +		ret = -EINVAL;
>>>> +	}
>>>
>>> Would it be better if using "6 * nodesize"?
>>>
>>> I'd like to use a precious low limit on total bytes, but we don't have
>>> such value, so 6 nodesize would be good.
>>
>> An early check can compare against some reasonable value, but the
>> total_bytes value must be equal to the sum of all device sizes
>> (disk_total_bytes). I'm not sure if we have enough information to verify
>> that at this point though.
>
> That's what I had in mind, the problem is that only the first device information is recorded in superblock.
>
> At this moment We have device_num but we don't know the size of other devices.
>
> Thanks,
>
> -liubo
>
>
What about error out if we found sb->total_bytes < 
sb->dev_item->total_bytes?

As we are just doing early check, no need to be comprehensive, but spot 
obvious problem.

For exact device_num and sb->total_bytes, we may do post check when 
device tree are loaded?
Splitting early_check() and post_check() seems valid for me.
(Also I prefer post_check() just warning, not forced exit)

Thanks,
Qu


