Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33025 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752256AbeEOIos (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:44:48 -0400
Subject: Re: [PATCH] btrfs: property: Set incompat flag of lzo/zstd
 compression
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <cover.1526370458.git.misono.tomohiro@jp.fujitsu.com>
 <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
 <88f4d96f-e362-4b09-b436-30b3d1720e8a@cn.fujitsu.com>
 <pan$37a76$649690$3701a6f8$971fe67@cox.net>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <e9ce921a-dbb5-9558-df3f-d257c01e7fad@cn.fujitsu.com>
Date: Tue, 15 May 2018 16:50:46 +0800
MIME-Version: 1.0
In-Reply-To: <pan$37a76$649690$3701a6f8$971fe67@cox.net>
Content-Type: multipart/mixed;
        boundary="------------77F7B986FE5D9B476A5F2A7D"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------77F7B986FE5D9B476A5F2A7D
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/15/2018 04:35 PM, Duncan wrote:
> Su Yue posted on Tue, 15 May 2018 16:05:01 +0800 as excerpted:
>=20
>=20
>>
>> On 05/15/2018 03:51 PM, Misono Tomohiro wrote:
>>> Incompat flag of lzo/zstd compression should be set at:
>>>  1. mount time (-o compress/compress-force)
>>>  2. when defrag is done 3. when property is set
>>>
>>> Currently 3. is missing and this commit adds this.
>>>
>>>
>> If I don't misunderstand, compression property of an inode is only apply
>> for *the* inode, not the whole filesystem.
>> So the original logical should be okay.
>=20
> But the inode is on the filesystem, and if it's compressed with lzo/zstd,=
=20
> the incompat flag should be set to avoid mounting with an earlier kernel=
=20
> that doesn't understand that compression and would therefore, if we're=20
> lucky, simply fail to read the data compressed in that file/inode.  (If=20
> we're unlucky it could blow up with kernel memory corruption like James=20
> Harvey's current case of unexpected, corrupted compressed data in a nocow=
=20
> file that being nocow, doesn't have csum validation to fail and abort the=
=20
> decompression, and shouldn't be compressed at all.)
>=20
> So better to set the incompat flag and refuse to mount at all on kernels=
=20
> that don't have the required compression support.
>=20

Get it.
As your conclusion, it's indeed better to set the incompat flag.

Thanks,
Su



--------------77F7B986FE5D9B476A5F2A7D
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

--------------77F7B986FE5D9B476A5F2A7D--
