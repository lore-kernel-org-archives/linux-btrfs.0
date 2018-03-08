Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50325 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750824AbeCHXsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 18:48:10 -0500
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
 <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
 <1520519895.15491.21.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1111e6a3-20fd-d3b5-8eaa-672a4a859380@gmx.com>
Date: Fri, 9 Mar 2018 07:48:03 +0800
MIME-Version: 1.0
In-Reply-To: <1520519895.15491.21.camel@scientia.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0jiXVsCyRPP6w3hwONsu53upwnPi57HC9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0jiXVsCyRPP6w3hwONsu53upwnPi57HC9
Content-Type: multipart/mixed; boundary="JdKmucALxBW93MD7YdKSxNRAzJh56qWg9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <1111e6a3-20fd-d3b5-8eaa-672a4a859380@gmx.com>
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
 <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
 <1520519895.15491.21.camel@scientia.net>
In-Reply-To: <1520519895.15491.21.camel@scientia.net>

--JdKmucALxBW93MD7YdKSxNRAzJh56qWg9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 22:38, Christoph Anton Mitterer wr=
ote:
> Hey.
>=20
>=20
> On Tue, 2018-03-06 at 09:50 +0800, Qu Wenruo wrote:
>>> These were the two files:
>>> -rw-r--r-- 1 calestyo calestyo   90112 Feb 22 16:46 'Lady In The
>>> Water/05.mp3'
>>> -rw-r--r-- 1 calestyo calestyo 4892407 Feb 27 23:28
>>> '/home/calestyo/share/music/Lady In The Water/05.mp3'
>>>
>>>
>>> -rw-r--r-- 1 calestyo calestyo 1904640 Feb 22 16:47 'The Hunt For
>>> Red October [Intrada]/21.mp3'
>>> -rw-r--r-- 1 calestyo calestyo 2968128 Feb 27 23:28
>>> '/home/calestyo/share/music/The Hunt For Red October
>>> [Intrada]/21.mp3'
>>>
>>> with the former (smaller one) being the corrupted one (i.e. the one
>>> returned by btrfs-restore).
>>>
>>> Both are (in terms of filesize) multiples of 4096... what does that
>>> mean now?
>>
>> That means either we lost some file extents or inode items.
>>
>> Btrfs-restore only found EXTENT_DATA, which contains the pointer to
>> the
>> real data, and inode number.
>> But no INODE_ITEM is found, which records the real inode size, so it
>> can
>> only use EXTENT_DATA to rebuild as much data as possible.
>> That why all recovered one is aligned to 4K.
>>
>> So some metadata is also corrupted.
>=20
> But that can also happen to just some files?

Yep, one tree leaf corruption would leads to corruption to several files.=


> Anyway... still strange that it hit just those two (which weren't
> touched for long).
>=20
>=20
>>> However, all the qcow2 files from the restore are more or less
>>> garbage.
>>> During the btrfs-restore it already complained on them, that it
>>> would
>>> loop too often on them and whether I want to continue or not (I
>>> choose
>>> n and on another full run I choose y).
>>>
>>> Some still contain a partition table, some partitions even
>>> filesystems
>>> (btrfs again)... but I cannot mount them.
>>
>> I think the same problem happens on them too.
>>
>> Some data is lost while some are good.
>> Anyway, they would be garbage.
>=20
> Again, still strange... that so many files (of those that I really
> checked) were fully okay,... while those 4 were all broken.

One leaf contains some extent data is corrupted here.

>=20
> When it only uses EXTENT_DATA, would that mean that it basically breaks=

