Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48934 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbbLIGqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 01:46:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6YWP-0008VC-W7
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 07:46:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 07:46:41 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 07:46:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub: no spae left on device
Date: Wed, 9 Dec 2015 06:46:32 +0000 (UTC)
Message-ID: <pan$e6131$4ac4af65$a9a25416$d5a8b7e8@cox.net>
References: <20151208150638.GL27889@merlins.org>
	<5666F947.5010902@googlemail.com> <5666FB58.2040900@bouton.name>
	<20151208160615.GO27889@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 08 Dec 2015 08:06:15 -0800 as excerpted:

> On Tue, Dec 08, 2015 at 04:46:32PM +0100, Lionel Bouton wrote:
>> Le 08/12/2015 16:37, Holger Hoffstätte a écrit :
>> > On 12/08/15 16:06, Marc MERLIN wrote:
>> >>
>> >> Why would scrub need space and why would it cancel if there isn't
>> >> enough of it? (kernel 4.3)
>> >>
>> >> btrfs scrub start -Bd /dev/mapper/pool1
>> >> ERROR: scrubbing /dev/mapper/pool1 failed for device id 1
>> >> (No space left on device)
>> >> scrub device /dev/mapper/pool1 (id 1) canceled
>> > Scrub rewrites metadata (apparently even in -r aka readonly mode),
>> > and that can lead to temporary metadata expansion (stuff gets COWed
>> > around); it's a bit surprising but makes sense if you think about it.

Are you sure about that?

My / is mounted ro by default, and if I try to scrub it in normal mode, 
it'll error out due to read-only.  But I can run a read-only scrub just 
fine, and if I find errors, I simply mount it writable and redo the scrub 
without the -r.  (My / is only 8 GiB, under half used including metadata 
on a fast SSD, so scrubs complete in under 30 seconds, and doing a read-
only scrub followed by a mount-writable and a second fixing scrub if 
necessary, is trivial.)

>> Sorry I'm not sure why metadata is rewritten if no error is detected.

But scrub will of course do copy-on-write if there's an error, and it's 
possible that on initialization it checks for space to do a few cows if 
necessary, before it actually checks for the -r read-only flag.  I try to 
leave at least enough unallocated space to do a balance, which of course 
except for -dusage=0 (or -musage=0) writes a new chunk to rewrite 
existing chunks into, so I'd be unlikely to ever get that close to out of 
space to trigger the possible initialization-time space-warning, and thus 
wouldn't know whether it has one or whether it comes before the -r check, 
or not.

> And this is what I got:
> legolas:~# btrfs balance start -musage=10 -v /mnt/btrfs_pool1/
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=10
>   SYSTEM (flags 0x2): balancing, usage=10
> ERROR: error during balancing '/mnt/btrfs_pool1/' - No space left on
> device There may be more info in syslog - try dmesg | tail
> 
> Ok, that sucks.
> 
> legolas:~# btrfs balance start -musage=0 -v /mnt/btrfs_pool1/
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=0
>   SYSTEM (flags 0x2): balancing, usage=0
> Done, had to relocate 0 out of 618 chunks
> 
> This worked. Mmmh, I thought this wouldn't be necessary anymore in 4.3
> kernels?

Well, it said it had to relocate zero blocks, so it _appears_ that it 
didn't do anything, which would be expected on reasonably current kernels 
as they already clean up zero-usage chunks, automatically.  *BUT*...

> legolas:~# btrfs balance start -musage=10 -v /mnt/btrfs_pool1
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=10
>   SYSTEM (flags 0x2):  balancing, usage=10
> Done, had to relocate 1 out of 618 chunks

... if it did nothing in the -musage=0 case above, why did the -musage=10 
case fail before, but succeed after?

That's a very good question I don't have an answer to.  Good question for 
the devs and others that actually read code.

Meanwhile, note that if it relocates only a single chunk (of non-zero 
usage), under normal circumstances, it'll take exactly the same amount of 
space as before, because it'd allocate a new chunk of exactly the same 
size as the one it was rewriting.

However, once remaining unallocated space gets tight enough, it starts 
allocating smaller than normal chunks, which may be what happened this 
time.  Presumably that chunk was originally allocated when the filesystem 
still has much more unallocated free space, so it was a standard size 
chunk.  When it was rewritten, unallocated space was much tighter, so a 
smaller chunk would likely be written, which would then be rather fuller 
than it was previously, as it would have the same amount of metadata in 
it, but be a smaller chunk.

