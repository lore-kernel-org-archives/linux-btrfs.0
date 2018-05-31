Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8950 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932570AbeEaCCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 22:02:23 -0400
Subject: Re: [PATCH v2] btrfs: returns -ENOMEM if path allocation failed in
 btrfs_cross_ref_exist()
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
 <20180530064910.8724-1-suy.fnst@cn.fujitsu.com>
 <20180530153338.GF3539@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <2efb5186-ab23-dbe4-1569-c62f49acf276@cn.fujitsu.com>
Date: Thu, 31 May 2018 10:08:17 +0800
MIME-Version: 1.0
In-Reply-To: <20180530153338.GF3539@twin.jikos.cz>
Content-Type: multipart/mixed;
        boundary="------------C5DDF7820AE6C5DFE6A34A5D"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------C5DDF7820AE6C5DFE6A34A5D
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/30/2018 11:33 PM, David Sterba wrote:
> On Wed, May 30, 2018 at 02:49:10PM +0800, Su Yue wrote:
>> btrfs_alloc_path() may fail due to no enough memory,
>> so let the function return -ENOMEM instead of -ENOENT is better.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>=20
> Reviewed-by: David Sterba <dsterba@suse.com>
>=20
> Thanks. I've audited all return codes after failed path allocation, this
> was the only one not matching.
>=20
> The return code of btrfs_cross_ref_exist should be also distinguished at
> the call sites, as both places expect only the ENOENT but should not
> react to ENOMEM as if it were ENOENT.
>=20
Not quite understand the last paragraph. Is necessary to send patches to
make the two callers to distinguish ENOMEM and ENOENT?

Thanks,
Su

>=20



--------------C5DDF7820AE6C5DFE6A34A5D
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----=0A=
=0A=
mQENBFrxafoBCADL54g5EnHtuYig32iQtOWgPqZlnBDgdSD+fMxnpMr6zZ7VNT9l=0A=
Pv7BNy4lUHkWff1TbLuZQIoxYKEbmkajwg1rEjBfQ+6RBQWGzsjfprPdEC6kf6Ch=0A=
sVKrfAfJArEgEvkMOCWZE1T5wNl/mNhlWfOYWadfLTIsQCKD5D1PhD9ZgKMwulGn=0A=
OhQfeRuu/X+7zijjrpT1Nvq/Qiya/ANCq7nCu2ZTXDgQR6GSe2qgn0oVC44HKTRl=0A=
PK+47CQ8LFnKeBuTygdOpfAWUi28SCMqwkfZhGtfQQU446HJPNz/bCNRok9l9dZi=0A=
3EEyxMamd/tVmtsOBvtUrYIIIxNAOB87h1+PABEBAAG0IFN1IFl1ZSA8c3V5LmZu=0A=
c3RAY24uZnVqaXRzdS5jb20+iQFUBBMBCAA+FiEE12oP3cNSLnn02mf3AOFqSFGv=0A=
ypwFAlrxafoCGwMFCQHhM4AFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQAOFq=0A=
SFGvypwZaAf8D8gcRk4atpfgKd1nB0UuDcJNPLpzrGxQz3u2UBeNjxGUXsVsQMsy=0A=
Ln+xd/5pbC7tk5D8/+XIZGtLc3Nb0G9D6kdSHjvlpRMo3GtnDJL/kp4TPBlcXM9V=0A=
xzPmbBECdo8Th5+P66H3MNl3S0B48kDEcj5i7M0dZDOeQjKxzt8j++bwEdXVgBvM=0A=
O5W8Qnd5CxbXnjme8/qyJtup1hYAKpf8Yi9bldPM0ri+uWbLtSx8/EvCxsFFMiM+=0A=
zk1fzPqsu+lhI+lBAKR9qvH6mVCictFxA6TM7BH+lcQezHunEJDSO1obLXpjQTwh=0A=
UpU7USyzmE0hx/O2unA6imv1O1fuafCsGLkBDQRa8Wn6AQgAtxCl1ghY/W/lP66b=0A=
27rYgz8otwQ5TaLLwb83qwVOv7AOiMu16ikNcG2Fn0ePj3kv4/iYcsAIq6UHka25=0A=
4UXMdwn8j8lN7dYuuJpFBjW45mHMH9gTNspp456ftqlvgTqJtPmRmcN62IGaI5OD=0A=
/L36v7nMY5iBPecK8hIZd7BFJcBV1jntzy3XTGrvyQXx7LxqIj9uKRj1vTYTLK+9=0A=
uaQFna1+SR7XKtkUg89YObQGXDD3D8qohk9SSmpQGkPPOdC1456Vpn/5FH057W0I=0A=
UC/udC6AKsbYrlEqYihMY0/5FkpTusPOxw+LHpAwJppQ95JNsjtq22HgyFMpGFCW=0A=
bSMMEwARAQABiQE8BBgBCAAmFiEE12oP3cNSLnn02mf3AOFqSFGvypwFAlrxafoC=0A=
GwwFCQHhM4AACgkQAOFqSFGvypwMlQf+NhF3GTn+VE7MgOBJdnYkcp8QjxAJXRVp=0A=
T9QHcJj37BiNJbCxKIac35rFsPe8BaFDM+W6aqe5+zayVd2Zx771imCbimCqgtTB=0A=
/ScbarN/fgTP1sodDBuVLJmJWPIisYrX4jQx26OfbnZHNYKEHumh5+YghSnNGd6U=0A=
zS/F+k2PEQZ6rbGQeyHYNDegzq7Nieg9aNoV7qvPAwbG/9KrXBQdh+X0w1Fs/Gye=0A=
wi1vrOIWtTE2ORTJZb8y76wy6M6oOWv2PnQ0TLHM+8wTTX+dgU/IjQNO6ikqLqI8=0A=
PN8qtLmiy6GAQETDZO//XSxcpHQJVIU/+jHKZYuHJ1IMCcaC9vvjzg=3D=3D=0A=
=3DDxgD=0A=
-----END PGP PUBLIC KEY BLOCK-----=0A=

--------------C5DDF7820AE6C5DFE6A34A5D--