> on every border where the file is split up into multiple extents (which=

> is of course likely for the (CoWed) images that I had.

This depends on the leaf boundary.

But normally one corrupted leaf can only lead to one or two corruption.
For 4 files, we have at least 2 leaf corruption.


>=20
>=20
>=20
>>>
>>>> Would you please try to restore the fs on another system with
>>>> good
>>>> memory?
>>>
>>> Which one? The originally broken fs from the SSD?
>>
>> Yep.
>>
>>> And what should I try to find out here?
>>
>> During restore, if the csum error happens again on the newly created
>> destination btrfs.
>> (And I recommend use mount option nospace_cache,notreelog on the
>> destination fs)
>=20
> So an update on this (everything on the OLD notebook with likely good
> memory):
>=20
> I booted again from USBstick (with 4.15 kernel/progs),
> luksOpened+losetup+luksOpened (yes two dm-crypt, the one from the
> external restore HDD, then the image file of the SSD which again
> contained dmcrypt+LUKS, of which one was the broken btrfs).
>=20
> As I've mentioned before... btrfs-restore (and the other tools for
> trying to find the bytenr) immediately fail here.
> They bring some "block mapping error" and produce no output.
>=20
> This worked on my first rescue attempt (where I had 4.12 kernel/progs).=

>=20
> Since I had no 4.12 kernel/progs at hand anymore, I went to an even
> older rescue stick, wich has 4.7 kernel/progs (if I'm not wrong).
> There it worked again (on the same image file).
>=20
> So something changed after 4.14, which makes the tools no longer being
> able to restore at least that what they could restore at 4.14.

This seems to be a regression.
But I'm not sure if it's the kernel to blame or the btrfs-progs.

>=20
>=20
> =3D> Some bug recently introduced in btrfs-progs?

Is the "block mapping error" message from kernel or btrfs-progs?

>=20
>=20
>=20
>=20
> I finished the dump then (from OLD notebook/good RAM) with 4.7
> kernel/progs,... to the very same external HDD I've used before.
>=20
> And afterwards I:
> diff -qr --no-dereference restoreFromNEWnotebook/ restoreFromOLDnoteboo=
k/
>=20
> =3D> No differences were found, except one further file that was in the=

> new restoreFromOLDnotebook. Could be that this was a file wich I
> deleted on the old restore because of csum errors, but I don't really
> remember (actually I thought to remember that there were a few which I
> deleted).
>=20
> Since all other files were equal (that is at least in terms of file
> contents and symlink targets - I didn't compare the metadata like
> permissions, dates and owners)... the qcow2 images are garbage as well.=

>=20
> =3D> No csum errors were recorded in the kernel log during the diff, an=
d
> since both, the (remaining) restore results from the NEW notebook and
> the ones just made on the OLD one were read because of the diff,... I'd=

> guess that no further corruption happened in the recent btrfs-restore.
>=20
>=20
>=20
>=20
>=20
> On to the next working site:
>=20
>>>> This -28 (ENOSPC) seems to show that the extent tree of the new
>>>> btrfs
>>>> is
>>>> corrupted.
>>>
>>> "new" here is dm-1, right? Which is the fresh btrfs I've created on
>>> some 8TB HDD for my recovery works.
>>> While that FS shows me:
>>> [26017.690417] BTRFS info (device dm-2): disk space caching is
>>> enabled
>>> [26017.690421] BTRFS info (device dm-2): has skinny extents
>>> [26017.798959] BTRFS info (device dm-2): bdev /dev/mapper/data-a4
>>> errs:
>>> wr 0, rd 0, flush 0, corrupt 130, gen 0
>>> on mounting (I think the 130 corruptions are simply from the time
>>> when
>>> I still used it for btrfs-restore with the NEW notebook with
>>> possibly
>>> bad RAM)... I continued to use it in the meantime (for more
>>> recovery
>>> works) and wrote actually many TB to it... so far, there seem to be
>>> no
>>> further corruption on it.
>>> If there was some extent tree corruption... than nothing I would
>>> notice
>>> now.
>>>
>>> An fsck of it seems fine:
>>> # btrfs check /dev/mapper/restore=20
>>> Checking filesystem on /dev/mapper/restore
>>> UUID: 62eb62e0-775b-4523-b218-1410b90c03c9
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> checking csums
>>> checking root refs
>>> found 2502273781760 bytes used, no error found
>>> total csum bytes: 2438116164
>>> total tree bytes: 5030854656
>>> total fs tree bytes: 2168242176
>>> total extent tree bytes: 286375936
>>> btree space waste bytes: 453818165
>>> file data blocks allocated: 2877953581056
>>>  referenced 2877907415040
>>
>> At least metadata is in good shape.
>>
>> If scrub reports no error, it would be perfect.
>=20
> In the meantime I had written the btrfs-restore under kernel 4.7 as
> mentioned above to that disk.
> At the same time I was trying to continue where I stopped last time
> when the SSD fs broke - doing backups of that.
>=20
> So I had the fs mounted as /-fs and mounted it again in /mnt (where a
> snapshot made from a rescue USB stick) was already waiting, and started=

> to tar.xz it.
>=20
> It happened then, that I wanted to do the diff of the two btrfs-
> restores (as mentioned above) and I accidentally mounted the external
> HDD on /mnt again.
>=20
> Shouldn't be a problem normally, but automatically I did Ctrl-C during
> the mount (which is of course useless).
> Afterwards I umount /mnt... where it said it couldn't do so,
> nevertheless only the first mount at /mnt was shown,... so maybe I was
> fast enough.
>=20
> I'm telling this boring story because of two reasons:
> - First I remembered that something very similar happened when the
> first SSD fs was corrupted,.. only that I then got this paging bug as
> described in my very first mail and couldn't unmount / cleanly shut
> down anymore.
> So maybe that had to do something with the whole story? Could there be
> some bug when mounts are stacked (I know it's unlikely... but who
> knows).

When kernel module (btrfs in this case) caused kernel BUG, it stalls the
whole module (if not the whole kernel).

So later operation, including umount/mount won't work properly.

>=20
> - This time (don't think this was the case back then when the SSD fs
> got corrupted), I got a:
> Mar 07 19:58:10 heisenberg kernel: BTRFS info (device dm-1): disk space=
 caching is enabled
> Mar 07 19:58:10 heisenberg kernel: BTRFS info (device dm-1): has skinny=
 extents
> Mar 07 19:58:10 heisenberg kernel: BTRFS info (device dm-1): bdev /dev/=
mapper/data-a4 errs: wr 0, rd 0, flush 0, corrupt 130, gen 0
> =3D> so I'd say it was in fact mounted (even though the umount claimed
>    differently)