And, perhaps partially answering my own question above, the balance with 
-musage=0 somehow triggered a space reevaluation, thus allowing the 
-musage=10 balance to run afterward when it wouldn't before, even tho the 
-musage=0 didn't actually relocate (to /dev/null as they'd be empty, IOW, 
delete) any empty chunks.

But... it still shouldn't happen, as if -musage=0 didn't relocate 
anything, it shouldn't trigger a space reevaluage that -musage=10 
wouldn't trigger on its own, so while this might partially answer what 
happened, it does nothing to explain /why/ it happened.  I'd call it a 
bug in the balance code, as the result of the -musage=10 should be 
exactly the same before and after, because the -musage=0 didn't actually 
relocate/delete anything.

> And now I'm back in business...
> 
> Still, this is a bit disappointing and at the very least very unexpected
> in 4.3.
> 
> legolas:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total=604.88GiB, used=520.09GiB
> System, DUP: total=32.00MiB, used=96.00KiB
> Metadata, DUP: total=5.00GiB, used=4.17GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

> legolas:~# btrfs fi show /mnt/btrfs_pool1
> Label: 'btrfs_pool1'  uuid: [...]
> 	Total devices 1 FS bytes used 524.26GiB
>       devid    1 size 615.01GiB used 614.94GiB path /dev/mapper/pool1


As Holger points out, you really are out of unallocated space.

And metadata is 5.00 GiB allocated, 4.17 directly used, plus the global 
reserve (which was recently confirmed on-list to come out of metadata) of 
half a GiB, so 4.17 + 0.50 = 4.67 GiB out of 5.00 used, so while not 
entirely full, you're close enough (under half a GiB free, and it's dup 
so you're under a pair of quarter-GiB metadata chunks free) that large 
operations may fail.

But as Holger also alluded to, you have all sorts of data space available 
(see below for why), with metadata space almost entirely used.

So why were you running -m balances, when -m was basically full but -d 
had some spare room and you actually needed to clear it?  Why weren't you 
doing -dusage=, to clear out those (partially, again, see below) empty 
data chunks, instead of the -musage=, which couldn't do much as metadata 
was pretty much fully used already?

And your command-prompts don't include timestamps so I can't say for 
sure, but presumably those results were AFTER the balance -musage=10 
succeeded and we don't have any pre-balance reports.  It's possible you 
were actually in worse shape before.

Meanwhile, it's worth noting that while current kernel btrfs /does/ 
automatically delete entirely empty chunks now, so -[dm]usage=0 can be 
expected to do nothing as the kernel already does that on its own now, 
thereby fixing the previously most extreme out-of-balance scenarios where 
there's loads of entirely empty chunks lying around, the kernel does 
*not* automatically do balances of _mostly-but-not-entirely_ empty chunks.

Which means that over time, normal usage is still likely to accumulate a 
bunch of say 1-60% full chunks, most likely data, that can still add up 
to tens or even hundreds of gigs of wasted chunk allocations that are 
*not* automatically cleared, because there's still at least *some* usage 
in those chunks.

Of course people leaving old snapshots lying around will exacerbate the 
problem, but even without snapshots, it'll likely still develop, given 
enough time, tho with usage=0 chunks automatically deleted now, it should 
take far longer than it did before.

That explains that data line above, nearly 605 GiB data chunk allocation, 
with only just over 520 GiB actually used, a difference of ~85 GiB.

While space is pretty tight and you might have to start pretty small (or 
delete a bunch of snapshots or temporarily delete or move off-filesystem 
a bunch of unsnapshotted files, hopefully clearing at least some data 
chunks to usage=0 so they can be cleaned up by the kernel or manually), 
say at -dusage=1, you should be able to get a good portion of that 85 GiB 
back with balance -dusage=, going up to say 70% if necessary, as you may 
have several 70% full chunks that can combine to one or two less chunks 
if they're rebalanced.

After that, please try to keep at least 5 or even 10 GiB unallocated, 
doing -dusage= balances while you still have enough room for balance to 
write new chunks, not letting it get so tight.  That's even more critical 
now than it was before, because there's unlikely to be zero-usage chunks 
lying around to balance away getting you out of the tight spot, because 
the kernel now balances those away on its own.

And of course if you do that, you shouldn't run into the scrub ENOSPC 
errors, either. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

