Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF79C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 07:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BB872133F
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 07:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbeLRH6y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 02:58:54 -0500
Received: from mout.gmx.net ([212.227.15.15]:37915 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbeLRH6y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 02:58:54 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Ma1Mt-1gqYZO2A99-00Ljtk; Tue, 18
 Dec 2018 08:58:46 +0100
Subject: Re: [PATCH] btrfs-progs: image: Only enlarge result image if it's
 regular file
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181218075740.23723-1-wqu@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <5e9bf391-8b4e-8d0f-c8f9-83cfc9904093@gmx.com>
Date:   Tue, 18 Dec 2018 15:58:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181218075740.23723-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lbA24ZrFZ55NCIeBt1qpszm1OF3T9LTgy"
X-Provags-ID: V03:K1:/KMpR9o0DH1eBeAGG4klEi0at33x8xs6PW8lJlb9Oa1wZR+Gp5f
 z/ZfIxECyV4wBUqYx5AuSToXWdgxM5XGKcWKC7mOGe3B91I3q5RgH+Rn/UQ7mUUb4IQzQma
 rXhas+IE2LN/Lid+C9NFFedExYumjw/xqqlaiBxKuq9lFUX1chwLQ/86a81vMBK1Sev9is1
 hut/AZexjgVMvLneEG1Vw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JlJkmI6zFm0=:0bbcxfIR7oZ3eOkVJVFeGu
 Z/Wq95fnZby3OSWih1r+zoQdPaTR+fSMQBgU5ZjbsPsZ+4tAv5Pr6b73LjGM6RAcQIr1/TSj7
 05YDwZLw7xErT2ZYU9CZwylbdpM1X0eMzLzrKZDu+zUJF3wUaXZCuG1fzs4qYf0VjNuGh+lMh
 PvTbL5JoU0Nhs6mOXTBh+HkpXQtI1sVKCae1r0hFepBnkL8Lk0H/9IOezI96xMFdady1c43KZ
 HO/AZLfdC1dAY0kBcLC41UOQuct23VIIApZUnnHLPLFDBeGn+F93ikTxG8MWegq1kdsE1gKIe
 5MZFnARszKkosG459IZprHNbAITdY3ZSmIG6cFiuo3e0gefXcNVhJpF0AKIktMNYv/UOFScJ9
 9YOy5qK05NNR58vHmrDT0KmQmhoNRihJdjMzBOa9kjIQYZqC2RrbCNwX2Ad3LeqEFEDRJfpxf
 umisa9kbRBlRYEyKDuC2fACeyyWqiDhevxrC7NfQEQ1Sh3/Ie9jm0kTzS/YpMDHBCkDoGvk7u
 dXFVR4psmIs5A/LlKNJHAn7k/t0lQFKiaiAEnfmAfiAScp/8+MWv+HDqmCgU3sNwzDR0YT6rq
 1pr1vb+ONRlym3qcI/yYqVhgVarFeY9kCebPrRQ7/CBegiSsN+Xzj2IVYb8tshkd9BmXX1JcD
 ZHoseXPYAsUcjzZwOB4OoV0Z3suvzmWbZKaCqsyXyzPwZ8IBtxpFTa6CMQpkn6y2fJNrNeCdS
 re3d0YFnC8BYUoymi30I2QHlVE/wpu3fUIA2Xhjbw73XVY7g+osPm9sAWSYRoHxeDvlpbj55w
 u3QJmujgWAXSd+uuvyeMmZS4Rnvc3jL8qG/X1UpMksQIAFlW7hLpu+/onVI3pbN8d1aQb8Gwx
 aBgMbbDYosQRQqYYed/b5c1bqJvfyERozvd4FfbDvv8q3BuQFBcVFq63c58DdB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lbA24ZrFZ55NCIeBt1qpszm1OF3T9LTgy
Content-Type: multipart/mixed; boundary="kJkiuZ5QfcJo546W4frD3FygPTw46obBC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5e9bf391-8b4e-8d0f-c8f9-83cfc9904093@gmx.com>
Subject: Re: [PATCH] btrfs-progs: image: Only enlarge result image if it's
 regular file
References: <20181218075740.23723-1-wqu@suse.com>
In-Reply-To: <20181218075740.23723-1-wqu@suse.com>

--kJkiuZ5QfcJo546W4frD3FygPTw46obBC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

This patch can also be folded into the original commit a7a44164c84e
("btrfs-progs: image: Use correct device size when restoring") in devel
branch.

Thanks,
Qu

On 2018/12/18 =E4=B8=8B=E5=8D=883:57, Qu Wenruo wrote:
> [BUG]
> misc-test/021 will fail with the following error message:
>=20
>   =3D=3D=3D=3D=3D=3D RUN CHECK root_helper btrfs-progs/btrfs-image -r b=
trfs-progs/tests//test.img /dev/loop2
>   ERROR: failed to enlarge result image: Invalid argument
>   ERROR: failed to fix chunks and devices mapping, the fs may not be mo=
untable: Invalid argument
>   extent buffer leak: start 30638080 len 16384
>   extent buffer leak: start 30408704 len 16384
>   WARNING: dirty eb leak (aborted trans): start 30408704 len 16384
>   ERROR: restore failed: Invalid argument
>   failed: root_helper btrfs-progs/btrfs-image -r btrfs-progs/tests//tes=
t.img /dev/loop2
>   test failed for case 021-image-multi-devices
>=20
> [CAUSE]
> For misc-test/021, we're using loopback device, which doesn't support
> ftruncate.
> That's why it returns EINVAL.
>=20
> [FIX]
> Only call ftruncate64() if we're operating on a regluar file.
>=20
> Fixes: a7a44164c84e ("btrfs-progs: image: Use correct device size when =
restoring")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  image/main.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/image/main.c b/image/main.c
> index cff5cc87662c..4fba8283cec7 100644
> --- a/image/main.c
> +++ b/image/main.c
> @@ -2101,6 +2101,7 @@ static int fixup_device_size(struct btrfs_trans_h=
andle *trans,
>  	struct extent_buffer *leaf;
>  	struct btrfs_root *root =3D fs_info->chunk_root;
>  	struct btrfs_key key;
> +	struct stat buf;
>  	u64 devid, cur_devid;
>  	u64 dev_size; /* Get from last dev extents */
>  	int ret;
> @@ -2147,12 +2148,19 @@ static int fixup_device_size(struct btrfs_trans=
_handle *trans,
> =20
>  	btrfs_set_stack_device_total_bytes(dev_item, dev_size);
>  	btrfs_set_stack_device_bytes_used(dev_item, mdres->alloced_chunks);
> -	/* Don't forget to enlarge the real file */
> -	ret =3D ftruncate64(out_fd, dev_size);
> +	ret =3D fstat(out_fd, &buf);
>  	if (ret < 0) {
> -		error("failed to enlarge result image: %m");
> +		error("failed to stat result image: %m");
>  		return -errno;
>  	}
> +	if (S_ISREG(buf.st_mode)) {
> +		/* Don't forget to enlarge the real file */
> +		ret =3D ftruncate64(out_fd, dev_size);
> +		if (ret < 0) {
> +			error("failed to enlarge result image: %m");
> +			return -errno;
> +		}
> +	}
> =20
>  	key.objectid =3D BTRFS_DEV_ITEMS_OBJECTID;
>  	key.type =3D BTRFS_DEV_ITEM_KEY;
>=20


--kJkiuZ5QfcJo546W4frD3FygPTw46obBC--

--lbA24ZrFZ55NCIeBt1qpszm1OF3T9LTgy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwYqLEACgkQwj2R86El
/qiooQf9G3DwUM7jM0pivFt/hPN2KNJ3xTgePS3HRlKZeP/PWlRQseDTtmwmclDW
xGvFy78oaffSqjZyjryWWNR6rN4goYQWfIGoBb/z4tz9dBCBDGyI92Z+8USfoJJU
1AuBbUBqiEf4rOz5vSjVYVZ5JifDXzO+4vitNFnEf79IVt4jlL5z4nmu1WLuwJH/
Ygqdte0C9yD+cQ0tZ+3cLZ6CgUuNjZyUtrIUXC6bSX9rtJkOA1LsCnVG8YD8KsuL
o0r8a8uPR0hPjy6WMsj7qzcFBb28BHigcHK2FfLQYWiCYzJv3uviEdnjyq60/mUk
qi5IpxKCSUqFoZnlO2YcA0oyu4659Q==
=Y45Q
-----END PGP SIGNATURE-----

--lbA24ZrFZ55NCIeBt1qpszm1OF3T9LTgy--
