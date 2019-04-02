Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453D2C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 00:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC15420857
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 00:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="AMqAKqhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfDBANM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 20:13:12 -0400
Received: from mout.gmx.net ([212.227.17.20]:34315 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfDBANM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 20:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554163989;
        bh=eL55Ue4cwz3wVNbEDtV8Icqv0f9ZHAqN5XburPicItI=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=AMqAKqhY49gWJmhOMFOUxw2aIYFn13MYrgEAIz7XPiQGJ1b+y6ZhmbyTwch4NIij/
         HEftLth3y003HbdJVvQzBhsxROKTlzx4s6WnCNMznbLYJz9qEJMNFP+G2ydfFwlGiO
         RekToVieaHILIN9HrSXHo/x6WkQujDBBQTfS/Zho=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MF5C3-1h8c5H1fdj-00GIQ0; Tue, 02
 Apr 2019 02:13:09 +0200
Subject: Re: btrfs and write barriers
To:     Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs@vger.kernel.org
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
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
Message-ID: <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
Date:   Tue, 2 Apr 2019 08:13:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6K2eUeudFQ6Ee3UNPeAir8dzaqKlMaERO"
X-Provags-ID: V03:K1:nqEtloa++3BhkHKnJyuSjSu7ynJbqBYYR34iA1XxmOkMF8eQ5Sp
 XFYLu9EUt43kw/XagPz6KD9mcqKx/4USsh+t5lSPVRmScpXLuKaIlJ3e4RRDj0+VUc0O+yK
 O+Y9PDV0H7Woq3q5I8U/2C1otVBOvwG4KxZ/CBXZuahdlMBVGl+SGQSigw0UuAQoJl6lhzg
 JWJAvqY2MEho4/Xt5bTiw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YmD4MH5OFig=:B5CNCJmYW3xd/XU8lrmTbi
 4qajlEhHs0gHmDX2EKdmXz7sMNH0MxuDE6tLQUWLXRKBMbgqeKnGcmMbRet+HCV8ZOYCcZbNJ
 90jChqyvXe3/94VnzGt1NEy/2QxfXjjiu0/kDEAzONPrKA2SgeHVL8O76hwyTDJH4TlHZvUOP
 RJ3vbWIp/a1XyqCRGh9rLFUtDusmqgOH6O501N3j7fyKl8X8ARKSj+4yUeNqrWcwkO+C8Ay3O
 Ivyo/WsjdyS//vpUkxyUfHWg5RE/R39a1IdubB/tzWhXCXbzJLCgJ8qd9KFuFZm8cw1ZLMgvU
 YNB947r55w2ZWjXm3fJXAp7SxrsVK/cwCHM968FpvgWWpyzQm4rQjrbYRw3abeky7GlIg+Q7W
 /diE6/HIy0GoimKkns/X21IEoelXQWLthciZaILg4FeCFs2lcb8tSSenaDv1YBMMe/Ge6lIv7
 WIzBt60a15j+RtYx+dGPynSOIBQN1P5wC1cMQL1+n3kLL6ItiuePe0GUZqbaPN8Y+XwGVBZET
 Q1IwNMN0GFTic525DCnfTSyRxTgxhObHk9w4kkEjOYZuK0XLgdixyH0g8aXrZehv5AA12P+6W
 wc879CA/LGZL7lyOpIvZfNLksN9B2KBW35d+H/ru1TsEOnWOlPoiyEtVSgDSiT+DG2T6Fxl3F
 aVKHuyzK1tYRJcp6Vo0UXDF3VKNDJ4ixrBIUf47NE/vlGyeYxDXCerAs8jTI54IRZhLUSPUuG
 ekHYHVlLrUfzEa4b1STIYCNLjogmWd4OWz+KjEH5m/U71zdT6nVes4vh4O0g5xlvQTRG98pUh
 IMhMtjt+zJGPrFYqm3Z8yQuzn3IKxzDGkxPsFaJQjARAp15gvlwpRNeOlYxqlLFWAugznSmMs
 P8FNw8pCqwUiszYb8j5GKESFRhgozKUEHNR7vja6ExM96lxV2Z/PGfX3nc1LpNAQVQnrnTouW
 M9QAqHdgDKlW0IWAtPqRkUy2JZpZ+03PT9thTfsExHtvfHDAVNUTB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6K2eUeudFQ6Ee3UNPeAir8dzaqKlMaERO
Content-Type: multipart/mixed; boundary="La7UAW8ibr1FGoxfSFJaE25HEqnwDP7d1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hendrik Friedel <hendrik@friedels.name>, linux-btrfs@vger.kernel.org
Message-ID: <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
Subject: Re: btrfs and write barriers
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
In-Reply-To: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>

--La7UAW8ibr1FGoxfSFJaE25HEqnwDP7d1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/2 =E4=B8=8A=E5=8D=883:22, Hendrik Friedel wrote:
> Dear btrfs-team,
>=20
> I am aware, that barriers are essential for btrfs [1].
> I have some questions on that topic:
> 1) I am not aware how to determine, whether barriers are supported,
> except for searching dmesg for a message that barriers are disabled. Is=

