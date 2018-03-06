Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58079 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752017AbeCFBu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 20:50:28 -0500
Subject: Re: spurious full btrfs corruption
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
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
 <1520297878.4428.39.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
Date: Tue, 6 Mar 2018 09:50:20 +0800
MIME-Version: 1.0
In-Reply-To: <1520297878.4428.39.camel@scientia.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7fA2qG6VWDa72p4rlepQ5HAxJ2pSm9yie"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7fA2qG6VWDa72p4rlepQ5HAxJ2pSm9yie
Content-Type: multipart/mixed; boundary="NqXXp1A7dSOtKOkGCKEolitVyNkVyk7oL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
Subject: Re: spurious full btrfs corruption
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
 <1520297878.4428.39.camel@scientia.net>
In-Reply-To: <1520297878.4428.39.camel@scientia.net>

--NqXXp1A7dSOtKOkGCKEolitVyNkVyk7oL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8806=E6=97=A5 08:57, Christoph Anton Mitterer wr=
ote:
> Hey Qu.
>=20
> On Thu, 2018-03-01 at 09:25 +0800, Qu Wenruo wrote:
>>> - For my personal data, I have one[0] Seagate 8 TB SMR HDD, which I
>>>   backup (send/receive) on two further such HDDs (all these are
>>>   btrfs), and (rsync) on one further with ext4.
>>>   These files have all their SHA512 sums attached as XATTRs, which
>>> I
>>>   regularly test. So I think I can be pretty sure, that there was
>>> never
>>>   a case of silent data corruption and the RAM on the E782 is fine.
>>
>> Good backup practice can't be even better.
>=20
> Well I still would want to add something tape and/or optical based
> solution...
> But having this depends a bit on having a good way to do incremental
> backups, i.e. I wouldn't want to write full copies of everything to
> tape/BluRay over and over again, but just the actually added data and
> records of metadata changes.
> The former (adding just added files is rather easy), but still
> recording any changes in metadata (moved/renamed/deleted files, changes=

> in file dates, permissions, XATTRS etc.).
> Also I would always want to backup complete files, so not just changes
> to a file, even if just one byte changed of a 4 GiB file... and not
> want to have files split over mediums.
>=20
> send/receive sounds like a candidate for this (except it works only on
> changes, not full files), but I would prefer to have everything in a
> standard format like tar which one can rather easily recover manually
> if there are failures in the backups.
>=20
>=20
> Another missing piece is a tool which (at my manual order) adds hash
> sums to the files, and which can verify them
> Actually I wrote such a tool already, but as shell script and it simply=

> forks so often, that it became extremely slow at millions of small
> files.
> I often found it so useful to have that kind of checksumming in
> addition to the kind of checksumming e.g. btrfs does which is not at
> the level of whole files.
> So if something goes wrong like now, I cannot only verify whether
> single extents are valid, but also the chain of them that comprises a
> file.. and that just for the point where I defined "now, as it is, the
> file is valid",.. and automatically on any writes, as it would be done
> at file system level checksumming.
> In the current case,... for many files where I had such whole-file-
> csums, verifying whether what btrfs-restore gave me was valid or not,
> was very easy because of them.
>=20
>=20
>> Normally I won't blame memory unless strange behavior happens, from
>> unexpected freeze to strange kernel panic.
> Me neither... I think bad RAM happens rather rarely these days.... but
> my case may actually be one.
>=20
>=20
>> Netconsole would help here, especially when U757 has an RJ45.
>> As long as you have another system which is able to run nc, it should
>> catch any kernel message, and help us to analyse if it's really a
>> memory
>> corruption.
> Ah thanks... I wasn't even aware of that ^^
> I'll have a look at it when I start inspecting the U757 again in the
> next weeks.
>=20
>=20
>>> - The notebooks SSD is a Samsung SSD 850 PRO 1TB, the same which I
>>>   already used with the old notebook.
>>>   A long SMART check after the corruption, brought no errors.
>>
>> Also using that SSD with smaller capacity, it's less possible for the
>> SSD.
> Sorry, what do you mean? :)

