Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26656 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751512AbdAPDRB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 22:17:01 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
 <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
 <1484188092.29002.4.camel@scientia.net>
 <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
 <1484499869.17186.1.camel@scientia.net>
 <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com>
 <1484535383.7577.53.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <657ea421-0058-b641-ef31-c7d371fa58ca@cn.fujitsu.com>
Date: Mon, 16 Jan 2017 11:16:48 +0800
MIME-Version: 1.0
In-Reply-To: <1484535383.7577.53.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/16/2017 10:56 AM, Christoph Anton Mitterer wrote:
> On Mon, 2017-01-16 at 09:38 +0800, Qu Wenruo wrote:
>> So the fs is REALLY corrupted.
> *sigh* ... (not as in fuck-I'm-loosing-my-data™ ... but as in *sigh*
> another-possibly-deeply-hidden-bug-in-btrfs-that-might-eventually-
> cause-data-loss...)
>
>> BTW, lowmem mode seems to have a new false alert when checking the
>> block
>> group item.
>
> Anything you want to check me there?

It would be very nice if you could paste the output of
"btrfs-debug-tree -t extent <your_device>" and "btrfs-debug-tree -t root 
<your device>"

That would help us to fix the bug in lowmem mode.

>
>
>> Did you have any "lightweight" method to reproduce the bug?
> Na, not at all... as I've said this already happened to me once before,
> and in both cases I was cleaning up old ro-snapshots.
>
> At least in the current case the fs was only ever filled via
> send/receive (well apart from minor mkdirs or so)... so there shouldn't
> have been any "extreme ways" of using it.

Since it's mostly populated by receive, yes, receive is completely sane, 
since it's done purely in user-space.

So if we have any way to reproduce it, it won't involve anything special.

BTW, if it's possible, would you please try to run btrfs-check before 
your next deletion on ro-snapshots?

>
> I think (but not sure), that this was also the case on the other
> occasion that happened to me with a different fs (i.e. I think it was
> also a backup 8TB disk).
>
>
>> For example, on a 1G btrfs fs with moderate operations, for example
>> 15min or so, to reproduce the bug?
> Well I could try to produce it, but I guess you'd have far better means
> to do so.
>
> As I've said I was mostly doing send (with -p) | receive to do
> incremental backups... and after a while I was cleaning up the old
> snapshots on the backup fs.
> Of course the snapshot subvols are pretty huge.. as I've said close to
> 8TB (7.5 or so)... everything from quite big files (4GB) to very small,
> smylinks (no device/sockets/fifos)... perhaps some hardlinks...
> Some refcopied files. The whole fs has compression enabled.
>
>
>>> Shall I rw-mount the fs and do sync and wait and retry? Or is there
>>> anything else that you want me to try before in order to get the
>>> kernel
>>> bug (if any) or btrfs-progs bug nailed down?
>>
>> Personally speaking, rw mount would help, to verify if it's just a
>> bug
>> that will disappear after the deletion is done.
> Well but than we might loose any chance to further track it down.
>
> And even if it would go away, it would still at least be a bug in terms
> of fsck false positive.... if not more (in the sense of... corruptions
> may happen if some affect parts of the fs are used while not cleaned up
> again).
>
>
>> But considering the size of your fs, it may not be a good idea as we
>> don't have reliable method to recover/rebuild extent tree yet.
>
> So what do you effectively want now?
> Wait and try something else?
> RW mount and recheck to see whether it goes away with that? (And even
> if, should I rather re-create/populate the fs from scratch just to be
> sure?
>
> What I can also offer in addition... as mentioned some times
> previously, I do have full lists of the reg-files/dirs/symlinks as well
> as SHA512 sums of each of the reg-files, as they are expected to be on
> the fs respectively the snapshot.
> So I can offer to do a full verification pass of these, to see whether
> anything is missing or (file)data actually corrupted.

Not really needed, as all corruption happens on tree block of root 6403,
it means, if it's a real corruption, it will only disturb you(make fs 
suddenly RO) when you try to modify something(leaves under that node) in 
that subvolume.

At least data is good.

And I highly suspect if the subvolume 6403 is the RO snapshot you just 
removed.

If 'btrfs subvolume list' can't find that subvolume, then I think it's 
mostly OK for you to RW mount and wait the subvolume to be fully deleted.

And I think you have already provided enough data for us to, at least 
try to, reproduce the bug.

Thanks,
Qu

>
> Of course that will take a while, and even if everything verifies, I'm
> still not really sure whether I'd trust that fs anymore ;-)
>
>
> Cheers,
> Chris.
>


