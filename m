Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:37591 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935615AbeCABZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 20:25:33 -0500
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
Date: Thu, 1 Mar 2018 09:25:23 +0800
MIME-Version: 1.0
In-Reply-To: <1519833022.3714.122.camel@scientia.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="htwJvheAwqY1EnQhjOVrB7MRq5xNnkRIj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--htwJvheAwqY1EnQhjOVrB7MRq5xNnkRIj
Content-Type: multipart/mixed; boundary="blzSgWItBoCTor9Lh99LJk7kbvxiMLWkb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
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
In-Reply-To: <1519833022.3714.122.camel@scientia.net>

--blzSgWItBoCTor9Lh99LJk7kbvxiMLWkb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8828=E6=97=A5 23:50, Christoph Anton Mitterer wr=
ote:
> Hey Qu
>=20
> Thanks for still looking into this.
> I'm still in the recovery process (and there are other troubles at the
> university where I work, so everything will take me some time), but I
> have made a dd image of the broken fs, before I put a backup on the
> SSD, so that still exist in the case we need to do further debugging.
>=20
> To thoroughly describe what has happened, let me go a bit back.
>=20
> - Until last ~ September, I was using some Fujitsu E782, for at least
>   4 years, with no signs of data corruptions.

That's pretty good.

> - For my personal data, I have one[0] Seagate 8 TB SMR HDD, which I
>   backup (send/receive) on two further such HDDs (all these are
>   btrfs), and (rsync) on one further with ext4.
>   These files have all their SHA512 sums attached as XATTRs, which I
>   regularly test. So I think I can be pretty sure, that there was never=

>   a case of silent data corruption and the RAM on the E782 is fine.

Good backup practice can't be even better.

> - In October I got a new notebook from the university... brand new
>   Fujitsu U757 in basically the best possible configuration.
>   I ran memtest86+ in it's normal (non-SMP) mode for roughly a day,
>   with no errors.
>   In SMP mode (which is considered experimental, I think) it crashes
>   reproducible on the same position. Many people seem to have this
>   (with exactly the same test, address range where it freezes) so I
>   considered it a bug in memtest86+ SMP mode, which it likely is.
>   A patch[1], didn't help me.

Normally I won't blame memory unless strange behavior happens, from
unexpected freeze to strange kernel panic.

But when this happens, a lot of things can go wrong.

> - Unfortunately from the beginning on that notebook showed many further=

>   issues.
>   - CPU overheating[2]
>   - boot freezes, when the initramfs tool of Debian isn't configured
> to=20
>     blindly add all modules to the initramfs[3].
>   - spurious freezes, which I couldn't really debug any further since
>     there is no serial port...

Netconsole would help here, especially when U757 has an RJ45.
As long as you have another system which is able to run nc, it should
catch any kernel message, and help us to analyse if it's really a memory
corruption.

> in that cases neither Magic-SysRq nor
>     even NumLock LEDs and so worked anymore.
>     These freezes caused me some troubles with dpkg[4].
>     The issue I describe there, could also shed some light on the whole=

>     situation, since it resulted out of the freezes.
> - The dealer replaced the thermal paste on the CPU and when the CPU
>   overheating and the freezes didn't go away, they sent the notebook
>   for one week to Fujitsu in Germany, who allegedly thoroughly tested
>   it with Windows, and found no errors.

That's unfortunately very common for consumer electronics, as few people
and cooperation really care about Linux user on consumer laptops.

And since there are problems with the system (either hardware or
software), I already see a much higher possibility to hard reset.

>=20
> - The notebooks SSD is a Samsung SSD 850 PRO 1TB, the same which I
>   already used with the old notebook.
>   A long SMART check after the corruption, brought no errors.

Also using that SSD with smaller capacity, it's less possible for the SSD=
=2E

>=20
>=20
> - Just before the corruption on the btrfs happened, I decided it's
> time=20
>   for a backup of the notebooks SSD (what an irony, I know), so I made
>   a snapshot of my one and only subvol, removed and non-precious data
>   from that snapshot, made anotjer ro-snapshot of that and removed the
>   rw snapshot.
> - The kernel was some 4.14.
>=20
> - More or less after that, I saw the "BUG: unable to handle kernel
>   paging request at ffff9fb75f827100" which I reported here.
>   I'm not sure whether this had to do with btrfs at all, and even if
>   whether it was the fs on the SSD, or another one on an external HDD

It could be Btrfs, and it would block btrfs module to continue, which is
almost a hard reset.