I'm using the same SSD (with smaller size).
So unless some strange thing happened, I won't blame the SSD.

>=20
>=20
>> Normally I won't blame memory, but even newly created btrfs, without
>> any
>> powerloss, it still reports csum error, then it maybe the problem.
> That was also my idea...
> I may mix up things, but I think I even found a csum error later on the=

> rescue USB stick (which is also btrfs)... would need to double check
> that, though.
>=20
>>> - So far, in the data I checked (which as I've said, excludes a
>>> lot,..
>>>   especially the QEMU images)
>>>   I found only few cases, where the data I got from btrfs restore
>>> was
>>>   really bad.
>>>   Namely, two MP3 files. Which were equal to their backup
>>> counterparts,
>>>   but just up to some offset... and the rest of the files were just
>>>   missing.
>>
>> Offset? Is that offset aligned to 4K?
>> Or some strange offset?
>=20
> These were the two files:
> -rw-r--r-- 1 calestyo calestyo   90112 Feb 22 16:46 'Lady In The Water/=
05.mp3'
> -rw-r--r-- 1 calestyo calestyo 4892407 Feb 27 23:28 '/home/calestyo/sha=
re/music/Lady In The Water/05.mp3'
>=20
>=20
> -rw-r--r-- 1 calestyo calestyo 1904640 Feb 22 16:47 'The Hunt For Red O=
ctober [Intrada]/21.mp3'
> -rw-r--r-- 1 calestyo calestyo 2968128 Feb 27 23:28 '/home/calestyo/sha=
re/music/The Hunt For Red October [Intrada]/21.mp3'
>=20
> with the former (smaller one) being the corrupted one (i.e. the one
> returned by btrfs-restore).
>=20
> Both are (in terms of filesize) multiples of 4096... what does that
> mean now?

That means either we lost some file extents or inode items.

Btrfs-restore only found EXTENT_DATA, which contains the pointer to the
real data, and inode number.
But no INODE_ITEM is found, which records the real inode size, so it can
only use EXTENT_DATA to rebuild as much data as possible.
That why all recovered one is aligned to 4K.

So some metadata is also corrupted.

>=20
>=20
>>> - Especially recovering the VM images will take up some longer
>>> time...
>>>   (I think I cannot really trust what came out from the btrfs restore=

>>>   here, since these already brought csum errs before)
>=20
> In the meantime I had a look of the remaining files that I got from the=

> btrfs-restore (haven't run it again so far, from the OLD notebook, so
> only the results from the NEW notebook here:):
>=20
> The remaining ones were multi-GB qcow2 images for some qemu VMs.
> I think I had non of these files open (i.e. VMs running) while in the
> final corruption phase... but at least I'm sure that not *all* of them
> were running.
>=20
> However, all the qcow2 files from the restore are more or less garbage.=

> During the btrfs-restore it already complained on them, that it would
> loop too often on them and whether I want to continue or not (I choose
> n and on another full run I choose y).
>=20
> Some still contain a partition table, some partitions even filesystems
> (btrfs again)... but I cannot mount them.

I think the same problem happens on them too.

Some data is lost while some are good.
Anyway, they would be garbage.

>=20
> The following is some output of several commands... but these
> filesystems are not that important for me... it would be nice if one
> could recover parts of it,... but nothing you'd need to waste time for.=

> But perhaps it helps to improve btrfs-restore(?),... so here we go:
>=20
>=20
>=20
> root@heisenberg:/mnt/restore/x# l
> total 368M
> drwxr-xr-x 1 root root 212 Mar  6 01:52 .
> drwxr-xr-x 1 root root  76 Mar  6 01:52 ..
> -rw------- 1 root root 41G Feb 15 17:48 SilverFast.qcow2
> -rw------- 1 root root 27G Feb 15 16:18 Windows.qcow2
> -rw------- 1 root root 11G Feb 21 02:05 klenze.scientia.net_Debian-amd6=
4-unstable.qcow2
> -rw------- 1 root root 13G Feb 17 22:27 mldonkey.qcow2
> -rw------- 1 root root 11G Nov 16 01:40 subsurface.qcow2
> root@heisenberg:/mnt/restore/x# qemu-nbd -f qcow2 --connect=3D/dev/nbd0=
 klenze.scientia.net_Debian-amd64-unstable.qcow2=20
