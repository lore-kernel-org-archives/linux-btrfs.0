Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964935AbeFNOn7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jun 2018 10:43:59 -0400
Subject: Re: Bad superblock when mounting rw, ro mount works
To: Daniel Underwood <daniel.underwood13@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
 <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
 <CAJCQCtTsWq_wZP-MO2-aXmzFAyR-QoT8147NFEiMqyGa7bbDNQ@mail.gmail.com>
 <CAHac6AtGU1VprzTqD-zaqEuBQBg_stZPVRZt5RcdQ6vaKemGVQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <10e17ab5-0a17-e5c4-a648-37faa75ccb3e@gmx.com>
Date: Thu, 14 Jun 2018 22:43:51 +0800
MIME-Version: 1.0
In-Reply-To: <CAHac6AtGU1VprzTqD-zaqEuBQBg_stZPVRZt5RcdQ6vaKemGVQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1uAiRBy48yI73YUYPilAGKMaz2DOm8n5f"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1uAiRBy48yI73YUYPilAGKMaz2DOm8n5f
Content-Type: multipart/mixed; boundary="tOv248SNaQl2qMBzNhtOjWPSqm4P7OCBU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Underwood <daniel.underwood13@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <10e17ab5-0a17-e5c4-a648-37faa75ccb3e@gmx.com>
Subject: Re: Bad superblock when mounting rw, ro mount works
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
 <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
 <CAJCQCtTsWq_wZP-MO2-aXmzFAyR-QoT8147NFEiMqyGa7bbDNQ@mail.gmail.com>
 <CAHac6AtGU1VprzTqD-zaqEuBQBg_stZPVRZt5RcdQ6vaKemGVQ@mail.gmail.com>
In-Reply-To: <CAHac6AtGU1VprzTqD-zaqEuBQBg_stZPVRZt5RcdQ6vaKemGVQ@mail.gmail.com>

--tOv248SNaQl2qMBzNhtOjWPSqm4P7OCBU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8814=E6=97=A5 22:23, Daniel Underwood wrote:
>>> Your very first task right now is to mount ro, and update your
>>> backups. Don't do anything else until you've done that. It's a
>>> testimony to Btrfs that this file system mounts at all, even ro, so
>>> take advantage of this fact before you can't mount it anymore.
>=20
> Backups are in place for the important parts, though I'd prefer not to
> use them if possible.
>=20
> For btrfs-progs, I am using 4.16.1 installed from
> https://github.com/kdave/btrfs-progs.
>=20
> Regarding em5, it had errors when I initially added it to the array
> that were due to a faulty SAS card. The card was replaced and I
> haven't seen errors since until this popped up. Regarding what you
> said about my dmesg, the numbers are actually still the same (bdev
> /dev/mapper/em5 errs: wr 164286, rd 3444262, flush 2110, corrupt 3,
> gen 181) after doing a backup and reboot. I would think they would
> have changed unless btrfs is just ignoring that disk now. Just to make
> sure, I've checked to make sure there weren't any loose connections.
> The logs for check (with and without lowmem mode), `btrfs fi us`, and
> `smartctl -x` are attached. The checks are only for em5, but I can do
> other disks if necessary (it's a 6-disk raid10-style setup). Note that
> there are a lot of errors on the SMART info, but they seem to be back
> from when I was having hardware issues.

=46rom the output, specially the lowmem mode output since original mode
handles extent tree corruption poorly and aborted, it's your extent tree
corrupted and causing the bug.

Thus, you should be able to mount the fs RO and copy all the data back
without much hassle.
Just need to pay attention for csum error.

And considering how many extent tree corruption, I don't think it's a
good idea to manually fix the fs.

The last chance is, to try --repair --init-extent-tree as your last
chance, if you still want to salvage the filesystem.
The lowmem mode shows no extra bug, thus it's possible for
--init-extent-tree to re-init extent tree and save the day.

But personally speaking I'm not fully confident of the operation, thus
it may fail and you may need to use the backup.

BTW, even --init-extent-tree succeeded, you may still need to run btrfs
check again to check if all the bugs are fixed.
But at least from the lowmem output, the remaining errors are all fixable=
=2E

Thanks,
Qu

>=20
> ---
>=20
> On Thu, Jun 7, 2018 at 4:50 PM, Chris Murphy <lists@colorremedies.com> =
wrote:
>> On Thu, Jun 7, 2018 at 2:38 PM, Chris Murphy <lists@colorremedies.com>=
 wrote:
>>
>>
>>> Your very first task right now is to mount ro, and update your
>>> backups. Don't do anything else until you've done that. It's a
>>> testimony to Btrfs that this file system mounts at all, even ro, so
>>> take advantage of this fact before you can't mount it anymore.
>>
>> After you've done the backup, you need to find out why one of these
>> devices is being so unreliable. That has to be fixed first. You can
>> recreate a new Btrfs or some other file system, and you'll just run
>> into the exact same problem down the road. Next, it might be useful to=

>> see the output from btrfs-progs 4.16.1 'btrfs check' and 'btrfs check
>> --mode=3Dlowmem'  both of which are slow, the second one is really slo=
w
>> but is a different implementation so it's helpful to see both outputs.=

>> That's safe as long as you do not use --repair.
>>
>> Also we need to see the output from 'btrfs fi us <mountpoint>' with
>> the volume mounted (ro). Off  hand I think the most likely outcome is
>> that you get a backup from the ro mounted file system, and you'll have=

>> to recreate it from scratch and restore from backups. In other words,
>> no matter what you need a current backup.
>>
>> --
>> Chris Murphy
>=20
>=20
>=20


--tOv248SNaQl2qMBzNhtOjWPSqm4P7OCBU--

--1uAiRBy48yI73YUYPilAGKMaz2DOm8n5f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsifygACgkQwj2R86El
/qhjiQf/duC252c+e6D6wAbd3YAmHEwkPN/SXGNBxPxcZ8ddkABX3/4eE9o9rjU8
3wh5ItJdusjrqHnee9eqnXi8wC5hnU2Eyfiw0F7pja4MEBm3BQxtCwk2FO9GNtr6
EHikwWlRDhIXt/jz+t1NqXhjZR/Izy1FBVaguZiiAGIyDOlh5msES2HHkmPNdqB+
peZZ0YseobsZ1En2yWwMZC98MiBPrp00c2LzJ5uylo/LQZo9el8sO6tGQyo2btpP
tIAw0IloI529s1K+YpJNQAXwQYMHMVgAKCxamsArW/TwBJTBEUMgdt173R+2hH2a
9klvtCYOVAs9TwKAhVf5anRLB+3kXg==
=ATp3
-----END PGP SIGNATURE-----

--1uAiRBy48yI73YUYPilAGKMaz2DOm8n5f--
