Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34709 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbbHYGAh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 02:00:37 -0400
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
To: Marc MERLIN <marc@merlins.org>
References: <55CB71E5.1070302@fb.com> <20150812171912.GL29259@merlins.org>
 <55D1406C.9040607@cn.fujitsu.com> <20150817144904.GT29259@merlins.org>
 <20150822143746.GG5602@merlins.org> <55DA6F06.7030605@cn.fujitsu.com>
 <20150824042800.GJ5602@merlins.org> <55DAA77E.10105@cn.fujitsu.com>
 <20150824141013.GM5602@merlins.org> <55DBD814.4000801@cn.fujitsu.com>
 <20150825052820.GC20179@merlins.org>
CC: Josef Bacik <jbacik@fb.com>, <dsterba@suse.com>, <clm@fb.com>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55DC0480.7080102@cn.fujitsu.com>
Date: Tue, 25 Aug 2015 14:00:32 +0800
MIME-Version: 1.0
In-Reply-To: <20150825052820.GC20179@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc MERLIN wrote on 2015/08/24 22:28 -0700:
> On Tue, Aug 25, 2015 at 10:51:00AM +0800, Qu Wenruo wrote:
>> Patches sent and CCed to you.
>>
>> Please try the two patches and see what's new.
>> This time, I think the output will be much larger.
>
> Indeed.
>
> However the bad news is that gen 39538 is the highest.
> Should I force btrfsck to work with an older generation, or do we throw the towel and stop bothering
> trying to rescue this FS longer (it's a backup FS, so I have no data I need to recover on it, I just curious
> on how it managed to corrupt itself when all I did was a weekly backup to it via btrfs send/receive.
>
> myth:~# sort  -rn -k +4  /var/spool/out  |head -20
> Well block 29523968(gen: 39538 level: 1) seems good, and it matches superblock
> Well block 29687808(gen: 39537 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 93749248(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 60669952(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 30474240(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 29540352(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 150880256(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 150568960(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 150552576(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 150519808(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 150503424(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 141410304(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 136347648(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7312195813376(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7312194404352(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7312086122496(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7312079536128(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7311940960256(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7311866003456(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
> Well block 7311839477760(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
>
> Thanks,
> Marc
>
Thanks for all your work and patient Marc,

Good to know there is backup.
But as there is no higher generation one, so I'd assume that's not a
normal transaction id failure case.

Personally, I'd like to try btrfsck with gen 39537(--tree-root 29687808),
but that's all my personal curiosity.
Although my curiosity is driving me from finding a clue how it's
damaged to try to recover it.

If you think it's OK, then just wipe it, nobody has the right to disturb 
your sleep.

At least we got some clue here.
Some parent nodes got corrupted with much higher and non-exists generation.

Thanks,
Qu