> root@heisenberg:/mnt/restore/x# blkid /dev/nbd0*
> /dev/nbd0: PTUUID=3D"a4944b03-ae24-49ce-81ef-9ef2cf4a0111" PTTYPE=3D"gp=
t"
> /dev/nbd0p1: PARTLABEL=3D"BIOS boot partition" PARTUUID=3D"c493388e-6f0=
4-4499-838e-1b80669f6d63"
> /dev/nbd0p2: LABEL=3D"system" UUID=3D"e4c30bb5-61cf-40aa-ba50-d296fe45d=
72a" UUID_SUB=3D"0e258f8d-5472-408c-8d8e-193bbee53d9a" TYPE=3D"btrfs" PAR=
TLABEL=3D"Linux filesystem" PARTUUID=3D"cd6a8d28-2259-4b0c-869f-267e7f6fa=
5fa"
> root@heisenberg:/mnt/restore/x# mount -r /dev/nbd0p2 /opt/
> mount: /opt: wrong fs type, bad option, bad superblock on /dev/nbd0p2, =
missing codepage or helper program, or other error.
> root@heisenberg:/mnt/restore/x#=20
>=20
> kernel says:
> Mar 06 01:53:14 heisenberg kernel: Alternate GPT is invalid, using prim=
ary GPT.
> Mar 06 01:53:14 heisenberg kernel:  nbd0: p1 p2
> Mar 06 01:53:44 heisenberg kernel: BTRFS info (device nbd0p2): disk spa=
ce caching is enabled
> Mar 06 01:53:44 heisenberg kernel: BTRFS info (device nbd0p2): has skin=
ny extents
> Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): bad tre=
e block start 0 12142526464
> Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): bad tre=
e block start 0 12142526464
> Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): failed =
to read chunk root
> Mar 06 01:53:44 heisenberg kernel: BTRFS error (device nbd0p2): open_ct=
ree failed
>=20
>=20
>=20
> root@heisenberg:/mnt/restore/x# btrfs check /dev/nbd0p2
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=3D12142526464, have=3D0
> ERROR: cannot read chunk root
> ERROR: cannot open file system
>=20
> (kernel says nothing)
>=20
>=20
> root@heisenberg:/mnt/restore/x# btrfs-find-root /dev/nbd0p2
> WARNING: cannot read chunk root, continue anyway
> Superblock thinks the generation is 572957
> Superblock thinks the level is 0
>=20
> (again, nothing from the kernel log)
>=20
>=20
>=20
> root@heisenberg:/mnt/restore/x# btrfs inspect-internal dump-tree /dev/n=
bd0p2
> btrfs-progs v4.15.1
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 12142526464 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=3D12142526464, have=3D0
> ERROR: cannot read chunk root
> ERROR: unable to open /dev/nbd0p2
>=20
>=20
>=20
> root@heisenberg:/mnt/restore/x# btrfs inspect-internal dump-super /dev/=
nbd0p2
> superblock: bytenr=3D65536, device=3D/dev/nbd0p2
> ---------------------------------------------------------
> csum_type		0 (crc32c)
> csum_size		4
> csum			0x36145f6d [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			e4c30bb5-61cf-40aa-ba50-d296fe45d72a
> label			system
> generation		572957
> root			316702720
> sys_array_size		129
> chunk_root_generation	524318
> root_level		0
> chunk_root		12142526464
> chunk_root_level	0
> log_root		0
> log_root_transid	0
> log_root_level		0
> total_bytes		20401074176
> bytes_used		6371258368
> sectorsize		4096
> nodesize		16384
> leafsize (deprecated)		16384
> stripesize		4096
> root_dir		6
> num_devices		1
> compat_flags		0x0
> compat_ro_flags		0x0
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA )
> cache_generation	572957
> uuid_tree_generation	33
> dev_item.uuid		0e258f8d-5472-408c-8d8e-193bbee53d9a
> dev_item.fsid		e4c30bb5-61cf-40aa-ba50-d296fe45d72a [match]
> dev_item.type		0
> dev_item.total_bytes	20401074176
> dev_item.bytes_used	11081351168
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		1
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
>=20
>=20
>>> Two further possible issues / interesting things happened during
>>> the
>>> works:
>>> 1) btrfs-rescue-boot-usb-err.log
>>>    That was during the rescue operations from the OLD notebook and
>>> 4.15
>>>    kernel/progs already(!).
>>>    dm-0 is the SSD with the broken btrfs
>>>    dm-1 is the external HDD to which I wrote the images/btrfs-
>>> restore
>>>    data earlier
>>>    The csum errors on dm-1 are, as said, possibly from bad memory
>>> on
>>>    the new notebook, which I used to write the image/restore-data
>>>    in the first stage... and this was IIRC simply the time when I
>>> had
>>>    noticed that already and ran a scrub.
>>>    But what about that:
>>>    Feb 23 15:48:11 gss-rescue kernel: BTRFS warning (device dm-1):
>>> Skipping commit of aborted transaction.
>>>    Feb 23 15:48:11 gss-rescue kernel: ------------[ cut here ]-----
>>> -------
>>>    Feb 23 15:48:11 gss-rescue kernel: BTRFS: Transaction aborted
>>> (error -28)
>>>    ...
>>>    ?
>>
>> No space left?
>> Pretty strange.
>=20
> If dm-1 should be the one with no space left,... then probably not, as
> it's another 8TB device that should have many TBs left.
>=20
>=20
>> Would you please try to restore the fs on another system with good
>> memory?
>=20
> Which one? The originally broken fs from the SSD?

