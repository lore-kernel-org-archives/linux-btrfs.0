Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63974 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbdLJA3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Dec 2017 19:29:21 -0500
Subject: Re: Chunk-Recovery fails with alignment error
To: Benjamin Beichler <hadrian2002@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
 <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com>
 <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
 <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com>
Date: Sun, 10 Dec 2017 08:29:12 +0800
MIME-Version: 1.0
In-Reply-To: <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k8HAEE9TmlRNvCRO8kU9fSs8xde5rkUm6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k8HAEE9TmlRNvCRO8kU9fSs8xde5rkUm6
Content-Type: multipart/mixed; boundary="ONxFjFvgKM59nO1iLlWwJVEBrBlPe9aLX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Benjamin Beichler <hadrian2002@googlemail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com>
Subject: Re: Chunk-Recovery fails with alignment error
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
 <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com>
 <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
 <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
In-Reply-To: <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>

--ONxFjFvgKM59nO1iLlWwJVEBrBlPe9aLX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8810=E6=97=A5 07:12, Benjamin Beichler wrote:
> Hi Qu,
>=20
> 2017-12-07 12:09 GMT+00:00 Qu Wenruo <quwenruo.btrfs@gmx.com>:
>>
>> Since the btrfs chunk recovery doesn't work and my dirty quick hack
>> doesn't work either, I don't expect much to recovery.
>>
>> Unless we have more detailed info about the how and why the BUG_ON() o=
f
>> chunk recovery is triggered.
>>
>> That's to say, it will be a quite time consuming work to use gdb to
>> locate the problem, and see if any developer (mostly me) could use the=

>> info to further dig into the problem or fix it.
>> (Considering the difference in timezone, I expect at least 8+ weeks to=

>> get a conclusion)
>=20
> I'm really pleased that you want to help me, of course the current
> backtrace was quite useless.
> Firstly, I revised the code a bit, and since one run over the 1,7TB
> drive took about 6h, I thought about saving the state of already found
> chunks. I simply saved all bytenr which are valid to a file. The
> consequence was a reduction of the time for scan_one_device to about
> 30s. If you think this could be interesting for the normal version, I
> could create a patch for this.
>=20
>>
>> If you really want to do it, please step into the function
>> btrfs_insert_item() in __rebuild_device_items() and to see at which
>> point -EIO is returned.
>>
>> My guess is btrfs_search_slot() call in btrfs_insert_empty_items().
>>
>> If that's true, please call
>>
>> btrfs_print_tree(root->fs_info->chunk_root, root->fs_info->chunk_root-=
>node, 1)
>>
>> in gdb, just before the btrfs_search_slot() call above, to show what's=

>> the problem.
>>
> Your guess was right. The current stack trace and btrfs_print_tree is
> under : https://gist.github.com/anonymous/2cf40ac1d3ddcbca95177acec7804=
1b2

The output is very helpful.

I was originally thinking it's something more serious, but it turns out
to be less serious than my expectation.

>=20
> As you can see, the code in disk.io:321 explicitly exclude the the
> sector from 0 to sectorsize, and states it is unaligned. I think
> because the code found a chunk/block at address zero, this triggers
> the problem. Is it possible, that there live chunks/blocks at address
> 0 or is this fuzzy data?

0 is completely valid in btrfs logical address space.

It's the IS_ALIGNED macro which caused the problem.
So it's quite easy to fix in fact.

For 0, always return it as aligned should fix your problem.

Thanks,
Qu

>=20
>>
>> BTW, currently nothing in chunk tree/super block contains any info of
>> your fs, feel free to share it with the mail list, where more guys may=
 help.
>>
> I added the list, I simply forgot it in some answer.
>=20
>> Thanks,
>> Qu
>>
>=20
> thanks
>=20
> Benjamin
>=20


--ONxFjFvgKM59nO1iLlWwJVEBrBlPe9aLX--

--k8HAEE9TmlRNvCRO8kU9fSs8xde5rkUm6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlosf9kXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi1/QgArkEVKL98/7d6u07OeVY1BaZP
NOWLDGug0A7ZxfGgjhCPxaDwqFCLt4g3VfGgMMuegtZS4bsIErSq0znn0Kgb17oF
elMziSnJeZemrxLcAZfRUiEMdt8zNH248vtU9KGKiw0R07J38BFgpOAV89ZoyNls
DQ0uOFVmPBV03EtBSUEEIme32bOl/+dwNm6yL2jHirimhCJI33Tq4oE6IJ+ydazH
PcGcmEka4/nyYgxujmFbMtqnTfa9xy0SfE/2yLHZQ1QTUUZp6vSp/MDKex/pInUz
zPushVJM/BgOz+6LnhOR5KULoemybHh9xzFGBwdFGGVcQaTGItP9ixi+lSOpzA==
=U7LM
-----END PGP SIGNATURE-----

--k8HAEE9TmlRNvCRO8kU9fSs8xde5rkUm6--
