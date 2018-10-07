Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E008C65C30
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 09:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 191C120882
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 09:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 191C120882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbeJGQy2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 12:54:28 -0400
Received: from mout.gmx.net ([212.227.15.19]:55883 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbeJGQy1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 12:54:27 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MaZWz-1gO9hc0WS1-00K6uf; Sun, 07
 Oct 2018 11:47:42 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MaZWz-1gO9hc0WS1-00K6uf; Sun, 07
 Oct 2018 11:47:42 +0200
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
To:     evan d <forumscollective@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
 <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
 <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com>
Date:   Sun, 7 Oct 2018 17:47:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gXrAiahfd8zkok7WAhzeNFd9Bg7dAPjYp"
X-Provags-ID: V03:K1:A3lpSNzTcbb0kXG/t5ZSIkXpB8xoy9yqpo2nSDyWrh/xyHgeR97
 J8Su6gm5DKdkGSReVg3P4e3PktgNEU3PwZLSkUW/1ONYSAOkYQgqkWMFFDu5qBZC8xV0OOB
 Iy5FsQ0KUSwa1+E8xtS125h9CIsGEDsxJGKuRWh0ZT8cocBSPoJqVMIp8yKejRtKTYXd15w
 13LyDqJ0yclw2PhZLzvYA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:JJxOORmm7kw=:sHgncek4fVvodcOMFHlQl3
 T/dd47S8iR+nbtX3bFLuYetu9yOu18G/voU++cbdiKdvLQXfc0kSVULt3allmp8qBDCksYIX2
 Bbw9FrGVWuwA973CeBpeMB3js4sBcv6DR31G+3Nx26+qhnK1LdQdxVMMxlHbiM4hBYicLnRaf
 dvH+3TIL8Xp2/C6Y/iVU3Bz27pqCCfiKpzH+1aIquc9qTJqXf3Rip9gpChbI3Too0GprDDuc1
 86ypFl4ioJUAp1C7YIVcyzqzslQFX4qtgVueDbX7veCjw0FM19UGFEkzRxJ03dk4XSx8XZRRl
 sUXKh4X3XzcuFlFETxVbbWJq1JdLdjKiOdVhOp+EtdVtACdSVEwMJ9POG1otNKLiviM5iWhDu
 X3Y+o/RTMY0rpm7oymiBZ84/6D7Dfyi25Qm96758kK5AtmOKX1Wx89sg+241hYN2dmVwLqKbQ
 H1rixHW2AYRqS0PFkbLfFwcVHjrU41uADPwjAd9V4ALhNs+8F9vF1nuhziR7B5J06Va/FL0Xd
 Ll4KKrpR7LUdTjWLP1TYksOKvVFBVhfuxymSGsdSxWL4FXl8Ulb13UfWsTvrOzENY6lWXXu9T
 GmcGLD2iSQ+862N60q1nB1VfLpz3lPoVxoga1QclT3Oiw4cs+rrFvaGc9wuNgDHqdZrhZ7e0i
 WMncGFaR0rRtEnlkiT8zCsZlukZiSEbqRp83es0k3TT0BAuTgCb8IqimDViIphKtJziRREISe
 NT7bcYNBwLsIHgPjdNlgHDkgE2870XULFadw/zoq4dFKMaUR84cFWq9Dt1jeTam+smPE8CXmm
 lCixblhvq5rMq3MaBz/RSRpxjwRBw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gXrAiahfd8zkok7WAhzeNFd9Bg7dAPjYp
Content-Type: multipart/mixed; boundary="6szFh5CB84XMdJC4dDgo8PooFbVcXRd4i";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
 <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com>
 <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
In-Reply-To: <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>

--6szFh5CB84XMdJC4dDgo8PooFbVcXRd4i
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/7 =E4=B8=8B=E5=8D=884:28, evan d wrote:
>>>> # dd if=3D/dev/sdb bs=3D1M of=3Dlast_chance.raw count=3D128 skip=3D2=
56M
>>>> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" last_chance.raw
>=20
> grep returns no result on either drive
>=20
>>>>> If still no hit, you could try just run the grep command on the dis=
k.
>=20
> like so?:
> grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /dev/sdc
>=20
Yes. And it will be very slow, since you're going to read out the whole
disk.

But I don't really think you would get some hit, according to current
result.

Thanks,
Qu


--6szFh5CB84XMdJC4dDgo8PooFbVcXRd4i--

--gXrAiahfd8zkok7WAhzeNFd9Bg7dAPjYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu51jkACgkQwj2R86El
/qgGzgf+PYXvXdVMSiYO7ChH6byFTOnCzp2Csg81SIxxj2OhmXrYz05RP7cERN/m
7mNyptYauUYZ+lLYfGjfU6R5FzW8qggLrjW+z7+uD0QQwhsdOeRTnBeAneSJRyki
wZEjv4eksUeuGMfwyYmGng84XnEV9DMXuEFH30tG1vN0wFGiSR4bFYoZPF5LdVlr
+53vD5w0fZLtmDRMYQdTNAFRmmlMuwiKeocM65eaa3PCDYKGWdjHD377gySTGI61
JzIgFu+xRAPKqoAjtQaeCBbHVdyROld04BLbvOWzHcFFs5H0tr/u5M1a/Y4s2EkZ
BrqIzMsmNL1hOTVOP2tw/hjhohjuMQ==
=NYpO
-----END PGP SIGNATURE-----

--gXrAiahfd8zkok7WAhzeNFd9Bg7dAPjYp--