Yep.

> And what should I try to find out here?

During restore, if the csum error happens again on the newly created
destination btrfs.
(And I recommend use mount option nospace_cache,notreelog on the
destination fs)

>=20
>=20
>> This -28 (ENOSPC) seems to show that the extent tree of the new btrfs
>> is
>> corrupted.
>=20
> "new" here is dm-1, right? Which is the fresh btrfs I've created on
> some 8TB HDD for my recovery works.
> While that FS shows me:
> [26017.690417] BTRFS info (device dm-2): disk space caching is enabled
> [26017.690421] BTRFS info (device dm-2): has skinny extents
> [26017.798959] BTRFS info (device dm-2): bdev /dev/mapper/data-a4 errs:=

> wr 0, rd 0, flush 0, corrupt 130, gen 0
> on mounting (I think the 130 corruptions are simply from the time when
> I still used it for btrfs-restore with the NEW notebook with possibly
> bad RAM)... I continued to use it in the meantime (for more recovery
> works) and wrote actually many TB to it... so far, there seem to be no
> further corruption on it.
> If there was some extent tree corruption... than nothing I would notice=

> now.
>=20
> An fsck of it seems fine:
> # btrfs check /dev/mapper/restore=20
> Checking filesystem on /dev/mapper/restore
> UUID: 62eb62e0-775b-4523-b218-1410b90c03c9
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 2502273781760 bytes used, no error found
> total csum bytes: 2438116164
> total tree bytes: 5030854656
> total fs tree bytes: 2168242176
> total extent tree bytes: 286375936
> btree space waste bytes: 453818165
> file data blocks allocated: 2877953581056
>  referenced 2877907415040

At least metadata is in good shape.

If scrub reports no error, it would be perfect.

