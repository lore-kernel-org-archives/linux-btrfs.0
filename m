Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54049 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751868AbdKVJCD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 04:02:03 -0500
Subject: Re: quotas: failure on removing a file via SFTP/SSH
To: ST <smntov@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1511266131.1680.27.camel@gmail.com>
 <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com>
 <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
 <1511278140.1680.41.camel@gmail.com>
 <CAJCQCtRCPfcSNQseoRdB1pq+DkF7pr6nt4syyYy1VWXYwy2R6g@mail.gmail.com>
 <1511298021.1675.14.camel@gmail.com>
 <28236dae-8190-9b74-521d-661942b52df4@gmx.com>
 <1511339571.1675.17.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <96439d6a-5f60-2095-3b62-75b9dd3bd941@gmx.com>
Date: Wed, 22 Nov 2017 17:01:52 +0800
MIME-Version: 1.0
In-Reply-To: <1511339571.1675.17.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IULaB9L8X9WwGtrhjMgPNvPkFUESWWlmx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IULaB9L8X9WwGtrhjMgPNvPkFUESWWlmx
Content-Type: multipart/mixed; boundary="hkk81inAmF6vlvXbJeOS0mL3gw3MRSdkE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <96439d6a-5f60-2095-3b62-75b9dd3bd941@gmx.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
References: <1511266131.1680.27.camel@gmail.com>
 <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com>
 <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
 <1511278140.1680.41.camel@gmail.com>
 <CAJCQCtRCPfcSNQseoRdB1pq+DkF7pr6nt4syyYy1VWXYwy2R6g@mail.gmail.com>
 <1511298021.1675.14.camel@gmail.com>
 <28236dae-8190-9b74-521d-661942b52df4@gmx.com>
 <1511339571.1675.17.camel@gmail.com>
In-Reply-To: <1511339571.1675.17.camel@gmail.com>

--hkk81inAmF6vlvXbJeOS0mL3gw3MRSdkE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8822=E6=97=A5 16:32, ST wrote:
>=20
>=20
>=20
> On Wed, 2017-11-22 at 08:39 +0800, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B411=E6=9C=8822=E6=97=A5 05:00, ST wrote:
>>> On Tue, 2017-11-21 at 11:33 -0700, Chris Murphy wrote:
>>>> On Tue, Nov 21, 2017 at 8:29 AM, ST <smntov@gmail.com> wrote:
>>>>>>>>> I'm trying to use quotas for a simple chrooted sftp setup, limi=
ting
>>>>>>>>> space for each user's subvolume (now for testing to 1M).
>>>>>>>>>
>>>>>>>>> I tried to hit the limit by uploading files and once it comes t=
o the
>>>>>>>>> limit I face following problem: if I try to free space by remov=
ing a
>>>>>>>>> file via Linux sftp client (or Filezilla) - I get error:
>>>>>>>>> "Couldn't delete file: Failure"
>>>>>>>>>
>>>>>>>>> Sometimes, but not always, if I repeat it for 3-5 times it does=
 removes
>>>>>>>>> the file at the end.
>>>>>>>>> If I login as root and try to remove the file via SSH I get the=
 error:
>>>>>>>>> "rm: cannot remove 'example.txt': Disk quota exceeded"
>>>>>>>>>
>>>>>>>>> What is the problem? And how can I solve it?
>>>>>>>>
>>>>>>>> Kernel version first.
>>>>>>>>
>>>>>>>> If it's possible, please use latest kernel, at least newer than =
v4.10,
>>>>>>>> since we have a lot of qgroup reservation related fixes in newer=
 kernel.
