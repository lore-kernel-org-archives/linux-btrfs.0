Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63056 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935134AbdKPOHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 09:07:41 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
Date: Thu, 16 Nov 2017 22:06:52 +0800
MIME-Version: 1.0
In-Reply-To: <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5C5jDPCLOFNi7kvCR4lwJv6uf2QPSovUi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5C5jDPCLOFNi7kvCR4lwJv6uf2QPSovUi
Content-Type: multipart/mixed; boundary="WvjtFDjJKEg1HQBBrhcdDtI2w7p9h6Ech";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov
 <nborisov@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
In-Reply-To: <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>

--WvjtFDjJKEg1HQBBrhcdDtI2w7p9h6Ech
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8816=E6=97=A5 20:33, Zdenek Kabelac wrote:
> Dne 16.11.2017 v 11:04 Qu Wenruo napsal(a):
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8816=E6=97=A5 17:43, Zdenek Kabelac wrote:
>>> Dne 16.11.2017 v 09:08 Qu Wenruo napsal(a):
>>>>
>>>>
>>>>>>>>>
>>>>>>>> [What we have]
>>>>>>>> The nearest infrastructure I found in kernel is
>>>>>>>> bio_integrity_payload.
>>>>>>>>
>>>
>>> Hi
>>>
>>> We already have=C2=A0 dm-integrity target upstream.
>>> What's missing in this target ?
>>
>> If I didn't miss anything, the dm-integrity is designed to calculate a=
nd
>> restore csum into its space to verify the integrity.
>> The csum happens when bio reaches dm-integrity.
>>
>> However what I want is, fs generate bio with attached verification hoo=
k,
>> and pass to lower layers to verify it.
>>
>> For example, if we use the following device mapper layout:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FS (can be any fs wit=
h metadata csum)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 dm-integrity
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 dm-raid1
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 / \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disk1=C2=A0=C2=A0=
=C2=A0=C2=A0 disk2
>>
>> If some data in disk1 get corrupted (the disk itself is still good), a=
nd
>> when dm-raid1 tries to read the corrupted data, it may return the
>> corrupted one, and then caught by dm-integrity, finally return -EIO to=

>> FS.
>>
>> But the truth is, we could at least try to read out data in disk2 if w=
e
>> know the csum for it.
>> And use the checksum to verify if it's the correct data.
>>
>>
>> So my idea will be:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FS (with metadata csum, or even data cs=
um support)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 READ bio for metadata
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 -With metadata verification hook
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dm-raid1
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 / \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disk1=C2=A0=
=C2=A0 disk2
>>
>> dm-raid1 handles the bio, reading out data from disk1.
>> But the result can't pass verification hook.
>> Then retry with disk2.
>>
>> If result from disk2 passes verification hook. That's good, returning
>> the result from disk2 to upper layer (fs).
>> And we can even submit WRITE bio to try to write the good result back =
to
>> disk1.
>>
>> If result from disk2 doesn't pass verification hook, then we return -E=
IO
>> to upper layer.
>>
>> That's what btrfs has already done for DUP/RAID1/10 (although RAID5/6
>> will also try to rebuild data, but it still has some problem).
>>
>> I just want to make device-mapper raid able to handle such case too.
>> Especially when most fs supports checksum for their metadata.
>>
>=20
> Hi
>=20
> IMHO you are looking for too complicated solution.

This is at least less complicated than dm-integrity.

Just a new hook for READ bio. And it can start from easy part.
Like starting from dm-raid1 and other fs support.

>=20
> If your checksum is calculated and checked at FS level there is no adde=
d
> value when you spread this logic to other layers.

That's why I'm moving the checking part to lower level, to make more
value from the checksum.

>=20
> dm-integrity adds basic 'check-summing' to any filesystem without the
> need to modify fs itself

Well, despite the fact that modern filesystem has already implemented
their metadata csum.

 - the paid price is - if there is bug between
> passing data from=C2=A0 'fs' to dm-integrity'=C2=A0 it cannot be captur=
ed.
>=20
> Advantage of having separated 'fs' and 'block' layer is in its
> separation and simplicity at each level.

Totally agreed on this.

But the idea here should not bring that large impact (compared to big
things like ZFS/Btrfs).

1) It only affect READ bio
2) Every dm target can choose if to support or pass down the hook.
   no mean to support it for RAID0 for example.
   And for complex raid like RAID5/6 no need to support it from the very
   beginning.
3) Main part of the functionality is already implemented
   The core complexity contains 2 parts:
   a) checksum calculation and checking
      Modern fs is already doing this, at least for metadata.
   b) recovery
      dm targets already have this implemented for supported raid
      profile.
   All these are already implemented, just moving them to different
   timing is not bringing such big modification IIRC.
>=20
> If you want integrated solution - you are simply looking for btrfs wher=
e
> multiple layers are integrated together.

If with such verification hook (along with something extra to handle
scrub), btrfs chunk mapping can be re-implemented with device-mapper:

In fact btrfs logical space is just a dm-linear device, and each chunk
can be implemented by its corresponding dm-* module like:

dm-linear:       | btrfs chunk 1 | btrfs chunk 2 | ... | btrfs chunk n |
and
btrfs chunk 1: metadata, using dm-raid1 on diskA and diskB
btrfs chunk 2: data, using dm-raid0 on disk A B C D
=2E..
btrfs chunk n: system, using dm-raid1 on disk A B

At least btrfs can take the advantage of the simplicity of separate layer=
s.

And other filesystem can get a little higher chance to recover its
metadata if built on dm-raid.

Thanks,
Qu

>=20
> You are also possibly missing feature of dm-interity - it's not just
> giving you 'checksum' - it also makes you sure - device has proper
> content - you can't just 'replace block' even with proper checksum for =
a
> block somewhere in the middle of you device... and when joined with
> crypto - it makes it way more secure...
>=20
> Regards
>=20
> Zdenek


--WvjtFDjJKEg1HQBBrhcdDtI2w7p9h6Ech--

--5C5jDPCLOFNi7kvCR4lwJv6uf2QPSovUi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloNm30XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qivUwf/ct0zdtcJIiqDfZdXJbmnSBTE
Lw119L4Rc9ZJLJcO85+AOuDLP8sgTZ3Az15ktHMvUyHbb+Z5QsnbEnQMIIaz/o28
nOOfDZVmLBhTEc3REbKpxOfkUHCIrdwHcq8cmoEO2WunfzpzfDf8yhX0InVDmcJF
S7LZrHXXSna4hq2XSyA0D3JT9auPC66lv142U/cp43Mr5JVaaHYoDiZ9Ffy22JIO
YJ9PxWdzCysrcbapux0h/IbZZl5jEHJYh21dSlu2YnJSTVXzg/ZVAnfn+1m+T3LY
9ohR0HiKf3X6N4cEUd31VTlMfIFA3FEj2lH+Pw7GlHDL//buASNQlh5Phn+IjQ==
=btke
-----END PGP SIGNATURE-----

--5C5jDPCLOFNi7kvCR4lwJv6uf2QPSovUi--