Something went wrong during mount.
Normally log-replay, but it could be other check.

>=20
> Mar 07 19:58:20 heisenberg kernel: BTRFS error (device dm-1): open_ctre=
e failed
> =3D> wtf? What does this mean? Anything to do with free space caches (I=

>    haven't disabled that yet)

Maybe during log-replay or other work must be reused at mount time, it
fails, so kernel just refuse to mount the fs.

>=20
> Mar 07 19:59:07 heisenberg kernel: BTRFS info (device dm-1): disk space=
 caching is enabled
> Mar 07 19:59:07 heisenberg kernel: BTRFS info (device dm-1): has skinny=
 extents
> Mar 07 19:59:07 heisenberg kernel: BTRFS info (device dm-1): bdev /dev/=
mapper/data-a4 errs: wr 0, rd 0, flush 0, corrupt 130, gen 0
> Mar 07 19:59:31 heisenberg kernel: BTRFS info (device dm-1): disk space=
 caching is enabled
> =3D> here I mounted it again at another dir...

And strangely this time it works...

>=20
> dm-1 here is the external HDD (and the 130 corrupt are likely from the
> first btrfs-restore that I made while still on the NEW notebook with
> the possible bad RAM).
>=20
>=20
> After that I did a fsck of the 8TB HDD / dm-1 ... and as you've anyway
> asked me above, a scrub of it.
> Neither of both showed any errors.... (so still strange why it got that=

> open_ctree error)

I'm surprise the corruption just disappeared...

>=20
>=20
>>>> Since free space cache corruption (only happens for v1) is not a
>>>> big
>>>> problem, fsck will only report but doesn't account it as error.
>>>
>>> Why is it not a big problem?
>>
>> Because we have "nospace_cache" mount option as our best friend.
>=20
> Which leaves the question when one could enable the cache again... if
> no clear error is found right now... :(

Fortunately (or unfortunately), no obvious problem with v1 space cache
found yet.

The difference in free space is caused by race and it's ensured that
free space cache can only have less space or equal space with block
group item.

And in that case, kernel will always expose such problem and discard the
cache.

>=20
>=20
>>> This comes as a surprise... wasn't it always said that v2 space
>>> cache
>>> is still unstable?
>>
>> But v1 also has its problem.
>> In fact I have already found a situation btrfs could corrupt its v1
>> space cache, just using fsstress -n 200.
>>
>> Although kernel and btrfs-progs can both detect the corruption,
>> that's
>> already the last defending line. The corrupted cache passes both
>> generation and checksum check, the only check which catches it is
>> free
>> space size, but that can be bypassed if we craft the operation
>> carefully
>> enough.
>=20
> Well then back to:
> it should be disabled per default in an update to stable kernels until
> the issues are found and fixed...

At least it's still not proven v1 cache is the cause.

>=20
>=20
>>> And shouldn't that then become either default (using v2)... or a
>>> default of not using v1 at least?
>>
>> Because we still don't have a strong enough evidence or test case to
>> prove it.
>> But I think it would change soon.
>>
>> Anyway, it's just an optimization, and most of us can live without
>> it.
>=20
> Perhaps still better to proactively disable it, if it's already
> suspected to be buggy and you have that situation with fsstress -n
> 200,... instead of waiting for people getting corruptions.
>=20
> (And/or possibly a good time to push for v2... if that's anyway the
> future to go) :)
>=20
>=20
>=20
>>> Wouldn't it be reasonable, that when a fs is mounted that was not
>>> properly unmounted (I assume there is some flag that shows
>>> this?),...
>>> any such possible corrupted caches/trees/etc. are simply
>>> invalidated as
>>> a safety measure?
>>
>> Unfortunately, btrfs doesn't have such flag to indicate dirty umount.
>> We could use log_root to find it, but that's not always the case, and
>> one can even use notreelog to disable log tree completely.
>=20
> Likely I'm just thinking to naively... but wouldn't that be easy to
> add?

Normally it's because we don't need. The metadata CoW is still pretty
safe so far.

Thanks,
Qu

> If the kernel or any tool that writes to the fs (things like --
> repair) opens the fs in a mode where any changes (including internal
> ones) can be made... flag the fs to be "dirty"... if that operation
> succeesds/ends (e.g. via umount)... flag it to be clean.
>=20
> I'm not saying, create a journal ;-) ... but such a plain flag could
> then be used to decide whether caches like the freespace cache should
> be rather discarded.
>=20
>=20
>> However there are still cases where V1 cache get CoWed, still digging
>> the reason, but under certain chunk layout, it could leads to
>> corruption.
>=20
> Okay... would be nice if you CC me in case you find anything in the
> future... especially when it's safe again to enable the caches.
>=20
>=20
> Thanks,
> Chris. :-)
>=20


--JdKmucALxBW93MD7YdKSxNRAzJh56qWg9--

--0jiXVsCyRPP6w3hwONsu53upwnPi57HC9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqhy7QXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhobwgAoXd5rSFKO1VWCUFRfaPdOl1G
8xuIzzKuFa+5MNFOO4SC3sJG67PcFiZ3sx/lhYuFoJR23Qxxm+yqQSNUoRuv2FAz
ne0gYV+/iE02t6XptQxadr/0pvNTZXmbRU++v/yNTVLOCLJiZNDZw3UJEgdIQ/n+
6oq4vjVT1u9mjKjAUsykbXSVpj5dqbxD4ePc20iKxJ6rjww8wqDe5fnaaMXETa/Y
iwi3S/fAjeim5glFoT05UmhMO8A+hANDdHqV94H2rUIWj1eQXyHspH15KrbgBvZ0
piDWKshB41sv+1eCW4yRTL+JtmfH4LgcefufssN97t/CFobtpn7VdcxXZ/FUtg==
=t9FS
-----END PGP SIGNATURE-----

--0jiXVsCyRPP6w3hwONsu53upwnPi57HC9--
