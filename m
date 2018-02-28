Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:42325 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751707AbeB1IgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 03:36:22 -0500
Subject: Re: Fwd: Re: BUG: unable to handle kernel paging request at
 ffff9fb75f827100
To: Christoph Anton Mitterer <calestyo@gmail.com>,
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
Date: Wed, 28 Feb 2018 16:36:12 +0800
MIME-Version: 1.0
In-Reply-To: <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VAf0QNCEmehftWNf88ZETLUdBWZ2IC9S6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VAf0QNCEmehftWNf88ZETLUdBWZ2IC9S6
Content-Type: multipart/mixed; boundary="PNlgXiL4il2ENpFeuzJ5ZOaRIFdxXPOm9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Anton Mitterer <calestyo@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
Subject: Re: Fwd: Re: BUG: unable to handle kernel paging request at
 ffff9fb75f827100
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
In-Reply-To: <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>

--PNlgXiL4il2ENpFeuzJ5ZOaRIFdxXPOm9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

Since I'm still digging the unexpected corruption (although without much
progress yet), would you please describe how the corruption happens?

In my current investigation, btrfs is indeed bullet-proof, (unlike my
original assumption) using newer dm-log-writes tool.

But free space cache file (v1 free space cache) is not CoW protected so
it's vulnerable against power loss.

So my current assumption is, there are at least 2 power loss happens
during the problem.

The 1st power loss caused free space cache corrupted but not detected by
its checksum, and btrfs used the corrupted free space cache to allocate
tree blocks.

And then 2nd power loss happened. Since new allocated tree blocks can
overwrite existing tree blocks, it breaks metadata CoW of btrfs, and
leads the final corruption.

Would you please provide some detailed info about the corruption?

Thanks,
Qu

On 2018=E5=B9=B402=E6=9C=8823=E6=97=A5 03:21, Christoph Anton Mitterer wr=
ote:
> Am 22. Februar 2018 04:57:53 MEZ schrieb Qu Wenruo <quwenruo.btrfs@gmx.=
com>:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 10:56, Christoph Anton Mitterer=
 wrote:
>>> Just one last for today... I did a quick run with the byte nr from
>> the last mail... See screenshot
>>>
>>> It still gives these mapping errors... But does seem to write
>> files...
>>
>>From your previous picture, it seems that FS_TREE is your primary
>> subvolume, and 257 would be your snapshot.
>>
>> And for that block which can't be mapped, it seems to be a corruption
>> and it's really too large.
>>
>> So ignoring it wouldn't be a problem.
>>
>> And just keep btrfs-store running to see what it salvaged?
>>
>>>
>>> But these mapping errors... Wtf?!=20
>>>
>>>
>>> Thanks and until tomorrow.
>>>
>>> Chris
>>>
>>> Oh and in my panic (I still fear that my main data fs, which is on
>> other hard disks could be affected by that strange bug, too, and have
>> no idea how to verify they are not) I forgot: you are from China,
>> aren't you? So a blessed happy new year. :-)
>>
>> Happy new year too.
>>
>> Thanks,
>> Qu
>>
>>>
>=20
> Hey
>=20
> Have you written more after the mail below?  Cause my normal email acco=
unt ran full and I cannot recover that right now with my computer.
>=20
> Anyway... I tried now the restore and it seems to give back some data (=
haven't looked at it yet)... I also made a dd copy of the whole fs image =
to another freshly crafted btrfs fs (as an image file).
>=20
> That seemed to work well, but when I differs that image with the origin=
al, new csum errors of that file were found. (see attached image)
>=20
> Could that be a pointer to some hardware defect? Perhaps the memory? Th=
ough I did do an extensive memtest86+ a while ago.
>=20
> And that could be the reason for the corruption in the first place...
>=20
> Thanks,
> Chris.
>=20


--PNlgXiL4il2ENpFeuzJ5ZOaRIFdxXPOm9--

--VAf0QNCEmehftWNf88ZETLUdBWZ2IC9S6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqWafwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj0Qwf/cSLSVFqqZ5m2ef45LWZmMaP3
bsBzI6iF10w2oXOsrEC6lZbxmh/qO+Y4I60Hiis1jgeN+4yzvHjB8xJSQC98f3X3
gmNYHhFUJOFrCNR4VzE3Qxnnt1V5PmCiOov1npE8HwIqD3P4Kfd/ExYV8acjiUcT
SSUS0xgzevTpjtz43Ivbs9i/03tK2TM/8bLXFAVJxci8DEzCykGLzXRBTqgp3urE
uYM/BXaUvJom/fHO76/zLOp+/5y4oQeiJ692/yqdnFmxacB/7BKyJSOD7MBq5k96
XDRDWy+QZiLe1OMTN5IOApc5dEf1VmPkLliH97D8/rRMMP31f1Zk1RdPvVEcYA==
=oGza
-----END PGP SIGNATURE-----

--VAf0QNCEmehftWNf88ZETLUdBWZ2IC9S6--
