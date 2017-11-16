Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdKPHiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 02:38:23 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
Date: Thu, 16 Nov 2017 15:38:05 +0800
MIME-Version: 1.0
In-Reply-To: <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WwRM2g8gbxEScQkQk5c8sA2QedQpN6iRu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WwRM2g8gbxEScQkQk5c8sA2QedQpN6iRu
Content-Type: multipart/mixed; boundary="M5RlEulBBN0LHpIGBldcAOuEjCSWN62d6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
In-Reply-To: <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>

--M5RlEulBBN0LHpIGBldcAOuEjCSWN62d6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8816=E6=97=A5 14:54, Nikolay Borisov wrote:
>=20
>=20
> On 16.11.2017 04:18, Qu Wenruo wrote:
>> Hi all,
>>
>> [Background]
>> Recently I'm considering the possibility to use checksum from filesyst=
em
>> to enhance device-mapper raid.
>>
>> The idea behind it is quite simple, since most modern filesystems have=

>> checksum for their metadata, and even some (btrfs) have checksum for d=
ata.
>>
>> And for btrfs RAID1/10 (just ignore the RAID5/6 for now), at read time=

>> it can use the checksum to determine which copy is correct so it can
>> return the correct data even one copy get corrupted.
>>
>> [Objective]
>> The final objective is to allow device mapper to do the checksum
>> verification (and repair if possible).
>>
>> If only for verification, it's not much different from current endio
>> hook method used by most of the fs.
>> However if we can move the repair part from filesystem (well, only btr=
fs
>> supports it yet), it would benefit all fs.
>>
>> [What we have]
>> The nearest infrastructure I found in kernel is bio_integrity_payload.=

>>
>> However I found it's bounded to device, as it's designed to support
>> SCSI/SATA integrity protocol.
>> While for such use case, it's more bounded to filesystem, as fs (or
>> higher layer dm device) is the source of integrity data, and device
>> (dm-raid) only do the verification and possible repair.
>>
>> I'm not sure if this is a good idea to reuse or abuse
>> bio_integrity_payload for this purpose.
>>
>> Should we use some new infrastructure or enhance existing
>> bio_integrity_payload?
>>
>> (Or is this a valid idea or just another crazy dream?)
>>
>=20
> This sounds good in principle, however I think there is one crucial
> point which needs to be considered:
>=20
> All fs with checksums store those checksums in some specific way, then
> when they fetch data from disk they they also know how to acquire the
> respective checksum.

Just like integrity payload, we generate READ bio attached with checksum
hook function and checksum data.

So for data read, we read checksum first and attach it to data READ bio,
then submit it.

And for metadata read, in most case the checksum is integrated into
metadata header, like what we did in btrfs.

In that case we attach empty checksum data to bio, but use metadata
specific function hook to handle it.

> What you suggest might be doable but it will
> require lower layers (dm) be aware of how to acquire the specific
> checksum for some data.

In above case, dm only needs to call the verification hook function.
If verification passed, that's good.
If not, try other copy if we have.

In this case, I don't think dm layer needs any extra interface to
communicate with higher layer.

Thanks,
Qu

> I don't think at this point there is such infra
> and frankly I cannot even envision how it will work elegantly. Sure you=

> can create a dm-checksum target (which I believe dm-verity is very
> similar to) that stores checksums alongside data but at this point the
> fs is really out of the picture.
>=20
>=20
>> Thanks,
>> Qu
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--M5RlEulBBN0LHpIGBldcAOuEjCSWN62d6--

--WwRM2g8gbxEScQkQk5c8sA2QedQpN6iRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFKBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloNQF0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh6cgf0D6mP7h8WsBOSlDWNPQ9RHYsc
gBGpyJqAcc2w0WcGxmQDNZe8Nj+zWk2oAy09+QjM45j2I1bOOBO1HFqSOeU+33VY
hQ3h9BIGxPtB2K3kWIRuGuSdICtrZlo02gg4C10+MaloM28f2aP5zXOZtjhp5dDy
EFwWwqkpKdahSsBDWrVTSqVvdaEsmZn3L1Hkw+VxRgkv6RZybqnmN6pY8t5EeKli
Mh8IShHAvtjVF7+hG7Jr76v/0xt8v78eSQQPwEHXDI7Ploh/PRM8thY3bYaHbvb7
jCnqRFPL34VBYvZK3SNhx2WPX3Du9e5ZwY+otbf4/7dp3asLtuXCSlslDuRj
=Gvty
-----END PGP SIGNATURE-----

--WwRM2g8gbxEScQkQk5c8sA2QedQpN6iRu--
