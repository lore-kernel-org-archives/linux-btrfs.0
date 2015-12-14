Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38588 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbLNOQ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 09:16:58 -0500
Received: by igbxm8 with SMTP id xm8so84272889igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 06:16:58 -0800 (PST)
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1450069158.2388.72.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566ECF41.10709@gmail.com>
Date: Mon, 14 Dec 2015 09:16:33 -0500
MIME-Version: 1.0
In-Reply-To: <1450069158.2388.72.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-13 23:59, Christoph Anton Mitterer wrote:
> (consider that question being asked with that face on: http://goo.gl/LQaOuA)
>
> Hey.
>
> I've had some discussions on the list these days about not having
> checksumming with nodatacow (mostly with Hugo and Duncan).
>
> They both basically told me it wouldn't be straight possible with CoW,
> and Duncan thinks it may not be so much necessary, but none of them
> could give me really hard arguments, why it cannot work (or perhaps I
> was just too stupid to understand them ^^)... while at the same time I
> think that it would be generally utmost important to have checksumming
> (real world examples below).
>
> Also, I remember that in 2014, Ted Ts'o told me that there are some
> plans ongoing to get data checksumming into ext4, with possibly even
> some guy at RH actually doing it sooner or later.
>
> Since these threads were rather admin-work-centric, developers may have
> skipped it, therefore, I decided to write down some thoughts&ideas
> label them with a more attracting subject and give it some bigger
> attention.
> O:-)
>
>
>
>
> 1) Motivation why, it makes sense to have checksumming (especially also
> in the nodatacow case)
>
>
> I think of all major btrfs features I know of (apart from the CoW
> itself and having things like reflinks), checksumming is perhaps the
> one that distinguishes it the most from traditional filesystems.
>
> Sure we have snapshots, multi-device support and compression - but we
> could have had that as well with LVM and software/hardware RAID... (and
> ntfs supported compression IIRC ;) ).
> Of course, btrfs does all that in a much smarter way, I know, but it's
> nothing generally new.
> The *data* checksumming at filesystem level, to my knowledge, is
> however. Especially that it's always verified. Awesome. :-)
>
>
> When one starts to get a bit deeper into btrfs (from the admin/end-user
> side) one sooner or later stumbles across the recommendation/need to
> use nodatacow for certain types of data (DBs, VM images, etc.) and the
> reason, AFAIU, being the inherent fragmentation that comes along with
> the CoW, which is especially noticeable for those types of files with
> lots of random internal writes.
It is worth pointing out that in the case of DB's at least, this is 
because at least some of the do COW internally to provide the 
transactional semantics that are required for many workloads.
>
> Now duncan implied, that this could improve in the future, with the
> auto-defragmentation getting (even) better, defrag becoming usable
> again for those that do snapshots or reflinked copies and btrfs itself
> generally maturing more and more.
> But I kinda wonder to what extent one will be really able to solve
> that, what seems to me a CoW-inherent "problem",...
> Even *if* one can make the auto-defrag much smarter, it would still
> mean that such files, like big DBs, VMs, or scientific datasets that
> are internally rewritten, may get more or less constantly defragmented.
> That may be quite undesired...
> a) for performance reasons (when I consider our research software which
> often has IO as the limiting factor and where we want as much IO being
> used by actual programs as possible)...
There are other things that can be done to improve this.  I would assume 
of course that you're already doing some of them (stuff like using 
dedicated storage controller cards instead of the stuff on the 
motherboard), but some things often get overlooked, like actually taking 
the time to fine-tune the I/O scheduler for the workload (Linux has 
particularly brain-dead default settings for CFQ, and the deadline I/O 
scheduler is only good in hard-real-time usage or on small hard drives 
that actually use spinning disks).
> b) SSDs...
> Not really sure about that; btrfs seems to enable the autodefrag even
> when an SSD is detected,... what is it doing? Placing the block in a
> smart way on different chips so that accesses can be better
> parallelised by the controller?
This really isn't possible with an SSD.  Except for NVMe and Open 
Channel SSD's, they use the same interfaces as a regular hard drive, 
which means you get absolutely no information about the data layout on 
the device.

