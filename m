Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:44603 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbbEKRan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 13:30:43 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Kernel Dump scanning directory
From: Anthony Plack <anthony@plack.net>
In-Reply-To: <20150508223723.GO18480@carfax.org.uk>
Date: Mon, 11 May 2015 12:30:40 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <0C98D842-9A04-4267-B3E3-B8C65DB756D0@plack.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net> <4B045A3B-60E2-4151-86E7-029E79585886@plack.net> <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net> <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net> <20150508211850.GN18480@carfax.org.uk> <A54EAF29-BF4C-4CCA-BFBF-FEDFF2A01C73@plack.net> <20150508223723.GO18480@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On May 8, 2015, at 5:37 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> On Fri, May 08, 2015 at 04:49:19PM -0500, Anthony Plack wrote:
>> 
>>> On May 8, 2015, at 4:18 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> 
>>> On Fri, May 08, 2015 at 11:44:39AM -0500, Anthony Plack wrote:
>>>> Once again btrfsck --repair /dev/sdm ended with
>>>> 
>>>> parent transid verify failed on 94238015488 wanted 150690 found 150691
>>>> Ignoring transid failure
>>>> 
>>>> no attempt to actually repair the volume.  No indication from the tools why.
>>> 
>>>  A transid failure means that the superblock has been written out to
>>> disk *before* a part of the metadata that forms that transaction, and
>>> then the machine has crashed in some way that prevented the
>>> late-arriving metadata from hitting the disk. There are two ways that
>>> this can happen: it's a bug in the kernel, or the hardware lies about
>>> having written data. Both are possible, but the former is more likely.
>> 
>> Also good to know.  I agree to the bug in the kernel.  I think you just hit on the issue here.  Since this COW, we should be able to assume that the superblock is then still "empty."  Or do I misunderstand?
> 
>   No, if the superblock didn't have anything in it, the FS wouldn't
> be mountable.
> 
>   The CoW design works by making all writes to currently-unused
> locations. At some point (a transaction boundary, every 30 seconds by
> default), the FS ensures that everything written to date is consistent
> -- that everything has been flushed to permanent storage -- and only
> when all of that data has hit the disk does it write out the updated
> superblock(s) that point to the new data structures. Since superblock
> writes are atomic, the FS remains consistent at all times: either the
> superblock refers to the old data or the new data, but cannot refer to
> any partial state in between.
> 
>   It doesn't matter what order the data is written out in, *provided*
> that there's a guarantee that it's *all* written out before the
> superblock is sent.
> 
>   Now, where things go wrong, and results in a transid failure, is
> where the metadata structures are written or modified *after* the
> superblock is written, and then the machine crashes partway through
> the sequence of writes. The intended design of the FS is such that
> this should never happen -- however, there's a class of bug that means
> it *can* happen, which is probably what's gone on here. I don't know
> enough about the block layer to be able to characterise in more detail
> what the problem looks like.
> 
>>>  Once this failure has happened, the FS is corrupt in a way that's
>>> hard to repair reliably. I did raise this question with Chris a while
>>> ago, and my understanding from the conversation was that he didn't
>>> think that it was possible to fix transid failures in btrfsck.
>> 
>> I guess I don't understand how that could be designed that way.
>> 
>>>  Once again: zeroing the log won't help. It doesn't fix everything.
>>> In fact, it rarely fixes anything.
>> 
>>>  The reason there's no documentation on fixing transid failures is
>>> because there's no good fix for them.
>> 
>> Then what is the point of the transactions?  Why do we care about
>> transid mismatch?  Why keep something, that if it fails, breaks the
>> whole thing?
> 
>   A transaction is simply what you get when you write out a new
> superblock. It's an atomic change to the FS state. In an ideal world,
> the transactions would be fine-grained, and would match the POSIX
> filesystem semantics. In practice, the overhead of CoWing all the
> metadata for a change at that scale is (relatively) huge. As a result,
> the FS collects together larger chunks of writes into a single
> transaction.
> 
>   Now, there's a further difficulty, which is that if you make
> transactions long-lived, you have two choices about the FS behaviour
> towards applications: either you wait until the end of the
> transaction, and then report success to the writer, in which case
> performance is appalling; or you can report to the application that
> the write succeeded as soon as you've accepted it.
> 
>   Btrfs uses the latter method for performance reasons. But... if you
> do that and the machine crashes before the end of the transaction, the
> FS state is still the old one, so the app thinks it's written data
> successfully to disk, but there's no record of it in the FS. The log
> tree fixes _this_ problem by keeping a minimal record of the writes
> made so far in the current transaction, so that when the FS resumes
> after a crash or power loss, the log can be examined and used to find
> the outstanding writes that have been confirmed to userspace. From
> that, the partial transaction can be completed.
> 
>   In the past, there have been a few bugs where the log tree has been
> written out with bad data in it, and this has led to non-mountable
> filesystems (because it tries replaying the log tree and crashes).
> This is the *only* case where btrfs-zero-log helps.
> 
>   I hope all that helps explain what all the moving parts and for,
> and why they're there.
> 
>   Hugo.
> 
> -- 
> Hugo Mills             | To an Englishman, 100 miles is a long way; to an
> hugo@... carfax.org.uk | American, 100 years is a long time.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                        Earle Hitchner

Hugo,
Thank you.  I have been letting your email ruminate in the brain pan.

I needed that reminder of transaction based processes.

So the transaction has failed, and therefore the drive is in an unknown state, but at some point, we need to make a decision about that transaction.

Either we:
1. Accept fact that the transaction has failed, revert the data back to the earlier stated, and continue.
2. Backup the entire data set, and reset the transaction log
3. Flush the disk, recreate from scratch and hope our backup is good and current.
4. ????

Regardless, I still don't get not handling the error.  Yes, there is an error.  All fsck programs have to deal with errors.  btrfsck just ends.  No repair, no options.

It seems that in BTRFS we just crash.  The transaction has an error, well dump the kernel and set the volume to read only.  There is no repair tool to help the user make these decisions. There isn't even a good explanation other than -5 kernel dump.

"Just recreate the volume from scratch and restore you backup is all we can do" does not seem to be a long term viable solution.

If the code understands enough to know that the transaction is damaged, why can the code not walk the admin through the repair?  It seems that we need to get to that point before we can even call this a viable beta file system.

If I understood more of the transaction issue, I might just write the code to help btrfsck actually become a real program regarding transactions.  Maybe that is where I need to start...

