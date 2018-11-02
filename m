Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26593C32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 17:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D509C2081F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 17:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D509C2081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbeKCC0U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:26:20 -0400
Received: from mout.gmx.net ([212.227.15.15]:39443 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbeKCC0T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 22:26:19 -0400
Received: from [192.168.178.27] ([109.193.14.2]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MePcd-1fuFEn3fih-00QFao; Fri, 02
 Nov 2018 18:18:22 +0100
Received: from [192.168.178.27] ([109.193.14.2]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MePcd-1fuFEn3fih-00QFao; Fri, 02
 Nov 2018 18:18:22 +0100
Subject: Re: Salvage files from broken btrfs
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
 <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
From:   "M. Klingmann" <m.klingmann@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=m.klingmann@gmx.de; prefer-encrypt=mutual; keydata=
 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
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>
Date:   Fri, 2 Nov 2018 18:18:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5SGVEnRCT9s3H3fyQx3nSj7ztE1Ufq14Y"
X-Provags-ID: V03:K1:n9yRzO3AlXkabCfD9UAtzGBNwBJYKE66W3X8fze+sb3q73hsi7Z
 0Oj5SCPXcrYAPbI5s+T/5p7na9pdPlPBTcsdCZ39sKoHTaSlKzC+3kYwEw3PgFZussXvyoS
 CMN8tTi+0OIKf/Y8NFJCXHyzJqSPDcgLBxQkNiXQV+0zHINdjYyyu6OcU3TnPH6I5Y/CuDi
 v6C0NT8k+wR6kjY6KX49w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:YF+lW4Piezg=:yE/LcowTHQ7qCtgCNf4caE
 NfZ3tahifysEblDkWzfQa0xSE8gETJXBZSHKuhb/iIJJT7zOEcl5B0nP6khfmvcd1YzT2Mldp
 n5xVRPLL50fxCi2IwJqBaQP+MkF04Q4lCTqlzFGvmOCvc+tfpANFFtFKoJG2cToxBwfLnZPjr
 MkYPhGXYmKqehO8qG0N+XZaV5Ml4pd7Dvm3bIWEK6fM9ntSPWFXTiG5S4M7ufs5JGm3K1UKd5
 ovVgHizFdIcxVztbToivNZqX2EjrpLFFNpIQvS6bhhTSbKqbeoqY5GXJZWqRSCG+Y8PHjZido
 1ul4twhkjD0lYxYhBtJpAMdeaZ1zq5Uk6zjTDdSO4dzVd8+aO2Miy8IQNBGNZersrmAu/uG5R
 BglHOzE6a4vz5+bXiEqxXtv3vsWJ3KawpItfVBZgb5/xbiWAuX2eBZjKU1l6Lx8iHk3ar8p2k
 TDiTUFpnOIbt/DclFttYS/RIBpuQ1lmid66HMBOyTRLxyIEJat+CNN4UrKVKcRzhR65Em5E4W
 orndu4oDf0vXejq8X22Wb3muh8S9zYWj7DcX8j5a7i4zRDLwcxXZDS0FFrnmShL+iHceL1gRl
 O3PaH16I4FbuULLN9AJWkCpkCcje7ybjH/KMo587RrMlwDlv6VFJMLJtiZjJszc0H4cGGOCHa
 7I6c7+45rf7m8AScJaMNbyfJd4d64dwNqYgMmcDpIG3Afcd5/wjAeoDFYxEqeN2WjuRBFB3bX
 SPeGui/CsbXODCCd6lHqvJfuiOcM+139HFD00raC1HSijCG59bJSsAFQdgxTTkJhD5jdp4Hky
 T6IjtAtU119NYjAB0tgvCOM5J14hg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5SGVEnRCT9s3H3fyQx3nSj7ztE1Ufq14Y
Content-Type: multipart/mixed; boundary="RL1MDsiyYi6uGgyYPz96MGETtJ6MrqPoO";
 protected-headers="v1"
From: "M. Klingmann" <m.klingmann@gmx.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>
Subject: Re: Salvage files from broken btrfs
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
 <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
In-Reply-To: <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>

--RL1MDsiyYi6uGgyYPz96MGETtJ6MrqPoO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: de-DE

On 02.11.2018 at 15:45 Qu Wenruo wrote:
> On 2018/11/2 =E4=B8=8B=E5=8D=8810:30, M. Klingmann wrote:
>> On 31.10.2018 at 01:03 Qu Wenruo wrote:
>>> My plan for such recovery is:
>>>
>>> 1) btrfs ins dump-super to make sure system chunk array is valid
>>> 2) btrfs-find-root to find any valid chunk tree blocks
>>> 3) pass that chunk tree bytenr to btrfs-restore
>>>    Unfortunately, btrfs-restore doesn't support specifying chunk root=

