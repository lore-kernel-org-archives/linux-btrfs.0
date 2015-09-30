Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23647 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbbI3Fsm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 01:48:42 -0400
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
To: Dave Chinner <david@fromorbit.com>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150929215135.GZ3902@dastard> <560B354B.9050400@cn.fujitsu.com>
 <20150930042018.GB3902@dastard>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <560B77B1.9040007@cn.fujitsu.com>
Date: Wed, 30 Sep 2015 13:48:33 +0800
MIME-Version: 1.0
In-Reply-To: <20150930042018.GB3902@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave Chinner wrote on 2015/09/30 14:20 +1000:
> On Wed, Sep 30, 2015 at 09:05:15AM +0800, Qu Wenruo wrote:
>>
>>
>> Dave Chinner wrote on 2015/09/30 07:51 +1000:
>>> On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
>>>> Normally, a bull fallocate call on a fully written and synced file
>>>> should not add an extent.
>>>
>>> Why not? Filesystems can do whatever they want with extents during
>>> a fallocate call. e.g. if the blocks are shared, then fallocate
>>> might break the block sharing so future overwrites don't get
>>> ENOSPC. This is a requirement set down by posix_fallocate(3)
>>>
>>> "After a successful call to posix_fallocate(), subsequent writes to
>>> bytes in the specified range are guaranteed not  to fail because of
>>> lack of disk space."
>>>
>>> Hence if you've got a file with shared blocks, a "full fallocate"
>>> must change the extent layout to break the sharing. As such, the
>>> premise of this test is wrong.
>>
>> First, btrfs never meets the posix_fallocate requirement by its COW nature.
>>
>> Btrfs fallocate can only ensure at most next write will not cause ENOSPC.
>
> Which, it can be successfully argued, meets the basic requirement of
> posix_fallocate().  i.e. "subsequent writes" is "one or more" future
> writes.
>
> But in trying to explain how COW works you've completely missed the
> point I was making about a fundamental principle that COW is based
> on - overwrite requires allocation. Hence fallocate must be allowed
> modify the underlying layout of a file, even if the file is already
> full of allocated blocks and data.
>
> This isn't just btrfs - any filesystem that does dedupe or reflink
> or snapshots or compression or any other sort of operation that can
> cause extent reallocation on overwrite *may* change the file layout
> during a fallocate call to guarantee the next write succeeds.
>
>> It's OK not to consider it as a bug, at least data is not corrupted.
>> But IMO the btrfs behavior is not needed and need optimization.
>> So kernel patch is submitted to btrfs ml:
>> https://patchwork.kernel.org/patch/7284431/
>
> That's a link to the fstests patch, not a btrfs kernel patch. :/

Sorry, the real patch is https://patchwork.kernel.org/patch/7283461/

>
>> And if fstests is not the proper place, any idea where such "test
>> case" should belong?
>
> You still haven't understood what I said. If you want to test that
> btrfs does not truncate extents beyond EOF when fallocate is called,
> then it's a btrfs test. Yes, You can do whatever you want with
> btrfs, but you've proposed a generic test that applies a constraint
> to a generic operation that has no such constraint defined in it's
> API. If you want to constrain fallocate behaviour like this, then
> take it to linux-fsdevel and get everyone to agree on the
> constraint, and then I'll take it as a generic test...

Now, I think I understand the point.
The test case is not for generic, but for Btrfs only.

The reason is:
Fallocate should be able to change extent layout
Even all extent is allocated, for its purpose.

So the assumption for the test case is not valid, and how a filesystem 
handle the last page truncate should follow its own standard.

This is convincing now.

I'll change it to btrfs test.

BTW, at least xfs doesn't truncate beyond EOF, will xfs also need such test?

Thanks,
Qu

>
> Cheers,
>
> Dave.
>
