Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:46466 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdIODpZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 23:45:25 -0400
Received: by mail-lf0-f47.google.com with SMTP id m199so1163053lfe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 20:45:24 -0700 (PDT)
Subject: Re: snapshots of encrypted directories?
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
Date: Fri, 15 Sep 2017 06:45:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170914153222.GC7067@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="x10DxpCVVSfKiCrrRTVNPvn7F1Ftja6Ga"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x10DxpCVVSfKiCrrRTVNPvn7F1Ftja6Ga
Content-Type: multipart/mixed; boundary="cDirKATLsa3f3i7tLC8vlGbrL2IbBChcX";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
Subject: Re: snapshots of encrypted directories?
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
In-Reply-To: <20170914153222.GC7067@carfax.org.uk>

--cDirKATLsa3f3i7tLC8vlGbrL2IbBChcX
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

14.09.2017 18:32, Hugo Mills =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Thu, Sep 14, 2017 at 04:57:39PM +0200, Ulli Horlacher wrote:
>> I use encfs on top of btrfs.
>> I can create btrfs snapshots, but I have no suggestive access to the f=
iles
>> in these snaspshots, because they look like:
>>
>> drwx------  framstag users        - 2017-09-08 11:47:18 uHjprldmxo3-nS=
fLmcH54HMW
>> drwxr-xr-x  framstag users        - 2017-09-08 11:47:18 wNEWaDCgyXTj0d=
-Myk8wXZfh
>> -rw-r--r--  framstag users      377 2015-06-12 14:02:53 -zDmc7xfobKDkb=
l8z7oKOHxv
>> -rw-r--r--  framstag users    2,367 2012-07-10 14:32:30 7pfKs27K9k5zAN=
E4WOQEuFa2
>> -rw-------  framstag users      692 2009-10-20 13:45:41 8SQElYCph85kDd=
cFasUHybVr
>> -rw-------  framstag users    2,872 2017-08-31 16:21:52 bm,yNi1e4fsACl=
Dv7lNxxSfJ
>> lrwxrwxrwx  framstag users        - 2017-06-01 15:53:00 GZxNYI0Gy96R18=
fz40f7k5rl -> wvuQKHYzdFbar18fW6jjOerXk2IsS4OAA2fnHalBZjMQ,7Kw0j-zE3IJqxh=
mmGBN8G9
>> -rw-r--r--  framstag users      182 2016-12-01 13:34:31 rqtNBbiYDym0hP=
MbBL-VLJZcFZu6nkNxlsjTX-sU88I4I1
>>
>> I have to mount the snapshot with encfs, to have access to the (decryp=
ted)
>> files.=20
>>
>> Any better ideas?
>=20
>    I'd say it's doing exactly what it should be doing. You're making a
> copy of an encrypted data store,

With all respect - snapshot is not a copy.

> and the result is encrypted. In order
> to read it, it needs to have the decrpytion layer applied to it with
> the correct key (which is the need to mount the snapshot with encfs).
>=20

But snapshot *is* mounted implicitly as it is part of mounted btrfs
filesystem. So I can see that this behavior could be rather unexpected.

>    Would you _really_ want a system where the encrypted contents of a
> subvolume can be decrypted by simply snapshotting it?

The actual question is - do you need to mount each individual btrfs
subvolume when using encfs? If yes, this behavior is at least
consistent. If not - how are snapshots different?


--cDirKATLsa3f3i7tLC8vlGbrL2IbBChcX--

--x10DxpCVVSfKiCrrRTVNPvn7F1Ftja6Ga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlm7TNEACgkQR6LMutpd94wVZgCggwp/pZGpGs89mmL4M41df0gp
t4EAniSDvoTocmyjj7QCbN4lpXTnM8Cw
=LIqq
-----END PGP SIGNATURE-----

--x10DxpCVVSfKiCrrRTVNPvn7F1Ftja6Ga--
