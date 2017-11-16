Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60348 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752910AbdKPKFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 05:05:06 -0500
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
Date: Thu, 16 Nov 2017 18:04:19 +0800
MIME-Version: 1.0
In-Reply-To: <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rp5H5jRXmQH48Eub0FB1q5LkciL8TK9g9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rp5H5jRXmQH48Eub0FB1q5LkciL8TK9g9
Content-Type: multipart/mixed; boundary="lF1cgHUCA14VM6fmsB6V8Cix7JdtbB0Pt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov
 <nborisov@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
In-Reply-To: <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>

--lF1cgHUCA14VM6fmsB6V8Cix7JdtbB0Pt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8816=E6=97=A5 17:43, Zdenek Kabelac wrote:
> Dne 16.11.2017 v 09:08 Qu Wenruo napsal(a):
>>
>>
>>>>>>>
>>>>>> [What we have]
>>>>>> The nearest infrastructure I found in kernel is
>>>>>> bio_integrity_payload.
>>>>>>
>=20
> Hi
>=20
> We already have=C2=A0 dm-integrity target upstream.
> What's missing in this target ?

If I didn't miss anything, the dm-integrity is designed to calculate and
restore csum into its space to verify the integrity.
The csum happens when bio reaches dm-integrity.

However what I want is, fs generate bio with attached verification hook,
and pass to lower layers to verify it.

For example, if we use the following device mapper layout:

        FS (can be any fs with metadata csum)
                |
             dm-integrity
                |
             dm-raid1
               / \
         disk1     disk2

If some data in disk1 get corrupted (the disk itself is still good), and
when dm-raid1 tries to read the corrupted data, it may return the
corrupted one, and then caught by dm-integrity, finally return -EIO to FS=
=2E

But the truth is, we could at least try to read out data in disk2 if we
know the csum for it.
And use the checksum to verify if it's the correct data.


So my idea will be:
     FS (with metadata csum, or even data csum support)
                |  READ bio for metadata
                |  -With metadata verification hook
            dm-raid1
               / \
          disk1   disk2

dm-raid1 handles the bio, reading out data from disk1.
But the result can't pass verification hook.
Then retry with disk2.

If result from disk2 passes verification hook. That's good, returning
the result from disk2 to upper layer (fs).
And we can even submit WRITE bio to try to write the good result back to
disk1.

If result from disk2 doesn't pass verification hook, then we return -EIO
to upper layer.

That's what btrfs has already done for DUP/RAID1/10 (although RAID5/6
will also try to rebuild data, but it still has some problem).

I just want to make device-mapper raid able to handle such case too.
Especially when most fs supports checksum for their metadata.

Thanks,
Qu
>=20
> Regards
>=20
> Zdenek
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--lF1cgHUCA14VM6fmsB6V8Cix7JdtbB0Pt--

--rp5H5jRXmQH48Eub0FB1q5LkciL8TK9g9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloNYqMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhURwf/QrCqqoH57J2peSoj06YQ7vkf
2t07+pqo2IdnySv4jNKzouBbrywiD1VnpPtX5e56beTG5lUI3z6SOFOpM9j8L2nx
ljg9wf9gBhADbY+++0yugAuhAzMCCK7v4D2+9O8aUSeajmOqBTasKJ2MIijec1aT
hx8E0bXomtM+ndXj72WbRihSNXq+zEIYggJl72UciEKjLbDRVHeQGH+5Qomc2Ol4
0N4rZIWcaPnSHYjBbzys7U3r+LfVYOHoywufwXJ1T3rPtyz9yEnudoG5gFzcZ3WE
XpA3eGXvMmsf6YLru/TWxjgNGjCMIW6KcNW824PtLiU4VYyf++ZYEZ1Md7QRAg==
=l6+M
-----END PGP SIGNATURE-----

--rp5H5jRXmQH48Eub0FB1q5LkciL8TK9g9--
