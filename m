Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:45219 "EHLO
	omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbcBZWOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 17:14:06 -0500
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs sub-volumes
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <56D0BCFC.5020302@suse.cz>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com> <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com> <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz> <56D0B007.2050106@gmail.com> <20160226203010.GD17997@ZenIV.linux.org.uk>
 <56D0BCFC.5020302@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1456524057_2415P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Fri, 26 Feb 2016 17:00:57 -0500
Message-ID: <52677.1456524057@turing-police.cc.vt.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--==_Exmh_1456524057_2415P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Feb 2016 22:00:44 +0100, Stanislav Brabec said:

> Well, it seems to be safe, even if the loop device was not allocated by=
=20
> mount(8) itself, as
> ioctl(fd, LOOP_CLR_FD)
> never returns EBUSY:

The fact you don't get an EBUSY doesn't mean it's actually safe....

--==_Exmh_1456524057_2415P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVtDLGQdmEQWDXROgAQLILQ/+PNCFSQDnMpcHHxQeulLX6xgnq3xKSv3I
YQIgsZHtBW8KK7b6Hty9/VwmQXWGXC8L5PAG8NNT0nSU3VNmeY/EYEdvpmkGP6Zn
tMrZgLMQeULqkxVo5ELAWfgXiB2Zec3/PjGNJey9PG+fzkQBv0/u2Mx0UiNH7txE
Izy5gci+Le4E9DEWaXyWapxjKOiOztV5KJf1MuPQDG6gYV4BB0Gb0zvXq3z4jpNi
ZkdM/JIKbP3vPYt5UmBRSrMa2N6WnelEgNrY69Au5LrOebJ/c8rPo62LBjbbnvNN
A3kL0UErG2/Dv/sf1kbto1OXFo95HpfJwZZzjfBTTibEZVjHtjT9R06GhXxLlyu3
7KkQ4hJxVLwDASn+pMuI8yfb5jdeLjB7Z5QNEHF70s5DaoYdfCEkVvbqEWQ47aS/
HGxASGDy5XjbTf9BFlq5xOJ+FeFpwq9ntaYl6sNPDISaujbv+ajE6wj5CJPc0H6Q
jtjaUjoyeBaqbO3zKuWZ6dd4ixLvWqigRNaPl/jjhR/LLg2XKqyvaOrIW3JBZaNA
MAk1lW1q8/sLIlyG9fhiu32SLKl9HFAick2kV1Vbj8KVPu+SQc+UXKM9RzET++WQ
RxYKGLO2dETUmGavQaN8vN63gzJCLIC7/Vfvt6Rs1L8zNF4n9u4N7sAqMkNbJVMi
j2vbjnA/4rM=
=LG2F
-----END PGP SIGNATURE-----

--==_Exmh_1456524057_2415P--
