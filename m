Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53812 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753684AbdKQBWa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 20:22:30 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Chris Murphy <lists@colorremedies.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4baeb223-85d3-4c0c-e6d3-d0b495c2d950@gmx.com>
Date: Fri, 17 Nov 2017 09:22:11 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UDe1UiNvSrHhMaFc1ajc9VC7ufJW3NpCu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UDe1UiNvSrHhMaFc1ajc9VC7ufJW3NpCu
Content-Type: multipart/mixed; boundary="ShqAOAi04N0h0iqoW6GFuLxW41re3fgmu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov
 <nborisov@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <4baeb223-85d3-4c0c-e6d3-d0b495c2d950@gmx.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
In-Reply-To: <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>

--ShqAOAi04N0h0iqoW6GFuLxW41re3fgmu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 06:32, Chris Murphy wrote:
> On Thu, Nov 16, 2017 at 3:04 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>=20
>> For example, if we use the following device mapper layout:
>>
>>         FS (can be any fs with metadata csum)
>>                 |
>>              dm-integrity
>>                 |
>>              dm-raid1
>>                / \
>>          disk1     disk2
>=20
>=20
> You would instead do dm-integrity per physical device, then make the
> two dm-integrity devices, members of md raid1 array. Now when
> integrity fails, basically it's UNC error to raid1 which then gets the
> copy from the other device.


Yep, dm-integrity under raid1 makes much more sense here.

Although, double the CPU usage for each device added in.

>=20
> But what you're getting at, that dm-integrity is more complicated, is
> true, in that it's at least partly COW based in order to get the
> atomic write guarantee needed to ensure data blocks and csums are
> always in sync, and reliable. But this also applies to the entire file
> system. The READ bio concept you're proposing leverages pretty much
> already existing code, has no write performance penalty or complexity
> at all, but does miss data for file systems that don't csum data
> blocks.

That's true, since currently only Btrfs supports data csum.
And to make filesystem to support data csum, it needs CoW support while
only XFS and Btrfs supports CoW yet.

> It's good the file system can stay alive, but data is the much
> bigger target in terms of percent space on the physical media,

It's also true.
(Although working on btrfs sometimes makes me care more about safe metada=
ta)

Thanks,
Qu

> and
> more likely to be corrupt or go missing due to media defect or
> whatever. It's still possible for silent data corruption to happen.
>=20
>=20
>=20
>=20
>> I just want to make device-mapper raid able to handle such case too.
>> Especially when most fs supports checksum for their metadata.
>=20
> XFS by default does metadata csums. But ext4 doesn't use it for either
> metadata or the journal by default still, it is still optional. So for
> now it mainly benefits XFS.
>=20
>=20


--ShqAOAi04N0h0iqoW6GFuLxW41re3fgmu--

--UDe1UiNvSrHhMaFc1ajc9VC7ufJW3NpCu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloOOcMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhEWwgApekvUyYq5aMVhmKXv2womaeu
YjQMMsOnaJFPxtu0bTAUZ2VdzFCVYvMLE7jXOsliTusr3z2iLVOllPHRpkNK+lSr
m0vDZlHVQ63bQU6mnTRVd/qCP7gt6cI70wWu506UkoBTIurP1w8CJvMhbTAjtU4L
/0nzfMMjesTXoQgQtuh2tbICiHz7CFwhl7IWJVtekxXsdJMjMGG4qoo1Bs215dbm
/uqU46yevkeItvOBgvUVyuThqJuOIVgYvKdLiPEUNvHaX2nYDVqC4Mi4dYbWlqR4
GC7OeP8df7QFBxQiW7VvG8uPI6gPoJA1eJRb5uj61Ftp3PIuDQpm6m8MnuHF9g==
=5CCQ
-----END PGP SIGNATURE-----

--UDe1UiNvSrHhMaFc1ajc9VC7ufJW3NpCu--