>>>    yet. But it's pretty easy to add such support.
>>>
>>> So, please provide the "btrfs ins dump-super -Ffa" output to start wi=
th.
>> Following your plan, I did 1) and 2).
>> As 2) failed (see below), is there anything I can do to find the tree
>> bytenr to supply btrfs-restore with it?
>>
>> 1) Here's the output given by "btrfs-show-super -Ffa":
>>
>> superblock: bytenr=3D65536, device=3Dsdcard.iso
>> ---------------------------------------------------------
>> csum=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0xb8e15dd=
7 [match]
[snip]
>> 2) "btrfs-find-root" yields "Couldn't read chunk root; Open ctree fail=
ed".
> It's not plain "btrfs-find-root" but "btrfs-find-root -o 5".
>
> And you should use btrfs-progs v4.17.1, not the old v4.4.
> The ability to continue search even if chunk tree get corrupted is adde=
d
> in v4.5, and I strongly recommend to use latest (v4.17.1) for a lot of
> fixes and extra debug output.
>
> If you can't find any handy way to update btrfs-progs, you could use
> Archlinux iso as a rescue OS to use the latest btrfs-progs.

Using Archlinux in fact is the easiest way to use version 4.17.1
(Archlinux for 2018-11-01).

Here's the output from "btrfs-find-root sdcard.iso":

WARNING: cannot read chunk root, continue anyway
Superblock thinks the generation is 1757933
Superblock thinks the level is 0

Here's the output using "btrfs-find-root -o 5 sdcard.iso":

WARNING: cannot read chunk root, continue anyway
Superblock doesn't contain generation info for root 5
Superblock doesn't contain the level info for root 5

> For 3), I could easily add such feature btrfs-restore, or just use
> manually patching your superblock to continue.
> So as soon as your "btrfs-find-root -o 5" gets some valid output, I
> could continue the work.
>
Thank you.

--=20
Mirko



--RL1MDsiyYi6uGgyYPz96MGETtJ6MrqPoO--

--5SGVEnRCT9s3H3fyQx3nSj7ztE1Ufq14Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJb3IbeAAoJEHhAHxjEAlI4g9UP/0sZ7kzNHlH/812pbqY9F8jI
WIuEpljJIwE9PjwbA3JEYtLEj20zinxnKLaShY4PhvCGUMu+q4i/YGWwyDyzUht1
lUY6w8O/HjRMFK/YSke/a8xWJDAR2lSGdovIF+93V4+nd6v6PcEvnV5kMFz9nu37
TC7la45H7UG2BK3kaGyB6pXPHh2bQwJq1LB//JKEhu8KPeWrH/guiysBZS7LEg7C
wmj4iw4L68aBhqv/H3IE2aewy7ygx/ja/Mek+magoFJjAATlyLH33ng1+IPvSV7G
0bosj/VFVyWDcZtsi6YPIfaafUOAK+tqVFJgkJQtOndN1/Qdhnm4pEeOQMFfbk2F
CCQckwOwGR3r2oEXv1f9isF00UxQD19xJg5za9kJ4cOKlTX08gjTGBTfVBJLtGge
hBd2WMXjhVVYi3SmWIbFZTJT9Ib3DaKZXIW91PJogsOIbeohAPitSlB0l+omh6I2
TgAlJz0wciAUSW90Uq9xHv4QFDYg/M1J4c3G1ZwZs8ud04M4k4IIWv+kSbbmFz4T
wucSJQnv1HjcvbsBd6CahbATRDdDdKaDTGGHGRVU3HIRheLKlM41iUn5nA6GYKKV
IENkmsWN8jpJtlHUH7R/KpiinjJGpNkxYose4e1S2QwOyGB4tNila/mrfXUS/qr8
BHGpEw4lMpFsCYZrLJt1
=lmfg
-----END PGP SIGNATURE-----

--5SGVEnRCT9s3H3fyQx3nSj7ztE1Ufq14Y--
