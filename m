Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49798 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbdKVAjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 19:39:32 -0500
Subject: Re: quotas: failure on removing a file via SFTP/SSH
To: ST <smntov@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1511266131.1680.27.camel@gmail.com>
 <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com>
 <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
 <1511278140.1680.41.camel@gmail.com>
 <CAJCQCtRCPfcSNQseoRdB1pq+DkF7pr6nt4syyYy1VWXYwy2R6g@mail.gmail.com>
 <1511298021.1675.14.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <28236dae-8190-9b74-521d-661942b52df4@gmx.com>
Date: Wed, 22 Nov 2017 08:39:22 +0800
MIME-Version: 1.0
In-Reply-To: <1511298021.1675.14.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q9THoBQ42gluMstMls3xk7ANGSEMhRBhV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q9THoBQ42gluMstMls3xk7ANGSEMhRBhV
Content-Type: multipart/mixed; boundary="Nqw1HtiK8Amof8sdmC1xahXffWiscDbjH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <28236dae-8190-9b74-521d-661942b52df4@gmx.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
References: <1511266131.1680.27.camel@gmail.com>
 <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com>
 <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
 <1511278140.1680.41.camel@gmail.com>
 <CAJCQCtRCPfcSNQseoRdB1pq+DkF7pr6nt4syyYy1VWXYwy2R6g@mail.gmail.com>
 <1511298021.1675.14.camel@gmail.com>
In-Reply-To: <1511298021.1675.14.camel@gmail.com>

--Nqw1HtiK8Amof8sdmC1xahXffWiscDbjH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8822=E6=97=A5 05:00, ST wrote:
> On Tue, 2017-11-21 at 11:33 -0700, Chris Murphy wrote:
>> On Tue, Nov 21, 2017 at 8:29 AM, ST <smntov@gmail.com> wrote:
>>>>>>> I'm trying to use quotas for a simple chrooted sftp setup, limiti=
ng
>>>>>>> space for each user's subvolume (now for testing to 1M).
>>>>>>>
>>>>>>> I tried to hit the limit by uploading files and once it comes to =
the
>>>>>>> limit I face following problem: if I try to free space by removin=
g a
>>>>>>> file via Linux sftp client (or Filezilla) - I get error:
>>>>>>> "Couldn't delete file: Failure"
>>>>>>>
>>>>>>> Sometimes, but not always, if I repeat it for 3-5 times it does r=
emoves
>>>>>>> the file at the end.
>>>>>>> If I login as root and try to remove the file via SSH I get the e=
rror:
>>>>>>> "rm: cannot remove 'example.txt': Disk quota exceeded"
>>>>>>>
>>>>>>> What is the problem? And how can I solve it?
>>>>>>
>>>>>> Kernel version first.
>>>>>>
>>>>>> If it's possible, please use latest kernel, at least newer than v4=
=2E10,
>>>>>> since we have a lot of qgroup reservation related fixes in newer k=
ernel.
>>>>>>
>>>>>> Then, for small quota, due to the nature of btrfs metadata CoW and=

>>>>>> relative large default node size (16K), it's quite easy to hit dis=
k
>>>>>> quota for metadata.
>>>>>
>>>>> Yes, but why I get the error specifically on REMOVING a file? Even =
if I
>>>>> hit disk quota - if I free up space - it should be possible, isn't =
it?
>>>>
>>>> It's only true for fs modifying its metadata in-place (and use journ=
al
>>>> to protect it).
>>>>
>>>> For fs using metadata CoW, even freeing space needs extra space for =
new
>>>> metadata.
>>>>
>>>
>>> Wait, it doesn't sound like a bug, but rather like a flaw in design.
>>> This means - each time a user hits his quota limit he will get stuck
>>> without being able to free space?!!
>>
>> It's a good question if quotas can make it possible for a user to get
>> wedged into a situation that will require an admin to temporarily
>> raise the quota in order to make file deletion possible.
>=20
> Why question? It's a fact. That's what I face right now.
>=20
>>  This is not a
>> design flaw, all COW file systems *add* data when deleting. The
>> challenge is how to teach the quota system to act like a hard limit
>> for data writes that clearly bust the quota, versus a soft limit that
>> tolerates some extra amount above the quota for the purpose of
>> eventually deleting data. That's maybe non-trivial. It's not that it's=

>> a design flaw. Metadata can contain inline data, so how exactly to you=

>> tell what kinds of writes are permitted (deleting a file) and what
>> kind of writes are not (append data to a file, or create new file)?
>>
>> But for sure the user space tools should prevent setting too low a
>> quota limit. If the limit cannot be reasonably expected to work, it
>> should be disallowed. So maybe the user space tools need to enforce a
>> minimum quota, something like 100MiB, or whatever.
>>
>=20
> Would you like to open an issue with your enhancement suggestions on th=
e
> bug tracker so this case doesn't get forgotten?

That's why I ask for the kernel version.

IIRC in newer kernel, quota doesn't limit deletion anymore, preventing
you from hitting such dilemma.

Thanks,
Qu
>=20
> Thank you!
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Nqw1HtiK8Amof8sdmC1xahXffWiscDbjH--

--q9THoBQ42gluMstMls3xk7ANGSEMhRBhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloUxzoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qipJAf6A/gGiIZgAjTkveLuW1Fdi3A8
yDakJOnPjToxu+SXZVz5caAR65p8jZQ+aLgY9Th17t4Ctz/VnXxppk6WzwG18mfp
/1E37icUCWxTKGYmfpWnfno0TtwvDCsP+bGnSpFYI/tLKgxuLn+k2UWLowdMy9C9
8c5C5XOhEY5oS4e1hDB/GoYZoK3Rv+yWiAW4j64IjY0xcHnxI28///rj1h0WxZIn
FzoomJsEtgqIF3THwhk314Fx0u59hPB2ZIpdyHaozy1+jAjkzVFk2OR7lVM+kWEZ
eYGB+p4m/Xuuj7dOFGADMBsE9ey35TaagfpTB4jZHdHkx09vMdVxUNvtqeqUCQ==
=35bm
-----END PGP SIGNATURE-----

--q9THoBQ42gluMstMls3xk7ANGSEMhRBhV--
