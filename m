Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4D9C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 02:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7663220820
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 02:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDDCsb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 22:48:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:58338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfDDCsa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 22:48:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67F70ACA5;
        Thu,  4 Apr 2019 02:48:29 +0000 (UTC)
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     btrfs@avgustinov.eu, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
From:   Jeff Mahoney <jeffm@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jeffm@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
Date:   Wed, 3 Apr 2019 22:48:25 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kjWsjRJ4uAqSLrucXBG6leGkDWeN3IXjK"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kjWsjRJ4uAqSLrucXBG6leGkDWeN3IXjK
Content-Type: multipart/mixed; boundary="vwtDxAtSe8pY6fzWgECcvMSYQWDqwkW40";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: btrfs@avgustinov.eu, linux-btrfs@vger.kernel.org
Message-ID: <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
In-Reply-To: <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>

--vwtDxAtSe8pY6fzWgECcvMSYQWDqwkW40
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/31/19 2:44 PM, btrfs@avgustinov.eu wrote:
> Dear all,
>=20
>=20
> I am a big fan of btrfs, and I am using it since 2013 - in the meantime=

> on at least four different computers. During this time, I suffered at
> least four bad btrfs-failures leading to unmountable, unreadable and
> unrecoverable file system. Since in three of the cases I did not manage=

> to recover even a single file, I am beginning to lose my confidence in
> btrfs: for 35-years working with different computers no other file
> system was so bad at recovering files!
>=20
> Considering the importance of btrfs and keeping in mind the number of
> similar failures, described in countless forums on the net, I have got
> an idea: to donate my last two damaged filesystems for investigation
> purposes and thus hopefully contribute to the improvement of btrfs. One=

> condition: any recovered personal data (mostly pictures and audio files=
)
> should remain undisclosed and be deleted.
>=20
> Should anybody be interested in this - feel free to contact me
> personally (I am not reading the list regularly!), otherwise I am going=

> to reformat and reuse both systems in two weeks from today.
>=20
> Some more info:
>=20
> =C2=A0 - The smaller system is 83.6GB, I could either send you an image=
 of
> this system on an unneeded hard drive or put it into a dedicated
> computer and give you root rights and ssh-access to it (the network lin=

> is 100Mb down, 50Mb up, so it should be acceptable).
>=20
> =C2=A0 - The used space on the other file system is about 3 TB (4 TB
> capacity) and it is distributed among 5 drives, so I can only offer
> remote access to this, but I will need time to organize it.
>=20
> If you need additional information - please ask, but keep in mind that =
I
> have almost no "free time" and the answer could need a day or two.

My team is always interested in images of broken file systems.  This is
how --repair evolves.  Images with failed --repair operations are still
valuable.  That's the first step most users take and why wouldn't they?
 If --repair is misbehaving, the end result shouldn't be "I hope you
have backups."

It's not the size of the file system that matters so much.  The data on
it doesn't matter from a debugging perspective and, in any event, it's
not written to the image file anyway.  I do want a btrfs-image file from
the file system, and if btrfs-image fails to create a usable image,
that's also valuable to know and fix.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--vwtDxAtSe8pY6fzWgECcvMSYQWDqwkW40--

--kjWsjRJ4uAqSLrucXBG6leGkDWeN3IXjK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlylcHoACgkQHntLYyF5
5bKBOBAAlIGZIHcXguPM50FpzT/xGP3ONzKmMFUwKdWAqMTS/HeahKYAIUjehtpx
jlj+T6cg4/FUK+A1FMarZ/Tj8yFhMHclERCaSgvMm8uQ6+fHUzWHgGYkmdnhwgG1
gNy5ZwNzHVJ/WSNP56sqJV75ltyHjEvlNUju8EpaTsyGDPtCSQa9rMm7kuM39MU/
hEJ8TaQXsYebLifzahMkD/wtfBB5QEfOWGoy0tzMMewPWyJDKDmCFUz8+/izk62x
sMSZmeq6eiyOuysYFOMW9y22UKMvOu3ATl7m4YJe32YWnMW4dduEsAIM54xGU534
oBbTT2TmJBhmqi4xoSwNsuOlhGIboEmi29pvytucJGZ48GELt4PcgOSsqcF3yozr
pr+/eGnj8OwVbV/FK1iZMVlXDfmRVICbgAS0A4Pm392yZMAOeedNKDQxM3Di96z+
tpWEvPUVePZ+m6bQBG2fvFcRJwclvaDE0iGq4HVL2sXJFh4PAa27HslnhyZWS7QE
TIKgMgdB2JuVQGaK/TR74w6e3eyl9+aUHZlmJ+sPdqNwPhRHGdvP0qjLcA9AcnWq
wOBU92h2ura4R2D+CEMBCBmIoNtG0hjtc2m1zeYqrrfckty9DtTuToexrXJMH/5A
1RHoTVS3eOU9nxTEEgeDZyNMnaUDlR+LxoxNunQIOMgh6wqohys=
=9zsw
-----END PGP SIGNATURE-----

--kjWsjRJ4uAqSLrucXBG6leGkDWeN3IXjK--
