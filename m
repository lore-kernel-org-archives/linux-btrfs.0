Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FBCC282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 01:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C93C2146F
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 01:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="giCk7D77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfDFBxT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 21:53:19 -0400
Received: from mout.gmx.net ([212.227.15.18]:51565 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfDFBxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 21:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554515593;
        bh=BF8mvYPawszHC4P7lfGDq3DFanXe7XQKFHHezOIyPto=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=giCk7D77qhi6x6/zYZ3UxsAK8KCo98IXktf1cH79JuIjVa41YJH2C7qju95ddcftz
         lBCxLI7tCIWn/KWHGO75WcdogI//UxaGTcI/dXsZvGkVIeATNc5JwUloGO+w9c6rRh
         WoIt9p936lUAq+ZxqPqmQMoRbLx2dzkmmrXxBIMQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MEGIi-1h635E06H2-00FWLN; Sat, 06
 Apr 2019 03:53:13 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        ming.lei@redhat.com
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: No way to break bio_for_each_segment_all() macro?
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
Message-ID: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
Date:   Sat, 6 Apr 2019 09:53:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o2McdFcddTPWCMfNt0Ur0DTTOZ1AAtsnZ"
X-Provags-ID: V03:K1:ZeP6OlBJAgBHBn3/lzrZM0HHShvMFAN3JM1AHPRHlvgR5THwQHa
 rWM6XbJ+2Oj6VpNhC+9AZ4whLsRQFSfgAHPAY8NAZ8Y36ai8h63Cw10AlGTA/MQjnfVho/k
 63BSZchAy2vZdgukOcUZNKklafqJ7puoAcrabxZX2K6CAQ6tm+pCom2MU2zjr9mzmWaa+GZ
 G3u3gHjOa8aBsYIYj8hjQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:g+90SxyGnos=:znL38MtiVv6f27WZDANRij
 IkN4XKjGGRKSWE/KwTOlqhWvmK/xDMJv6WWBN0G6nCe0OowY19G/mzv7fS+ClE9Um3p5liyNl
 KHFj/59VsYJZBaPT1QabEOsZ/ZpVPefJZeTAQ9tm4yG4++iYOlQPuAK7A5ovoa/DIxRCRk3Bt
 b+20RH9RRk170UtlCQBiySDly/ytbUkc90czqsYomwagmqP7d4gJOUxfK1lVo3YriOePWHA/N
 WNkedSlku2gBtMg2xzBCtoWNlSXJGCP6lJ7lzvFjwLqjIUBR9mKG5lCofey2lVIbg1XNOLXQm
 ljh6EGKtI3urJfNywLuw5GVHv2XprZInRKNV7jXVZnOfpqhIFFN0Psq53sAisV6OI5ktb0zFQ
 QRIB9FVYdyn0Gv2KOVfwm3CKXHYuXmK8Ssxj175KLYRf06jV9FAmr6kju7TeY8V1y2wZCmoh4
 Oxg7XZGauy6784PrSwTxNez8Gor4ekqT+qPt+gpJdRt/XFdspELA7Hf6jAW5DCon/x2LKNl7E
 zkiIRLBL3vQ4az+1mrJsW0Dv4Dh/POdzC2RTCrlPtM7myqZUPKOlxRV/Vsh7UM3he7W7VwDIQ
 CLPPxDAJ0fDQyvIU6E2aqVOraSZIfcpKvNKfbh0s3hF9QLG0dnluA+c7UNDuWDxA3mt8zQXPc
 zjkgCtyAxaOvySToJhXSmM3p+z5ZLDGUzbipoInexxTJbMHBHq5aFQUAxItNoV3rMlPHujGMO
 UkO8t0XbmQJIY1xN1BcOl2nJMhsUoCytwYkEg2C0tXn5C+qyzjlx2hu5+ajqd6OtDgmm5OlMX
 y3LKJm25QCZ2xeC/WIh6/y4A+Cxz6WS7TW91ipJ4shFfPc8mgJ0KjLKuBe1iSrOs3BLHYkM4d
 VIeiaENOmPQw/AcGb0W+L0HR6w49/f3vwsOocGRX49zd2SEMw+QgBZi2boLbpt
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o2McdFcddTPWCMfNt0Ur0DTTOZ1AAtsnZ
Content-Type: multipart/mixed; boundary="apEgUZgEjsL4edQEnouqEAibX1D08IUQT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 ming.lei@redhat.com
Message-ID: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
Subject: No way to break bio_for_each_segment_all() macro?

--apEgUZgEjsL4edQEnouqEAibX1D08IUQT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I'm looking into a strange behavior that we can't break
bio_for_each_segment_all() after commit 6dc4f100c175 ("block: allow
bio_for_each_segment_all() to iterate over multi-page bvec").

It's screwing up all bio_for_each_segment_all() call with error out branc=
h.


There is one relatively easy to trigger setup.

Here is my kernel branch, which is based on David Sterb's misc-next branc=
h:
https://github.com/adam900710/linux/tree/tree_checker_testing

It's just two commits ahead.

Then some debug diff:

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c2c0640aea55..05c880a5254b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -851,16 +851,22 @@ static blk_status_t btree_csum_one_bio(struct bio
*bio)
        struct bio_vec *bvec;
        struct btrfs_root *root;
        int i, ret =3D 0;
+       int err =3D 0;
        struct bvec_iter_all iter_all;

        ASSERT(!bio_flagged(bio, BIO_CLONED));
        bio_for_each_segment_all(bvec, bio, i, iter_all) {
                root =3D BTRFS_I(bvec->bv_page->mapping->host)->root;
                ret =3D csum_dirty_buffer(root->fs_info, bvec->bv_page);
-               if (ret)
+               if (ret) {
+                       err =3D ret;
+                       pr_info("breaking out with ret=3D%d\n", ret);
                        break;
+               }
        }

+       if (err)
+               pr_info("err=3D%d out, but ret=3D%d\n",err, ret);
        return errno_to_blk_status(ret);
 }

Straightforward, if we break, we should have err =3D=3D ret.

Then run fstests btrfs/151, which will trigger a false alert in
tree-checker:

  BTRFS critical (device dm-1): corrupt leaf: root=3D3 block=3D570572800
slot=3D1 devid=3D1 invalid total bytes: have 0
  BTRFS error (device dm-1): block=3D570572800 write time tree block
corruption detected
  breaking out with ret=3D-117
  err=3D-117 out, but ret=3D0

So it looks like the break line doens't really break, but continue
executing.

Thanks,
Qu


--apEgUZgEjsL4edQEnouqEAibX1D08IUQT--

--o2McdFcddTPWCMfNt0Ur0DTTOZ1AAtsnZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoBoMACgkQwj2R86El
/qj1aQf/RrUb9WlSqSXfA5v0MyVYfkw+SEFdhvd0aqjlgaYT3aYrqcBa7LdoB/8u
c1laONQFTv3+MBZQz7+Yp2t9vCUyqvfJE4hDaw/e5Z286dlnqqm9nQBc+Vhb6AEN
BIWvpf1jfLGVUdrMotc8T8yZxDNFnXlXSF0Tr3LV98yChe032M2asgm6nUjBrnFZ
b9qXV4Vr6Z4zEb3FAlt9wxEOLHQ85FHve92gB9tPtFUiyGnon6vuHSVxaVPSU9MV
KPb8vnRifvv9E3fKjsWSdFU17IOMR1EiPmO+6LPgYOlvvh5vMEj/nPAJX9iP1d9e
qBZLFhtlkr/KqSSEEViF+FE2/0vv/Q==
=506k
-----END PGP SIGNATURE-----

--o2McdFcddTPWCMfNt0Ur0DTTOZ1AAtsnZ--
