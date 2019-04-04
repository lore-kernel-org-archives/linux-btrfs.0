Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80747C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 02:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DCBC2082E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 02:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfDDCiQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 22:38:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:56050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbfDDCiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 22:38:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 274A3AD8A;
        Thu,  4 Apr 2019 02:38:14 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs-progs: check: run delayed refs after writing
 out dirty block groups
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190402180956.28893-1-jeffm@suse.com>
 <CAL3q7H7O=ZqJdQUXYZjJRfZF04Or7kLgEVnRUGE97YRsV=3pMg@mail.gmail.com>
From:   Jeff Mahoney <jeffm@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jeffm@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <068957f9-c4cf-688d-3db7-7f519c21e4ea@suse.com>
Date:   Wed, 3 Apr 2019 22:38:09 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7O=ZqJdQUXYZjJRfZF04Or7kLgEVnRUGE97YRsV=3pMg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1uz7alJcqwNQDXcQlzAX6bPw9H0yDH2vm"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1uz7alJcqwNQDXcQlzAX6bPw9H0yDH2vm
Content-Type: multipart/mixed; boundary="AW1HX8lK5aY2hctBxrIwvmNS0LZBhVayx";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <068957f9-c4cf-688d-3db7-7f519c21e4ea@suse.com>
Subject: Re: [PATCH 1/2] btrfs-progs: check: run delayed refs after writing
 out dirty block groups
References: <20190402180956.28893-1-jeffm@suse.com>
 <CAL3q7H7O=ZqJdQUXYZjJRfZF04Or7kLgEVnRUGE97YRsV=3pMg@mail.gmail.com>
In-Reply-To: <CAL3q7H7O=ZqJdQUXYZjJRfZF04Or7kLgEVnRUGE97YRsV=3pMg@mail.gmail.com>

--AW1HX8lK5aY2hctBxrIwvmNS0LZBhVayx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/2/19 3:19 PM, Filipe Manana wrote:
> On Tue, Apr 2, 2019 at 7:29 PM <jeffm@suse.com> wrote:
>>
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> When repairing the extent tree, it's possible for delayed extents to
>> be created when running btrfs_write_dirty_block_groups.  We run
>> delayed refs one last time in the kernel but that is missing in
>> the userspace tools.
>>
>> That results in delayed refs getting dropped on the floor, the extent
>> records not getting created, and in the next tranaction, when the
>> extent tree is CoW'd again, we hit the BUG_ON when we can't find
>> the extent record.
>>
>> We can fix this by running the delayed refs after writing out the
>> dirty block groups.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  transaction.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/transaction.c b/transaction.c
>> index e756db33..2f19e9c8 100644
>> --- a/transaction.c
>> +++ b/transaction.c
>> @@ -194,6 +194,8 @@ commit_tree:
>>         ret =3D btrfs_run_delayed_refs(trans, -1);
>>         BUG_ON(ret);
>>         btrfs_write_dirty_block_groups(trans);
>> +       ret =3D btrfs_run_delayed_refs(trans, -1);
>> +       BUG_ON(ret);
>=20
> And running delayed refs can dirty more block groups as well.
> At this point shouldn't we loop running delayed refs until no more
> dirty block groups exist? Just like in the kernel.

Right.  This is another argument for code sharing between the kernel and
userspace.

-Jeff

> thanks
>=20
>>         __commit_transaction(trans, root);
>>         if (ret < 0)
>>                 goto out;
>> --
>> 2.16.4
>>
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--AW1HX8lK5aY2hctBxrIwvmNS0LZBhVayx--

--1uz7alJcqwNQDXcQlzAX6bPw9H0yDH2vm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlylbhIACgkQHntLYyF5
5bK5yxAAkTh48dKB/w7mmVsdM17+d3NivzTt3g1+/8XYt/HTHPxwxMqMLdCbubQT
EsMVWhdpsYR9xy5YYseAyv6YEl4mUX8cxvVfock1FntJAOI01HbCxSJJ2u3ZzqZV
RFqBVnscjgwjn620PaMoyxZo4o+YK9RxE7f0tcuYriLUILWfEMyjQXhBczbF8bfN
jpSHWeKFL7A8i8Q4iKY+wy6egLIhPWUfSQklU5aCOUZ5L8DxwUdVejoG4GcnxiBs
78yFIC77hl1PrydhGgejm7Ay5cSfDm72FeqxLL3LTCOHA9o2U+eTwtgTqTuD+gGE
9hiHVh/WzjEMpLI6GB+4r5ba6xm0fX8BlCB6J6tNSUSrwCCttzWejyEmWdxy1QzP
7AO0d3OBxx7h+zQXoKM3Be84nfyWKSKHw7Eya0Smp25jHL1lA3wsJ52myXRW2mm+
RPF5iBz67JYGV3QqfaG1EFg3RiplGHSvnnGFp8THHadhczCnlG0Coag/ed4cSa6F
OwI8IIFskjoIHly7HobXmgdJvvTgD4RxesYXo+lhrwF50+bXnHjxVCZQB2X8cAcK
qhnAaIuspB2OfHL8JHqs8aGdfWt8P7dz2nZ6KU6YN1CB962YEFFJqZGFpgUzgAaO
kQgpj/vTBlXEixKDAzv5Ece6D2Kh+ayeOdopgjbkM9M2q1FStuA=
=sl3f
-----END PGP SIGNATURE-----

--1uz7alJcqwNQDXcQlzAX6bPw9H0yDH2vm--
