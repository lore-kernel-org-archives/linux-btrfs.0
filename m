Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:46027 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbeIDQ6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Sep 2018 12:58:47 -0400
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: Etienne Champetier <champetier.etienne@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
 <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com>
Date: Tue, 4 Sep 2018 20:33:42 +0800
MIME-Version: 1.0
In-Reply-To: <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MmsRVoTeLT9bGa1FKiA1lsBROheN5bJjt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MmsRVoTeLT9bGa1FKiA1lsBROheN5bJjt
Content-Type: multipart/mixed; boundary="Yi1qC6N2P8yjQgpUo7r5ZNCC4tGdXKnHS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Etienne Champetier <champetier.etienne@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com>
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
 <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
In-Reply-To: <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>

--Yi1qC6N2P8yjQgpUo7r5ZNCC4tGdXKnHS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/4 =E4=B8=8B=E5=8D=887:53, Etienne Champetier wrote:
> Hi Qu,
>=20
> Le lun. 3 sept. 2018 =C3=A0 20:27, Qu Wenruo <quwenruo.btrfs@gmx.com> a=
 =C3=A9crit :
>>
>> On 2018/9/3 =E4=B8=8B=E5=8D=8810:18, Etienne Champetier wrote:
>>> Hello btfrs hackers,
>>>
>>> I have a computer acting as backup server with BTRFS RAID1, and I
>>> would like to know the different options to rebuild this RAID
>>> (I saw this thread
>>> https://www.spinics.net/lists/linux-btrfs/msg68679.html but there was=

>>> no raid 1)
>>>
>>> # uname -a
>>> Linux servmaison 4.4.0-134-generic #160-Ubuntu SMP Wed Aug 15 14:58:0=
0
>>> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> # btrfs --version
>>> btrfs-progs v4.4
>>>
>>> # dmesg
>>> ...
>>> [ 1955.581972] BTRFS critical (device sda2): corrupt leaf, bad key
>>> order: block=3D6020235362304,root=3D1, slot=3D63
>>> [ 1955.582299] BTRFS critical (device sda2): corrupt leaf, bad key
>>> order: block=3D6020235362304,root=3D1, slot=3D63
>=20
> Now running a Fedora 28 install kernel
>=20
> # uname -a
> Linux servmaison 4.16.3-301.fc28.x86_64 #1 SMP Mon Apr 23 21:59:58 UTC
> 2018 x86_64 x86_64 x86_64 GNU/Linux
> # btrfs --version
> btrfs-progs v4.15.1

Unfortunately, even for latest btrfs-progs release (v4.17.1, and even
devel branch), btrfs check will abort checking if free space cache is
corrupted.

So we didn't get any useful info from btrfs check.

Such diff would help you continue checking (if you really want, other
than starting salvaging your data)
------
diff --git a/check/main.c b/check/main.c
index b361cd7e26a0..4f720163221e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9885,7 +9885,6 @@ int cmd_check(int argc, char **argv)
                        error("errors found in free space tree");
                else
                        error("errors found in free space cache");
-               goto out;
        }

        /*
------


For dump tree block, the corrupted tree block belongs to extent tree.
Which could be a good news (depends on how you define GOOD news).

The corruption is not an easy fix, it's not just a swapped slot.
The corrupted slot (item 64, whole key objectid is 5946810351616) is way
beyond the extent data range, thus btrfs-progs can't fix it easily.

Considering how much bytenr difference there is and the generation gap
(53167 vs current generation 1555950), the bug happens a long long time
ago (days or weeks before 2016-06-04). So it's a little too late to be
fixed (unless someone could send me a time machine).

On the other hand, this means any WRITE would easily fail due to
corrupted extent tree, but your fs should be OK if mounted RO, thus you
could copy your data out.

>=20
>>
>> Please provide the following dump:
>>
>> # btrfs inspect dump-tree -t root /dev/sda2
>> # btrfs inspect dump-tree -b 6020235362304 /dev/sda2
>=20
> All requested dump are in this repo:
> https://github.com/champtar/debugraidbtrfs
>=20
[snip]
>>
>> If it's the only problem, "btrfs check --repair" indeed could fix it.
>=20
> Also available in https://github.com/champtar/debugraidbtrfs, here
> "btrfs check --readonly /dev/sda2" output
> ~~~~~~~~~~~~~~~~~~~~
> checking extents
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad key ordering 63 64
> bad block 6020235362304
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> there is no free space entry for 6011561750528-5942842273792
> there is no free space entry for 6011561750528-6012044050432
> cache appears valid but isn't 6010970308608
> there is no free space entry for 6015529828352-5946810351616
> there is no free space entry for 6015529828352-6016339017728
> cache appears valid but isn't 6015265275904
> there is no free space entry for 6139476623360-6070757146624
> there is no free space entry for 6139476623360-6139852881920
> cache appears valid but isn't 6138779140096
> ERROR: errors found in free space cache
> Checking filesystem on /dev/sda2
> UUID: 4917db5e-fc20-4369-9556-83082a32d4cd
> found 1321120776195 bytes used, error(s) found
> total csum bytes: 0
> total tree bytes: 1163182080
> total fs tree bytes: 0
> total extent tree bytes: 1161740288
> btree space waste bytes: 290512355
> file data blocks allocated: 618135552
>  referenced 618135552
> ~~~~~~~~~~~~~~~~~~~~

As expected, btrfs-progs is unable to fix it.

>=20
> Thanks
> Etienne
>=20
> P.S: sorry for the initial duplicate email, it took a very long time
> to show up in https://www.spinics.net/lists/linux-btrfs/maillist.html,
> thought it was discarded as I was not subscribed to the list

It's pretty common, I even sometimes sent patches twice for the same reas=
on.

And just another kindly note, for "btrfs check" or "btrfs inspect
dump-tree", there is no difference using difference device.
So one output is enough.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>> (I can boot on a more up to date Linux live if it helps)
>>>
>>> Thanks
>>> Etienne
>>>
>>


--Yi1qC6N2P8yjQgpUo7r5ZNCC4tGdXKnHS--

--MmsRVoTeLT9bGa1FKiA1lsBROheN5bJjt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluOe6YACgkQwj2R86El
/qjlGgf/RJt+I9XmhmSOVk6BSsFDztEsBnxpJT4m3lB1kuLF4ev6kAkEuLPN5WeO
SF1Hh5QAZyT61LckSVkWPCj1SSV5IpUzv6RZFIX5zNgV0rAwaFWxitN711HNDETB
Fx8gwwO08EQgOFTqsizXgbbz1L2XSeuYJxu9ssOs6OLsaTJoYNRpEAzfIeDboE1/
UY34VyM/mpTpHdN6i0HWtN4/+pVZ8CzNE1zhnOlpnsSGCAum0NYjhqoNC2a1I04M
cUW6vUjmFK+D8xc6vvP8YNojmkNJdm5gykzZcGiCitHq2sRIPuUviP71KLF2WUz8
mHbN+ufMKLM/ZO9/YOnnxzXpBu0yyQ==
=3ik2
-----END PGP SIGNATURE-----

--MmsRVoTeLT9bGa1FKiA1lsBROheN5bJjt--
