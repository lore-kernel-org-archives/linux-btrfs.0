Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D5CC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 23:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63D3921726
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 23:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfAVXII (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 18:08:08 -0500
Received: from mout.gmx.net ([212.227.15.15]:54459 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfAVXII (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 18:08:08 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LnPSg-1hQ7Wu31mI-00hfV8; Wed, 23
 Jan 2019 00:07:55 +0100
Subject: Re: [PATCH v4 5/7] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-6-wqu@suse.com> <20190122165554.GO2900@twin.jikos.cz>
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
Message-ID: <507b96ec-86b1-6c23-2d16-b6b67b2f5920@gmx.com>
Date:   Wed, 23 Jan 2019 07:07:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122165554.GO2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iyQ8y9CbIJIJbjKG9yAxfcwGVabdo7IVN"
X-Provags-ID: V03:K1:JFVyME0s3EBoQZZonzBg06DQzFgOQrg7Iv0gmvPSaOQYenrXDwR
 WYRDVRtKWfRn3vB8Cdwn0l4xJOIr3fXkRue/VBYfLGodSf+gequdkf+4RTlKQVUGbTPm8ji
 lMpjdJSPlPEXebCovZWSOTgruY36SbdenbLNCvPnqXFlLjHq0yDP9siUCnzpUeXS3ayJihS
 +O814pMW9GirozJyRuWOw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yvRSdKSdCB4=:2KhtajK7SsfC7qCAbbWxKB
 ffYy8y6w4tZ2sk3ONmNksUiiLU7kIodygLDbJG/vPO9WnySzEcOlPq/zHRdsfb69od5CfjcfD
 +T8OTUgb1UmyCur9ifoS35o1cGKI2uJAHJE1VTt/szzFm2bf5Tzpb7MzyxYfJ3f/kVr/0AWxE
 IAKdIlMc1mMufZ6eCV7UO6ZgyR3XBulvy3Czr0YmhZIQIWN6LA8RpKx9evuBEygfm9hwQYquf
 6XFERIKrRxJ0rvyZtYa/rWimwmjDRkRp7Sq0JOqt9ai6t6UCFH0KwrzN2mU2BG6CpPyrSnIXD
 I5EwGC7IpPXAB+6NCbq33x+B0lMeDQ0HVbMKp8vieoftdwbLsh5ExE+hqVex30XXuINjDWHC/
 0M7Wg3egpRXEJMK/IblRDc1RmsyH97KZzCQoNlFz/RpSuKzHx+dvCspQGPXq5W7Vxo/rFfAAo
 E3yZji3WfxPINZC+uFMWJIw2I8KhqNEAiWfa4i3m46kd1Sr/68wkk9l1cF/ZTiX7GGaraHd1p
 Ftjun2os6zMdrdgMxLRGiuYZoBrY0exledxW7kH+wFzFpkh/z4lrA+kQUQdVSLeYhFE9sVj+6
 GizgFRbFRzwqHQ4nKMsSGhZpqDpQOP43fS1wxoLKWXlMt3ZyyMxVnEJT1i1tWjA7985zEACVo
 KInGKWgyJmhNaMbQ1fhYUQPMoeMb9+X/Jhw0E/02+MBsn2RvOHXwVCI/FMSMNw3klzbg96cOY
 P4ZGgEdQFgxdGYy+P1Ki+LX/Q9BsssNbKIzSrG4R1T11X39bvd9nNwcTsC18EizL9mnNcruui
 R/0LG41HRDYi9D17cXCF7ZEynkAWproPgK7L9GwJouExPPEvNuxPhKSkghwlFZxBO0A/YDpN4
 1oNm6/jXYhqPmfLMJVyGqlwttCw5War8w+PJch3li4WArXBPebJMPZyCiFwiH9
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iyQ8y9CbIJIJbjKG9yAxfcwGVabdo7IVN
Content-Type: multipart/mixed; boundary="DZXFwZzssW5aBqdh4FvHhfmYD2A16ROcz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <507b96ec-86b1-6c23-2d16-b6b67b2f5920@gmx.com>
Subject: Re: [PATCH v4 5/7] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-6-wqu@suse.com> <20190122165554.GO2900@twin.jikos.cz>
In-Reply-To: <20190122165554.GO2900@twin.jikos.cz>

--DZXFwZzssW5aBqdh4FvHhfmYD2A16ROcz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/23 =E4=B8=8A=E5=8D=8812:55, David Sterba wrote:
> On Tue, Jan 15, 2019 at 04:16:02PM +0800, Qu Wenruo wrote:
<snip>
>> +
>> +	block =3D kmalloc(sizeof(*block), GFP_NOFS);
>> +	if (!block) {
>> +		ret =3D -ENOMEM;
>=20
> This goes to 'out' that marks quota as inconsistent, is this
> intentional?

Yes

> Ie. if this function does not succed for whatever reason,
> the quotas are indeed inconsistent.

If we hit this ENOMEM case, although it's possible later CoW doesn't
touch this subtree, it's also possible later CoW touches this and make
qgroup numbers inconsistent.

So we should mark qgroup inconsistent for the possibility of
inconsistent qgroup numbers.

[snip]
>=20
>> +	while (*p) {
>> +		struct btrfs_qgroup_swapped_block *entry;
>> +
>> +		parent =3D *p;
>> +		entry =3D rb_entry(parent, struct btrfs_qgroup_swapped_block,
>> +				 node);
>> +
>> +		if (entry->subv_bytenr < block->subv_bytenr)
>> +			p =3D &(*p)->rb_left;
>> +		else if (entry->subv_bytenr > block->subv_bytenr)
>> +			p =3D &(*p)->rb_right;
>> +		else {
>=20
> I've pointed out missing { } around if/else if/else statemtents in patc=
h
> 1, would be good if you fix all patches.

Sorry, it's sometimes hard to apply the same comment to older branches.
Normally I'll pay more attention for newly written code, but it's not
that easy to spot older code.

>=20
>> +			if (entry->subv_generation !=3D block->subv_generation ||
>> +			    entry->reloc_bytenr !=3D block->reloc_bytenr ||
>> +			    entry->reloc_generation !=3D
>> +			    block->reloc_generation) {
>> +				WARN_ON_ONCE(1);
>=20
> This would need some explanation why you want to see the warning.

The case here is, I don't want to populate the whole dmesg with tons of
possible backtrace from this call sites, but I still hope user to report
such error.

So I choose _ONCE() to inform user to report the error, as I don't
really see it's possible.

> _ONCE
> is for the whole lifetime of the module but I think you'd be interested=

> on a per-filesystem basis. If this is meant for developers it should go=

> under DEBUG, but otherwise I don't see what would this warning bring to=

> the users.

OK, I'll put it under DEBUG and change from ONCE to regular WARN_ON().

[snip]
>> =20
>> +/*
>> + * Special performance hack for balance.
>=20
> Is it really a hack? Hack sounds cool, but isn't it just an optimizatio=
n?

It's optimization indeed.
(But hack sounds really cool).


>> =20
>> +struct btrfs_qgroup_swapped_block {
>> +	struct rb_node node;
>> +
>> +	bool trace_leaf;
>> +	int level;
>=20
> Please reorder that so int goes before bool, othewise this adds
> unnecessary padding.

Can we make compiler to do this work?

Thanks,
Qu

[snip]


--DZXFwZzssW5aBqdh4FvHhfmYD2A16ROcz--

--iyQ8y9CbIJIJbjKG9yAxfcwGVabdo7IVN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxHokYACgkQwj2R86El
/qj5FQf9H/ZewNlUdeAiTQDUW1F8rskw62oWDJqwq3M4kEj7YQ7z/xhf9lPjKyqN
y9fgB1S+C9DfIGj5rPeDBGKQXvHoE3z6ILU4GouOovvG7BIb9/gZR5iEtrRcGluy
5gmiQPUfWVW0Q7zCaiMabUcyudlpKWz2vBkhiwjK89yTsauoiV0eP1F6h1IrKhNb
//DF0l7Rt3eCX7iDhQtHnoi/EphvwT6hncUsQn0mStxkAn7Gtx5uWPfuHbV8aV8b
UBg7G5AjgO/pUHM/4XlYcn/CCsee6TYQavn4uPMvpwtgzfvD8e/i/50SGGKGqsSC
C5lFysjNtQbt6hLnPwD6z+EgxdPKFg==
=aKlF
-----END PGP SIGNATURE-----

--iyQ8y9CbIJIJbjKG9yAxfcwGVabdo7IVN--
