Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34405 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbLUNgy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 08:36:54 -0500
Received: by mail-ig0-f182.google.com with SMTP id m11so30692617igk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Dec 2015 05:36:54 -0800 (PST)
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1450069158.2388.72.camel@scientia.net> <566ECF41.10709@gmail.com>
 <1450149311.701.126.camel@scientia.net> <56703928.7070003@gmail.com>
 <1450318197.6242.170.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56780042.5060307@gmail.com>
Date: Mon, 21 Dec 2015 08:36:02 -0500
MIME-Version: 1.0
In-Reply-To: <1450318197.6242.170.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-16 21:09, Christoph Anton Mitterer wrote:
> On Tue, 2015-12-15 at 11:00 -0500, Austin S. Hemmelgarn wrote:
>>> Well sure, I think we'de done most of this and have dedicated
>>> controllers, at least of a quality that funding allows us ;-)
>>> But regardless how much one tunes, and how good the hardware is. If
>>> you'd then loose always a fraction of your overall IO, and be it
>>> just
>>> 5%, to defragging these types of files, one may actually want to
>>> avoid
>>> this at all, for which nodatacow seems *the* solution.
>> nodatacow only works for that if the file is pre-allocated, if it
>> isn't,
>> then it still ends up fragmented.
> Hmm is that "it may end up fragmented" or a "it will definitely?
> Cause I'd have hoped, that if nothing else had been written in the
> meantime, btrfs would perhaps try to write next to the already
> allocated blocks.
If there are multiple files being written, then there is a relatively 
high probability that they will end up fragmented if they are more than 
about 64k and aren't pre-allocated.
>
>
>>>> The problem is not entirely the lack of COW semantics, it's also
>>>> the
>>>> fact that it's impossible to implement an atomic write on a hard
>>>> disk.
>>> Sure... but that's just the same for the nodatacow writes of data.
>>> (And the same, AFAIU, for CoW itself, just that we'd notice any
>>> corruption in case of a crash due to the CoWed nature of the fs and
>>> could go back to the last generation).
>> Yes, but it's also the reason that using either COW or a log-
>> structured
>> filesystem (like NILFS2, LogFS, or I think F2FS) is important for
>> consistency.
> So then it's no reason why it shouldn't work.
> The meta-data is CoWed, any incomplete writes of checksumdata in that
> (be it for CoWed data or no-CoWed data, should the later be
> implemented), would be protected at that level.
>
> Currently, the no-CoWed data is, AFAIU completely at risk of being
> corrupted (no checksums, no journal).
>
> Checksums on no-CoWed data would just improve that.
Except that without COW semantics on the data blocks, you can't be sure 
whether the checksum is for the data that is there, the data that was 
going to be written there, or data that had been there previously.  This 
will significantly increase the chances of having false positives, which 
really isn't a viable tradeoff.
>
>
>>> What about VMs? At least a quick google search didn't give me any
>>> results on whether there would be e.g. checksumming support for
>>> qcow2.
>>> For raw images there surely is not.
>> I don't mean that the VMM does checksumming, I mean that the guest OS
>> should be the one to handle the corruption.  No sane OS doesn't run
>> at
>> least some form of consistency checks when mounting a filesystem.
> Well but we're not talking about having a filesystem that "looks clear"
> here. For this alone we wouldn't need any checksumming at all.
>
> We talk about data integrity protection, i.e. all files and their
> contents. Nothing which a fsck inside a guest VM would ever notice (I
> mean by a fsck), if there are just some bit flips or things like that.
That really depends on what is being done inside the VM.  If you're 
using BTRFS or even dm-verity, you should have no issues detecting the 
corruption.
>
>
>>>
>>> And even if DBs do some checksumming now, it may be just a
>>> consequence
>>> of that missing in the filesystems.
>>> As I've written somewhere else in the previous mail: it's IMHO much
>>> better if one system takes care on this, where the code is well
>>> tested,
>>> than each application doing it's own thing.
>> That's really a subjective opinion.  The application knows better
>> than
>> we do what type of data integrity it needs, and can almost certainly
>> do
>> a better job of providing it than we can.
> Hmm I don't see that.
> When we, at the filesystem level, provide data integrity, than all data
> is guaranteed to be valid.
> What more should an application be able to provide? At best they can do
> the same thing faster, but even for that I see no immediate reason to
> believe it.
Any number of things.  As of right now, there are no local filesystems 
on Linux that provide:
1. Cryptographic verification of the file data (Technically possible 
with IMA and EVM, or with DM-Verity (if the data is supposed to be 
read-only), but those require extra setup, and aren't part of the FS).
2. Erasure coding other than what is provided by RAID5/6 (At least one 
distributed cluster filesystem provides this (Ceph), but running such a 
FS on a single node is impractical).
3. Efficient transactional logging (for example, the type that is needed 
by most RDBMS software).
4. Easy selective protections (Some applications need only part of their 
data protected).

Item 1 can't really be provided by BTRFS under it's current design, it 
would require at least implementing support for cryptographically secure 
hashes in place of CRC32c (and each attempt to do that has been pretty 
much shot down).  Item 2 is possible, and is something I would love to 
see support for, but would require a significant amount of coding, and 
almost certainly wouldn't anywhere near as flexible as letting the 
application do it itself.  Item 3 can't be done without making the 
filesystem application specific, because you need to know enough about 
the data being logged to do it efficiently (see the original Oracle 
Cluster Filesystem for an example (not OCFS2), it was designed solely 
for Oracle's database software).  Item 4 is technically possible, but 
not all that practical, as the amount of metadata required to track 
different levels of protection within a file would prohibitive.
>
> And in practise it seems far more likely that if countless applications
> should such task on their own, that it's more error prone (that's why
> we have libraries for all kinds of code, trying to reuse code,
> minimising the possibility of errors in countless home-brew solutions),
> or not done at all.
Yes, and _all_ the libraries are in userspace, which is even more 
argument for the protection being done there.
>
>
>>>>>      - the data was written out correctly, but before the csum
>>>>> was
>>>>>        written the system crashed, so the csum would now tell us
>>>>> that
>>>>> the
>>>>>        block is bad, while in reality it isn't.
>>>> There is another case to consider, the data got written out, but
>>>> the
>>>> crash happened while writing the checksum (so the checksum was
>>>> partially
>>>> written, and is corrupt).  This means we get a false positive on
>>>> a
>>>> disk
>>>> error that isn't there, even when the data is correct, and that
>>>> should
>>>> be avoided if at all possible.
>>> I've had that, and I've left it quoted above.
>>> But as I've said before: That's one case out of many? How likely is
>>> it
>>> that the crash happens exactly after a large data block has been
>>> written followed by a relatively tiny amount of checksum data.
>>> I'd assume it's far more likely that the crash happens during
>>> writing
>>> the data.
>> Except that the whole metadata block pointing to that data block gets
>> rewritten, not just the checksum.
> But that's the case anyway, isn't it? With or without checksums.
Yes, and it's also one of the less well documented failure modes for 
nodatacow. If the data is COW, then BTRFS doesn't even look at the new 
data, because the only metadata block that points to it is invalid, so 
you see old data, but you are also guaranteed to see verified data.
>
>
>
>>> And regarding "reporting data to be in error, which is actually
>>> correct"... isn't that what all journaling systems may do?
>> No, most of them don't actually do that.  The general design of a
>> journaling filesystem is that the journal is used as what's called a
>> Write-Intent-Log (WIL), the purpose of which is to say 'Hey, I'm
>> going
>> to write this data here in a little while.' so that when your system
>> dies while writing that data, you can then finish writing it
>> correctly
>> when the system gets booted up again.  And in particular, the only
>> journaling filesystem that I know of that even allows the option of
>> journaling the file contents instead of just metadata is ext4.
> Well but that's just what I say... the system crashes,... the journal
> tells about anything that's not for sure cleanly on disk, even though
> it may have actually made it it.
Except, like I said, it doesn't track data, only metadata, so only stuff 
for which allocations changed would be covered by the journal.
>
> Nothing more than what would happen in our case.
>
>
>>> And, AFAIU, isn't that also what can happen in btrfs? The data was
>>> already CoWed, but the metadata wasn't written out... so it would
>>> fall
>>> back somehow - here's where the unicorn[0] does it's job - to an
>>> older
>>> generation?
>> Kind of, there are some really rare cases where it's possible if you
>> get
>> _really_ unlucky on a multi-device filesystem that things get
>> corrupted
>> such that the filesystem thinks that data that is perfectly correct
>> is
>> invalid, and thinks that the other copy which is corrupted is valid.
>> (I've actually had this happen before, it was not fun trying to
>> recover
>> from it).
> Doesn't really speak against nodatacow checksumming, AFAICS.
You're right, it was more meant to point out that even with COW, stuff 
can get confused if you're really unlucky.
>
>
>>> Well it was clear to me, that data+csum isn't sequentially on disk
>>> are
>>> there any numbers from real studies how often it would happen that
>>> data
>>> is written correctly but not the metadata?
>>> And even if such study would show that - crash isn't the only
>>> problem
>>> we want to protect here (silent block errors, bus errors, etc).
>>> I don't want to say crashes never happen, but in my practical
>>> experience they don't happen that often either,...
>>>
>>> Losing a few blocks of valid data in the rare case of crashes,
>>> seems to
>>> be a penalty worth, when one gains confidence in data integrity in
>>> all
>>> others.
>> That _really_ depends on what the data is.  If you made that argument
>> to
>> the IT department at a financial institution, they would probably
>> fall
>> over laughing at you.
> Well but your point is completely moot, because for someone who cares
> so much in data, they wouldn't use nodatacow when btrfs has no journal
> and the data could end up in any state in case of crash.
>
> And I'm quite certain that each financial institution rather clearly
> gets an error message (i.e. because the checksums don't very), after
> which they can get a backup, than having corrupt data taking for valid,
> and the debts of their customers being zeroed.
That all assumes that the administrators in question are smart.  This is 
_never_ a safe assumption unless you have personally verified it, and 
even then it's still not a particularly safe assumption.
>
> It's kinda strange how you argue against better integrity protection
> ;-)
The point was that your argument that 'losing a few blocks of valid data 
on a crash is worth it for better integrity' was pretty far fetched. 
For almost all applications out there, losing known good data or getting 
false errors is never something that should happen.
>
>
>>> But that's nothing the fs could or should decide for the user.
>> OK, good point about this being policy.  And in some cases
>> (executables,
>> configuration for administrative software, similar things), it is
>> better
>> to just return an error, but in many cases, that's not what most
>> desktop
>> users would want.  Think document files, where a single byte error
>> could
>> easily be corrected by the user, or configuration files for sanely
>> written apps (It's a lot nicer (and less confusing for someone
>> without a
>> lot of low-level computer background) to say 'Hey, your configuration
>> file is messed up, here's how to fix it', than it is to say 'Hey, I
>> couldn't read your configuration file').  And because BTRFS is
>> supposed
>> to be a general purpose filesystem, it has to account for the case of
>> desktop users, and because server admins are supposed to be smart,
>> the
>> default should be for desktop usage.
> Well but that's just the point I've made. The fs cannot decide what's
> better or not.
> Your document could be an important config file that allows/disallows
> remote users access to resources. The single byte error could make a 0
> to a 1, allowing world wide access.
That's not something that falls with actual 'Desktop' usage, that's 
server usage.
> It could be your thesis' data, or part of the document file, changing
> some numbers, which you won't easily notice but which makes everything
> bogus when examined.
And if you're writing a thesis, or some other research paper, you'd darn 
well better be verifying your data multiple times before you publish it.
> I had brought the example with the video file, where it may not matter.
It really doesn't in the case of a video file, or most audio files, or 
even some image files.  If you take almost any arbitrary video file, and 
change any one bit outside of the header, then unless it's very poor 
quality to begin with, it's almost certain that nobody will notice (and 
in the case of the good formats, it'll just result in a dropped frame, 
because they have built-in verification).
>
> But in any case it's nothing what the fs can decide. The best it can do
> is give an error on read, and the tools to give clearance to such files
> (when they could not be auto-recovered by e.g. other copies).
>
> All this is however only possible with checksumming.
Or properly educating users so they don't use nodatacow on everything.
It's just like journal=writeback on ext4, it improves performance for 
some things, but can result in really weird inconsistencies when the 
system crashes.
>
>
>>> a) Are checksums really stored per device (and not just once in the
>>> metadata? At least from my naive understanding this would either
>>> mean
>>> that there's a waste of storage, or that the csums are made on data
>>> that could vary from device to device (e.g. the same data split up
>>> in
>>> different extents, or compression on one device but not on the
>>> other).
>>> but..
>> AFAIUI, checksums are stored per-instance for every block.  This is
>> important in a multi-device filesystem in case you lose a device, so
>> that you still have a checksum for the block.  There should be no
>> difference between extent layout and compression between devices
>> however.
> hmm but if that's the case, especially the later, that the extents are
> the same on all devices,... then there's IMHO no need for data being
> stored per-instance (I guess you mean per device instance?) for every
> block.
> The meta-data would have e.g. DUP anyway, so even if one device fails
> metadata would hopefully be still there.
> And if metadata is coompletely lost, the fs is lost anyway, and csums
> don't matter anymore.
OK, as Duncan pointed out in one of his replies, I was only correct by 
coincidence.  checksums are stored based on metadata redundancy, so if 
metadata is raid1 or dup, you have two copies of each checksum.
>
>
>>> b) that problem (different data each with valid corresponding
>>> csums)
>>> should in principle exist for CoWed data as well, right? And there,
>>> I
>>> guess, it's solved by CoWing the metadata... (which would still be
>>> the
>>> case for no-dataCoWed files).
>> Yes.
>>> Don't know what btrfs does in the CoWed case when such incident
>>> happens... how does it decide which of two such corresponding
>>> blocks
>>> would be the newer one? The generations?
>> Usually, but like I mentioned above there are edge cases that can
>> occur
>> as a result of data corruption on disk or other really rare
>> circumstances.  In the particular case of multiple copies of a block
>> with different data but valid checksums, I'm about 95% certain that
>> it
>> will non-deterministically return one block or the other on an
>> arbitrary
>> read when the read doesn't hit the VFS cache.
> Hmm would be quite worrysome if that could happen, especially also in
> the CoW case.
The thing is, this can't be fully protected against, except by verifying 
the blocks against each other when you read them, which will absolutely 
kill performance.  The chance of this happening (without actively 
malicious intent) with COW on everything is extremely small (it requires 
a very large number of highly correlated errors), but having nodatacow 
enabled makes it slightly higher.  In both cases it's statistically 
impossible, but that just means ti's something that almost certainly 
won't happen, and thus we shouldn't worry about dealing with it until we 
have everything else covered.
>
>>    This is a potential issue
>> for COW as well, but much less likely because it can more easily
>> detect
>> the corruption and fix it.
> But then again, there should be no difference to checksumming the
> no-CoWed data - the checksums would be CoWed again, if btrfs can detect
> it there, it should be fine.
>
>
>
>
>>>
>>> Anyway, since metadata would still be CoWed, I think I may have
>>> gotten
>>> once again out of the tight spot - at least until you explain me,
>>> why
>>> my naive understanding, as laid out just above, doesn't work out
>>> O:-)
>> Hmm, I had forgotten about the metadata being COW, that does avoid
>> the
>> situation above under the specified circumstances, but does not avoid
>> it
>> happening due to disk errors (although that's extremely unlikely,a s
>> it
>> would require direct correlation of the errors in a way that is
>> statistically impossible).
> Ah... here we go :-)
>
> What exactly do you mean with disk errors here? IOW, what scenario do
> you think of, in which checksumming no-CoWed data could lead to any
> more corruptions than it can to without checksumming as well, or where
> any inconsistencies could get into the filesystem's meta-data, that
> couldn't already come in for checksummed+CoWed data and/or non-
> checksummed+CoWed data?
It can't (AFAICS) lead to any more _actual_ corruption, but it very much 
can lead to more false positives in the error detection, which is by 
definition a regression.
>
>>> Well, for PostgreSQL it's still fairly new (9.3, as I've said
>>> above, ht
>>> tps://wiki.postgresql.org/wiki/What%27s_new_in_PostgreSQL_9.3#Data_
>>> Chec
>>> ksums), but it's not done per default (http://www.postgresql.org/do
>>> cs/c
>>> urrent/static/app-initdb.html), and they warn about a noticable
>>> performance benefit (though I have of course no data whether this
>>> would
>>> be better/similar/worse to what is implied by btrfs checksumming).
>>>
>>> I've tried to find something for MySQL/MariaDB, but the only thing
>>> I
>>> could find there was: CHECKSUM TABLE
>>> But that seems to be a SQL command, i.e. not on-read checksumming
>>> as
>>> we're talking about, but rather something the application/admin
>>> would
>>> need to do manually.
>> I actually had been referring to this, with the assumption that the
>> application would use it to verify it's own data.  I hadn't realized
>> PostgreSQL had in-line support for it.
> Well but the (fairly new) in-line support, is the only thing that we
> can really count here.
>
> What mysql does is that it requires the app to do it.
> a) It's likely that there are many apps which don't use this (maybe
> simply because they don't know it) and it's unlikely they'll all
> change.
> While what we can do at the btrfs level (or what postgresql would do)
> works out of the box for everything.
It works out of the box for everything, but it's also sub-optimal 
protection for almost everything that actually requires data integrity.
>
> b) I may simply not very well understand the CHECKSUM TABLE, but to me
> it doesn't seem useful to provide data integrity in the sense we're
> talking here about (i.e. silent block errors, bus errors, etc.)
> Why?
> First, it seems to checksum the whole data of the whole table, and
> AFAICS, it uses only CRC32... given that such tables may be easily GiB
> in size, CRC32 is IMHO simply not good enough.
> Postgresql/btrfs in turn do the checksums on much smaller amounts of
> data.
> Second, verification seems to only take place when that command is
> called. I'm not sure whether it implies locking the table in memory
> then (didn't dig too deep), but I can't believe it would, which system
> could keep a 100 GiB table in mem?
> So it seems to be basically a one-shot verification, not covering any
> corruptions that happen in between.
> In fact, the documentation of the function even tells that this is for
> backups/rollbacks/etc. only... so it's absolutely not that kind of data
>   integrity protection we're talking about (and even for that purpose,
> CRC32 seems to be a poor choice).
>
>
>> VDI is still widely used, because it's the default for Virtual Box
>> when
>> creating a VM.
> Guess I just disbelieved that VirtualBox is still widely used O;-)
On a commercial level, it really isn't (I don't even think that Oracle 
uses internally any more).  On a personal level, it very much is, 
because too many people are too stupid because of Windows to learn to 
use stuff like QEMU or Xen.
>
>
>>    VHD is way more widely used than it should be, solely
>> because there are insane people out there using Windows as a
>> virtualization host.  You also forgot VMDK, which is what VMWare uses
>> almost exclusively, but I don't think it has built-in checksumming.
>>
>> As for Xen, the BCP are to avoid using image files like the plague,
>> and
>> use disks directly instead (or more commonly, use either LVM, or ZFS
>> with zvols).
> Anyway... what it comes down to: None of the VM image formats seem to
> support checksumming.
>
>
>>> So given all that, the picture looks a bit different again, I
>>> think.
>>> None of major FLOSS DBs doesn't do any checksumming per default,
>>> MySQL
>>> doesn't seem to support it, AFAICT. No VM image format seems to
>>> even
>>> support it.
>> Again, most of my intent in referring to those was that the
>> application
>> or the Guest OS would do the verification itself.
> I've answered that above already, IIRC (our mails get too lengthy O:-)
> ).
> The guest OS doesn't verify more than what our typical host OS (Linux)
> does.
> And that (except when btrfs with CoWed data is used ;-) does filesystem
> integrity verification - which is however not data integrity
> verification.
>
>
> btw: That makes me think about something interesting:
> If btrfs will ever support checksumming on no-CoWed data... then the
> documentation should describe, that depending on the actual scenario,
> it may make sense that btrfs filesystems inside the guest run generally
> with nodatasum.
> The idea begin: Why verifying twice?
That gets to be a particularly dangerous recommendation, because lots of 
people (who arguably shouldn't be messing around with such stuff to 
begin with) will likely think it means that they can turn it off 
unconditionally in the guest system, which really isn't safe for 
anything that might be moved to some other FS.
>
> The constraints being, AFAICS, the following:
> - If the VM image is ever to be moved off the host's btrfs image
> (which
>    would have checksumming enabled) to a fs without checksumming or if
>    it would be ever copied remotely, than not having the "internal"
>    checksumming (i.e. from the btrfs filesystems inside the gues),
> would
>    make one loose the integrity protection
> - It further would only work, if the hypervisor itself, would properly
>    pass on any IO errors when it reads from the image files in the
>    host's btrfs, to block IO errors for the guest. If it wouldn't, then
>    the guest (with disabled "internal" checksumming) wouldn't probably
>    notice any data integrity errors, which he would, if the "internal"
>    checksumming wasn't turned off.
>
>
>> If the application doesn't have that type of thing built in, then
>> that's
>> not something the filesystem should be worrying about, that's the job
>> of
>> the application developers to deal with.
> No.
>
> If you see it like that, you could as well drop data checksumming in
> btrfs completely.
> You'd anyway argue that it would be the applications duty to do that.
No, BTRFS's job is to verify that the data it returns matches what it 
was given in the first place.  That is not reliably possible without 
having COW semantics on data blocks.
>
> The same way you could argue, that your MP4, JPG, ISO image or whatever
> you downloaded via bittorrent needs to contain checksum data, and that
> the actual application (which is not bittorrent, but e.g. mplayer,
> imagemagick or wodim) need to verify these.
> However this is not the case.
ISO 9660 includes built-in ECC, it would be impractical for usage on 
removable optical media otherwise.  JPEG and MP4 are irrelevant because 
in both cases, the average person can't detect corruption caused by 
single bit errors.  Bittorrent itself properly verifies the downloads 
like it should.
> In fact, it's quite usual and proper to have the lower layer handle
> stuff which the higher layer don't have any real direct interest in
> (except for the case, that the lower layer doesn't do it).
Except that data integrity is obviously something the higher layers _do_ 
have interest in.
>
>
>> The point of a filesystem is
>> to store data within the integrity guarantees provided by the
>> hardware,
>> possibly with some additional protection
> If you're convinced by that, you should probably propose that btrfs
> removes data checksumming altogether.
> I guess you won't make much friends with that idea ;)
I think you missed the bit about 'possibly with some additional 
protection'.  I really could have worded that better, but that's 
somewhat irrelevant.
>
>
>
>> In the case of stuff like torrents and such, all the good software
>> for
>> working with them has an option to verify the file after downloading.
> Not sure what you mean with "and such", if it's again VMs, and DBs (the
> IMHO actually more important use case than file sharing), I showed you
> in the last mail, that non of these do any verification by default, and
>   half of the important ones don't even support it, with nothing on the
> horizon that this would change (probably because they argue just the
> other way round than you do: the fs should handle data integrity, and
> ZFS and btrfs give them partially right ;-) ).
> And I'm not sure with torrents, but I'd have suspected once the file's
> downloaded completely, any checksumming data is no longer kept.
If you keep the torrent file (even if it's kept loaded in the software), 
you have the checksum, as that's part of the identifier that is used to 
fetch the file.
> If my guess is correct, even the torrent software doesn't really do
> overall data integrity protection, but just until the download is
> finished; at least this used to be the case with the other P2P network
> softwares.
Any good torrent software will let you verify the download after the 
fact, assuming you still have the torrent running (because if the 
verification fails, it will then go and re-download the failed blocks).
>
>
>
> Thanks for the discussion so far :)
> It actually made me just more confident that no-CoWed data checksumming
> should work and is actually needed ;)
If your so convinced it's necessary, C is not hard to learn, and patches 
would go a long way towards getting this in the kernel.  Whether I agree 
with it or not, if patches get posted, I'll provide the same degree of 
review as I would for any other feature (and even give my Tested-by 
assuming it passes xfstests, and the various edge-cases not in XFS tests 
that I throw at anything I test).
