Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:52787 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbeCFA6D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 19:58:03 -0500
Message-ID: <1520297878.4428.39.camel@scientia.net>
Subject: Re: spurious full btrfs corruption
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Date: Tue, 06 Mar 2018 01:57:58 +0100
In-Reply-To: <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
References: <26306A4D-2D8E-4661-B89E-9F050FD184D5@scientia.net>
         <BF03A3DF-684D-47FE-A9AD-320256F64763@scientia.net>
         <b6b4ed0e-9569-158d-19ad-82c885bab4ec@gmx.com>
         <BB977A40-847C-4611-A468-9BF1137CE711@scientia.net>
         <d2a14d69-dfa9-8794-6375-03d1b209632f@gmx.com>
         <68697875-6E77-49C4-B54E-0FADB94700DA@scientia.net>
         <99ee9b31-a38a-d479-5b1d-30e9c942d577@gmx.com>
         <A19E863A-F83C-4630-9675-4309CECB318E@scientia.net>
         <1b24e69e-2c1e-71af-fb1d-9d32f72cc78c@gmx.com>
         <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>
         <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
         <1519833022.3714.122.camel@scientia.net>
         <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Qu.

On Thu, 2018-03-01 at 09:25 +0800, Qu Wenruo wrote:
> > - For my personal data, I have one[0] Seagate 8 TB SMR HDD, which I
> >   backup (send/receive) on two further such HDDs (all these are
> >   btrfs), and (rsync) on one further with ext4.
> >   These files have all their SHA512 sums attached as XATTRs, which
> > I
> >   regularly test. So I think I can be pretty sure, that there was
> > never
> >   a case of silent data corruption and the RAM on the E782 is fine.
> 
> Good backup practice can't be even better.

Well I still would want to add something tape and/or optical based
solution...
But having this depends a bit on having a good way to do incremental
backups, i.e. I wouldn't want to write full copies of everything to
tape/BluRay over and over again, but just the actually added data and
records of metadata changes.
The former (adding just added files is rather easy), but still
recording any changes in metadata (moved/renamed/deleted files, changes
in file dates, permissions, XATTRS etc.).
Also I would always want to backup complete files, so not just changes
to a file, even if just one byte changed of a 4 GiB file... and not
want to have files split over mediums.

send/receive sounds like a candidate for this (except it works only on
changes, not full files), but I would prefer to have everything in a
standard format like tar which one can rather easily recover manually
if there are failures in the backups.


Another missing piece is a tool which (at my manual order) adds hash
sums to the files, and which can verify them
Actually I wrote such a tool already, but as shell script and it simply
forks so often, that it became extremely slow at millions of small
files.
I often found it so useful to have that kind of checksumming in
addition to the kind of checksumming e.g. btrfs does which is not at
the level of whole files.
So if something goes wrong like now, I cannot only verify whether
single extents are valid, but also the chain of them that comprises a
file.. and that just for the point where I defined "now, as it is, the
file is valid",.. and automatically on any writes, as it would be done
at file system level checksumming.
In the current case,... for many files where I had such whole-file-
csums, verifying whether what btrfs-restore gave me was valid or not,
was very easy because of them.


> Normally I won't blame memory unless strange behavior happens, from
> unexpected freeze to strange kernel panic.
Me neither... I think bad RAM happens rather rarely these days.... but
my case may actually be one.


> Netconsole would help here, especially when U757 has an RJ45.
> As long as you have another system which is able to run nc, it should
> catch any kernel message, and help us to analyse if it's really a
> memory
> corruption.
Ah thanks... I wasn't even aware of that ^^
I'll have a look at it when I start inspecting the U757 again in the
next weeks.


> > - The notebooks SSD is a Samsung SSD 850 PRO 1TB, the same which I
> >   already used with the old notebook.
> >   A long SMART check after the corruption, brought no errors.
> 
> Also using that SSD with smaller capacity, it's less possible for the
> SSD.
Sorry, what do you mean? :)


> Normally I won't blame memory, but even newly created btrfs, without
> any
> powerloss, it still reports csum error, then it maybe the problem.
That was also my idea...
I may mix up things, but I think I even found a csum error later on the
rescue USB stick (which is also btrfs)... would need to double check
that, though.

> > - So far, in the data I checked (which as I've said, excludes a
> > lot,..
> >   especially the QEMU images)
> >   I found only few cases, where the data I got from btrfs restore
> > was
> >   really bad.
> >   Namely, two MP3 files. Which were equal to their backup
> > counterparts,
> >   but just up to some offset... and the rest of the files were just
> >   missing.
> 
> Offset? Is that offset aligned to 4K?
> Or some strange offset?