>=20
>>> 2) btrfs-check.weird
>>>    This is on the freshly created FS on the SSD, after populating
>>> it
>>>    with loads of data from the backup.
>>>    fscks from 4.15 USB stick with normal and lowmem modes...
>>>    The show no error, but when you compare the byte numbers,...
>>> some
>>> of=20
>>>    them differ!!! What the f***?
>>>    I.e. all but:
>>>    found 213620989952 bytes used, no error found
>>>    total csum bytes: 207507896
>>>    total extent tree bytes: 41713664
>>>    differ.
>>>    Same fs, no mounts/etc. in between, fscks directly ran after
>>> each
>>>    other.
>>>    How can this be?
>>
>> Lowmem mode and original mode do different ways to iterate all
>> extents.
>> For now please ignore it, but I'll dig into this to try to keep them
>> same.
>=20
> Okay... just tell me if you need me to try something new out in that
> area.
>=20
>=20
>> The point here is, we need to pay extra attention about any fsck
>> report
>> about free space cache corruption.
>> Since free space cache corruption (only happens for v1) is not a big
>> problem, fsck will only report but doesn't account it as error.
> Why is it not a big problem?

Because we have "nospace_cache" mount option as our best friend.

>=20
>=20
>=20
>> I would recommend to use either v2 space cache or *NEVER* use v1
>> space
>> cache.
>> It won't cause any functional chance, just a little slower.
>> But it rules out the only weak point against power loss.
> This comes as a surprise... wasn't it always said that v2 space cache
> is still unstable?

But v1 also has its problem.
In fact I have already found a situation btrfs could corrupt its v1
space cache, just using fsstress -n 200.

Although kernel and btrfs-progs can both detect the corruption, that's
already the last defending line. The corrupted cache passes both
generation and checksum check, the only check which catches it is free
space size, but that can be bypassed if we craft the operation carefully
enough.

>=20
> And shouldn't that then become either default (using v2)... or a
> default of not using v1 at least?

Because we still don't have a strong enough evidence or test case to
prove it.
But I think it would change soon.

Anyway, it's just an optimization, and most of us can live without it.

>=20
>=20
>=20
>>> I do remember that in the past I've seen few times errors with
>>> respect
>>> to the free space cache during the system ran... e.g.
>>> kern.log.4.xz:Jan 24 05:49:32 heisenberg kernel: [  120.203741]
>>> BTRFS warning (device dm-0): block group 22569549824 has wrong
>>> amount of free space
>>> kern.log.4.xz:Jan 24 05:49:32 heisenberg kernel: [  120.204484]
>>> BTRFS warning (device dm-0): failed to load free space cache for
>>> block group 22569549824, rebuilding it now
>>> but AFAIU these are considered to be "harmless"?
>>
>> Yep, when kernel outputs such error, it's harmless.
>=20
> Well I have seen such also in case there was no power loss/crash/etc.
> (see the mails I wrote you off list in the last days).
>=20
>=20
>> But if kernel doesn't output such error after powerloss, it could be
>> a
>> problem.
>> If kernel just follows the corrupted space cache, it would break
>> meta/data CoW, and btrfs is no longer bulletproof.
> Okay... sounds scary... as I probably had "many" cases of crashes,
> where I at least didn't notice these messages (OTOH, I didn't really
> look for them).
>=20
>=20
>> And to make things even more scary, nobody knows if such thing
>> happens.
>> If no error message after power loss, it could be that block group is
>> untouched in previous transaction, or it could be damaged.
> Wouldn't it be reasonable, that when a fs is mounted that was not
> properly unmounted (I assume there is some flag that shows this?),...
> any such possible corrupted caches/trees/etc. are simply invalidated as=

> a safety measure?

Unfortunately, btrfs doesn't have such flag to indicate dirty umount.
We could use log_root to find it, but that's not always the case, and
one can even use notreelog to disable log tree completely.