The big argument for defragmenting a SSD is that it makes it such that 
you require fewer I/O requests to the device to read a file, and in most 
cases, the device will outlive it's usefulness because of performance 
long before it dies due to wearing out the flash storage.
> Anyway, (a) is could be already argument enough, not to run solve the
> problem by a smart-[auto-]defrag, should that actually be implemented.
>
> So I think having notdatacow is great and not just a workaround till
> everything else gets better to handle these cases.
> Thus, checksumming, which is such a vital feature, should also be
> possible for that.
The problem is not entirely the lack of COW semantics, it's also the 
fact that it's impossible to implement an atomic write on a hard disk. 
If we could tell the disk 'ensure that this set of writes either all 
happen, or none of them happen', then we could do checksumming without 
using COW in the filesystem safely, except that that would require the 
disk to either do COW, or use the block level equivalent of a log 
structured filesystem, thus pushing the issue further down the storage 
stack.
>
>
> Duncan also mention that in some of those cases, the integrity is
> already protected by the application layer, making it less important to
> have it at the fs-layer.
> Well, this may be true for file-sharing protocols, but I wouldn't know
> that relational DBs really do cheksuming of the data.
All the ones I know of except GDBM and BerkDB do in fact provide the 
option of checksumming.  It's pretty much mandatory if you want to be 
considered for usage in financial, military, or medical applications.
> They have journals, of course, but these protect against crashes, not
> against silent block errors and that like.
> And I wouldn't know that VM hypervisors do checksuming (but perhaps
> I've just missed that).
>
> Here I can give a real-world example, from the Tier-2 that I run for
> LHC at work/university.
> We have large amounts of storage (perhaps not as large as what Google
> and Facebook have, or what the NSA stores about us)... but it's still
> some ~ 2PiB, or a bit more.
> That's managed with some special storage management software called
> dCache. dCache even stores checksums, but per file, so that means for
> normal reads, these cannot be verified (well technically it's
> supported, but with our usual file sizes, this is not working) so what
> remains are scrubs.
> For The two PiB, we have some... roughly 50-60 nodes, each with
> something between 12 and 24 disks, usually in either one or two RAID6
> volumes, all different kinds of hard disks.
> And we do run these scrubs quite rarely, since it costs IO that could
> be used for actual computing jobs (a problem that wouldn't be there
> with how btrfs calculates the sums on read, the data is then read
> anyway)... so likely there are even more errors that are just never
> noticed, because the datasets are removed again, before being scrubbed.
>
>
> Long story short, it does happen every now and then, that a scrub shows
> file errors, for neither the RAID was broken, nor there were any block
> errors reported by the disks, or anything suspicious in SMART.
> In other words, silent block corruption.
Or a transient error in system RAM that ECC didn't catch, or a 
undetected error in the physical link layer to the disks, or an error in 
the disk cache or controller, or any number of other things.  BTRFS 
could only protect against some cases, not all (for example, if you have 
a big enough error in RAM that ECC doesn't catch it, you've got serious 
issues that just about nothing short of a cold reboot can save you from).
>
> One may rely on the applications to do integrity protection, but I
> think that's not realistic, and perhaps that shouldn't be their task
> anyway (at least not when it's about storage device block errors and
> that like).
That depends, if the application has data safety requirements above and 
beyond what the OS can provide, then it very much is their job to ensure 
those requirements are met.
>
> I don't think it's on the horizon that things like DBs or large
> scientific data files do their own integrity protection (i.e. one that
> protects against bad blocks, and not just journalling that preserves
> consistency in case of crashes).
Actually, a lot of them do in fact do this (or at least, many database 
systems do), precisely because most existing filesystems don't provide 
guarantees of data consistency without a ridiculous hit to performance.
> And handling that on the fs level is anyway quite nice, I think.
> It doesn't mean that countless applications need to handle this on the
> application layer, making it configurable whether it should be enabled
> (for integrity protection) or disabled (for more speed), each of them
> writing a lot of code for that.
> If we can control that on the fs layer, by setting datasum/nodatasum,
> all needed is already there - except, that as of now, nodatacowed stuff
> is excluded in btrfs.
>
>
>
>
>
> 2) Technical
>
>
> Okay the following is obviously based on my naive view of how things
> could work, which may not necessarily go well with how an actual fs
> developer sees things ;-)
>
> As said in the introduction, I can't quite believe that data
> checksumming should in principle be possible for ext4, but not for
> btrfs non-CoWed parts.
Except that for this to work safely, ext4 would have to add COW support, 
which I think they added for the in-line encryption stuff (in-line data 
transformations like encryption or compression have the exact same 
issues that data checksumming does when run on a non-COW filesystem).
>
> Duncan&Hugo said, the reason is basically it cannot do checksums with
> no-CoW, because there's no guarantee that the fs doesn't end up
> inconsistently...
Exactly.
>
> But, AFAIU, not doing CoW, while not having a journal (or does it have
> one for these cases???) almost certainly means that the data (not
> necessarily the fs) will be inconsistent in case of a crash during a
> no-CoWed write anyway, right?
> Wouldn't it be basically like ext2?
Kind of, but not quite.  Even with nodatacow, metadata is still COW, 
which is functionally as safe as a traditional journaling filesystem 
like XFS or ext4.  Absolute worst case scenario for both nodatacow on 
BTRFS, and a traditional journaling filesystem, the contents of the file 
are inconsistent.  However, almost all of the things that are 
recommended use cases for nodatacow (primarily database files and VM 
images) have some internal method of detecting and dealing with 
corruption (because of the traditional filesystem semantics ensuring 
metadata consistency, but not data consistency).
>
> Or we have the case of multi-device, e.g. RAID1, multiple copies of the
> same blocks, a crash has happened during writing such (no-CoWed and no-
> checksummed)...
> Again it's almost certainly that at least one (maybe even both) of the
> blocks contains garbage and likely (at least a 50% chance) we get that
> one when the actual read happens later (I was told btrfs would behave
> in these cases like e.g MD RAID does,... deliver what the first
> readable block said).
>
> If btrfs would calculate checksums and write them e.g. after or before
> the actual data was written,... what would be the worst that could
> happen (in my naive understanding of course ;-) ) at a crash?
> - I'd say either one is lucky, and checksum and data matches.
>    Yay.
> - Or it doesn't match, which could boil down to the following two
>    cases:
>    - the data wasn't written out correctly and is actually garbage
>      => then we can be happy, that the checksum wouldn't match and we'd
>         get an error
>    - the data was written out correctly, but before the csum was
>      written the system crashed, so the csum would now tell us that the
>      block is bad, while in reality it isn't.
>      or the other way round:
>      the csum was written out (completely)... and no data was written
>      at all before the system crashed (so the old block would be still
>      completely there)
>      => in both cases: so what? Having that particular case happening
>         is probably far less likely, than csumming actually detecting a
>         bad block, or not completely written data in case of a crash.
>         (Not to talk about all the cases where nothing crashes, and
>         where we simply would want to detect block errors, bus errors,
>         etc.)
There is another case to consider, the data got written out, but the 
crash happened while writing the checksum (so the checksum was partially 
written, and is corrupt).  This means we get a false positive on a disk 
error that isn't there, even when the data is correct, and that should 
be avoided if at all possible.

