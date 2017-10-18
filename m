Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:38894 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756896AbdJREgX (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 18 Oct 2017 00:36:23 -0400
Subject: Re: Mount failing - unable to find logical
To: Cameron Kelley <cameronkelley28@gmail.com>, linux-btrfs@vger.kernel.org
References: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
 <93bfd00c-1ade-176d-0c0f-675fe904ab88@gmx.com>
 <1badda3c-c030-502c-d09d-cb619c333fc8@gmail.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <475b1ad3-2519-9c70-f98c-25355a65c168@suse.com>
Date: Wed, 18 Oct 2017 12:36:03 +0800
MIME-Version: 1.0
In-Reply-To: <1badda3c-c030-502c-d09d-cb619c333fc8@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f8VckLtj7g6q3kmnsoMNVqn8F6TEeKNLT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f8VckLtj7g6q3kmnsoMNVqn8F6TEeKNLT
Content-Type: multipart/mixed; boundary="SbrhtLbH3lbWcUi32RbSdVIqjVCVskC3l";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Cameron Kelley <cameronkelley28@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <475b1ad3-2519-9c70-f98c-25355a65c168@suse.com>
Subject: Re: Mount failing - unable to find logical
References: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
 <93bfd00c-1ade-176d-0c0f-675fe904ab88@gmx.com>
 <1badda3c-c030-502c-d09d-cb619c333fc8@gmail.com>
In-Reply-To: <1badda3c-c030-502c-d09d-cb619c333fc8@gmail.com>

--SbrhtLbH3lbWcUi32RbSdVIqjVCVskC3l
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8818=E6=97=A5 11:22, Cameron Kelley wrote:
>=20
>=20
> On 10-17-2017 6:24 PM, Qu Wenruo wrote:
>>
>>
>> On 2017-10-18 04:43, Cameron Kelley wrote:
>>> Hey btrfs gurus,
>>>
>>> I have a 4 disk btrfs filesystem that has suddenly stopped mounting
>>> after a recent reboot. The data is in an odd configuration due to
>>> originally being in a 3 disk RAID1 before adding a 4th disk and runni=
ng
>>> a balance to convert to RAID10. There wasn't enough free space to
>>> completely convert, so about half the data is still in RAID1 while th=
e
>>> other half is in RAID10. Both metadata and system are RAID10. It has
>>> been in this configuration for 6 months or so now since adding the 4t=
h
>>> disk. It just holds archived media and hasn't had any data added or
>>> modified in quite some time. I feel pretty stupid now for not
>>> correcting that sooner though.
>>>
>>> I have tried mounting with different mount options for recovery, ro,
>>> degraded, etc. Log shows errors about "unable to find logical
>>> 3746892939264 length 4096"
>>>
>>> When I do a btrfs check, it doesn't find any issues. Running
>>> btrfs-find-root comes up with a message about a block that the
>>> generation doesn't match. If I specify that block on the btrfs check,=
 I
>>> get transid verify failures.
>>>
>>> I ran a dry run of a recovery of the entire filesystem which runs
>>> through every file with no errors. I would just restore the data and
>>> start fresh, but unfortunately I don't have the free space at the
>>> moment for the ~4.5TB of data.
>>>
>>> I also ran full smart self tests on all 4 disks with no errors.
>>>
>>> root@nas2:~# uname -a
>>> Linux nas2 4.13.7-041307-generic #201710141430 SMP Sat Oct 14 14:39:0=
6
>>> UTC 2017 i686 i686 i686 GNU/Linux
>>
>> I don't think i686 kernel will cause any difference, but considering
>> most of us are using x86_64 to develop/test, maybe it will be a good
>> idea to upgrade to x86_64 kernel?
>>
>=20
> Thanks for the quick response.
>=20
> This is an old x86 Pentium NAS I inherited, so unfortunately I'm stuck
> on a 32-bit kernel. If push comes to shove, I can disassemble another
> x64 machine to test with.

I think it's better to try x86_64, since the problem is quite weird and
I don't even know how the strange bytenr come from, so I think it's
better to wipe out any possibility.

>=20
>>>
>>> root@nas2:~# btrfs version
>>> btrfs-progs v4.13.2
>>>
>>> root@nas2:~# btrfs fi show
>>> Label: none=C2=A0 uuid: 827029a4-8625-4a50-a22d-0fd28dbe2d36
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 4=
 FS bytes used 4.60TiB
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=
=C2=A0 1 size 2.73TiB used 2.33TiB path /dev/sdb1
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=
=C2=A0 2 size 2.73TiB used 2.33TiB path /dev/sdc
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=
=C2=A0 3 size 2.73TiB used 2.33TiB path /dev/sdd1
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=
=C2=A0 4 size 2.73TiB used 2.33TiB path /dev/sde1
>>>
>>> root@nas2:~# mount /dev/sdb1 /mnt/nas2/
>>> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 missing codepage or h=
elper program, or other error
>>>
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 In some cases useful =
info is found in syslog - try
>>>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dmesg | tail or so.
>>>
>>> root@nas2:~# dmesg | tail
>>> [=C2=A0 801.332623] BTRFS info (device sdb1): disk space caching is e=
nabled
>>> [=C2=A0 801.332627] BTRFS info (device sdb1): has skinny extents
>>> [=C2=A0 801.333386] BTRFS critical (device sdb1): unable to find logi=
cal
>>> 3746892939264 length 4096
>>> [=C2=A0 801.333472] BTRFS critical (device sdb1): unable to find logi=
cal
>>> 3746892939264 length 4096
>>> [=C2=A0 801.333769] BTRFS critical (device sdb1): unable to find logi=
cal
>>> 3746892939264 length 4096
>>> [=C2=A0 801.333835] BTRFS critical (device sdb1): unable to find logi=
cal
>>> 3746892939264 length 4096
>>> [=C2=A0 801.333909] BTRFS critical (device sdb1): unable to find logi=
cal
>>> 3746892939264 length 4096
>>> [=C2=A0 801.333968] BTRFS critical (device sdb1): unable to find logi=
cal
>>> 3746892939264 length 4096
>>> [=C2=A0 801.334028] BTRFS error (device sdb1): failed to read chunk r=
oot
>>> [=C2=A0 801.365452] BTRFS error (device sdb1): open_ctree failed
>>
>> Some of the chunk tree failed to be read out.
>>
>> Either chunk tree or system chunk array has some problem.
>>
>> Would you please dump the chunk tree and superblock by the following
>> commands?
>>
>> # btrfs inspect-internal dump-tree -t chunk /dev/sdb1
>> # btrfs inspect-internal dump-super -fa /dev/sdb1
>>
>=20
> # btrfs inspect-internal dump-tree -t chunk /dev/sdb1
> http://pastebin.ubuntu.com/25763241/
>=20
> # btrfs inspect-internal dump-super -fa /dev/sdb1
> http://pastebin.ubuntu.com/25763246/

Strange.

All your chunks start from 16365829226496, which is completely common if
you tried or have already balanced the whole fs (for several times).

But this leads to the problem, there is no chunk mapping for
3746892939264, since all your chunk starts far behind that byte number.

I can't see any thing related to the bytenr in the dump, both chunk tree
and super dump.
All your chunk tree are in valid chunk map range. So your chunk tree is
good.
Both check mode also verified this.

And further more, you are using 16K nodesize, which is the default
value, while kernel is trying to read a 4K block, which means it's data.

But according to your dmesg, you are stuck where we failed to read out
the chunk root (not the whole chunk tree).

This makes the whole thing even more weird, as your superblock shows
your chunk root is at 21339078983680, which is completely valid.

So I recommend to try to mount the fs on a x64 or at least some newer
machine, to see if the problem just suddenly disappears.

Thanks,
Qu

>=20
>>>
>>> root@nas2:~# btrfs check /dev/sdb1
>>> Checking filesystem on /dev/sdb1
>>> UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
>>> checking extents
>>> checking free space cache
>>> cache and super generation don't match, space cache will be invalidat=
ed
>>> checking fs roots
>>> checking csums
>>> checking root refs
>>> found 5054297628672 bytes used, no error found
>>> total csum bytes: 4929567064
>>> total tree bytes: 5197856768
>>> total fs tree bytes: 15237120
>>> total extent tree bytes: 43433984
>>> btree space waste bytes: 161510789
>>> file data blocks allocated: 5050024812544
>>>=C2=A0=C2=A0 referenced 5049610178560
>>
>> Unless we has some bug in btrfs-progs chunk mapping, the result seems
>> quite good.
>>
>> Just in case, would you please also run "btrfs check --mode=3Dlowmem
>> /dev/sdb1" to see if it's OK?
>>
>=20
> # btrfs check --mode=3Dlowmem /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 5053072662528 bytes used, no error found
> total csum bytes: 4929567064
> total tree bytes: 5195988992
> total fs tree bytes: 15237120
> total extent tree bytes: 43368448
> btree space waste bytes: 161593371
> file data blocks allocated: 5048801714176
> =C2=A0referenced 5048387080192
>=20
>>>
>>> root@nas2:~# btrfs-find-root /dev/sdb1
>>> Superblock thinks the generation is 147970
>>> Superblock thinks the level is 1
>>> Found tree root at 21335861559296 gen 147970 level 1
>>> Well block 21335857758208(gen: 147969 level: 1) seems good, but
>>> generation/level doesn't match, want gen: 147970 level: 1
>>
>> Since it's mostly related to chunk tree, would you please try the
>> following command?
>>
>> # btrfs-find-root -o 3 /dev/sdb1
>> # btrfs check --chunk-root <the next chunk root bytenr> /dev/sdb1
>>
>> Thanks,
>> Qu
>>
>=20
> # btrfs-find-root -o 3 /dev/sdb1
> Superblock thinks the generation is 147728
> Superblock thinks the level is 1
> Found tree root at 21339078983680 gen 147728 level 1
>=20
> # btrfs check --chunk-root 21339078983680 /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 5053072662528 bytes used, no error found
> total csum bytes: 4929567064
> total tree bytes: 5195988992
> total fs tree bytes: 15237120
> total extent tree bytes: 43368448
> btree space waste bytes: 161593371
> file data blocks allocated: 5048801714176
> =C2=A0referenced 5048387080192
>=20
>>>
>>> root@nas2:~# btrfs check -r 21335857758208 /dev/sdb1
>>> parent transid verify failed on 21335857758208 wanted 147970 found
> 147969
>>> parent transid verify failed on 21335857758208 wanted 147970 found
> 147969
>>> parent transid verify failed on 21335857758208 wanted 147970 found
> 147969
>>> parent transid verify failed on 21335857758208 wanted 147970 found
> 147969
>>> Ignoring transid failure
>>> Checking filesystem on /dev/sdb1
>>> UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
>>> checking extents
>>> checking free space cache
>>> cache and super generation don't match, space cache will be invalidat=
ed
>>> checking fs roots
>>> checking csums
>>> checking root refs
>>> ERROR: transid errors in file system
>>> found 5054297628672 bytes used, error(s) found
>>> total csum bytes: 4929567064
>>> total tree bytes: 5197856768
>>> total fs tree bytes: 15237120
>>> total extent tree bytes: 43433984
>>> btree space waste bytes: 161510789
>>> file data blocks allocated: 5050024812544
>>>=C2=A0=C2=A0 referenced 5049610178560
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--SbrhtLbH3lbWcUi32RbSdVIqjVCVskC3l--

--f8VckLtj7g6q3kmnsoMNVqn8F6TEeKNLT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnm2jMNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qIFpCACAXiK74sseaN7k/O0akEv/y7qW1OpoTkEytGxS
BURxEAcCk6sMNMxYtieftlgGlPLPTtFsH6UT0/z52YszZpSGJYwe/7y1TMIhYWwO
PbdyD38otTAPaUc45fmTmhrAX9SG3FliJ2EYRwjT/b5yVgV9nbdB2uuMs5D31xPz
mk8Ka+iCq08b0joqYSvxyAReszBChm3ySD+jA69JCh2gfZA3fdrLGug8GavEL21m
yJ+8GIk7otTt7+Dpf71+K0mKdDygq2uzPfC7TPT4bZjTpqRc0RCGHEvKLYt367XP
/3dyFK2TCTXifB77Uktw4+z+jWtKz2Xn8HK8DcCEBxySbUbm
=wTp+
-----END PGP SIGNATURE-----

--f8VckLtj7g6q3kmnsoMNVqn8F6TEeKNLT--