> that correct? It would be nice, if that could be determined before
> creating the FS.

That wiki line of barrier is out of date in fact.

The truth is, spec of SATA/SCSI/NVMe forces all devices to support at
least FLUSH (to flush all cached data in the controller to disk or
another persistent cache).

For the FUA (you can consider it as atomic write), if the controller
doesn't support it, kernel will emulate it by FLUSH/WRITE/FLUSH.

So even you see something like the following from dmesg:
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

It means nothing wrong. Don't panic.

In fact, for most SATA devices, libata disable FUA by default.
And all other fs is OK with FLUSH only.

> 2) I find the location of the (only?) warning -dmesg- well hidden. I
> think it would be better to notify the user when creating the file-syst=
em.
> 3) Even more, it would be good, if btrfs would disable the write cache
> in that case, so that one does not need to rely on the user

Personally speaking, if user really believes it's write cache causing
the problem or want to be extra safe, then they should disable cache.

As long as FLUSH is implemented without problem, the only faulty part is
btrfs itself and I haven't found any proof of either yet.

Thanks,
Qu

> 4) If [2] is still valid, there are drives 'lying' about their barrier
> support. Can someone comment? If that is the case, it would be even
> advisable to provide a test to test the actual capability. In fact, if
> this is still valid, this may be the reason for some btrfs corruptions
> that have been discussed here. [I did read, that LVM/Device-Mapper does=

> not support barriers, but I think that this is outdated]
>=20
> Greetings,
> Hendrik
>=20
>=20
> [1]
> https://btrfs.wiki.kernel.org/index.php/FAQ#I_see_a_warning_in_dmesg_ab=
out_barriers_being_disabled_when_mounting_my_filesystem._What_does_that_m=
ean.3F
>=20
> [2] https://brad.livejournal.com/2116715.html
>=20


--La7UAW8ibr1FGoxfSFJaE25HEqnwDP7d1--

--6K2eUeudFQ6Ee3UNPeAir8dzaqKlMaERO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyiqQ8ACgkQwj2R86El
/qgPnwf8DLwqoeV/bgkqWdBn65lGrN2Cq061Fui62qa8HaQBNnA+wJGDLsFDJSnM
F8PdAZRAbrZcv+4r7KyVvFMLb20udfKRNm5aJrpwucJotyEWukp9o5nms+DYWxNZ
M5pfrGE12jl8bpgO8SVwZZvd83GacI5fOf0ADuqvjql/+zRofzXgQEaDppyOg9Do
PYMwbJ6aTEEM3B3zmVzYb1Bnvl3yffu2K0fSXtRl4bUmRjUPuQjwSbjUd2tEVP+z
Pph0ADhL7ejG3KlfbHcHZN3M7fOTu6e6ktnb63BBaMCFOoe+1ZJsgnZG4B+f4fph
M1uX8YnsqSsDO0/KWvvmnyJL8iIcAw==
=nI7I
-----END PGP SIGNATURE-----

--6K2eUeudFQ6Ee3UNPeAir8dzaqKlMaERO--
