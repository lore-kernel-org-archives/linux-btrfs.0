Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 13:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309D421874
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 13:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Nb3YVkOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfCUNpu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 09:45:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:34555 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfCUNpt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 09:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553175941;
        bh=iuXxzLPB5wybgYQ4mwGXqDm1gQbdCCzAtnYVh7XaxOQ=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Nb3YVkOZ4pIdnxN/M5m+CcpqatcRvbdfvDgEVz749SL6TZ4GlWX5Xub0nPimKZc1S
         ooBvmTCX5f0cpD+WS5rrqTkBmpKdwReZ7uCoedza958EiSwbRR30Exo499kzKcbdna
         EjeAGWYK4NV8AX0JCVuRsVxcFKF1wu/h0hG99K0Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lu2F0-1gygH01RV0-011Pz4; Thu, 21
 Mar 2019 14:45:41 +0100
Subject: Re: [PATCH v5.3 07/11] btrfs: extent_io: Handle error better in
 extent_write_locked_range()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-8-wqu@suse.com> <20190321131920.GB26179@twin.jikos.cz>
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
Message-ID: <b2c6a1db-db0c-f394-dff1-f4c0ea57b3e5@gmx.com>
Date:   Thu, 21 Mar 2019 21:45:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190321131920.GB26179@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6N614Zq7Z6EBiyeqbhB3uch0efZLooR2r"
X-Provags-ID: V03:K1:pJY2KT3PcwipMaCimluJ5GXgGpivHO3CWJTUx2hmBKYBGZZZdMl
 M7vVCbTvLHV7b5n4Rfxi0/oDx41oa+I96vfzKV4VvmrSW25N5ARRHyavP/u/la01fYPsC8V
 atkTmDshzIcGvglA7QAWgrMT4p60mIw+KPl3INr29sYyH6wi2Qp91e9w6o7ZI9PTGX6F/lL
 rlxVNxoEQ+vqOH/xnZlHw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/okDDqBOXyY=:PngcgRDQcXTO5t5r/fIQpw
 7Ygt5QS3tmWGiwdIZR0VIC/yB1V14ehYQrC04tzutz27bRx6Ht5bHBJ9cfHskj/fl5ha2oSwk
 Epw/I/HFw9BJOLTVZdFEh4tA2Fb+pWMKL49s8EdHJYQK0lM6Vpzj1X/Lu4EcJmFzO3qM3BFqu
 XDY6XYtcSiYScJDUAhSPdYBo1tBVbsULirojknR3b5npL14LSciTr3zPVRXrz1UqZXTZ4hXEs
 MPLQIyMqzsm7dq+NgTCFVOjzTWF6unxJOO2nh9ekS0nO2XnPo9hwNDeKOhNKzAzha9BNj08Iy
 zy9601xCf0mW9oYZX51hyRaQ6J34LTNOWo/BahYP0FUFxN9GOrUFGtEIqdpq4h0QHJmOjaSlK
 QNGG0WU3/mWT5vNVrlpyCvVQfChbpt89gtqxA4+pXLhJaGXSVvAJKfKatOmXmndaPqgCM/9hS
 GeXk8qMd1qu14tJM+0qk2HF1fYeb6hsYE/QectCaKJZSaLmSQICapia46sdq+ZefZRaaZJLIj
 nGjY+RQA+tO7Lu2KmjcZZvLCLA96Y4hXI/9tmEtSUUB27ETndAjq1CBVQ/EGsBFXQ4Ph8imMY
 3f5tlcC2Ejlxy3EBp0hj5B5yeyH25n8FgHlHIohxuUQbQ43FE6HKXdFlazlYADKk6nzYjpLs2
 IkaNEDim/nE1rW0YnEMNgvtIDOc52Id2PofeKPC/ekCTc3b5kWVOQ839nu1EKmV5rFKIZNTCx
 Fay9kHwBTBhJG04k6Veet0igoTFcpPi0IOy1KGic4qzj7hEIj8ZyR54MIp5AhzQ3zwlSqc4Xj
 BdRVM4uPh2aMwyJJ5DT5vTrRYIRaUyvYVsB/+hV9a57I6t9y9rgeckd49DsgJfXpaWE5QDOyb
 wtaSk4xH9G1HNF50uIc87J0fNWtWY7R/7uPd2MdbeMehgzmo4dXHxH6xxifvu5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6N614Zq7Z6EBiyeqbhB3uch0efZLooR2r
Content-Type: multipart/mixed; boundary="GCxushdqCMuA1phHckREdiZPduKjd7elP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b2c6a1db-db0c-f394-dff1-f4c0ea57b3e5@gmx.com>
Subject: Re: [PATCH v5.3 07/11] btrfs: extent_io: Handle error better in
 extent_write_locked_range()
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-8-wqu@suse.com> <20190321131920.GB26179@twin.jikos.cz>
In-Reply-To: <20190321131920.GB26179@twin.jikos.cz>

--GCxushdqCMuA1phHckREdiZPduKjd7elP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/21 =E4=B8=8B=E5=8D=889:19, David Sterba wrote:
> On Wed, Mar 20, 2019 at 02:27:45PM +0800, Qu Wenruo wrote:
>> Do proper cleanup if we hit any error in extent_write_locked_range(),
>> and check the return value of flush_write_bio().
>=20
> Yes that's what the code does, but the changelog should explain why thi=
s
> is correct. Same for "btrfs: extent_io: Handle error better in
> extent_writepages()". You do that in other patches, why not in this one=

> too?

My bad, I thought the patch implementing end_write_bio() explains why
the cleanup function is doing the same work as previous
flush_write_bio(), but skipping the bio submitting.

So I skipped the reason why calling end_write_bio() here is enough for
the error case.

> If the reason is same for several patches, then copy it, eg. btrfs:
> "extent_io: Handle errors better in btree_write_cache_pages()" is ok.
>=20
> But don't resend, I'll fix it here as I made some other fixups to
> changelogs and am finishing the whole series.

Thank you for the effort and sorry for the inconvenience.

Thanks,
Qu

>=20


--GCxushdqCMuA1phHckREdiZPduKjd7elP--

--6N614Zq7Z6EBiyeqbhB3uch0efZLooR2r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyTlXkACgkQwj2R86El
/qg9wAf/V7nM2o3rQ8LVf96Fb8Kh5GVvZaHd9+dL+eLcMUa/jwvaxddq/TCkFoh5
0oBbGyIfMftAQG1XjWWhU8SwZGnTDKl5LZg1z0Eytgt/s3+3nQH0U5vJlWqiKjGO
FpZp9FZgLwaIlRYyDd+ygd3wFc7y2fK55+Pdig1qjYU2Dk/NjJY2+/Xi9olGJCJn
FJZJthGHS4a5gwvOtqAZPBU2f9Ba6oVVvbUj9EgN1iETmp8mGt5jKXfqCWMCfaEC
RY+QMkNNTsGe5vpx7RG2m/HTbSrnpF5fR77hEuIWbCb3r6+dY/0Ap7fVGh7JoxF3
Cd6W1tjPkUv1Jg2x+4Y+pQbREZUNIg==
=5OOV
-----END PGP SIGNATURE-----

--6N614Zq7Z6EBiyeqbhB3uch0efZLooR2r--
