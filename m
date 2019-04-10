Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9873C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 689A02083E
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="lKNI1Vw0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfDJHsK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:48:10 -0400
Received: from mout.gmx.net ([212.227.15.18]:52309 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfDJHsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 03:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554882457;
        bh=rAiKQfyFbPBDFRsTRtlzHByJaJE7qMmOU5jsoorPtUY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=lKNI1Vw0FWmNZ+Na9M4zH8gtX982su8uAlGI443wPxWMl6W5EA9PiRz2mQLraUQXa
         5kwTGV/KyLggLEJ/nw61isrVkLCmxsObzMuLFht//jHb2ViXQrde3kNmEyTCCFVHHe
         u8J0B92gUEZw8OLlENvHDUGHuY9dudJRaAVzqaDU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LtIdP-1gll2p2r0d-012nM6; Wed, 10
 Apr 2019 09:47:37 +0200
Subject: Re: [PATCH v3 1/2] block: Add new BLK_STS_UCLEAN status
To:     Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190410074149.26646-1-wqu@suse.com>
 <20190410074420.GA23039@infradead.org>
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
Message-ID: <c9b92afa-5b99-2c05-3fc2-fb645be29256@gmx.com>
Date:   Wed, 10 Apr 2019 15:47:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190410074420.GA23039@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aClOsa4J28L3ZPDZc62X2IQELcgpkn3Aa"
X-Provags-ID: V03:K1:UuHtsUln+xa0Mv8q4CCEI1FhI22V9j+7bNqIyHu0OAZyxzxH0/M
 rUk/uH+5btM3Gi7Wrjdk+HPy+cCX7IiF0OOBzoePKT4XdWZeZdeZq2uk5yFjAjQzR20CpxZ
 Ow1UbWAfe+F+nXcUeITcS6vItHmzteu8Jl+26dkSXtO48+8k+zym2lexB9iqrD0WSuOLvFA
 x0Qx9RBdZMVcmdPT9iKdw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pNWLLHk6ZWw=:UFsQLGOwz+CgQ+OrBq6as5
 w7dNQkjSQrO036pdfMs2x31PgJQfBcvYMRUHivr13JERANhaU5OBdLvEpdXES5emsXsDBQkvW
 zHvN64hfzrp8zwfx/O4rFZo6Z779J7OnsN/ADPWBOvZaJsORyswKe69egoQMLc62N9WZHwIJA
 o8NPxL5w7KfhRUMtBvXnZHtd9CQ9BUyLRjwUs2HhjqST3GN0728fiEEMymTkKv+GUZ5AAXpyB
 MvMlqi64AywQTQJSBvBV9KQsuCOcZj4RQSC7wotoYX/l3PqKihc5EB2SLRHUyY1D5P8MG4fSR
 rnlcM/Y3tltETf58by7IK0LpK5uWiNW9v5RqZPBuQ6V1Ae8ZC9W5X9oZTAqlJIYzLgMKYMove
 BaPrNuPTYYEy4YYVFo8bgGurk5KzNwiwVGcXFKSVlnUW6jSWmeM4cduWI0+SAeCfoCf8jS+qX
 u7rhr7V/6I1Ifk68+fRxFF9Vc4XVElYqNhzvwXEQUQF/1eyngFnqx4p1GO4kGeLadAYFvCAnY
 mh5GcGpk8a5XtHl9aRPhtSzPWoJiqhg3gpuaSCZ0v8OKyWvtiBetRC0ugBo3FX7GeNQ4ZO7ry
 3lobxac9BxoE0flNt/DlCeVt8N6eUUcjK7kb3Ix29toqIRH8D0tbsPbIB+Yme6lfcwz2rJjrL
 XrWosuiMjFTo1WsQH2cg0EmFr/50MA2s62KBPV0yHOZPds8AcOcaDlyIiiW4LvLtnOYnRMI4g
 j6tteaoKvHkBlKmn+U3IyFSS/L23PrZ7X3/gQo5NSDZnWx7vFOPkHH0nFf04GNWVkBMb3TZAL
 uoxiCC1AGvzhcU4vVDHg5Wfh7pG5i1yUDCrdnIjml9kAS9o25TGFF2eOmcPo3xNAiZEZZkANg
 QcItt9DkSGpW/uvFy0kN0/2AvJ/AXJjzg6AOyd0kWlC5/lpf8YxrCWkZsw73Ks
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aClOsa4J28L3ZPDZc62X2IQELcgpkn3Aa
Content-Type: multipart/mixed; boundary="h5R4ZkpkaDzGQArkfSxhi1i9oWM8W8IGT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c9b92afa-5b99-2c05-3fc2-fb645be29256@gmx.com>
Subject: Re: [PATCH v3 1/2] block: Add new BLK_STS_UCLEAN status
References: <20190410074149.26646-1-wqu@suse.com>
 <20190410074420.GA23039@infradead.org>
In-Reply-To: <20190410074420.GA23039@infradead.org>

--h5R4ZkpkaDzGQArkfSxhi1i9oWM8W8IGT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/10 =E4=B8=8B=E5=8D=883:44, Christoph Hellwig wrote:
> Please keep linux-block and fsdevel in Cc.
>=20
> Also as mentioned before UCLEAN is a horrible name, please use
> the FSCORRUPTED one actually in use in the file systems that
> actually describes what is going on.  Bonus points for also
> moving the EFSCORRUPTED definition to common code.

Then the problem is, if we're keeping EFSCORRUPTED, should it still be
the same value of EUCLEAN?

Or it's pretty common to have same error value while have two different
name for it?

Thanks,
Qu


--h5R4ZkpkaDzGQArkfSxhi1i9oWM8W8IGT--

--aClOsa4J28L3ZPDZc62X2IQELcgpkn3Aa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlytn5MACgkQwj2R86El
/qj84wf9GK5tLElalZafVSBb+rGdVpATaclHDyHR2hkcW6ueJGXepSVlr1GdNDNR
hTMnwnCCj08xUJ0e4KHQLXuARPKw6wEqxbAdxaDqNiKZVfXgCcDTwT7OSsBlrjoK
97506vi7WsUbJZ466YVr1NzX7kgbITftbWRtIShhvyFE4DChTLyfgsYntgtuvoKK
Xc5GfIBqTZHZ8h2afJlSut3VwmAmLDFE4uj4EI0GVKIY8fZnQBpQked3FMowoGfh
u0sqhqeOYul6n//Yw2cDJx5PiLsuyMEhZuJS/AfAIIJOZrQmFGnJepr7j1SFpfKF
ggqdCYLR7VTMrYmLiEUTR+PQ6A81XQ==
=KA6N
-----END PGP SIGNATURE-----

--aClOsa4J28L3ZPDZc62X2IQELcgpkn3Aa--
