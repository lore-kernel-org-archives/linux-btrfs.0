Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:56063 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbdKFN3E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 08:29:04 -0500
Received: by mail-it0-f54.google.com with SMTP id l196so5032326itl.4
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 05:29:04 -0800 (PST)
Subject: Re: Problem with file system
To: Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>
Cc: Marat Khalili <mkh@rqc.ru>, Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
 <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
 <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru>
 <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com>
 <CAJCQCtTT7_pfx5yn--We-kq0XWd38H_Lw1Prbmo5ytkTZWapYQ@mail.gmail.com>
 <20171104044634.thg7mnchm4hvzdic@angband.pl>
 <CAJCQCtReVi8k+OoitBBUZm_T+mj9dkV6GCVs7JMSG1myR78AGw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6833d956-05c6-ee7b-ba80-b0a29c2772c6@gmail.com>
Date: Mon, 6 Nov 2017 08:29:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtReVi8k+OoitBBUZm_T+mj9dkV6GCVs7JMSG1myR78AGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-04 13:14, Chris Murphy wrote:
> On Fri, Nov 3, 2017 at 10:46 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> On Fri, Nov 03, 2017 at 04:03:44PM -0600, Chris Murphy wrote:
>>> On Tue, Oct 31, 2017 at 5:28 AM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>
>>>> If you're running on an SSD (or thinly provisioned storage, or something
>>>> else which supports discards) and have the 'discard' mount option enabled,
>>>> then there is no backup metadata tree (this issue was mentioned on the list
>>>> a while ago, but nobody ever replied),
>>>
>>>
>>> This is a really good point. I've been running discard mount option
>>> for some time now without problems, in a laptop with Samsung
>>> Electronics Co Ltd NVMe SSD Controller SM951/PM951.
>>>
>>> However, just trying btrfs-debug-tree -b on a specific block address
>>> for any of the backup root trees listed in the super, only the current
>>> one returns a valid result.  All others fail with checksum errors. And
>>> even the good one fails with checksum errors within seconds as a new
>>> tree is created, the super updated, and Btrfs considers the old root
>>> tree disposable and subject to discard.
>>>
>>> So absolutely if I were to have a problem, probably no rollback for
>>> me. This seems to totally obviate a fundamental part of Btrfs design.
>>
>> How is this an issue?  Discard is issued only once we're positive there's no
>> reference to the freed blocks anywhere.  At that point, they're also open
>> for reuse, thus they can be arbitrarily scribbled upon.
> 
> If it's not an issue, then no one should ever need those backup slots
> in the super and we should just remove them.
> 
> But in fact, we know people end up situations where they're needed for
> either automatic recovery at mount time or explicitly calling
> --usebackuproot. And in some cases we're seeing users using discard
> who have a borked root tree, and none of the backup roots are present
> so they're fucked. Their file system is fucked.
> 
> Now again, maybe this means the hardware is misbehaving, and honored
> the discard out of order, and did that and wrote the new supers before
> it had completely committed all the metadata? I have no idea, but the
> evidence is present in the list that some people run into this and
> when they do the file system is beyond repair even though it can
> usually be scraped with btrfs restore.
With ATA devices (including SATA), except on newer SSD's, TRIM commands 
can't be queued, so by definition they can't become unordered (the 
kernel ends up having to flush the device queue prior to the discard and 
then flush the write cache, so it's functionally equivalent to a write 
barrier, just more expensive, which is why inline discard performance 
sucks in most cases).  I'm not sure about SCSI (I'm pretty sure UNMAP 
can be queued and is handled just like any other write in terms of 
ordering), MMC/SD (Though I'm also not sure if the block layer and the 
MMC driver properly handle discard BIO's on MMC devices), or NVMe (which 
I think handles things similarly to SCSI).
> 
> 
>> Unless your hardware is seriously broken (such as lying about barriers,
>> which is nearly-guaranteed data loss on btrfs anyway), there's no way the
>> filesystem will ever reference such blocks.  The corpses of old trees that
>> are left lying around with no discard can at most be used for manual
>> forensics, but whether a given block will have been overwritten or not is
>> a matter of pure luck.
> 
> File systems that overwrite, are hinting the intent in the journal
> what's about to happen. So if there's a partial overwrite of metadata,
> it's fine. The journal can help recover. But Btrfs without a journal,
> has a major piece of information required to bootstrap the file system
> at mount time, that's damaged, and then every backup has been
> discarded. So it actually makes Btrfs more fragile than other file
> systems in the same situation.
Indeed.

Unless I'm seriously misunderstanding the code, there's a pretty high 
chance that any given old metadata block will get overwritten reasonably 
soon on an active filesystem.  I'm not 100% certain about this, but I'm 
pretty sure that BTRFS will avoid allocating new chunks to write into 
just to preserve old copies of metadata, which in turn means that it 
will overwrite things pretty fast if the metadata chunks are mostly full.>
>>
>> For rollbacks, there are snapshots.  Once a transaction has been fully
>> committed, the old version is considered gone.
> 
> Yeah well snapshots do not cause root trees to stick around.
> 
> 
>>
>>>   because it's already been discarded.
>>>> This is ideally something which should be addressed (we need some sort of
>>>> discard queue for handling in-line discards), but it's not easy to address.
>>>
>>> Discard data extents, don't discard metadata extents? Or put them on a
>>> substantial delay.
>>
>> Why would you special-case metadata?  Metadata that points to overwritten or
>> discarded blocks is of no use either.
> 
> I would rather lose 30 seconds, 1 minute, or even 2 minutes of writes,
> than lose an entire file system. That's why.
And outside of very specific use cases, this is something you'll hear 
from almost any sysadmin.
> 
> Anyway right now I consider discard mount option fundamentally broken
> on Btrfs for SSDs. I haven't tested this on LVM thinp, maybe it's
> broken there too.
For LVM thinp, discard there deallocates the blocks, and unallocated 
regions read back as zeroes, just like in a sparse file (in fact, if you 
just think of LVM thinp as a sparse file with reflinking for snapshots, 
you get remarkably close to how it's actually implemented from a 
semantic perspective), so it is broken there.  In fact, it's guaranteed 
broken on any block device that has the discard_zeroes_data flag set, 
and theoretically broken on many things that don't have that flag 
(although block devices that don't have that flag are inherently broken 
from a security perspective anyway, but that's orthogonal to this 
discussion).
> 
> Even fstrim leaves a tiny window open for a few minutes every time it
> gets called, where if the root tree is corrupted for any reason,
> you're fucked because all the backup roots are already gone.
For this particular case, I'm pretty sure you can minimize this window 
by calling `btrfs filesystem sync` on the filesystem after calling 
fstrim.  It likely won't eliminate the window, but should significantly 
shorten it.
