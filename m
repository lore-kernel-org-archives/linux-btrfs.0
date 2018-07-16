Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:34791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbeGPI7C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 04:59:02 -0400
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
To: Udo Waechter <root@zoide.net>, linux-btrfs@vger.kernel.org
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
 <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <effecc0d-c835-c690-522f-ccd0214a61db@gmx.com>
Date: Mon, 16 Jul 2018 16:32:37 +0800
MIME-Version: 1.0
In-Reply-To: <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xvzoMfsW5wnjfodqNi8UvbqMV7T1P3xkM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xvzoMfsW5wnjfodqNi8UvbqMV7T1P3xkM
Content-Type: multipart/mixed; boundary="YmV9nY75di2IQjMO7OpERjIzLMuPg6LEA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Udo Waechter <root@zoide.net>, linux-btrfs@vger.kernel.org
Message-ID: <effecc0d-c835-c690-522f-ccd0214a61db@gmx.com>
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
 <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
In-Reply-To: <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>

--YmV9nY75di2IQjMO7OpERjIzLMuPg6LEA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8816=E6=97=A5 16:15, Udo Waechter wrote:
> Hello,
>=20
> noone any ideas? Do you need more information?
>=20
> Cheers,
> udo.
>=20
> On 11/07/18 17:37, Udo Waechter wrote:
>> Hello everyone,
>>
>> I have a corrupted filesystem which I can't seem to recover.
>>
>> The machine is:
>> Debian Linux, kernel 4.9 and btrfs-progs v4.13.3
>>
>> I have a HDD RAID5 with LVM and the volume in question is a LVM volume=
=2E
>> On top of that I had a RAID1 SSD cache with lvm-cache.
>>
>> Yesterday both! SSDs died within minutes. This lead to the corruped
>> filesystem that I have now.
>>
>> I hope I followed the procedure correctly.
>>
>> What I tried so far:
>> * "mount -o usebackuproot,ro " and "nospace_cache" "clear_cache" and a=
ll
>> permutations of these mount options
>>
>> I'm getting:
>>
>> [96926.830400] BTRFS info (device dm-2): trying to use backup root at
>> mount time
>> [96926.830406] BTRFS info (device dm-2): disk space caching is enabled=

>> [96926.927978] BTRFS error (device dm-2): parent transid verify failed=

>> on 321269628928 wanted 3276017 found 3275985
>> [96926.938619] BTRFS error (device dm-2): parent transid verify failed=

>> on 321269628928 wanted 3276017 found 3275985
>> [96926.940705] BTRFS error (device dm-2): failed to recover balance: -=
5

This means your fs failed to recover the balance.

And it should mostly be caused by transid error just one line above.
Normally this means your fs is more or less corrupted, could be caused
by powerloss or something else.

>> [96926.985801] BTRFS error (device dm-2): open_ctree failed
>>
>> The weird thing is that I can't really find information about the
>> "failed to recover balance: -5" error. - There was no rebalancing
>> running when during the crash.

Can only be determined by tree dump.

# btrfs ins dump-tree -t root <device>

>>
>> * btrfs-find-root: https://pastebin.com/qkjnSUF7 - It bothers me that =
I
>> don't see any "good generations" as described here:
>> https://btrfs.wiki.kernel.org/index.php/Restore
>>
>> * "btrfs rescue" - it starts, then goes to "looping on XYZ" then stops=

>>
>> * "btrfs rescue super-recover -v" gives:
>>
>> All Devices:
>> 	Device: id =3D 1, name =3D /dev/vg00/...
>> Before Recovering:
>> 	[All good supers]:
>> 		device name =3D /dev/vg00/...
>> 		superblock bytenr =3D 65536
>>
>> 		device name =3D /dev/vg00/...
>> 		superblock bytenr =3D 67108864
>>
>> 		device name =3D /dev/vg00/...
>> 		superblock bytenr =3D 274877906944
>>
>> 	[All bad supers]:
>>
>> All supers are valid, no need to recover
>>
>>
>> * Unfortunatly I did a "btrfs rescue zero-log" at some point :( - As i=
t
>> turns out that might have been a bad idea
>>
>>
>> * Also, a "btrfs  check --init-extent-tree" - https://pastebin.com/jAT=
DCFZy

Then it is making things worse, fortunately it should terminate before
it causes more damage.

I'm just curious why people doesn't try the safest "btrfs check" without
any options, but goes the most dangerous option.

And "btrfs check" output please.
If possible, "btrfs check --mode=3Dlowmem" is also good for debug.

Thanks,
Qu

>>
>> The volume contained qcow2 images for VMs. I need only one of those,
>> since one piece of important software decided to not do backups :(
>>
>> Any help is highly appreciated.
>>
>> Many thanks,
>> udo.
>>
>=20


--YmV9nY75di2IQjMO7OpERjIzLMuPg6LEA--

--xvzoMfsW5wnjfodqNi8UvbqMV7T1P3xkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltMWCUACgkQwj2R86El
/qhDEQf/RY5obBxGDbQol/Lvhu8wkxsiT2vfUOKmqsLml6PK4I86LLgpMFply6hY
uM5xl8Ylvn2EOiob93mGn/IzHUvc4tzWaR/40lZ/Dq8z5QHRPXakijJHZIIl8gT5
x3aY8dCc5YuFey881rOfsYg+RZ6tEkqFxaE8np+vIIgIp1fH6HuAHHQxd50mpruN
LildasFmTWUqA1YC3cZMwezJgqjW9+60Ki5+wdpM6e81ybkdS7/CaRf5IC6WPXoA
BOzeVLAiiB71ha/yE+USWExT12kbhWTVXULBQrzaXfNvve4Tny3UXkqcqsrkfBdh
S4k8jgl6QAjnlHkPGfIYYhdwCmgB1w==
=Y5B3
-----END PGP SIGNATURE-----

--xvzoMfsW5wnjfodqNi8UvbqMV7T1P3xkM--
