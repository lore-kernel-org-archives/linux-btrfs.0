Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BD0C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 00:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC4E20659
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 00:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfAOApO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 19:45:14 -0500
Received: from mout.gmx.net ([212.227.17.21]:33239 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbfAOApO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 19:45:14 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LpKY5-1hCmNO0kWT-00f7Bo; Tue, 15
 Jan 2019 01:45:04 +0100
Subject: Re: [PATCH v3.1 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190107054151.18662-1-wqu@suse.com>
 <20190107054151.18662-4-wqu@suse.com> <20190114171116.GD2900@twin.jikos.cz>
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
Message-ID: <1bbf2ba2-b259-78a0-e911-f749356f24ac@gmx.com>
Date:   Tue, 15 Jan 2019 08:44:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190114171116.GD2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="048swt3phtriHYN0Hv8F4mDUore9rj0Uk"
X-Provags-ID: V03:K1:XfSNXEK0DBnKJPBHs26L1N7wSFqPz/1EiW6hYRnPu2IFMCzDS9E
 VK5hpGePE4lsT5yZcjyCZxR8HudhBTsAEF+tvle/IMpz8zawKDJZyG0U00hXFGtsd9/QfSj
 +IpHdeFtsoWLtrj6ILLjSRUBHj6W8cHTD0pN/FleES99vnvdiby/RPCG7L+wD0C4o+DF+AE
 r3vL0HYfUGxoo63Pl7xVg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fDhferHx0dY=:I3ojm13tsDirNarAFPwlkW
 1V1/ftePh/S0b/z83xKeE68F0fuC8oixY8QORHrA8hDfVoEqQgeXZ7p7DfzuVAdLO7CkpdxGK
 QQs0+R0VCVWY6r+yCyaDTsPl7gHfRfQI/1I/Un1bmgLZXpOV+3c1Zh4gsC7PsNkNs+vqpfPln
 L+nFRyxWdfBO6Nn2UtDC5XcICYas8KELBPvUq0L9rmnenHwJHxJqzK14ymObsPzVSSJVbtPnC
 MvSVlBBaRZDa4GoIs8KFDRgxEi9gizhMUD8vHr5YcIQdvb47TqHyTKf7aHh8iYZyq+RYKIRGP
 r/lYxEeijAckOgMqMCYTtYcC7FToY7Kpbl5dBFc82C6bQAm77pJae1jpIUfZrAbOH2Fue1+Q6
 adUtnMYTomZKgf2dJ/FrcvfAJ3hsqUfBfshOEJQv84Sn7+RrVpERCmJVCDR0iNLdkoeQZmzSQ
 8wCuzD3fd/VZmEUeL3JHS5dR0YZXMxv7jSSBHUoGZ56Mku06aHstYRHZlPzsPprwM7CWih2j/
 DRD85deYR4NUvs11oqHWg+sYz2Ff4dgRzYdcVO7C1zwcH2UiDYu/wcRLjWKRWL8qUd9LLrr1c
 oUqPJU1lLo7japqXrdSjSSmS1F4d69Jqq1gCPaIbx6RaKA8hFvzPtsGKKUhYWC1BuKq6poeFl
 Kryn0tuSNweYtTy2Otz5IGt4DRLzfnhjgJam0wp4gcDHR+PbzcreyV+kSix+nmpth0etOASkt
 ZMEEm3CQWeho3yDJlR6PWPU33DXGfNE8J+6fXtKEQ13ozDNIUayIX+EgQCu1tFtqPSUXFC/XP
 zQdFFrrwtajvLl5mpkW/Nv/+4HgbdNaRh+X1Ks8XPbMxbXcqgV0giCPGN05/VEkQjcTIepgKH
 dU+v6AP+vUuotl4DIRZxauCKmWW8p0treTm9OmUQ8pIYYFEwJrOpiOfZOlGw1I
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--048swt3phtriHYN0Hv8F4mDUore9rj0Uk
Content-Type: multipart/mixed; boundary="kTdRTBYXHashRhx2iFDvAKe7sxWelvRnc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <1bbf2ba2-b259-78a0-e911-f749356f24ac@gmx.com>
Subject: Re: [PATCH v3.1 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
References: <20190107054151.18662-1-wqu@suse.com>
 <20190107054151.18662-4-wqu@suse.com> <20190114171116.GD2900@twin.jikos.cz>
In-Reply-To: <20190114171116.GD2900@twin.jikos.cz>

--kTdRTBYXHashRhx2iFDvAKe7sxWelvRnc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8A=E5=8D=881:11, David Sterba wrote:
> On Mon, Jan 07, 2019 at 01:41:47PM +0800, Qu Wenruo wrote:
>> +/*
>> + * Helper structure to keep record of a file tree whose reloc
>> + * root needs to be cleaned up.
>> + *
>> + * Since reloc_control is used less frequently than btrfs_root, this =
should
>> + * prevent us to add another structure in btrfs_root.
>=20
> The alternative is to keep that in btrfs_root and avoid all allocations=

> that also remove one failure possibility. The overall root structure
> size is over 1K already and roots get allocated from the generic slabs,=

> so quite possible from the 2K slab anyway. A few more bytes will not be=

> that expensive though the number of uses of the data would be very low.=

>=20
> Memory failures are ok for restartable operations and at the beginning
> of the operation. Imagine that relocation fails with ENOMEM after hours=

> of shuffling data just before it is about to finish.
>=20
> I think in another patch you add 128 bytes to btrfs_root anyway, so som=
e
> kind of memory consumption increas will happen anyway.

Indeed, I'll just use a list_head in btrfs_root to record this.

Thanks,
Qu


--kTdRTBYXHashRhx2iFDvAKe7sxWelvRnc--

--048swt3phtriHYN0Hv8F4mDUore9rj0Uk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw9LQYACgkQwj2R86El
/qis+Qf5AesobPVCQD0As8RNpqvhheTrSms5wv7kXRsg6Y4TlCeaObMEYEWtBmaD
f0tn8d2f96Tvf982ZxlSmLUIWyqr6ughz3utTQrChMxCbnyt/7yyUD+HGbBOrnRX
15dtKm35leU5soLKyLgsQDokQyFsS/PxDznxA1fT9if+vIz3JbOEHFuy5uaVFlH1
83JO4Rvk2iNYzmkQ1LsCFM5DVXOwln6pBMYPS2Eiki/tLX1E1RrxbdizlWL+r3Ba
Hm6a6jf4BTOfK+BJAVopvW2SUiQ/NuxtFzW9qvNy7Jq11PqNPc2lKFxN22NjpLx5
UQsHyJWSPE+lb7YKJ05mcEYsmhz1gA==
=6YIt
-----END PGP SIGNATURE-----

--048swt3phtriHYN0Hv8F4mDUore9rj0Uk--