>   I've had mounted at that time.
>   sync/umount/remount,rw/shutdown all didn't work, and I had to power
>   off the node.
> - After that things went on basically as I described in my previous
>   mails to the list already.
>   - There were some csum erros.>   - Checking these files with debsums =
(Debian stores MD5s of the
>     package's files) found no errors.
>   - A scrub brought no errors.
>   - Shortly after the scrub, further csum errors as well as:
>     BTRFS critical (device dm-0): unable to find logical 45036587292098=
56 length 4096
>   - Then I booted from a rescue USB stick with kernel/btrfs-progs 4.12.=

>   - fsck in normal/lowmem mode were okay except:
>     Couldn't find free space inode 1
>   - I cleared the v1 free space cache
>   - a scrub failed with "ret=3D-1, errno=3D5 (Input/output error)"
>   - Things like these in the kernel log:
>     Feb 21 17:43:09 heisenberg kernel: BTRFS warning (device dm-0): che=
cksum error at logical 16401395712 on dev /dev/mapper/system, sector 3203=
3976, root 257, inode 42609350, offset 6754201600, length 4096, links 1 (=
path: var/lib/libvirt/images/subsurface.qcow2)
>     Feb 21 17:43:09 heisenberg kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/system errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>     Feb 21 17:46:57 heisenberg kernel: BTRFS critical (device dm-0): un=
able to find logical 4503658729209856 length 16384
>   - ... (see the mails in the list archive, respectively what I sent
>     you off list... since I could only make screenshots from then)
>=20
> - Off list you told me what to try (btrfs check with different roots,
>   and how to use btrfs restore, and how to find the right block for
>   that).
>   I didn't try --repair or so.
> - All the rescue works I made from that USB stick with
>   kernel/btrfs-progs 4.12.
>   Using the very block and FS_TREE ROOT_ITEM (or whatever it is called
>   ^^) that I wrote in our off list mails.
> - Since I didn't think of a possible memory defect on the new notebook
>   yet, I stil used the new one for these works.
> - To an external disk I did
>   - btrfs restore with options -x -S -i (plus the -f <num>, answering
>     all questions whether to go on because it's looping too long over a=

>     file with no)
>   - the same to another dir, with option -m in addition and answering
>     these questions with yes.
> - Then I made a dd image of the broken fs,... and after that I diff'ed
>   the image with the original.
>   There I got another btrfs csum error, i.e. on the (freshly created)
>   btrfs on some external HDD, to which I dumped all the files during my=

>   rescue efforts). So the file with the csum error was the image I just=

>   created with dd.
> - Just for trying a made another dd/diff round (on the new notebook),
>   and this time it worked.
> - Still, alerted, I put the SSD into my OLD notebook, and continued
>   with everything that follows from there, I also upgraded
>   kernel/btrfs-progs to 4.15.
>=20
> - I tried to repeat the two btrfs-restores... but interestingly, with
>   4.15, that didn't work and I got these block mapping errors.
>   This is IMO really strange...
>   I could later try to do it again with the OLD notebook but with 4.12.=

>=20
> - THen, I diffed what came out by the two different btrfs-restore
>   Except for the files where I answered the question n, they were
>   equal, that is at least in terms of actual data (didn't check
>   metadata)
>   (here however, I used the data from the restores that I made still on=

>   the NEW notebook with 4.12 kernel/progs)
> - Parts of the first two restores (still made on the new notebook) gave=

>   csum errors as well (and the diff aborted with an IO error).
>   I made a scrub on the extern HDD and removed all the broken files
>   (which were anyway uninteresting).
>=20
>=20
> I'd guess that the csum errors on the fresh btrfs on the external HDD,
> are some hint, that there could be simply an issue with the memory of
> the new notebook,... that just happens so rarely (only on a few blocks
> in 1TB copied), that it didn't strike too often.
> Maybe (pure speculation) this can be a reason for the freezes as well?

Normally I won't blame memory, but even newly created btrfs, without any
powerloss, it still reports csum error, then it maybe the problem.

>=20
>=20
>=20
> - Then (OLD notebook, 4.15 kernel/progs) I created new btrfs on the
>   SSD, extracted a backup from last September (the backup happens to
> be=20
>   on these Seagate 8TB HDDs I mentioned before... they were tar.gz'ed
>   and that file had SHA512 XATTRs which still verified).
>   Afterwards upgrading everything to the current state.
> - Now (and still ongoing) merging the data from the btrfs restore into
>   the "new" system,... which includes diffing or manually inspecting
>   files which have changed or are new since the backup.
>   This is obviously impossible for the multi-GB qcow2 VM images, which
>   appeared above in some checksum error at logical 16401395712...
>=20
> - During that merging/checking... I didn't check anything off the files=

>   under package management, i.e. /usr /bin /sbin /lib*
>   I checked everything from /root /etc/ /home and I'm still in the
>   process of checking the precious parts from /var
>   And here's something interesting again for you developers:
>=20
> - So far, in the data I checked (which as I've said, excludes a lot,..
>   especially the QEMU images)
>   I found only few cases, where the data I got from btrfs restore was
>   really bad.
>   Namely, two MP3 files. Which were equal to their backup counterparts,=

