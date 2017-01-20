Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16026 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751059AbdATFq1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 00:46:27 -0500
Subject: Re: btrfs check lowmem vs original
To: Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
Date: Fri, 20 Jan 2017 13:45:57 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/20/2017 12:38 PM, Chris Murphy wrote:
> All of my Btrfs file systems, including new ones, have errors
> according to lowmem mode, and no errors reported at all for original
> mode. So which is correct? If lowmem mode is correct, then there are
> obviously kernel bugs that are causing problems right away, even on
> minutes old file systems.
>
> I can't tell from the output whether these are serious errors or minor
> errors either, because the output from check is totally
> incomprehensible. Further the usage summary at the end, extent bytes,
> and fs bytes, etc. are different, sometimes by an order of magnitude,
> between lowmem and original.
>
> Errors like this:
>
> ERROR: block group[46200258560 1073741824] used 1073741824 but extent
> items used 1144422400
> ERROR: block group[85928706048 1073741824] used 1073741824 but extent
> items used 0
> ERROR: block group[178270502912 1073741824] used 1073741824 but extent
> items used 1083211776
> ERROR: block group[360806612992 1073741824] used 1073479680 but extent
> items used 1074769920

Christoph Anton Mitterer also reported this bug.

And it turns out to be a false alert.

Patch under test, should be out soon.
(But the image is not easy to create, so no test case yet)

> ERROR: extent[366498091008, 134217728] referencer count mismatch
> (root: 818, owner: 73782, offset: 134217728) wanted: 4, have: 26

This is a little different.
Not sure which fsck is wrong until btrfs-debug-tree extent and fs tree 
dump is provided.

>
> One file system has over 100 lines (exactly the same thing, no difference)
>
> ERROR: data extent[16913485824 7577600] backref lost

Same, need btrfs-debug-tree extent and fs tree dump.

>
> Another file system, 15 minutes old with two mounts in its whole
> lifetime, and only written with kernel 4.10-rc3 has over 30 lines of
> varying numbers:
>
> ERROR: root 257 EXTENT DATA[150134 11317248] prealloc shouln't have datasum
>
> That file system should have no preallocated extents (It's a clean
> installation of Fedora Rawhide, using only rsync)

btrfs-debug-tree will help to make sure what is wrong.

>
> Again, zero errors with original mode; but all file systems of all
> ages have errors with lowmem. This is kindof annoying to say the
> least, it's like we're adding dice to the check and repair situation
> on Btrfs which is already incredibly more complicated and unhelpful
> than any other file system.

That's why lowmem mode is still not the default option.

The problem os original mode is, if you're checking a TB level fs and 
only 2 or 4G ram, then it's quite possible you ran out of memory and 
won't be able to check the fs forever, more several than annoying.

Thanks,
Qu

>
> btrfs-progs 4.9.
> kernels vary from 4.4 to 4.10-rc4, but one fs is only a month old
> having used 4.7 and 4.8 kernels; and another one just 4.10-rc3 as I
> said.
>
>