These were the two files:
-rw-r--r-- 1 calestyo calestyo   90112 Feb 22 16:46 'Lady In The Water/05.mp3'
-rw-r--r-- 1 calestyo calestyo 4892407 Feb 27 23:28 '/home/calestyo/share/music/Lady In The Water/05.mp3'


-rw-r--r-- 1 calestyo calestyo 1904640 Feb 22 16:47 'The Hunt For Red October [Intrada]/21.mp3'
-rw-r--r-- 1 calestyo calestyo 2968128 Feb 27 23:28 '/home/calestyo/share/music/The Hunt For Red October [Intrada]/21.mp3'

with the former (smaller one) being the corrupted one (i.e. the one
returned by btrfs-restore).

Both are (in terms of filesize) multiples of 4096... what does that
mean now?


> > - Especially recovering the VM images will take up some longer
> > time...
> >   (I think I cannot really trust what came out from the btrfs restore
> >   here, since these already brought csum errs before)

In the meantime I had a look of the remaining files that I got from the
btrfs-restore (haven't run it again so far, from the OLD notebook, so
only the results from the NEW notebook here:):

The remaining ones were multi-GB qcow2 images for some qemu VMs.
I think I had non of these files open (i.e. VMs running) while in the
final corruption phase... but at least I'm sure that not *all* of them
were running.

However, all the qcow2 files from the restore are more or less garbage.
During the btrfs-restore it already complained on them, that it would
loop too often on them and whether I want to continue or not (I choose
n and on another full run I choose y).

Some still contain a partition table, some partitions even filesystems
(btrfs again)... but I cannot mount them.

The following is some output of several commands... but these
filesystems are not that important for me... it would be nice if one
could recover parts of it,... but nothing you'd need to waste time for.
But perhaps it helps to improve btrfs-restore(?),... so here we go:



root@heisenberg:/mnt/restore/x# l
total 368M
drwxr-xr-x 1 root root 212 Mar  6 01:52 .
drwxr-xr-x 1 root root  76 Mar  6 01:52 ..
-rw------- 1 root root 41G Feb 15 17:48 SilverFast.qcow2
-rw------- 1 root root 27G Feb 15 16:18 Windows.qcow2
-rw------- 1 root root 11G Feb 21 02:05 klenze.scientia.net_Debian-amd64-unstable.qcow2
-rw------- 1 root root 13G Feb 17 22:27 mldonkey.qcow2
-rw------- 1 root root 11G Nov 16 01:40 subsurface.qcow2
root@heisenberg:/mnt/restore/x# qemu-nbd -f qcow2 --connect=/dev/nbd0 klenze.scientia.net_Debian-amd64-unstable.qcow2 
root@heisenberg:/mnt/restore/x# blkid /dev/nbd0*
/dev/nbd0: PTUUID="a4944b03-ae24-49ce-81ef-9ef2cf4a0111" PTTYPE="gpt"
/dev/nbd0p1: PARTLABEL="BIOS boot partition" PARTUUID="c493388e-6f04-4499-838e-1b80669f6d63"
/dev/nbd0p2: LABEL="system" UUID="e4c30bb5-61cf-40aa-ba50-d296fe45d72a" UUID_SUB="0e258f8d-5472-408c-8d8e-193bbee53d9a" TYPE="btrfs" PARTLABEL="Linux filesystem" PARTUUID="cd6a8d28-2259-4b0c-869f-267e7f6fa5fa"
root@heisenberg:/mnt/restore/x# mount -r /dev/nbd0p2 /opt/
mount: /opt: wrong fs type, bad option, bad superblock on /dev/nbd0p2, missing codepage or helper program, or other error.
root@heisenberg:/mnt/restore/x# 

kernel says:
Mar 06 01:53:14 heisenberg kernel: Alternate GPT is invalid, using primary GPT.
Mar 06 01:53:14 heisenberg kernel:  nbd0: p1 p2
Mar 06 01:53:44 heisenberg kernel: BTRFS info (device nbd0p2): disk space caching is enabled
Mar 06 01:53:44 heisenberg kernel: BTRFS info (device nbd0p2): has skinny extents
Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): bad tree block start 0 12142526464
Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): bad tree block start 0 12142526464
Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): failed to read chunk root
Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): open_ctree failed



