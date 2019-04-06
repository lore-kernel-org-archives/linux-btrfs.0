Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C85C282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 14:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B414C2175B
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 14:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="eggklNjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfDFOAS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 10:00:18 -0400
Received: from mout.gmx.net ([212.227.15.18]:46215 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfDFOAS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 10:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554559211;
        bh=3SLb5x5/VLbq1OX5Mq1K/7H/gpnZm+XCggnGnPh9qko=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=eggklNjhO7Z+OvQSOjw7wTImVr4zQt6tiNgRC4RU0PCJFlENWGCnYDwqUYQNrkAQF
         1ESxqcwZwTsGKnrqMXpjZZVvFGikscuGmU669H+yi1spvcDxLxiqN+MtwcwIOkyHLP
         Hub1HU2yBvA9/wPpJ7yWZzVm1EN/OuzP/m972vYw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LcBin-1gVyv634i5-00jcBo; Sat, 06
 Apr 2019 16:00:10 +0200
Subject: Re: No way to break bio_for_each_segment_all() macro?
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
 <20190406134718.GC3018@ming.t460p>
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
Message-ID: <eec127e6-e1d4-edc6-572a-92dc7e818790@gmx.com>
Date:   Sat, 6 Apr 2019 22:00:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190406134718.GC3018@ming.t460p>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Dqwoz2nzTkviyWrC29elZ61H4dVfRYawB"
X-Provags-ID: V03:K1:yPh9QcGLB7VSAN9KlgdBAgjlV++BttG9yN0hpYVYh1nz0RWhO9j
 b42pya1w/k6SCvBX1tTwj0LruAtCef8L9dFGSggNZLFQr/lhMt8gBdQKbuTe5oKlWFPutpm
 lJ1otcoQwfd9ODc2p1Joxvc4lXBpOyqRLgxFkr44zpeC1jaAfyD+aYJYIwrRg0TIZojb+Po
 ptzydA+71xvNlN+p8fpEQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZaGKYShBIFo=:U6sPo8bq2fPXWXKMzTrumH
 I55uWVVk1isyPSdM2ZvXbDChSt6F4B8OmmtWumWDzHMTSxgQl/rj88TqQK0ti13VKZwRFSG07
 EiPArH1fNFzdWMda246OdSVfsBUgonBOOPMunDCsmdqjb+AZyypa0rxyP7LDptIBR57NpVo3m
 JwBjxvL8sHkRRPWJsDGQQDwhpNF0xuptKV5TshqtkauX9sp8El83vS/Yjy6M7WfmGSJImGv2X
 NTGapFgTj4P/Rlc1goFwHs/pfH9KjTdYsnoxLKv2dzVqyBsL1qRgGK6eBgU7ll3NRFGK8QDcJ
 70Sf/MkOOH1XJFumNKrGxDhoGhhc7a2jh5D79PyX2w3UPNWTXcYfWD8gKo1wPG+wfg8IEZkKG
 BavPMQITjYtRZ2P/qhx0U+9QTToWY0wSgNNo8RNLpcDOy8cTPS5Ko/PUgNIbioYAubbYwlDb9
 VkQ0os59McA2ssVtsznVX/Ap9DtWElxfdYmFnU5GyGT3vzsH46VnY+TkC6Ztk9om0iyvsFURK
 ekM7pVKeiUGLH9jYpA4iRePk7kqcePYECvUkUCeiTJ+O+qGZqmB+J+o/V2dFux7vgpCAGbST0
 ktBVO3GHPnnH82+jVLSJQsPiHepWykGbXBcobu1woDm6nxGGlUINRsgd1dxaortl3RJVJOCRC
 UJBQGo7u2DdNNqFg5DU4Ur9aos7dyriuKQR5u0i34clUKeiw4tQb8HFjG+fhLXH4jTlopu9jw
 xvn6LJXcaGgQh8vUpC6OYd/RUAycX+RqD8J3TIntDSVh5JeEvSc9SdZk8vaH4G5ios83K+Eyh
 Gs1J2HeH2gU26s197/SYZiP8kAJybsdQWH23twMZ/RqhrHjN013YgI29nNdlVhNoRFsGfIDnx
 YHhj9YUgLegBcVjSVwwgbTbka41jecfs1eABe9JL4qAk16HS5uyTy299rxh2BO
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Dqwoz2nzTkviyWrC29elZ61H4dVfRYawB
Content-Type: multipart/mixed; boundary="Ye9Y9E8rkY0yUvPRLPtxsElfDjj496vGC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Message-ID: <eec127e6-e1d4-edc6-572a-92dc7e818790@gmx.com>
Subject: Re: No way to break bio_for_each_segment_all() macro?
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
 <20190406134718.GC3018@ming.t460p>
In-Reply-To: <20190406134718.GC3018@ming.t460p>

--Ye9Y9E8rkY0yUvPRLPtxsElfDjj496vGC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8B=E5=8D=889:47, Ming Lei wrote:
> On Sat, Apr 06, 2019 at 09:53:07AM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> I'm looking into a strange behavior that we can't break
>> bio_for_each_segment_all() after commit 6dc4f100c175 ("block: allow
>> bio_for_each_segment_all() to iterate over multi-page bvec").
>>
>> It's screwing up all bio_for_each_segment_all() call with error out br=
anch.
>>
>=20
> Please test the following patch:

It works!

Without touching the handling in btrfs part, error can break out of that
bio_for_each_segment_all() loop, just as it used to do.

Thanks,
Qu

> --
>=20
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index bb6090aa165d..7bd7e64e02f8 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -120,19 +120,15 @@ static inline bool bio_full(struct bio *bio)
>  	return bio->bi_vcnt >=3D bio->bi_max_vecs;
>  }
> =20
> -#define mp_bvec_for_each_segment(bv, bvl, i, iter_all)			\
> -	for (bv =3D bvec_init_iter_all(&iter_all);			\
> -		(iter_all.done < (bvl)->bv_len) &&			\
> -		(mp_bvec_next_segment((bvl), &iter_all), 1);		\
> -		iter_all.done +=3D bv->bv_len, i +=3D 1)
> -
>  /*
>   * drivers should _never_ use the all version - the bio may have been =
split
>   * before it got to the driver and the driver won't own all of it
>   */
> -#define bio_for_each_segment_all(bvl, bio, i, iter_all)		\
> -	for (i =3D 0, iter_all.idx =3D 0; iter_all.idx < (bio)->bi_vcnt; iter=
_all.idx++)	\
> -		mp_bvec_for_each_segment(bvl, &((bio)->bi_io_vec[iter_all.idx]), i, =
iter_all)
> +#define bio_for_each_segment_all(bvl, bio, i, iter_all)			\
> +	for (i =3D 0, bvl =3D bvec_init_iter_all(&iter_all);		\
> +		iter_all.idx < (bio)->bi_vcnt &&			\
> +		(mp_bvec_advance(&((bio)->bi_io_vec[iter_all.idx]),	\
> +				 &iter_all), 1); i++)
> =20
>  static inline void bio_advance_iter(struct bio *bio, struct bvec_iter =
*iter,
>  				    unsigned bytes)
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index f6275c4da13a..6e4996dfc847 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -48,7 +48,7 @@ struct bvec_iter {
>  struct bvec_iter_all {
>  	struct bio_vec	bv;
>  	int		idx;
> -	unsigned	done;
> +	unsigned	bv_done;
>  };
> =20
>  static inline struct page *bvec_nth_page(struct page *page, int idx)
> @@ -145,18 +145,18 @@ static inline bool bvec_iter_advance(const struct=
 bio_vec *bv,
> =20
>  static inline struct bio_vec *bvec_init_iter_all(struct bvec_iter_all =
*iter_all)
>  {
> -	iter_all->bv.bv_page =3D NULL;
> -	iter_all->done =3D 0;
> +	iter_all->bv_done =3D 0;
> +	iter_all->idx =3D 0;
> =20
>  	return &iter_all->bv;
>  }
> =20
> -static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
> -					struct bvec_iter_all *iter_all)
> +static inline void mp_bvec_advance(const struct bio_vec *bvec,
> +				   struct bvec_iter_all *iter_all)
>  {
>  	struct bio_vec *bv =3D &iter_all->bv;
> =20
> -	if (bv->bv_page) {
> +	if (iter_all->bv_done) {
>  		bv->bv_page =3D nth_page(bv->bv_page, 1);
>  		bv->bv_offset =3D 0;
>  	} else {
> @@ -164,7 +164,13 @@ static inline void mp_bvec_next_segment(const stru=
ct bio_vec *bvec,
>  		bv->bv_offset =3D bvec->bv_offset;
>  	}
>  	bv->bv_len =3D min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
> -			   bvec->bv_len - iter_all->done);
> +			   bvec->bv_len - iter_all->bv_done);
> +	iter_all->bv_done +=3D bv->bv_len;
> +
> +	if (iter_all->bv_done =3D=3D bvec->bv_len) {
> +		iter_all->idx++;
> +		iter_all->bv_done =3D 0;
> +	}
>  }
> =20
>  /*
>=20
> Thanks,
> Ming
>=20


--Ye9Y9E8rkY0yUvPRLPtxsElfDjj496vGC--

--Dqwoz2nzTkviyWrC29elZ61H4dVfRYawB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyosOIACgkQwj2R86El
/qj+AQf/a24Iw1UB5MaBI9GNKm1NVYETMatmfW3FMYhRLr67+l9Q+d0741mMnc/E
oXvfITsj8e+0IzJCA/fvton7N2q//WGlezW+SWvwJN2dfLiXNBT7ECxBRaVg9X+b
1/Q5K40WNhOEj/sPWhmF6Iws90PDg/uDlOBIyqZKigzFIOHWqyaL7AdNc6LTFQAc
PuthujUfyfSR+VN5/CeGUVIPa4bMAcsiz+i2AoE8E2TZBEXsRFplr7K1aBeJpdtV
KxhYgaLZQc7Qn2PFBOKMAxw5QIwLHK2l964wKragjs8KCUyf+DZ985A4VxHeitnH
X5Lzt5M08NQ+hK25xAQYMaNvaqsFWw==
=WvsY
-----END PGP SIGNATURE-----

--Dqwoz2nzTkviyWrC29elZ61H4dVfRYawB--
