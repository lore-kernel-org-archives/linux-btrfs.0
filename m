Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09A5C282CB
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 00:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 661662175B
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 00:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfBFAWY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 19:22:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:50375 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbfBFAWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 19:22:24 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MCtLD-1gzfYU1jpT-009fhJ; Wed, 06
 Feb 2019 01:22:14 +0100
Subject: Re: New hang (Re: Kernel traces), sysreq+w output
To:     "Stephen R. van den Berg" <srb@cuci.nl>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
 <20181228150016.GB13717@cuci.nl> <20190123155046.GA8995@cuci.nl>
 <20190125080137.GA27316@cuci.nl> <20190205221802.GA30715@cuci.nl>
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
Message-ID: <db1081bb-d8c4-0ad4-104f-e22d5acce3b4@gmx.com>
Date:   Wed, 6 Feb 2019 08:22:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190205221802.GA30715@cuci.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C4CEZ1UANWNfdioxc2h6i79ADxD8htL7h"
X-Provags-ID: V03:K1:igh6F+6oc0Rn6qcG/lALkbU9tWoPHchTCZnJjcte+bSgEqDUBjI
 GTqb7pIgfv/NSjtcUSLJTmsUZHwUY6njEy9TZ3gk69R25qZ3BL9Tncg02VRe7hC0QB/Zueo
 hN4rsebbeCgAlKjgtYjslOswYZcZZq6KYLA+plPpsbUWvndPe9h76i0jK1DtCCRGcBf8Msj
 gYu9kpVOqzddYmoOAaPOg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DulKHkeTdwc=:uIiN9b0z0sUET2oQp9BG3y
 UInkGiEs21NqEde/V8fTAI81dibyXA1WKHg9/6ukEArr5s0mDQGUoQ7v7NeGdGwkCy8J+Rpe1
 dHkUOAdrZ+pIGgyjFdokd40TucThjL2VilcHnJgdywncEl7q2gYemebm05Njm3l3vfAo9CgtI
 8oKbl/zB+av+8oBDJ//8bq5HRViU7wUNDRFV2hHnR7UqiqbLdC6QtIgJyggH0O5LuCCEIeZ9d
 eAbHeT7sZCjuYuCXF/FU/UUgOSsJdme0JIAW/AfEtdD3vKLCf+YOS0FFKhCyzs2/+YExfMlYK
 jlWk/Can9njBDJBIthhS5NosZGpQG/eldK4mK20NJcDRSXcNHi/cxUCnhmJ5f+VYHQ7jpLMLe
 9Pm2M9j4T4BZ9JF5PLYYWRa78RrVgQbv7sJqVq8Bu9enKfcXqXyNc20JNusflcMkDyqYaw5b/
 oeTfp3gvyOXJPE/cdpXNnKB/VNe6dHzfF0ojeltjVq4ctbv2s/iLUwCr2z/A1NLwA8jBcHYNR
 NxwMvg3HPRa6dv1MwiQJaDTDwa7VmnocdSQT7ii+DlQUkBIprbyDWovvo/p5TDRW6+KtBq87l
 GYtxz5YDWTMrIOQlh73aof2p66eD8a4GFRMComfGwtmpzEgUzsYIBEPR0Uuh7QK8oybh7XaCb
 4q+2IIvhTpwHAkbRi5LQMh2jx/Y1pwEc5C9o8UOEwwKyHn8pYV2zsixQEFBMl+AY1r1lCd+Mh
 jfN1wsXzFrs3ZmfB6rBEWa8KtxhCI9IUFjUYVsEX6qgc5gteR4PgUJlsqc4tq4NnbCEk7R9E5
 0KCIv3mCKAv1lI9kaIHWMEEDUnMfRsPaof1tK4XxN7tadIQ8fiHJctbi7qoSqd3kFj/SE6TH6
 UmRkanRd5IH1M6ca27bs0qFpNnxPHXCg+Jy5AeBiMeR7QkJCgmvHgMHafoAKt5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C4CEZ1UANWNfdioxc2h6i79ADxD8htL7h
Content-Type: multipart/mixed; boundary="zj4c7YBFAjgENshijZNoVd92JUioFNr57";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <db1081bb-d8c4-0ad4-104f-e22d5acce3b4@gmx.com>
Subject: Re: New hang (Re: Kernel traces), sysreq+w output
References: <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
 <20181228150016.GB13717@cuci.nl> <20190123155046.GA8995@cuci.nl>
 <20190125080137.GA27316@cuci.nl> <20190205221802.GA30715@cuci.nl>
In-Reply-To: <20190205221802.GA30715@cuci.nl>

--zj4c7YBFAjgENshijZNoVd92JUioFNr57
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/6 =E4=B8=8A=E5=8D=886:18, Stephen R. van den Berg wrote:
> Are these Sysreq+w dumps not usable?
>=20
Sorry for the late reply.

The hang looks pretty strange, and doesn't really look like previous
deadlock caused by tree block locking.
But some strange behavior about metadata dirty pages:

This looks like to be the cause of the problem.

kworker/u16:1   D    0 19178      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40

But I'm not familiar with balance_dirty_pages part, thus can't provide
much details about this.

Thanks,
Qu


--zj4c7YBFAjgENshijZNoVd92JUioFNr57--

--C4CEZ1UANWNfdioxc2h6i79ADxD8htL7h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxaKLEACgkQwj2R86El
/qhD1Af+M8hCwfZad4Iad4ZhmqG6Op51fA5M6zeWIBROjKN5rVL52CWpE/i5Na+r
5ZghxsQ1RGhQviuti/ms4EDWikt/RVJiiIs5dqIHhhJknv1PPUkEBZpftf73HYdo
cD5uykbzWpcF7qpA9nz74Vae/+N21Ht8RGpWAPv7cLpZXbI4i8OajkGjloqDap4N
KuKqgDi/6xptetLaYjntF8aQcNdZ4m9+KoTvGFilRpz6SDEGxHdzOgy20xMWoo3C
OrdAEcQA/YZD4Mr15Wa88UrEhzrdHZISgCq89WtGX7yGF1WrjGbEkMV31I5HF70Y
T9cU0z4VLxOxLAnpZzoMAUVibIh3gQ==
=hwP5
-----END PGP SIGNATURE-----

--C4CEZ1UANWNfdioxc2h6i79ADxD8htL7h--
