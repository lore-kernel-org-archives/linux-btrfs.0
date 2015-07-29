Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61111 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750945AbbG2BrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 21:47:17 -0400
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
To: <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728145021.GI6306@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B830A0.6030302@cn.fujitsu.com>
Date: Wed, 29 Jul 2015 09:47:12 +0800
MIME-Version: 1.0
In-Reply-To: <20150728145021.GI6306@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, thanks David for the review.

David Sterba wrote on 2015/07/28 16:50 +0200:
> On Tue, Jul 28, 2015 at 04:30:36PM +0800, Qu Wenruo wrote:
>> Although Liu Bo has already submitted a V10 version of his deduplication
>> implement, here is another implement for it.
>
> What's the reason to start another implementation?
Mainly for the memory usage advantage and less codes to implement it.

Also want to test my understanding of dedup:
Dedup should be implemented as simple as possible, as the benefit is not 
so huge but potential bug may be huge.

>
>> [[CORE FEATURES]]
>> The main design concept is the following:
>> 1) Controllable memory usage
>> 2) No guarantee to dedup every duplication.
>> 3) No on-disk format change or new format
>> 4) Page size level deduplication
>
> 1 and 2) are good goals, allow usability tradeoffs
>
> 3) so the dedup hash is stored only for the mount life time. Though it
> avoids the on-disk format changes, it also reduces the effectivity. It
> is possible to "seed" the in-memory tree by reading all files that
> contain potentially duplicate blocks but one would have to do that after
> each mount.
For 3), that's almost the same thing with 2).
For the next mount, either read needed file contents as you mentioned, 
or just let the write happen for a while just like no dedup, to build up 
the hash tree.

>
> 4) page-sized dedup chunk is IMHO way too small. Although it can achieve
> high dedup rate, the metadata can potentially explode and cause more
> fragmentation.
Yes, that's one of my concern too.
But compared to Liu's implement, at least the non-dedup extent is less 
affected, which is up to 512Kbytes other than dedup size length.

And that's in my TODO list to merge possible adjusted dedup extents to 
increase dedup extent size and reduce metadata size/fragmentation.
>
>> Implement details includes the following:
>> 1) LRU hash maps to limit the memory usage
>>     The hash -> extent mapping is control by LRU (or unlimited), to
>>     get a controllable memory usage (can be tuned by mount option)
>>     alone with controllable read/write overhead used for hash searching.
>
> In Liu Bo's series, I rejected the mount options as an interface and
> will do that here as well. His patches added a dedup ioctl to (at least)
> enable/disable the dedup.
For ioctl method, what I am afraid of is, we may need to implement a 
rescan function just like qgroup, as we need to keep hash up-to-date.

And IMHO, qgroup is not a good example for new feature to follow.
As so many bugs we tried to fix and so many new bugs we introduced 
during the fix.
Even with the 4.2-rc1 qgroup fix, I reintroduced an old bug, fixed by 
Fillipe recently.
And we still don't have a good idea to fix the snapshot deletion bug.
(My patchset can only handle snapshot with up to 2 levels. With higher 
level, the qgroup number will still be wrong until related node/leaves 
are all COWed)

So the fear of being next qgroup also drives me to avoid persistent hash 
and ioctl hash.

>
>> 2) Reuse existing ordered_extent infrastructure
>>     For duplicated page, it will still submit a ordered_extent(only one
>>     page long), to make the full use of all existing infrastructure.
>>     But only not submit a bio.
>>     This can reduce the number of code lines.
>
>> 3) Mount option to control dedup behavior
>>     Deduplication and its memory usage can be tuned by mount option.
>>     No need to indicated ioctl interface.
>
> I'd say the other way around.
>
>>     And further more, it can easily support BTRFS_INODE flag like
>>     compression, to allow further per file dedup fine tunning.
>>
>> [[TODO]]
>> 3. Add support for per file dedup flags
>>     Much easier, just like compression flags.
>
> How is that supposed to work? You mean add per-file flags/attributes to
> mark a file so it fills the dedup hash tree and is actively going to be
> deduped agains other files?

Yes, much like that.
Just like NODATACOW flag, for files set NODEDUP, any read from it won't 
add hash into hash tree and write won't ever bother searching hashes.

>
>> Any early review or advice/question on the design is welcomed.
>
> The implementation is looks simpler than the Liu Bo's, but (IMHO) at the
> cost of reduced funcionality.
>
> Ideally, we merge one patchset with all desired functionality. Some kind
> of control interface is needed not only to enable/dsiable the whole
> feature but to affect the trade-offs (memory consumptin vs dedup
> efficiency vs speed), and that in a way that's flexible according to
> immediate needs.
>
> The persistent dedup hash storage is not mandatory in theory, so we
> could implement an "in-memory tree only" mode, ie. what you're
> proposing, on top of Liu Bo's patchset.
>
So the ideal implement should be with the following features?
1) Tunable dedup size
    For trade off and Liu Bo's patchset has provided it.
    But I still want it not to affect non-dedup extent size too much like
    the current patchset.

2) Different dedup backend
    Again for trade off, persist one from Liu Bo and the in-memory only
    one?
And maybe others?

For me, all the ideas seems great, but I'm more concerned about whether 
it's worthy just for dedup function.
Maybe we need about 3~4K lines for the ideal dedup function and new 
incompat flags.

But for the benefit, we may never do as well as user-space dedup implement.
So why not focus on the simplicity and speed in kernel implement?

Thanks,
Qu