Also, because of how disks work, and the internal layout of BTRFS, it's 
a lot more likely than you think that the data would be written but the 
checksum wouldn't.  The checksum isn't part of the data block, nor is it 
stored with it, it's actually a part of the metadata block that stores 
the layout of the data for that file on disk.  Because of the nature of 
the stuff that nodatacow is supposed to be used for, it's almost always 
better to return bad data than it is to return no data (if you can get 
any data, then it's usually possible to recover the database file or VM 
image, but if you get none, it's a lot harder to recover the file).
> => Of course it wouldn't be as nice as in CoW, where it could
>     simply take the most recent consistent state of that block, but
>     still way better than:
>     - delivering bogus data to the application in n other cases
>     - not being able to decide which of m block copies is valid, if a
>       RAID is scrubbed
This gets _really_ scarily dangerous for a RAID setup, because we 
_absolutely_ can't ensure consistency between disks without using COW. 
As of right now, we dispatch writes to disks one at a time (although 
this would still be just as dangerous even if we dispatched writes in 
parallel), so if we crash it's possible that one disk would hold the old 
data, one would hold the new data, and _both_ would have correct 
checksums, which means that we would non-deterministically return one 
block or the other when an application tries to read it, and which block 
we return could change _each_ time the read is attempted, which 
absolutely breaks the semantics required of a filesystem on any modern 
OS (namely, the file won't change unless something writes to it).
>
> And as said before, AFAIU, nodatacow'ed files have no journal in btrfs
> as in ext3/4, so it's basically anyway that such files, when written
> during a crash, may end up in any state, right? Which makes not having
> a csum sound even worse, since nothing tells that this file is possibly
> bad.
As I stated above, most of the stuff that nodatacow is intended for 
already has it's own built-in protection.  No self-respecting RDBMS 
would be caught dead without internal consistency checks, and they all 
do COW internally anyway (because it's required for atomic transactions, 
which are an absolute requirement for database systems), and in fact 
that's part of why performance is so horrible for them on a COW 
filesystem.  As far as VM's go, either the disk image should have it's 
own internal consistency checks (for example, qcow2 format, used by 
QEMU, which also does COW internally), or the guest OS should have such 
checks.
>
> Not having checksumming seems to be especially bad in the multi-device
> case... what happens when one runs a scrub? AFAIU, it simply does what
> e.g. MD does: taking the first readable block, writing it to any
> others, thereby possibly destroying the actually good one?
AFAICT from the code, yes, that is the case.
>
> Not sure about whether the following would make any practical sense:
> If data checksumming would work for nodatacow, then maybe some people
> may even choose to run btrfs in CoW1 mode,.. they still could have most
> fancy features from btrfs (checksumming, snapshots, perhaps even
> refcopy?) but unless snapshots or refcopies are explicitly made, btrfs
> doesn't do CoW.
That might have some use when people _really_ don't care about 
consistency across a crash (for example, when it's a filesystem that 
gets reinitialized every boot).

