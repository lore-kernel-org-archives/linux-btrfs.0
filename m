Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F00C282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 02:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBE10218AF
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 02:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="EOPSZQ9j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfDFCJf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 22:09:35 -0400
Received: from mout.gmx.net ([212.227.15.18]:38911 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfDFCJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 22:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554516567;
        bh=EJ+96HaPzqVUI3ZkekynL0S5/+g336nRPrSemoAmVjw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EOPSZQ9jTmAUj/JvqK3x3LnAiuiGesAYOICNmm7hQo1B9EDbmoxGrLBaN9N4ruWo8
         TKTKdsOrojrs7o1JveRtcLSb45LVm72u0G+h4of4Te9uQsFbOyCaKtvAu8wPuNjjmL
         F6/qQJ9jHW7A3lAxeb2r/ZEWNAhzsxgKHihNJojI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MOfcU-1hIf2W2bIs-0069KW; Sat, 06
 Apr 2019 04:09:27 +0200
Subject: Re: No way to break bio_for_each_segment_all() macro?
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        ming.lei@redhat.com
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
 <20190406020118.GL2217@ZenIV.linux.org.uk>
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
Message-ID: <a3c15ef2-84a9-e276-ff0c-f0df0ff05111@gmx.com>
Date:   Sat, 6 Apr 2019 10:09:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190406020118.GL2217@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qzoeZtSNrqlplkOeFUOY4VW7wEq3wFagd"
X-Provags-ID: V03:K1:kNMnoZXkXxvz/mBAL+DoG9DpXFpyUZ+5Eh1alDISX01puWILI7T
 E9F0XBpkdg8xs+s1AnorCG++ioAJKuJ+78ukwi8OMSwsE2h3iUud+pEN8jRySKgD/DKeV09
 kbmKTj8PkVSmuCqDbHjb6xbFCJVBr5GeZz0S69zJPPsla8rrypYl78UwufUvR08aXfbAw57
 gYh98/58spoe0gae/rL+w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0Lx8wIfqA6M=:H8AM6PLGveD8PFOVn3V0qv
 vs8xcidZIqsimMuis640BGwkz++b2NRh7yED8EDoOvz9GkNJ7d61OZYWXdN8HJICGbyvAfNNz
 WsOwiu8DZPOXvFxU+8fMNMHC+IAaGWaS/0t8WgUbOZkmmrlq62D4QcdjII0xHWeSQyI9VSTI9
 XS9pYuLKMjncD9mifh7OzEKm8ffPsyEiLB2rN1jarshGaV56ZTPSkzNDDKwCoTvwxdcHVQcOX
 gEHUyznQ+3csAlZO/nEP1n+DEmvgk28s2uMDGAKdaFmPYG+1/z7ODCiBoyDBeG2bPAkGFTmJr
 B81hQHap1u2VK3nWjEG8g69quHgHfk+jY3SJshg5Qmyr3K+RcijSTJDGZJ8Rh5xrL3En+pE6w
 B2AXLCZ9O0KuMUCeLp8HdVSU7qXSpzAMli224e03Hics9+pzsBVy+4gEOeWy46fsinBzh3FKD
 vhrMSDtae69rjDEuVj/kf1wvz2aLav+1eRhRPnkTRDGoavL0mfEWESqdd/SUP2wkSiiWTNDBO
 POjkj3VtYyUTtLh0HLbeoKrcEmMCOWt6qqyGvmepPq8qR4VBdCK2f2xyOm0x+0NlkSG5Yhh/X
 odMRFmObXUM4AzTJIMkJeHPGQt2YfYey3K3RGZ4PHYKhXpzf/3IgKoW6gLaOIoO4n0isLQj6e
 QGLrFfXx8YWAIz/zoG9RDJcwQGf/pi4idK4oJaDteng0JuphQSnPBHO5hLYYL0xa12zRdOhBe
 PLq2wJ3Z+vaRUm9LBYURJ2dbmiBuo2YesOLPf80WuZFuNICU3wVJWhwqY2QJaGw7E9qfC9Bqa
 DucxXEpvF2nCVE/fPzpuFbIN5ycCzMrTIz71NpC/aanrNDzqk72gBTkbV35GXeRClpST3qoqV
 Oofo/E/0OsULcQ71foBQfZuuj2ax2Lx1iL7GGGqswl2P6xf2iZud34fTcGr0di
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qzoeZtSNrqlplkOeFUOY4VW7wEq3wFagd
Content-Type: multipart/mixed; boundary="em07ByakKYN6mZb0IhVbjwmwf3E3FrDyz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 ming.lei@redhat.com
Message-ID: <a3c15ef2-84a9-e276-ff0c-f0df0ff05111@gmx.com>
Subject: Re: No way to break bio_for_each_segment_all() macro?
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
 <20190406020118.GL2217@ZenIV.linux.org.uk>
In-Reply-To: <20190406020118.GL2217@ZenIV.linux.org.uk>

--em07ByakKYN6mZb0IhVbjwmwf3E3FrDyz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8A=E5=8D=8810:01, Al Viro wrote:
> On Sat, Apr 06, 2019 at 09:53:07AM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> I'm looking into a strange behavior that we can't break
>> bio_for_each_segment_all() after commit 6dc4f100c175 ("block: allow
>> bio_for_each_segment_all() to iterate over multi-page bvec").
>>
>> It's screwing up all bio_for_each_segment_all() call with error out br=
anch.
>=20
>>         bio_for_each_segment_all(bvec, bio, i, iter_all) {
>>                 root =3D BTRFS_I(bvec->bv_page->mapping->host)->root;
>>                 ret =3D csum_dirty_buffer(root->fs_info, bvec->bv_page=
);
>> -               if (ret)
>> +               if (ret) {
>> +                       err =3D ret;
>> +                       pr_info("breaking out with ret=3D%d\n", ret);
>>                         break;
>> +               }
>>         }
>>
>> +       if (err)
>> +               pr_info("err=3D%d out, but ret=3D%d\n",err, ret);
>>         return errno_to_blk_status(ret);
>>  }
>>
>> Straightforward, if we break, we should have err =3D=3D ret.
>>
>> Then run fstests btrfs/151, which will trigger a false alert in
>> tree-checker:
>>
>>   BTRFS critical (device dm-1): corrupt leaf: root=3D3 block=3D5705728=
00
>> slot=3D1 devid=3D1 invalid total bytes: have 0
>>   BTRFS error (device dm-1): block=3D570572800 write time tree block
>> corruption detected
>>   breaking out with ret=3D-117
>>   err=3D-117 out, but ret=3D0
>>
>> So it looks like the break line doens't really break, but continue
>> executing.
>=20
> It expands to for-inside-for since that commit, so break only takes you=

> out of the inner loop...
>=20
> No comments on desirability of such macros - personally, I prefer to
> avoid those, but I'm not stepping into that holy war...

But it's a regression at least, not only for btrfs, but at least another
caller:
  https://elixir.bootlin.com/linux/v5.1-rc3/source/block/bio.c#L1134

At least it's a surprise for some old code.

Anyway, I'll fix the problem in btrfs.

Thanks,
Qu


--em07ByakKYN6mZb0IhVbjwmwf3E3FrDyz--

--qzoeZtSNrqlplkOeFUOY4VW7wEq3wFagd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoClEACgkQwj2R86El
/qjNZgf/dfjlU7DtsFq7OayIwsuASk/fj8TSr3vkEsuu6iI5sKxwR6+PsXdX5nAo
T6P/CidDjyLUDhBfjMaq+QspPHkUM82FKOPbhA4ydwlVHSF2V8tR0IyTt+I3iMfQ
tpVUXTPproLAt7vcbLZ87iaI6vc/1i3X1Ka5x06l8gh5O/2rjNt+PiDp9+6Vf22q
mRXbdgFQd3pg1AQRlvWXB2gsx9Ag3Gqo0tpTgKnRXwqfFbkH36lBkfEakU/1BIxt
suR/g2OkOUr8ui9gyx7ta5SAw8mP+uws8w3M70CqsadDf/J5mtnbykc95LaM9Nrp
nhyLYiMYAhrgU6KQwWne/AEQhiu34A==
=aMsi
-----END PGP SIGNATURE-----

--qzoeZtSNrqlplkOeFUOY4VW7wEq3wFagd--