>=20
>=20
>> So I'm working to try to reproduce a case where v1 space cache is
>> corrupted and could lead to kernel to use them.
> Well even if you manage to do and rule out a few cases of such
> corruptions by fixing bugs, it still sounds all pretty fragile.
>=20
>=20
> Had you seen that from my mail "Re: BUG: unable to handle kernel paging=

> request at ffff9fb75f827100" from "Wed, 21 Feb 2018 17:42:01 +0100":
> checking extents
> checking free space cache
> Couldn't find free space inode 1
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/mapper/system
> UUID: b6050e38-716a-40c3-a8df-fcf1dd7e655d
> found 676124835840 bytes used, no error found
> total csum bytes: 657522064
> total tree bytes: 2546106368
> total fs tree bytes: 1496350720
> total extent tree bytes: 182255616
> btree space waste bytes: 594036536
> file data blocks allocated: 5032601706496
>  referenced 670040977408
>=20
> That was a fsck of the corrupted fs on the SSD (from the USB stick with=

> I think with 4.12 kernel/progs)
> Especially that it was inode 1 seems like a win in the lottery...
> "Couldn't find free space inode 1"=20
> so couldn't that also point to something?

Hard to say. It could be a new block group chunk with no cache.
It's possible, so I won't worry about that too much.

>=20
>=20
> [obsolete because of below] The v1 space caches aren't
> checksumed/CoWed, right? Wouldn't that make sense to rule out using any=

> broken cache?

V1 cache is not CoWed nor checksumed by the normal routine.

But it has its own checksum, a little like the XATTR method.
It stores its own checksum in its first page.
And each page will have its own checksum in the 1st page. (including the
1st page itself)

And it also has its own generation.
So normally it should be enough to detect such corruption.

However there are still cases where V1 cache get CoWed, still digging
the reason, but under certain chunk layout, it could leads to corruption.=


>=20
>=20
>> On the other hand, btrfs check does pretty good check on v1 space
>> cache,
>> so after power loss, I would recommend to do a btrfs check before
>> mounting the fs.
> And I assume using --clear-space-cache v1 to simply reset the cache...?=


That's also valid.

>=20
>=20
>> And v2 space cache follows metadata CoW so we don't even need to
>> bother
>> any corruption, it's just impossible (unless code bug)
> Ah... okay ^^ Then why isn't it default, or at least v1 space cache
> disabled per default for anyone?

Because V1 works well so far, and the corruption I'm chasing is really
hard to reproduce, and v1 is just the most possible reason right now.

I'm not saying v2 is perfect, as when digging v1 code, I'm also
wondering how v2 handles case where v2 cache lives in a metadata chunk
which also has its own cache.

So I recommend to disable space cache at all for now.

Thanks,
Qu

> Even if my case of corruptions here on the SSD may/would have been
> caused by bad memory and nothing to do with space cache,... this sounds=

> still like an area where many bad things could happen> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--NqXXp1A7dSOtKOkGCKEolitVyNkVyk7oL--

--7fA2qG6VWDa72p4rlepQ5HAxJ2pSm9yie
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqd890XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj6ZAf/fW3V/3IEmIgSzqDxQKDf4gzE
8KRAXXK0eYSjtmRBu4LUY7eptofw1Rq2yKHZj8+9FQ3mgs3e+jW5YLhI72L7p7gU
48R44xsLVS+h0xwvedJ5Khmz/CPs8L/FVZRK70cCU3Ef5HmDljWHFv2nizRM/eqF
FYzvqsioG+nuiwd/rwV2SACI77iSx1dPWXybL7Izuo0B+RU58ltv2XHaVdzcWRJC
+mdK2Wz+3fXrEdCNmAq0q3eWBcWc4R1z766fAhyoV7O8R1bjPKhdLwJ50KF+aVWA
y7Y7BEk0MjD8qLAKzVVhip0vvhlZUiniO7F1p+PbAI9LFJvHWG97eAKzL0SBSA==
=jf+d
-----END PGP SIGNATURE-----

--7fA2qG6VWDa72p4rlepQ5HAxJ2pSm9yie--
