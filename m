Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38752 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422AbbLOQAl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 11:00:41 -0500
Received: by mail-ig0-f179.google.com with SMTP id xm8so17176964igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 08:00:40 -0800 (PST)
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1450069158.2388.72.camel@scientia.net> <566ECF41.10709@gmail.com>
 <1450149311.701.126.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56703928.7070003@gmail.com>
Date: Tue, 15 Dec 2015 11:00:40 -0500
MIME-Version: 1.0
In-Reply-To: <1450149311.701.126.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 22:15, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-14 at 09:16 -0500, Austin S. Hemmelgarn wrote:
>>> When one starts to get a bit deeper into btrfs (from the admin/end-
>>> user
>>> side) one sooner or later stumbles across the recommendation/need
>>> to
>>> use nodatacow for certain types of data (DBs, VM images, etc.) and
>>> the
>>> reason, AFAIU, being the inherent fragmentation that comes along
>>> with
>>> the CoW, which is especially noticeable for those types of files
>>> with
>>> lots of random internal writes.
>> It is worth pointing out that in the case of DB's at least, this is
>> because at least some of the do COW internally to provide the
>> transactional semantics that are required for many workloads.
> Guess that also applies to some VM images then, IIRC qcow2 does CoW.
Yep, and I think that VMWare's image format does too.
>
>
>
>>> a) for performance reasons (when I consider our research software
>>> which
>>> often has IO as the limiting factor and where we want as much IO
>>> being
>>> used by actual programs as possible)...
>> There are other things that can be done to improve this.  I would
>> assume
>> of course that you're already doing some of them (stuff like using
>> dedicated storage controller cards instead of the stuff on the
>> motherboard), but some things often get overlooked, like actually
>> taking
>> the time to fine-tune the I/O scheduler for the workload (Linux has
>> particularly brain-dead default settings for CFQ, and the deadline
>> I/O
>> scheduler is only good in hard-real-time usage or on small hard
>> drives
>> that actually use spinning disks).
> Well sure, I think we'de done most of this and have dedicated
> controllers, at least of a quality that funding allows us ;-)
> But regardless how much one tunes, and how good the hardware is. If
> you'd then loose always a fraction of your overall IO, and be it just
> 5%, to defragging these types of files, one may actually want to avoid
> this at all, for which nodatacow seems *the* solution.
nodatacow only works for that if the file is pre-allocated, if it isn't, 
then it still ends up fragmented.
>
>
>> The big argument for defragmenting a SSD is that it makes it such
>> that
>> you require fewer I/O requests to the device to read a file
> I've had read about that too, but since I haven't had much personal
> experience or measurements in that respect, I didn't list it :)
I can't give any real numbers, but I've seen noticeable performance 
improvements on good SSD's (Intel, Samsung, and Crucial) when making 
sure that things are defragmented.
>
>> The problem is not entirely the lack of COW semantics, it's also the
>> fact that it's impossible to implement an atomic write on a hard
>> disk.
> Sure... but that's just the same for the nodatacow writes of data.
> (And the same, AFAIU, for CoW itself, just that we'd notice any
> corruption in case of a crash due to the CoWed nature of the fs and
> could go back to the last generation).
Yes, but it's also the reason that using either COW or a log-structured 
filesystem (like NILFS2, LogFS, or I think F2FS) is important for 
consistency.
>
>
>>> but I wouldn't know that relational DBs really do cheksuming of the
>>> data.
>> All the ones I know of except GDBM and BerkDB do in fact provide the
>> option of checksumming.  It's pretty much mandatory if you want to be
>> considered for usage in financial, military, or medical applications.
> Hmm I see... PostgreSQL seem to have it since 9.3 ... didn't know
> that... only crc16 but at least something.
>
>
>>> Long story short, it does happen every now and then, that a scrub
>>> shows
>>> file errors, for neither the RAID was broken, nor there were any
>>> block
>>> errors reported by the disks, or anything suspicious in SMART.
>>> In other words, silent block corruption.
>> Or a transient error in system RAM that ECC didn't catch, or a
>> undetected error in the physical link layer to the disks, or an error
>> in
>> the disk cache or controller, or any number of other things.
> Well sure,... I was referring to these particular cases, where silent
> block corruption was the most likely reason.
> The data was reproducibly read identical, which probably rules out bad
> RAM or controller, etc.
>
>
>>    BTRFS
>> could only protect against some cases, not all (for example, if you
>> have
>> a big enough error in RAM that ECC doesn't catch it, you've got
>> serious
>> issues that just about nothing short of a cold reboot can save you
>> from).
> Sure, I haven't claimed, that checksumming for no-CoWed data is a
> solution for everything.
>
>
>>> But, AFAIU, not doing CoW, while not having a journal (or does it
>>> have
>>> one for these cases???) almost certainly means that the data (not
>>> necessarily the fs) will be inconsistent in case of a crash during
>>> a
>>> no-CoWed write anyway, right?
>>> Wouldn't it be basically like ext2?
>> Kind of, but not quite.  Even with nodatacow, metadata is still COW,
>> which is functionally as safe as a traditional journaling filesystem
>> like XFS or ext4.
> Sure, I was referring to the data part only, should have made that more
> clear.
>
>
>> Absolute worst case scenario for both nodatacow on
>> BTRFS, and a traditional journaling filesystem, the contents of the
>> file
>> are inconsistent.  However, almost all of the things that are
>> recommended use cases for nodatacow (primarily database files and VM
>> images) have some internal method of detecting and dealing with
>> corruption (because of the traditional filesystem semantics ensuring
>> metadata consistency, but not data consistency).
> What about VMs? At least a quick google search didn't give me any
> results on whether there would be e.g. checksumming support for qcow2.
> For raw images there surely is not.
I don't mean that the VMM does checksumming, I mean that the guest OS 
should be the one to handle the corruption.  No sane OS doesn't run at 
least some form of consistency checks when mounting a filesystem.
>
> And even if DBs do some checksumming now, it may be just a consequence
> of that missing in the filesystems.
> As I've written somewhere else in the previous mail: it's IMHO much
> better if one system takes care on this, where the code is well tested,
> than each application doing it's own thing.
That's really a subjective opinion.  The application knows better than 
we do what type of data integrity it needs, and can almost certainly do 
a better job of providing it than we can.  This is actually essentially 
the same reason that BTRFS and ZFS have multi-device support, the 
filesystem knows much better than the block device how it stores data, 
so it makes more sense to handle laying that data out across the disks 
in the filesystem.
>
>
>>>     - the data was written out correctly, but before the csum was
>>>       written the system crashed, so the csum would now tell us that
>>> the
>>>       block is bad, while in reality it isn't.
>> There is another case to consider, the data got written out, but the
>> crash happened while writing the checksum (so the checksum was
>> partially
>> written, and is corrupt).  This means we get a false positive on a
>> disk
>> error that isn't there, even when the data is correct, and that
>> should
>> be avoided if at all possible.
> I've had that, and I've left it quoted above.
> But as I've said before: That's one case out of many? How likely is it
> that the crash happens exactly after a large data block has been
> written followed by a relatively tiny amount of checksum data.
> I'd assume it's far more likely that the crash happens during writing
> the data.
Except that the whole metadata block pointing to that data block gets 
rewritten, not just the checksum.
>
> And regarding "reporting data to be in error, which is actually
> correct"... isn't that what all journaling systems may do?
No, most of them don't actually do that.  The general design of a 
journaling filesystem is that the journal is used as what's called a 
Write-Intent-Log (WIL), the purpose of which is to say 'Hey, I'm going 
to write this data here in a little while.' so that when your system 
dies while writing that data, you can then finish writing it correctly 
when the system gets booted up again.  And in particular, the only 
journaling filesystem that I know of that even allows the option of 
journaling the file contents instead of just metadata is ext4.
> And, AFAIU, isn't that also what can happen in btrfs? The data was
> already CoWed, but the metadata wasn't written out... so it would fall
> back somehow - here's where the unicorn[0] does it's job - to an older
> generation?
Kind of, there are some really rare cases where it's possible if you get 
_really_ unlucky on a multi-device filesystem that things get corrupted 
such that the filesystem thinks that data that is perfectly correct is 
invalid, and thinks that the other copy which is corrupted is valid. 
(I've actually had this happen before, it was not fun trying to recover 
from it).
> So that would be nothing really new.
>
>
>> Also, because of how disks work, and the internal layout of BTRFS,
>> it's
>> a lot more likely than you think that the data would be written but
>> the
>> checksum wouldn't.  The checksum isn't part of the data block, nor is
>> it
>> stored with it, it's actually a part of the metadata block that
>> stores
>> the layout of the data for that file on disk.
> Well it was clear to me, that data+csum isn't sequentially on disk are
> there any numbers from real studies how often it would happen that data
> is written correctly but not the metadata?
> And even if such study would show that - crash isn't the only problem
> we want to protect here (silent block errors, bus errors, etc).
> I don't want to say crashes never happen, but in my practical
> experience they don't happen that often either,...
>
> Losing a few blocks of valid data in the rare case of crashes, seems to
> be a penalty worth, when one gains confidence in data integrity in all
> others.
That _really_ depends on what the data is.  If you made that argument to 
the IT department at a financial institution, they would probably fall 
over laughing at you.
>
>
>> Because of the nature of
>> the stuff that nodatacow is supposed to be used for, it's almost
>> always
>> better to return bad data than it is to return no data (if you can
>> get
>> any data, then it's usually possible to recover the database file or
>> VM
>> image, but if you get none, it's a lot harder to recover the file).
> No. Simply no! :D
>
> Seriously:
> If you have bad data, for whichever reason (crash, silent block errors,
> etc.), it's always best to notice.
> *Then* you can decide what to do:
> - Is there a backup and does one want to get the data from that
>    backup, rather than continuing to use bad data, possibly even
>    overwriting good backups one week later
> - Is there either no backup or the effort of recovering it is to big
>    and the corruption doesn't matter enough (e.g. when you have large
>    video files, and there is a sinlge bit flip... well that may just
>    mean that one colour looks a tiny bit different)
>
> But that's nothing the fs could or should decide for the user.
OK, good point about this being policy.  And in some cases (executables, 
configuration for administrative software, similar things), it is better 
to just return an error, but in many cases, that's not what most desktop 
users would want.  Think document files, where a single byte error could 
easily be corrected by the user, or configuration files for sanely 
written apps (It's a lot nicer (and less confusing for someone without a 
lot of low-level computer background) to say 'Hey, your configuration 
file is messed up, here's how to fix it', than it is to say 'Hey, I 
couldn't read your configuration file').  And because BTRFS is supposed 
to be a general purpose filesystem, it has to account for the case of 
desktop users, and because server admins are supposed to be smart, the 
default should be for desktop usage.
>
> After I've had sent the initial mail from this thread I remembered what
> I've had forgotten to add:
> Is there a way in btrfs, to tell it that gives clearance to a file
> which it found to be in error based on checksums?
>
> Cause *this* is IMHO the proper solution for your "it's almost always
> better to return bad data than it is to return no data".
>
> When we at the Tier-2 detect a file error that we cannot correct by
> means of replicas, we determine the owner of that file, tell him about
> the issue, and if he wants to continue using the broken file, there's a
> way in the storage management system to rewrite the checksum.
>
>
>>> => Of course it wouldn't be as nice as in CoW, where it could
>>>      simply take the most recent consistent state of that block, but
>>>      still way better than:
>>>      - delivering bogus data to the application in n other cases
>>>      - not being able to decide which of m block copies is valid, if
>>> a
>>>        RAID is scrubbed
>> This gets _really_ scarily dangerous for a RAID setup, because we
>> _absolutely_ can't ensure consistency between disks without using
>> COW.
> Hmm now I just thought "damn he got me" ;-)
>
>> As of right now, we dispatch writes to disks one at a time (although
>> this would still be just as dangerous even if we dispatched writes in
>> parallel)
> Sure...
>
>
>> so if we crash it's possible that one disk would hold the old
>> data, one would hold the new data
> sure..
>
>
>> and _both_ would have correct
>> checksums, which means that we would non-deterministically return one
>> block or the other when an application tries to read it, and which
>> block
>> we return could change _each_ time the read is attempted, which
>> absolutely breaks the semantics required of a filesystem on any
>> modern
>> OS (namely, the file won't change unless something writes to it).
> Here I do not longer follow you, so perhaps you (or someone else) can
> explain a bit further. :-)
>
> a) Are checksums really stored per device (and not just once in the
> metadata? At least from my naive understanding this would either mean
> that there's a waste of storage, or that the csums are made on data
> that could vary from device to device (e.g. the same data split up in
> different extents, or compression on one device but not on the other).
> but..
AFAIUI, checksums are stored per-instance for every block.  This is 
important in a multi-device filesystem in case you lose a device, so 
that you still have a checksum for the block.  There should be no 
difference between extent layout and compression between devices however.
>
> b) that problem (different data each with valid corresponding csums)
> should in principle exist for CoWed data as well, right? And there, I
> guess, it's solved by CoWing the metadata... (which would still be the
> case for no-dataCoWed files).
Yes.
> Don't know what btrfs does in the CoWed case when such incident
> happens... how does it decide which of two such corresponding blocks
> would be the newer one? The generations?
Usually, but like I mentioned above there are edge cases that can occur 
as a result of data corruption on disk or other really rare 
circumstances.  In the particular case of multiple copies of a block 
with different data but valid checksums, I'm about 95% certain that it 
will non-deterministically return one block or the other on an arbitrary 
read when the read doesn't hit the VFS cache.  This is a potential issue 
for COW as well, but much less likely because it can more easily detect 
the corruption and fix it.
>
> Anyway, since metadata would still be CoWed, I think I may have gotten
> once again out of the tight spot - at least until you explain me, why
> my naive understanding, as laid out just above, doesn't work out O:-)
Hmm, I had forgotten about the metadata being COW, that does avoid the 
situation above under the specified circumstances, but does not avoid it 
happening due to disk errors (although that's extremely unlikely,a s it 
would require direct correlation of the errors in a way that is 
statistically impossible).
>
>
>> As I stated above, most of the stuff that nodatacow is intended for
>> already has it's own built-in protection.  No self-respecting RDBMS
>> would be caught dead without internal consistency checks, and they
>> all
>> do COW internally anyway (because it's required for atomic
>> transactions,
>> which are an absolute requirement for database systems), and in fact
>> that's part of why performance is so horrible for them on a COW
>> filesystem.  As far as VM's go, either the disk image should have
>> it's
>> own internal consistency checks (for example, qcow2 format, used by
>> QEMU, which also does COW internally), or the guest OS should have
>> such
>> checks.
> Well, for PostgreSQL it's still fairly new (9.3, as I've said above, ht
> tps://wiki.postgresql.org/wiki/What%27s_new_in_PostgreSQL_9.3#Data_Chec
> ksums), but it's not done per default (http://www.postgresql.org/docs/c
> urrent/static/app-initdb.html), and they warn about a noticable
> performance benefit (though I have of course no data whether this would
> be better/similar/worse to what is implied by btrfs checksumming).
>
> I've tried to find something for MySQL/MariaDB, but the only thing I
> could find there was: CHECKSUM TABLE
> But that seems to be a SQL command, i.e. not on-read checksumming as
> we're talking about, but rather something the application/admin would
> need to do manually.
I actually had been referring to this, with the assumption that the 
application would use it to verify it's own data.  I hadn't realized 
PostgreSQL had in-line support for it.
>
>
> BDB seems to support it (https://docs.oracle.com/cd/E17076_04/html/api_
> reference/C/dbset_flags.html), but again not per default.
> (And yes, we have quite big ones of them ^^)
>
> SQLite doesn't seem to do it, at least not per default? (https://www.sq
> lite.org/fileformat.html)
>
>
> I tried once again to find any reference that qcow2 (which alone I
> think would justify having csum support for nodatacow) supports
> checksumming.
> https://people.gnome.org/~markmc/qcow-image-format.html which seems to
> be the original definition, doesn't tell[1] anything about it.
> raw image, do of course not to any form of checksumming...
> I had a short glance at OVF, but nothing popped up immediately that
> would make me believe it supports checksumming.
> Well there's VDI and VHD left... but are these still used seriously?
> I guess KVM and Xen people mostly use raw or qcow2 these days, don't
> they?
VDI is still widely used, because it's the default for Virtual Box when 
creating a VM.  VHD is way more widely used than it should be, solely 
because there are insane people out there using Windows as a 
virtualization host.  You also forgot VMDK, which is what VMWare uses 
almost exclusively, but I don't think it has built-in checksumming.

