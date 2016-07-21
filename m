Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61870 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753363AbcGUBxw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 21:53:52 -0400
Subject: Re: [PATCH 0/4] update bytes_may_use timely to avoid false ENOSPC
 issue
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
 <578F3A4C.4040702@applied-asynchrony.com>
CC: <dsterba@suse.cz>, <jbacik@fb.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57902A99.3000407@cn.fujitsu.com>
Date: Thu, 21 Jul 2016 09:51:21 +0800
MIME-Version: 1.0
In-Reply-To: <578F3A4C.4040702@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/20/2016 04:46 PM, Holger Hoffstätte wrote:
> On 07/20/16 07:56, Wang Xiaoguang wrote:
>> Currently in btrfs, for data space reservation, it does not update
>> bytes_may_use in btrfs_update_reserved_bytes() and the decrease operation
>> will be delayed to be done in extent_clear_unlock_delalloc(), for
>> fallocate(2), decrease operation is even delayed to be done in end
>> of btrfs_fallocate(), which is too late. Obviously such delay will
>> cause unnecessary pressure to enospc system, in [PATCH 4/4], there is
>> a simpel test script that can reveal such false ENOSPC bug.
>>
>> So in this patch set, it will remove RESERVE_FREE, RESERVE_ALLOC and
>> RESERVE_ALLOC_NO_ACCOUNT, and we always update bytes_may_use timely.
>>
>> I'll also commit a fstests test case for this issue.
>>
>> Wang Xiaoguang (4):
>>    btrfs: use correct offset for reloc_inode in
>>      prealloc_file_extent_cluster()
>>    btrfs: divide btrfs_update_reserved_bytes() into two functions
>>    btrfs: introduce new EXTENT_CLEAR_DATA_RESV flag
>>    btrfs: update btrfs_space_info's bytes_may_use timely
>>
> Just like the previous version, for all 4 patches:
>
> Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>
> via the reproducer script & some very large manual fallocates.
Yes, thanks very much for your test.
I also run the whole fstests before sending this patch set :)

Regards,
Xiaoguang Wang
>
> thanks!
> Holger
>
>
>