root@heisenberg:/mnt/restore/x# btrfs check /dev/nbd0p2
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=12142526464, have=0
ERROR: cannot read chunk root
ERROR: cannot open file system

(kernel says nothing)


root@heisenberg:/mnt/restore/x# btrfs-find-root /dev/nbd0p2
WARNING: cannot read chunk root, continue anyway
Superblock thinks the generation is 572957
Superblock thinks the level is 0

(again, nothing from the kernel log)



root@heisenberg:/mnt/restore/x# btrfs inspect-internal dump-tree /dev/nbd0p2
btrfs-progs v4.15.1
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=12142526464, have=0
ERROR: cannot read chunk root
ERROR: unable to open /dev/nbd0p2



root@heisenberg:/mnt/restore/x# btrfs inspect-internal dump-super /dev/nbd0p2
superblock: bytenr=65536, device=/dev/nbd0p2
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0x36145f6d [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			e4c30bb5-61cf-40aa-ba50-d296fe45d72a
label			system
generation		572957
root			316702720
sys_array_size		129
chunk_root_generation	524318
root_level		0
chunk_root		12142526464
chunk_root_level	0
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		20401074176
bytes_used		6371258368
sectorsize		4096
nodesize		16384
leafsize (deprecated)		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
cache_generation	572957
uuid_tree_generation	33
dev_item.uuid		0e258f8d-5472-408c-8d8e-193bbee53d9a
dev_item.fsid		e4c30bb5-61cf-40aa-ba50-d296fe45d72a [match]
dev_item.type		0
dev_item.total_bytes	20401074176
dev_item.bytes_used	11081351168
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0


> > Two further possible issues / interesting things happened during
> > the
> > works:
> > 1) btrfs-rescue-boot-usb-err.log
> >    That was during the rescue operations from the OLD notebook and
> > 4.15
> >    kernel/progs already(!).
> >    dm-0 is the SSD with the broken btrfs
> >    dm-1 is the external HDD to which I wrote the images/btrfs-
> > restore
> >    data earlier
> >    The csum errors on dm-1 are, as said, possibly from bad memory
> > on
> >    the new notebook, which I used to write the image/restore-data
> >    in the first stage... and this was IIRC simply the time when I
> > had
> >    noticed that already and ran a scrub.
> >    But what about that:
> >    Feb 23 15:48:11 gss-rescue kernel: BTRFS warning (device dm-1):
> > Skipping commit of aborted transaction.
> >    Feb 23 15:48:11 gss-rescue kernel: ------------[ cut here ]-----
> > -------
> >    Feb 23 15:48:11 gss-rescue kernel: BTRFS: Transaction aborted
> > (error -28)
> >    ...
> >    ?
> 
> No space left?
> Pretty strange.

If dm-1 should be the one with no space left,... then probably not, as
it's another 8TB device that should have many TBs left.


> Would you please try to restore the fs on another system with good
> memory?

Which one? The originally broken fs from the SSD?
And what should I try to find out here?


> This -28 (ENOSPC) seems to show that the extent tree of the new btrfs
> is
> corrupted.

"new" here is dm-1, right? Which is the fresh btrfs I've created on
some 8TB HDD for my recovery works.
While that FS shows me:
[26017.690417] BTRFS info (device dm-2): disk space caching is enabled
[26017.690421] BTRFS info (device dm-2): has skinny extents
[26017.798959] BTRFS info (device dm-2): bdev /dev/mapper/data-a4 errs:
wr 0, rd 0, flush 0, corrupt 130, gen 0
on mounting (I think the 130 corruptions are simply from the time when
I still used it for btrfs-restore with the NEW notebook with possibly
bad RAM)... I continued to use it in the meantime (for more recovery
works) and wrote actually many TB to it... so far, there seem to be no
further corruption on it.
If there was some extent tree corruption... than nothing I would notice
now.

An fsck of it seems fine:
# btrfs check /dev/mapper/restore 
Checking filesystem on /dev/mapper/restore
UUID: 62eb62e0-775b-4523-b218-1410b90c03c9
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 2502273781760 bytes used, no error found
total csum bytes: 2438116164
total tree bytes: 5030854656
total fs tree bytes: 2168242176
total extent tree bytes: 286375936
btree space waste bytes: 453818165
file data blocks allocated: 2877953581056
 referenced 2877907415040