As for Xen, the BCP are to avoid using image files like the plague, and 
use disks directly instead (or more commonly, use either LVM, or ZFS 
with zvols).
>
>
> So given all that, the picture looks a bit different again, I think.
> None of major FLOSS DBs doesn't do any checksumming per default, MySQL
> doesn't seem to support it, AFAICT. No VM image format seems to even
> support it.
Again, most of my intent in referring to those was that the application 
or the Guest OS would do the verification itself.
>
> And not to talk about countless of scientific data formats, which are
> mostly not widely known to the FLOSS world, but which are used with
> FLOSS software/Linux.
If the application doesn't have that type of thing built in, then that's 
not something the filesystem should be worrying about, that's the job of 
the application developers to deal with.  The point of a filesystem is 
to store data within the integrity guarantees provided by the hardware, 
possibly with some additional protection, not to save the user or 
application from making stupid choices.
>
> So AFAICT, the only thing left is torrent/edonkey files.
> And do these store the checksums along the files? Or do they rather
> wait until a chunk has been received, verify that and then throw it
> away?
> In any case however, at least some of these files types eventually end
> up in the raw files, without any checksum (as that's only used during
> download),... so when the files remain in the nodatacow area, they're
> again at risk (+ during the time after the P2P software has finally
> committed them to disk, and they'd be moved to CoWed and thus
> checksummed areas)
In the case of stuff like torrents and such, all the good software for 
working with them has an option to verify the file after downloading.

>
> [0] http://abstrusegoose.com/120
> [1] admittedly I just cross read over it, and searched for the usual
> suspect strings (hash, crc, sum) ;)
>

