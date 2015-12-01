Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbbLATFK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 14:05:10 -0500
Subject: Re: Bug/regression: Read-only mount not read-only
To: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151130164801.GD2162@ret.masoncoding.com>
 <20151130170600.GC8775@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <565DEF65.4080900@redhat.com>
Date: Tue, 1 Dec 2015 13:05:09 -0600
MIME-Version: 1.0
In-Reply-To: <20151201190018.GD8918@ret.masoncoding.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/1/15 1:00 PM, Chris Mason wrote:
> On Mon, Nov 30, 2015 at 05:06:00PM +0000, Hugo Mills wrote:
>> On Mon, Nov 30, 2015 at 11:48:01AM -0500, Chris Mason wrote:
>>> On Sat, Nov 28, 2015 at 01:46:34PM +0000, Hugo Mills wrote:
>>>>    We've just had someone on IRC with a problem mounting their FS. The
>>>> main problem is that they've got a corrupt log tree. That isn't the
>>>> subject of this email, though.
>>>>
>>>>    The issue I'd like to raise is that even with -oro as a point
>>>> option, the FS is trying to replay the log tree. The dmesg output from
>>>> mount -oro is at the end of the email.
>>>>
>>>>    Now, my memory, experience and understanding is that the FS
>>>> doesn't, and shouldn't replay the log tree on a RO mount, because the
>>>> FS should still be consistent even without the reply, and
>>>> RO-means-actually-RO is possible and desirable. (Compared to a
>>>> journalling FS, where journal replay is required for a consistent,
>>>> usable FS).
>>>>
>>>>    So, this looks to me like a regression that's come in somewhere.
>>>>
>>>>    (Just for completeness, the system in question usually runs 4.2.5,
>>>> but the live CD the OP is using is 4.2.3).
>>>
>>> We do need to replay the log tree, even on readonly mounts.  Otherwise
>>> files created and fsunk before crashing may not even exist.
>>
>>    I'm actually happy with that, as long as the log tree is retained
>> until it _can_ be played back. I think it's much more important that
>> read-only actually means read-only *as much as is possible* (if for no
>> other reason than being able to test the status of the log tree).
>> Obviously, for journalling FSes, a journal reply is required by the
>> design of the FS, but with a CoW FS, the FS should be consistent if
>> possibly outdated with a RO mount.
> 
> Normally I'd agree, but we have a long tradition of mounting root
> readonly at first for no good reason at all.  This is why reiserfs/ext
> (and I think xfs) all replay logs on readonly mounts.  It's not an
> admin initiated action but an early stage of boot.

yes, xfs does; we have "-o norecovery" if you don't want that, or need
to mount a filesystem with a dirty log on a readonly device.

TBH I think it comes down to semantics: does a readonly mount mean
that the filesystem will not write to the block device, or does it mean
that you cannot write to the block device through the filesystem?
Subtle difference.

I think most filesystems treat it as "you cannot write to the filesystem"
but will still replay the log for consistency, because that's what is
normally expected.

If you're doing forensics, blkdev --setro /dev/blah to be sure; use
fs-specific mount options to bypass any log replay that would otherwise
be done, and have at it ...

-Eric

