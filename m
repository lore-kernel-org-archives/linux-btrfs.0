Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21182 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab3DZJDW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 05:03:22 -0400
Message-ID: <517A431E.3090608@cn.fujitsu.com>
Date: Fri, 26 Apr 2013 17:04:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] Btrfs: remove btrfs_sector_sum structure
References: <5153FB3A.10507@cn.fujitsu.com> <515BF310.4070904@cn.fujitsu.com> <20130423205435.GD2631@localhost.localdomain> <517A41AA.6030102@cn.fujitsu.com>
In-Reply-To: <517A41AA.6030102@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 26 Apr 2013 16:58:18 +0800, Miao Xie wrote:
> On tue, 23 Apr 2013 16:54:35 -0400, Josef Bacik wrote:
>> On Wed, Apr 03, 2013 at 03:14:56AM -0600, Miao Xie wrote:
>>> Using the structure btrfs_sector_sum to keep the checksum value is
>>> unnecessary, because the extents that btrfs_sector_sum points to are
>>> continuous, we can find out the expected checksums by btrfs_ordered_sum's
>>> bytenr and the offset, so we can remove btrfs_sector_sum's bytenr. After
>>> removing bytenr, there is only one member in the structure, so it makes
>>> no sense to keep the structure, just remove it, and use a u32 array to
>>> store the checksum value.
>>>
>>> By this change, we don't use the while loop to get the checksums one by
>>> one. Now, we can get several checksum value at one time, it improved the
>>> performance by ~74% on my SSD (31MB/s -> 54MB/s).
>>>
>>> test command:
>>>  # dd if=/dev/zero of=/mnt/btrfs/file0 bs=1M count=1024 oflag=sync
>>>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> [SNIP]
>>>         next_offset = (u64)-1;
>>>         found_next = 0;
>>> +       bytenr = sums->bytenr + total_bytes;
>>>         file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
>>> -       file_key.offset = sector_sum->bytenr;
>>> -       bytenr = sector_sum->bytenr;
>>> +       file_key.offset = bytenr;
>>>         btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
>>>
>>> -       item = btrfs_lookup_csum(trans, root, path, sector_sum->bytenr, 1);
>>> +       item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
>>>         if (!IS_ERR(item)) {
>>> -               leaf = path->nodes[0];
>>> -               ret = 0;
>>> -               goto found;
>>> +               csum_offset = 0;
>>> +               goto csum;
>>
>> Ok I've just spent the last 3 hours tracking down an fsync() problem that turned
>> out to be because of this patch.  btrfs_lookup_csum() assumes you are just going
>> in 4k chunks, but we could be going in larger chunks.  So as long as the bytenr
>> falls inside of this csum item it thinks its good.  So what I'm seeing is this,
>> we have item
>>
>> [0-8k]
>>
>> and we are csumming
>>
>> [4k-12k]
>>
>> and then we're adding our new csum into the old one, the sizes match but the
>> bytenrs don't match.  If you want a reproducer just run my fsync xfstest that I
>> just posted.  I'm dropping this patch for now and I'll wait for you to fix it.
>> Thanks,
> 
> Is the reproducer is the 311th case of xfstests?
> ([PATCH] xfstests 311: test fsync with dm flakey V2)
> 
> If yes, I'm so sorry that we didn't reproduce the problem you said above. Could you
> give me your test option?

please ignore the attached patch, I sent it out by mistake.

Thanks
Miao