> > 2) btrfs-check.weird
> >    This is on the freshly created FS on the SSD, after populating
> > it
> >    with loads of data from the backup.
> >    fscks from 4.15 USB stick with normal and lowmem modes...
> >    The show no error, but when you compare the byte numbers,...
> > some
> > of 
> >    them differ!!! What the f***?
> >    I.e. all but:
> >    found 213620989952 bytes used, no error found
> >    total csum bytes: 207507896
> >    total extent tree bytes: 41713664
> >    differ.
> >    Same fs, no mounts/etc. in between, fscks directly ran after
> > each
> >    other.
> >    How can this be?
> 
> Lowmem mode and original mode do different ways to iterate all
> extents.
> For now please ignore it, but I'll dig into this to try to keep them
> same.

Okay... just tell me if you need me to try something new out in that
area.


> The point here is, we need to pay extra attention about any fsck
> report
> about free space cache corruption.
> Since free space cache corruption (only happens for v1) is not a big
> problem, fsck will only report but doesn't account it as error.
Why is it not a big problem?



> I would recommend to use either v2 space cache or *NEVER* use v1
> space
> cache.
> It won't cause any functional chance, just a little slower.
> But it rules out the only weak point against power loss.
This comes as a surprise... wasn't it always said that v2 space cache
is still unstable?

And shouldn't that then become either default (using v2)... or a
default of not using v1 at least?



> > I do remember that in the past I've seen few times errors with
> > respect
> > to the free space cache during the system ran... e.g.
> > kern.log.4.xz:Jan 24 05:49:32 heisenberg kernel: [  120.203741]
> > BTRFS warning (device dm-0): block group 22569549824 has wrong
> > amount of free space
> > kern.log.4.xz:Jan 24 05:49:32 heisenberg kernel: [  120.204484]
> > BTRFS warning (device dm-0): failed to load free space cache for
> > block group 22569549824, rebuilding it now
> > but AFAIU these are considered to be "harmless"?
> 
> Yep, when kernel outputs such error, it's harmless.

Well I have seen such also in case there was no power loss/crash/etc.
(see the mails I wrote you off list in the last days).


> But if kernel doesn't output such error after powerloss, it could be
> a
> problem.
> If kernel just follows the corrupted space cache, it would break
> meta/data CoW, and btrfs is no longer bulletproof.
Okay... sounds scary... as I probably had "many" cases of crashes,
where I at least didn't notice these messages (OTOH, I didn't really
look for them).


> And to make things even more scary, nobody knows if such thing
> happens.
> If no error message after power loss, it could be that block group is
> untouched in previous transaction, or it could be damaged.
Wouldn't it be reasonable, that when a fs is mounted that was not
properly unmounted (I assume there is some flag that shows this?),...
any such possible corrupted caches/trees/etc. are simply invalidated as
a safety measure?


> So I'm working to try to reproduce a case where v1 space cache is
> corrupted and could lead to kernel to use them.
Well even if you manage to do and rule out a few cases of such
corruptions by fixing bugs, it still sounds all pretty fragile.


Had you seen that from my mail "Re: BUG: unable to handle kernel paging
request at ffff9fb75f827100" from "Wed, 21 Feb 2018 17:42:01 +0100":
checking extents
checking free space cache
Couldn't find free space inode 1
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/mapper/system
UUID: b6050e38-716a-40c3-a8df-fcf1dd7e655d
found 676124835840 bytes used, no error found
total csum bytes: 657522064
total tree bytes: 2546106368
total fs tree bytes: 1496350720
total extent tree bytes: 182255616
btree space waste bytes: 594036536
file data blocks allocated: 5032601706496
 referenced 670040977408

That was a fsck of the corrupted fs on the SSD (from the USB stick with
I think with 4.12 kernel/progs)
Especially that it was inode 1 seems like a win in the lottery...
"Couldn't find free space inode 1" 
so couldn't that also point to something?


[obsolete because of below] The v1 space caches aren't
checksumed/CoWed, right? Wouldn't that make sense to rule out using any
broken cache?


> On the other hand, btrfs check does pretty good check on v1 space
> cache,
> so after power loss, I would recommend to do a btrfs check before
> mounting the fs.
And I assume using --clear-space-cache v1 to simply reset the cache...?


> And v2 space cache follows metadata CoW so we don't even need to
> bother
> any corruption, it's just impossible (unless code bug)
Ah... okay ^^ Then why isn't it default, or at least v1 space cache
disabled per default for anyone?
Even if my case of corruptions here on the SSD may/would have been
caused by bad memory and nothing to do with space cache,... this sounds
still like an area where many bad things could happen.