>   but just up to some offset... and the rest of the files were just
>   missing.

Offset? Is that offset aligned to 4K?
Or some strange offset?

>=20
> - I cannot tell whether files from after the backup was made, may be
>   completely missing from the btrfs-restore... and I just don't
>   remember them...
>=20
> - Especially recovering the VM images will take up some longer time...
>   (I think I cannot really trust what came out from the btrfs restore
>   here, since these already brought csum errs before)
>=20
>=20
> Two further possible issues / interesting things happened during the
> works:
> 1) btrfs-rescue-boot-usb-err.log
>    That was during the rescue operations from the OLD notebook and 4.15=

>    kernel/progs already(!).
>    dm-0 is the SSD with the broken btrfs
>    dm-1 is the external HDD to which I wrote the images/btrfs-restore
>    data earlier
>    The csum errors on dm-1 are, as said, possibly from bad memory on
>    the new notebook, which I used to write the image/restore-data
>    in the first stage... and this was IIRC simply the time when I had
>    noticed that already and ran a scrub.
>    But what about that:
>    Feb 23 15:48:11 gss-rescue kernel: BTRFS warning (device dm-1): Skip=
ping commit of aborted transaction.
>    Feb 23 15:48:11 gss-rescue kernel: ------------[ cut here ]---------=
---
>    Feb 23 15:48:11 gss-rescue kernel: BTRFS: Transaction aborted (error=
 -28)
>    ...
>    ?

No space left?
Pretty strange.

Would you please try to restore the fs on another system with good memory=
?

This -28 (ENOSPC) seems to show that the extent tree of the new btrfs is
corrupted.

> 2) btrfs-check.weird
>    This is on the freshly created FS on the SSD, after populating it
>    with loads of data from the backup.
>    fscks from 4.15 USB stick with normal and lowmem modes...
>    The show no error, but when you compare the byte numbers,... some
> of=20
>    them differ!!! What the f***?
>    I.e. all but:
>    found 213620989952 bytes used, no error found
>    total csum bytes: 207507896
>    total extent tree bytes: 41713664
>    differ.
>    Same fs, no mounts/etc. in between, fscks directly ran after each
>    other.
>    How can this be?

Lowmem mode and original mode do different ways to iterate all extents.
For now please ignore it, but I'll dig into this to try to keep them same=
=2E

>=20
>=20
>=20
> Now on to your questions:
>=20
>=20
> On Wed, 2018-02-28 at 16:36 +0800, Qu Wenruo wrote:
>> So my current assumption is, there are at least 2 power loss happens
>> during the problem.
>>
>> The 1st power loss caused free space cache corrupted but not detected
>> by
>> its checksum, and btrfs used the corrupted free space cache to
>> allocate
>> tree blocks.
>>
>> And then 2nd power loss happened. Since new allocated tree blocks can
>> overwrite existing tree blocks, it breaks metadata CoW of btrfs, and
>> leads the final corruption.
>>
>> Would you please provide some detailed info about the corruption?
>=20
>=20
> As for your questions about power loss... well there was no "classic"
> blackout power loss, but just the (many) occasions of freezes much
> earlier (described in the very beginning, at the problems with the new
> notebook). These happened over the last months... I usually made a
> fsck/scrub/full-debsums check... but never found an error.

The point here is, we need to pay extra attention about any fsck report
about free space cache corruption.
Since free space cache corruption (only happens for v1) is not a big
problem, fsck will only report but doesn't account it as error.

I would recommend to use either v2 space cache or *NEVER* use v1 space
cache.
It won't cause any functional chance, just a little slower.
But it rules out the only weak point against power loss.

> So my conclusion was the btrfs must be simply rock-solid ;-) (perhaps I=

> should say non-raid56-btrfs?! :-P)...
>=20
> Apart from these,... the cases of power loss by me having to put the
> system off (as shutdown/sync/etc. didn't work)... are described
> above... and all following events as thoroughly as I remembered them.

That's detailed enough, and that could considered as power loss (for btrf=
s).

>=20
>=20
>=20
> I do remember that in the past I've seen few times errors with respect
> to the free space cache during the system ran... e.g.
> kern.log.4.xz:Jan 24 05:49:32 heisenberg kernel: [  120.203741] BTRFS w=
arning (device dm-0): block group 22569549824 has wrong amount of free sp=
ace
> kern.log.4.xz:Jan 24 05:49:32 heisenberg kernel: [  120.204484] BTRFS w=
arning (device dm-0): failed to load free space cache for block group 225=
69549824, rebuilding it now
> but AFAIU these are considered to be "harmless"?

Yep, when kernel outputs such error, it's harmless.

