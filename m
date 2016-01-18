Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50854 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238AbcARBhV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 20:37:21 -0500
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Al <6401e46d@opayq.com>, <linux-btrfs@vger.kernel.org>
References: <loom.20160116T132316-196@post.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <569C41B1.1090206@cn.fujitsu.com>
Date: Mon, 18 Jan 2016 09:36:49 +0800
MIME-Version: 1.0
In-Reply-To: <loom.20160116T132316-196@post.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Al wrote on 2016/01/16 12:27 +0000:
> Hi,
>
> This must be a silly question! Please assume that I know not much more than
> nothing abou*t fs.
> I know dedup is traditionally costs a lot of memory, but I don't really
> understand why it is done like that. Let me explain my question:

As one of the author of the recent btrfs inband dedup patches, at least 
from my codes, dedup doesn't cost a lot of memory, unless stupid user 
gives a stupid memory limit for in-memory backend.

And for on-disk backend, the memory pressure is even smaller.
Kernel can trigger a transaction commit to reclaim the pages caches used 
for dedup.
So I didn't see what's wrong with the memory usage.

>
> AFAICT dedup matches file level chunks (or whatever you call them) using a
> hash function or something which has limited collision potential.

The more accurate term should be "file extent" though.

> The hash
> is used to match blocks as they are committed to disk, I'm talking online
> dedup*, and reflink/eliminate the duplicated blocks as necessary.  This
> bloody great hash tree is saved in memory for speed of lookup (I assume).

No, you can choose whether to store it in memory or on disk.
Which is one of the selling point of the patchset I recently submitted.
Before this, either using Liu Bo's on-disk one, or my early pure 
in-memory one.

And unfortunately (or in fact fortunately?), the size of hash is already 
quite small.

Current dedup unit (although I use the term "dedup blocksize") is 16K, 
which means only write larger than 16K will go through inband dedup.
So, 16K data = one hash = 112 bytes.
For 1G data, it's about just 7M.
(BTW, 1G data means 1M CRC32 checksum, although it can be stored into 
disk, just like what we do in on-disk backend)

And the dedup blocksize can be tuned from 4K to 8M.
If using 8M dedup blocksize. 1G data only takes about 14K memory.
Much smaller than btrfs CRC32 checksum.

Not to mention there is a memory usage limit and there is also on-disk 
backend.

>
> But why?
>
> Is there any urgency for dedup? What's wrong with storing the hash on disk
> with the block and having a separate process dedup the written data over
> time;

And that's almost what on-disk backend doing.

> dedup'ing data immediately when written to high-write-count data is
> counter productive because no sooner has it been deduped then it is rendered
> obsolete by another COW write.

And it seems that you are not familiar how kernel is caching data for 
filesystem.
There is already kernel page cache for such case.
No matter how many times you write, as long as you're doing buffered 
write the the data is not written to disk but cached by kernel, until 
either you triggered a manual sync or memory pressure hits threshold.

And inband dedup doesn't happen *until* the cached data is going to 
written to disk.
So all you concerned is not a problem.
No extra CPU/memory is used until you're committing data to disk.

>
> There's also the problem of opening a potential problem window before the
> commit to disk, hopefully covered by the journal, whilst we seek the
> relevant duplicate if there is one.

>
> Help me out peeps? Why is there a such an urgency to have online dedup,
> rather than a triggered/delayed dedup, similar the current autodefrag process?
>
> Thank you. I'm sure the answer is obvious, but not to me!

Although I really don't like to say things like this,
but please, READ THE "FUNNY" CODE.

I used to have a lot of questions and "good" ideas about btrfs,
but as I digging into the code, the question disappeared and "good" 
ideas turn to be either already done or really bad ideas.

So if you're really interested in btrfs, please stand from digging the 
on-disk format(believe me, this is the easiest way) and get familiar 
with a lot of kernel MM/VFS facilities.
(and that's what I used to do and are still doing)

Thanks,
Qu

>
> * dedup/dedupe/deduplication
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


