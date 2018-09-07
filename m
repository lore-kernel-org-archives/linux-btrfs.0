Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbeIGO4W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 10:56:22 -0400
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>, linux-btrfs@vger.kernel.org
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
Date: Fri, 7 Sep 2018 18:15:58 +0800
MIME-Version: 1.0
In-Reply-To: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Nr2bRojtwkAw1R0547SKDIvW8yqe6ch93"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nr2bRojtwkAw1R0547SKDIvW8yqe6ch93
Content-Type: multipart/mixed; boundary="WafStqb96ZbbgUlyY6WzLc5VB4yX16naH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>, linux-btrfs@vger.kernel.org
Message-ID: <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
In-Reply-To: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>

--WafStqb96ZbbgUlyY6WzLc5VB4yX16naH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/7 =E4=B8=8B=E5=8D=885:56, J=C3=BCrgen Herrmann wrote:
> Hello!
>=20
> I'm having a problem with btrfs send which stops after several seconds.=

> The process hangs with 100% cpu time on one cpu. The system is still
> responsive to input but no io is happening anymore so the system
> basically becomes unuseable.

Do you have a lot of snapshots or reflinked files (common for offline
dedupe)?

If so, send can spend a lot of time trying to iterate all referencers.

>=20
> I'm on linux mint 19, freshly installed on a new laptop about 6 weeks
> ago. So i wanted to compile latest btrfs-progs and latest stable kernel=

> first before reporting that here, BUT: I cannot compile btrfs-progs 4.1=
7.1
> because of the following error:

Your configure detects reiserfs support but it seems that your reiserfs
progs is not up-to-date.

You could disable reiserfs convert support by:

$ ./configure --with-convert=3Dext2

Thanks,
Qu

>=20
> =C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0 convert/source-reiserfs=
=2Eo
> In file included from convert/source-reiserfs.c:30:0:
> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No suc=
h
> file or directory
> =C2=A0#include <reiserfs/misc.h>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~~~~~~~~~~~~~~=
~
> compilation terminated.
> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
> make: *** [convert/source-reiserfs.o] Error 1
>=20
> A google search did not turn up any help nor does apt know of any
> reiserfs related libs that i could install.
>=20
> Best regards,
> J=C3=BCrgen
>=20


--WafStqb96ZbbgUlyY6WzLc5VB4yX16naH--

--Nr2bRojtwkAw1R0547SKDIvW8yqe6ch93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluST94ACgkQwj2R86El
/qg6GggAgT+FznvQYnbPbunftGiVh8+x+ZhlrxI+iRe5rCVT0jVRzNa4OBcnWbSW
tWIbU/MfNrmOf4rwxkCc+g99K4f7PTIIZepxdR4Rsk3Lq6e7WD8Ku3EfoiMJvuxq
R0IpPFrGU82BER5dWC4AyccYk/Kqo3tZnhGcowGmn+iQMpItJmSPYMEpGxSWyyDE
VQ619173aaxqJCNifIRuumsxcjZVqdt51dnQCLC6LvF8kOBUKvSePJrjIh5T7wgf
0Aru1sZ6xjO907I4rl/9J0ew/BbKcwg39pl/yYWXxM1wpgz8HNnWSID5+ybNi+QF
OpjGZOTX+l+hCYxzmVuLQBxCpOQC9A==
=bGoJ
-----END PGP SIGNATURE-----

--Nr2bRojtwkAw1R0547SKDIvW8yqe6ch93--
