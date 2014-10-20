Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60212 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaJTOwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 10:52:39 -0400
Received: by mail-vc0-f176.google.com with SMTP id hq11so3605256vcb.21
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 07:52:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141020140437.GC29401@hungrycats.org>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
	<20141017080202.GA3604@localhost.localdomain>
	<20141017081009.GC582640@mother.pipebreaker.pl>
	<20141017081737.GC29594@carfax.org.uk>
	<20141020140437.GC29401@hungrycats.org>
Date: Mon, 20 Oct 2014 10:52:38 -0400
Message-ID: <CAGfcS_npsgR+_-WP5+peYA3aLYa-Ru1PWOOLBKLzshiJr03k9w@mail.gmail.com>
Subject: Re: unexplainable corruptions 3.17.0
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Zygo Blaxell <zblaxell@furryterror.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, Tomasz Torcz <tomek@pipebreaker.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 20, 2014 at 10:04 AM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> On Fri, Oct 17, 2014 at 08:17:37AM +0000, Hugo Mills wrote: > On Fri, Oct 17, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
>> > On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
>> > > >   Recently I've observed some corruptions to systemd's journal
>> > > > files which are somewhat puzzling. This is especially worrying
>> > > > as this is btrfs raid1 setup and I expected auto-healing.
>> > > >
>> > > >   System details: 3.17.0-301.fc21.x86_64
>> > > > btrfs: raid1 over 2x dm-crypted 6TB HDDs.
>> > > > mount opts: rw,relatime,seclabel,compress=lzo,space_cache
>> > > >   Reads with cat, hexdump fails with:
>> > > > read(4, 0x1001000, 65536)               = -1 EIO (Input/output error)
>> > > >
>> > > Does scrub work for you?
>> >
>> >   As there seem to be no way to scrub individual files, I've started
>> > scrub of full volume.  It will take some hours to finish.
>> >
>> >   Meanwhile, could you satisfy my curiosity what would scrub do that
>> > wouldn't be done by just reading the whole file?
>>
>>    It checks both copies. Reading the file will only read one of the
>> copies of any given block (so if that's good and the other copy is
>> bad, it won't fix anything).
>
> Really?  One of my earliest btrfs tests was to run a loop of 'sha1sum
> -c' on a gigabyte or two of files in one window while I used dd to
> write random data in random locations directly to one of the filesystem
> mirror partitions in the other.  I did this test *specifically* to
> watch the automatic checksumming and self-healing features of btrfs
> in action.  A complete 'sha1sum' verification of the filesystem contents
> passed even though the kernel log was showing checksum errors scrolling
> by faster than I could read, which strongly implies that read() normally
> does check both mirrors before returning EIO.

I think you misread the earlier post.  It sounds like the algorithm is:
1.  Receive request to read block from file.
2.  Determine which mirrored block to read it from (it sounds like
this is sub-optimal today, presumably you'd want to use the least busy
disk or disk with the head closest to the right cylinder to do it).
3.  Read the block.  Verify the checksum.  If it matches return the data.
4.  If not find another mirrored block to read it from if one exists.
Verify the checksum.  If it matches return the data and update all
other mirrored copies with it.
5.  Repeat step 4 until you run out of mirrored copies.  If so, return an error.

So, doing random reads will NOT be equivalent to scrubbing the disks,
because with a scrub you want to check that ALL copies are code, and
the algorithm above only determines that any copy is good.

When you used dd to overwrite blocks, you didn't get errors because
when the first copy failed the filesystem just read the second copy as
intended.  That isn't a scrub - it is a recovery.

An actual scrub isn't file-focused, but device focused.  It starts
reading at the start of the device, and verifies each logical unit of
data sequentially.  This can be done asynchronously since btrfs stores
checksums, as opposed to a traditional RAID where the reads need to be
synchronous since the validity of a mirror/stripe can only be
ascertained by comparing it to all the other devices in that
mirror/stripe (and then unless you're using something like RAID6+ you
couldn't determine which copy is bad without a checksum).  In theory
I'd expect a scrub with btrfs to be less detrimental to performance as
a result - a read request could halt the scrub on one device without
delaying the scrub on the other devices.  Writes in RAID1 mode
necessarily disrupt two devices, but others would not be impacted.

--
Rich