But if kernel doesn't output such error after powerloss, it could be a
problem.
If kernel just follows the corrupted space cache, it would break
meta/data CoW, and btrfs is no longer bulletproof.

And to make things even more scary, nobody knows if such thing happens.
If no error message after power loss, it could be that block group is
untouched in previous transaction, or it could be damaged.

So I'm working to try to reproduce a case where v1 space cache is
corrupted and could lead to kernel to use them.

On the other hand, btrfs check does pretty good check on v1 space cache,
so after power loss, I would recommend to do a btrfs check before
mounting the fs.

And v2 space cache follows metadata CoW so we don't even need to bother
any corruption, it's just impossible (unless code bug)

Thanks,
Qu

>=20
> Another case was:
> https://www.spinics.net/lists/linux-btrfs/msg61706.html
> But that was on one of the copies of the big 8TB HDDs with my private
> data... and not on the fs that broke now.
>=20
>=20
>=20
>=20
> From my PoV the following question remain:
> a) Obviously whether my new notebook is broken and how I verify this
>    ;-)
>    (and whether Qu still works for Fujitsu and has some contact for me
>    who really deal with these problems without saying "it's Linux'
>    fault" or who can make Fujitsu send me a new one :D)
>=20
>=20
> b) Whether my six 8TB-HDDs with btrfs, which I used (and wrote to) with=

>    the new notebook may have also already some silent corruptions in
>    it.. and whether I can check them for that?
>    I'd have done the following:
>    - fsck (normal & lowmem) them all
>        and clear the v1 free space cache just to be sure
>    - verify my own SHA512 sums in the XATTRs
>    - do I full scrub
>    - perhaps do a stat on each file, to make sure that all metadata is
>      really read?
>=20
>    Is there anything else I can do to verify everything is fine?
>=20
> c) From what I can tell,.. btrfs restore seemed to have recovered a
>    lot... (though as I've said for much that it recovered I haven't
>    checked whether it's really fine or just garbage in terms of data)
>    This and also the fact that when the corruption finally appeared
>    (though I have no idea whether it built up already far longer), not
>    much was written to disk, makes me guess that most data was actually=

>    still there... and just stuff in the meta-data (e.g. that generation=

>    discrepancies and that block mapping errors) caused the troubles.
>    Is there anything one could do to make btrfs more robust against
>    these things?
>    E.g. on SSD metadata defaults to single, right? Would it have helped=

>    if this was not the case?
>=20
>    As far as I understand, btrfs by design with the CoW (if it has no
>    coding errors) shouldn't be able to lead to such corruptions.. but
>    rather just to either see old or new data.
>    Of course it can't solve possible memory errors... but it should
>    perhaps be able to notice them (isn't everything checksummed?) and
>    only write if these match?
>    But maybe my thinking is too simple minded here ;-)
>=20
>=20
> btw: I just remember, that during the btrfs-restore... the tool already=

> complained that it cannot recover some few files (but those were not
> really important to me).... still it's a surprise that it worked for so=

> many files... but couldn't recover some.
>=20
>=20
>=20
> Thanks for your help, and do not hesitate to ask if you need more
> information.
> Chris.
>=20
>=20
>=20
> [0] In the meantime the data grow furthere and thus I had to split it
>     on two HDDs, each having 2 btrfs copies and one on ext4.
> [1] http://forum.canardpc.com/threads/115443-PATCH-false-errors-in-test=
-7-with-SMP
> [2] http://lkml.iu.edu/hypermail/linux/kernel/1710.3/03429.html
> [3] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D878829
> [4] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D888234
>=20


--blzSgWItBoCTor9Lh99LJk7kbvxiMLWkb--

--htwJvheAwqY1EnQhjOVrB7MRq5xNnkRIj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqXVoQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhr5QgAk87pl34laiY95z9FTb3Ks9XC
LPFkh4JmlLgIxwzMMY7p1QW28oi4Tl0Ee1dyO2NO2sNBpFmR8sUOwtwtOGEOamEB
8wzlQFd/kP0dt6xJx11FzNsqifrLg0GqcpM7SMkKs8zVRLbCEl1PQ7ZcgOl4ksp5
JbPEH1xrgwoSnWkqTjYji5g3cTrvaZR2oZ0W5f7dWi+zx2pQj4wrb3xKGOIEGH7v
r1FEw86FqfkjjHMVGJd3CJkfTEl/DMOVI0QiEVLMChKDuQpelEy7rgaZQnnRp5O0
RQFMnZYPoRHm3luITwyEQ8jPszn/AvfNKYBeuAjMDPocf/OJXa4li2+kwqbYWQ==
=zITs
-----END PGP SIGNATURE-----

--htwJvheAwqY1EnQhjOVrB7MRq5xNnkRIj--
