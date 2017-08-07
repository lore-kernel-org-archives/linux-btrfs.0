Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751683AbdHGRTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Aug 2017 13:19:36 -0400
Subject: Re: Btrfs umount hang
To: Angel Shtilianov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
Date: Mon, 7 Aug 2017 13:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DukhGGvnl81FjM5W2fTbMPwQ0QIriw1nj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DukhGGvnl81FjM5W2fTbMPwQ0QIriw1nj
Content-Type: multipart/mixed; boundary="N38K7KUF66meGjtm13C8sWROePUCw2dTT";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Angel Shtilianov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
Message-ID: <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
Subject: Re: Btrfs umount hang
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
In-Reply-To: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>

--N38K7KUF66meGjtm13C8sWROePUCw2dTT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/7/17 10:12 AM, Angel Shtilianov wrote:
> Hi there,
> I'm investigating sporadic hanging during btrfs umount. The FS is
> contained in a loop mounted file.
> I have no reproduction scenario and the issue may happen once a day or
> once a month. It is rare, but frustrating.
> I have a crashdump (the server has been manually crashed and collected
> a crashdump), so I could take look through the data structures.
> What happens is that umount is getting in D state and a the kernel
> complains about hung tasks. We are using kernel 4.4.y The actual back
> trace is from 4.4.70, but this happens with all the 4.4 kernels I've
> used (4.4.30 through 4.4.70).
> Tasks like:
> INFO: task kworker/u32:9:27574 blocked for more than 120 seconds.
> INFO: task kworker/u32:12:27575 blocked for more than 120 seconds.
> INFO: task btrfs-transacti:31625 blocked for more than 120 seconds.
> are getting blocked waiting for btrfs_tree_read_lock, which is owned
> by task umount:31696 (which is also blocked for more than 120 seconds)
> regarding the lock debug.
>=20
> umount is hung in "cache_block_group", see the '>' mark:
>        while (cache->cached =3D=3D BTRFS_CACHE_FAST) {
>                 struct btrfs_caching_control *ctl;
>=20
>                 ctl =3D cache->caching_ctl;
>                 atomic_inc(&ctl->count);
>                 prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE=
);
>                 spin_unlock(&cache->lock);
>=20
>>                schedule();
>=20
>                 finish_wait(&ctl->wait, &wait);
>                 put_caching_control(ctl);
>                 spin_lock(&cache->lock);
>         }
>=20
> The complete backtraces could be found in the attached log.
>=20
> Do you have any ideas ?

Hi Angel -

In your log, it says lockdep is disabled.  What tripped it earlier?
Lockdep really should be catching locking deadlocks in situations like
this, if that's really the underlying cause.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--N38K7KUF66meGjtm13C8sWROePUCw2dTT--

--DukhGGvnl81FjM5W2fTbMPwQ0QIriw1nj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWYihJB57S2MheeWyAQhIhA/+KSpX7URrIuFfVFgup/vbCW6dFZ2sKJlO
WrYr3XLbyp4rRC3O7Mrtc5yPyFu7zsMUc0Yrq4+ULXIOIOMGL112r9xbTfbWNLMe
HdyAhyuwVtNQ3XJOjUFbqISpxWD7AzqJFyphabd494efhz2Qhj2djQ6q9uPypwLn
pTQ7wwgH1+tGNX4DY+Rhc758nPbCj0RTBJNgz4YJIm6bolDd7aj2J4Iu2+/OANCf
oKuMDNxL8ud2OJu2Sf7RP1LvQc2iz8389Y6wHoPOu+vLEdF8F9pxGSCnWIk9/SMK
tORCygKtJgtdqBKl2xlgfYZ7jxZjQYXZW/ndqULjE6rgV5wPorJPryZCntWA5Or/
Oq+vUdXQPAFpIJQpad7wf0Y4HG7NUEpAqHiDzR6yURn4wtjtR17C+8oqxu2CPwRa
IjP7pJlbVuers1jbewEk04iOlFj9f1XV2VbbS59NBxNW1hp8m20fRZGpuTPeMXbf
A5cw/mVGSsSmHKh2JRdv9jgxjZBpIlmHm4bLgSn3dEHIWS7go+XusXO7qwxGySCF
Nk3SaxgmCWrm6eCcWSl27HR3Cg5j1uP5cgEPqRY+b6WGmGrutjjXGG/XbqqP+IeX
Y3TmrIDPpoisUBKZVJXKtoJb+1/Z4Skv8cTzQkD8UNDfrprgzR8cdDfCWaFX8gjP
xYz568vgoPg=
=hJ7e
-----END PGP SIGNATURE-----

--DukhGGvnl81FjM5W2fTbMPwQ0QIriw1nj--
