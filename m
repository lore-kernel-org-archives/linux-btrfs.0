Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5016 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751175AbdAPB7y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 20:59:54 -0500
Subject: Re: [PATCH 0/3 for-4.10] RAID56 scrub fixes
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <clm@fb.com>
References: <20161212093843.8878-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <35ebd3e4-c6e9-5102-b336-416e9352267e@cn.fujitsu.com>
Date: Mon, 16 Jan 2017 09:59:45 +0800
MIME-Version: 1.0
In-Reply-To: <20161212093843.8878-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David, Chris,

Any comment on this patchset?

Although we don't recommend user to use RAID5/6 for now, but this 
patchset still fixes 2 quite important bugs for RAID5/6.

And current so far the test shows no regression.
(Although test cases like btrfs/011 and btrfs/069 is still causing 
problem, as v4.10-rc without this patch will also cause problems).

And the patchset is relatively small enough for an rc.

Thanks,
Qu

At 12/12/2016 05:38 PM, Qu Wenruo wrote:
> Can be feteched from github:
> https://github.com/adam900710/linux.git raid56_fixes
>
> Fixes 2 scrub bugs:
> 1) Scrub recover correct data, but wrong parity
> 2) Scrub report wrong csum error number, or even unrecoverable error
>
> The patches are still undergoing xfstests, but currect for-linus-4.10 is already
> causing deadlock for btrfs/011, even without the patches.
>
> So I'd remove btrfs/011 and continue the test, even these test cases won't trigger
> real recover code.
>
> But the current internal test cases are quite good so far.
> I'll test them for several extra loop, and submit the internal test for reference.
> (Since it's not suitable for xfstest, so I'd only submit the test script, which
> needs manually to probe chunk layout)
>
> Qu Wenruo (3):
>   btrfs: scrub: Introduce full stripe lock for RAID56
>   btrfs: scrub: Fix RAID56 recovery race conditiong
>   btrfs: raid56: Use correct stolen pages to calculate P/Q
>
>  fs/btrfs/ctree.h       |   4 ++
>  fs/btrfs/extent-tree.c |   3 +
>  fs/btrfs/raid56.c      |  62 ++++++++++++++--
>  fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 257 insertions(+), 4 deletions(-)
>


