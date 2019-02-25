Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E072C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A0920842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbfBYMSJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:18:09 -0500
Received: from mout.gmx.net ([212.227.15.19]:43015 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfBYMSJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:18:09 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MFtf4-1glbsH23kM-00EsCP; Mon, 25
 Feb 2019 13:18:00 +0100
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
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
Message-ID: <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
Date:   Mon, 25 Feb 2019 20:17:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190225121540.GN9874@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q2mdy093Jbs7BsIaz18c6fWhlStrymFUc"
X-Provags-ID: V03:K1:2rod06HtjdyS6pTuJBRy5BDjt+R8PeP7yUbSVrI+yRi3j4l5eUq
 vzLQYLkDS3ts2Buy1YsvdzvJ0sydt0S1dHHU5G36j47kUeiHK5SMERpfqZGClbAh0C/odSP
 0gMK3d2zLMjklHDLfGNQ1hQfK0gucQL+GdzDEt2QV+m4S+ivDI4OVuyt3gtETHq9vytwxsw
 p14PsRQ2H/cpiF3ChECaA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tp0qMeU0Axw=:R1Lj3y/nLiS7JZTjfgdD91
 2V8JNYXBUrU5WNFCkpujWXMMlRw+RL2PkLIKfxt2MVJ7qeI8g4cSN3/FGrjuqzKqg4p5Dc/91
 /PyZRMk+1aYnqZnjkVJsuuLdnR7fmndPw4hK9a4yNkH2x5SJFmUjegh60ufw0/gR3+xmtM9OE
 jEBtD3iNu5KlkNCycHJoFq5e+pmvBEO6F9rF8ArBKtMo8QXyAsh/036JhMgmcApQOnRu+PGhA
 eLldYtKTHBydzS2uY2rKVJSPIJ43JU6YIrWCprSW//T38ydYz/j69WQZTdZtV18UPSntO//mD
 VWj7OHWe6PFd9pzkQsMmtIR3vV/OPPjtXDWPAukMoTWORh+2260LGADZ/AfHW3Cx524T54ECM
 tIlgsioWcEBQPj46ykdNioy+tkdHpieIvniVd57BclELm0fTkoiSAXPwoEmyBfGeFPUrbrNFi
 xXsqAZV88IotBp0cU/1en1oAjvazXEsUrPciJTu/4NCOLhb5GxAbm8OPVeoFhJNaoaEg2qwsd
 W1NcIIFBfUdPWD38eDVjahcqUBuKQcanCo1tqPBoIb7C77nrcyRIugRE37rkFgP0t22wSidHL
 kTJhOFj4lEmVCpgdQqehTuTXkkHxSR7yWbsJzcBcNSmePfy2WBB5vg18SsaXEKBlTD15BSwoK
 bCOf/6S09kmg4QZxCzHHCOhsYCQP/6au6WUghvZ1kDPHZ8YdOm0j/KRW5qi1sqMq3TmdDR4iD
 UCbcOw3c0f6MSobs98aMPSuzEDsolGrdmlpWsjGNIEkDljjyDXlm5YzW4YWCS1zBSZPCNN8VG
 XXoJWq3EabQXxVaGm7ioclp6afYb8MhP00t/z880c8TlHQLiE5du7mcVl7QlKgPstOAKBT9GT
 VTY9tX+tALNGOnhqcA5BuefWblGS6KmpdUMIwwTKcJE4vufCumLK+ctK8uMzNK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q2mdy093Jbs7BsIaz18c6fWhlStrymFUc
Content-Type: multipart/mixed; boundary="FhHawZu8tp1t9xM7vi4k9l7wGnF0hOxnP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 josef@toxicpanda.com
Message-ID: <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
In-Reply-To: <20190225121540.GN9874@twin.jikos.cz>

--FhHawZu8tp1t9xM7vi4k9l7wGnF0hOxnP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/25 =E4=B8=8B=E5=8D=888:15, David Sterba wrote:
> On Mon, Feb 25, 2019 at 01:50:43PM +0800, Qu Wenruo wrote:
>> All users of extent_io_tree::private_data are expecting struct inode*.=

>> So just use struct inode* to replace extent_io_tree::private_data, and=

>> this should provide better type check.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>  struct extent_io_tree {
>>  	struct rb_root state;
>> -	void *private_data;
>> +	struct inode *inode;
>>  	u64 dirty_bytes;
>>  	int track_uptodate;
>>  	spinlock_t lock;
>=20
> So this is effectively reverting c6100a4b4e3d1650deafd ("Btrfs: replace=

> tree->mapping with tree->private_data"),

That commit message doesn't explain why this is needed for btree_inode
removal.

Any idea what the extra type would be used in that case?

Thanks,
Qu

> that seems to be preparatory
> work for btree_inode removal. I haven't heared any news about that work=

> for a long time though, so if this is going to land any time soon then
> we can keep it there. Otherwise, well, ack for the patch.
>=20


--FhHawZu8tp1t9xM7vi4k9l7wGnF0hOxnP--

--q2mdy093Jbs7BsIaz18c6fWhlStrymFUc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxz3PEACgkQwj2R86El
/qhRhAf/UA/eJxQ5Aqqoi0E9pwgLcCzZwpb0j52alvK4HmrKDYq0bW379XfuRD8U
xxxW8MkvcLizyG41DJXxUDz2bpfa1ls49FtrDvYgMv35fWzul1De1r+DluoMrqX5
y/RDp0qSenNdXJzPotCvzEeEmKhB5asaDE4ActFEskFphpKJUgAsdfopqHbgFQ2M
qktFXORl9G77bIhLSkIiwg2dyWa39BvBib5LiqeJxqJ2d2eI2EzhF+8Mah+qnaOa
A525eZsOGySfT5dydo48EU8i2dqmHAT9LTHhobEgNcH/VnPxJBtVlJZf5Y+HURgt
1D8BCgKsDz9HfLF8Y/fw8OG+fSLFRQ==
=jrfk
-----END PGP SIGNATURE-----

--q2mdy093Jbs7BsIaz18c6fWhlStrymFUc--