>>>>>>>>
>>>>>>>> Then, for small quota, due to the nature of btrfs metadata CoW a=
nd
>>>>>>>> relative large default node size (16K), it's quite easy to hit d=
isk
>>>>>>>> quota for metadata.
>>>>>>>
>>>>>>> Yes, but why I get the error specifically on REMOVING a file? Eve=
n if I
>>>>>>> hit disk quota - if I free up space - it should be possible, isn'=
t it?
>>>>>>
>>>>>> It's only true for fs modifying its metadata in-place (and use jou=
rnal
>>>>>> to protect it).
>>>>>>
>>>>>> For fs using metadata CoW, even freeing space needs extra space fo=
r new
>>>>>> metadata.
>>>>>>
>>>>>
>>>>> Wait, it doesn't sound like a bug, but rather like a flaw in design=
=2E
>>>>> This means - each time a user hits his quota limit he will get stuc=
k
>>>>> without being able to free space?!!
>>>>
>>>> It's a good question if quotas can make it possible for a user to ge=
t
>>>> wedged into a situation that will require an admin to temporarily
>>>> raise the quota in order to make file deletion possible.
>>>
>>> Why question? It's a fact. That's what I face right now.
>>>
>>>>  This is not a
>>>> design flaw, all COW file systems *add* data when deleting. The
>>>> challenge is how to teach the quota system to act like a hard limit
>>>> for data writes that clearly bust the quota, versus a soft limit tha=
t
>>>> tolerates some extra amount above the quota for the purpose of
>>>> eventually deleting data. That's maybe non-trivial. It's not that it=
's
>>>> a design flaw. Metadata can contain inline data, so how exactly to y=
ou
>>>> tell what kinds of writes are permitted (deleting a file) and what
>>>> kind of writes are not (append data to a file, or create new file)?
>>>>
>>>> But for sure the user space tools should prevent setting too low a
>>>> quota limit. If the limit cannot be reasonably expected to work, it
>>>> should be disallowed. So maybe the user space tools need to enforce =
a
>>>> minimum quota, something like 100MiB, or whatever.
>>>>
>>>
>>> Would you like to open an issue with your enhancement suggestions on =
the
>>> bug tracker so this case doesn't get forgotten?
>>
>> That's why I ask for the kernel version.
>>
>> IIRC in newer kernel, quota doesn't limit deletion anymore, preventing=

>> you from hitting such dilemma.
>=20
> I'm sorry. I've mentioned it in another mail in this thread, here it is=
:
>=20
> I am on Debian 9 (stable), so kernel version is:
> uname -r
> 4.9.0-4-amd64

This seems before the workaround for file deletion, but I can also be
wrong about it.

If you could try v4.13/14, it will be possible to verify the behavior.

Thanks,
Qu

> btrfs-tools (4.7.3-1)
>=20
> I hope kernel 4.13 will move from Debian stable-backports to stable in
> some not so distant future. Is this issue already resolved in 4.13?
>=20
> Thank you!
>=20


--hkk81inAmF6vlvXbJeOS0mL3gw3MRSdkE--

--IULaB9L8X9WwGtrhjMgPNvPkFUESWWlmx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloVPQAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjKhAf/Qgqq+J2u/iOJNK0XHtsK7lLR
6iYWQKa5ZpkVXRmaU7/llwWgaOeJgm6+IEz26bBZr7lt+chhV7Q1FDcvKJlLu4Gg
rCP+6HSVN5fTAPi+ZSZ6lU5GCqdRB8Im7j9/Y8p0YpFUgKPLtWbgdWmBPWRGEgD+
t8Pt3cWVNmI4H4JJprxG400CqLRVAbMoglHfjSJ9UhpKKczNoaOkll73WUz/jJ99
Zns1s5vEN+Mlc+gFPVtRflVmgctprXLSZkEv+cLoHEcPOxnvR8CrYcY5jHKrDYLP
VwxBnLDMVqHldQK0Pnn5E9BwoSQ0dFoLKWn1AVYpr48u+Klux8ws88ca687Law==
=H9C5
-----END PGP SIGNATURE-----

--IULaB9L8X9WwGtrhjMgPNvPkFUESWWlmx--
