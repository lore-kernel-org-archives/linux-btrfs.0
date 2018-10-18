Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB1EC67863
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 23:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC952145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 23:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFC952145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbeJSHc5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 03:32:57 -0400
Received: from mout.gmx.net ([212.227.17.20]:47725 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbeJSHc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 03:32:57 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LfXmv-1foyTD3d97-00p5BG; Fri, 19
 Oct 2018 01:29:31 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LfXmv-1foyTD3d97-00p5BG; Fri, 19
 Oct 2018 01:29:31 +0200
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com> <20181018162059.GJ29418@twin.jikos.cz>
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
Message-ID: <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
Date:   Fri, 19 Oct 2018 07:29:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181018162059.GJ29418@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vdBiV5XCzAI6XE1PJ0i3g6536CbUptKi7"
X-Provags-ID: V03:K1:hAjcHjoRm+Rv7sBf3IyvZ9mmMSwlqXeG87XaJT416P/iY8JZ0Eb
 ZLjtUQBq4Hw4oVOmwLNZwb68LAZBi/jE/ZfZAkdQkfJPXp7Q7uRHCKuTlSJOUYRhmzAWo+M
 H6DVEzlfZUr5dD6Sj7FRhKiz93YlwrjtVZ2sN8wQ+zNduCJrjmZa4cb2eGifDp7z7yZMwk0
 a9QYGr3OXX94h2BMHVRUw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:BuHm1cr+OzY=:vYW/MniwoGRS/SA8DIFHcJ
 5l9E0Z3qukQGKAbeNWNmePxl8ie7AEA0sjZp+d3qMeSmfCzAOQjltEx9Y7RhFqZXZRBWj/U2p
 Uee/OfXPHwoM+LNhGsWBPbHsIKGDO4q/gwnAETXE16W/OdwAgPMcr+netBANhCrUbrpnrLFbw
 RKggNVnbfAajdTfU/E8yuZxzbiMkhTNfPpHx/7pG5U5Rv5PDiC+zM+zfyQhKONEkEA+YQFVWH
 YbuXqTtc8aCXGcb9uY6xHsNQIo8awZgcV26qpths25H0k4OdfWXtiBamWAtmebO3oB0LyKYSD
 IL5mPMunWwghsLI6Y5eQjvdNCWXfvx0wFHEKEaOWxBI6kRPIZm+Cst/hbVbSJIVME1i2ZSWqb
 TfEWhlzZAM/LGH+4b43qOHQjtMUqvOo7IeQhMwc1+zOgvK2BE7JLnXIM9oUJ4ooCMjqyizBrG
 ux3htsJ7lLvCnBuwbHSgEVzTyK5uDXJWkW8KxcAMsLjU5AtdjIQaJb4EaYD4WYI9ivCwY3ja1
 CH9PvvIkw8K5aMR7n0BuGptUhmVd1GGrhrRNMFIwCbTdnfYF+HQFtfqp3sHP0ac1G+RPL23Oc
 IfQyXqExkQF7nbI5RKKtDm/xfzyA3dzph5UVb22nBF4FhgVEtUXyf5F21/Rza0fu0kBT3MyEM
 CiGQxXky2ABygqqm4Llsi7TwI2DHOikkIjudFmHSHGzYD8spBJprC8VSKLBcMnoCmpPKOaT/y
 U1VPAM88W6WxEi6WQ2B8v7y7ADW/z1gQOQInvBUTn90z0dRJKWUkEzI54ApRAwE2F11GxT3mh
 2vPqnn7cNVNPo0wta/wUFj5DpD69g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vdBiV5XCzAI6XE1PJ0i3g6536CbUptKi7
Content-Type: multipart/mixed; boundary="mwyv09VMGVMjX3CdecUDtdvn9yUsyyO1Y";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com> <20181018162059.GJ29418@twin.jikos.cz>
In-Reply-To: <20181018162059.GJ29418@twin.jikos.cz>

--mwyv09VMGVMjX3CdecUDtdvn9yUsyyO1Y
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/19 =E4=B8=8A=E5=8D=8812:20, David Sterba wrote:
> On Thu, Oct 18, 2018 at 07:17:27PM +0800, Qu Wenruo wrote:
>> +void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root)
>> +{
>> +	struct btrfs_qgroup_swapped_blocks *swapped_blocks;
>> +	struct btrfs_qgroup_swapped_block *cur, *next;
>> +	int i;
>> +
>> +	swapped_blocks =3D &root->swapped_blocks;
>> +
>> +	spin_lock(&swapped_blocks->lock);
>> +	if (!swapped_blocks->swapped)
>> +		goto out;
>> +	for (i =3D 0; i < BTRFS_MAX_LEVEL; i++) {
>> +		struct rb_root *cur_root =3D &swapped_blocks->blocks[i];
>> +
>> +		rbtree_postorder_for_each_entry_safe(cur, next, cur_root,
>> +						     node) {
>> +			rb_erase(&cur->node, cur_root);
>=20
> https://elixir.bootlin.com/linux/latest/source/include/linux/rbtree.h#L=
141
>=20
> rb_erase must not be used on the same pointer that
> rbtree_postorder_for_each_entry_safe iterates, here it's cur.

Oh, thanks for pointing this out.

So we must go the old while(rb_first()) loop...

Thanks,
Qu


--mwyv09VMGVMjX3CdecUDtdvn9yUsyyO1Y--

--vdBiV5XCzAI6XE1PJ0i3g6536CbUptKi7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvJF1YACgkQwj2R86El
/qj6DQgAoE3rSbwZyLoINJOZO09rEchVQH/Jz+DcWFDPAmJZert8q6YsB2jKaRs8
Of3IUQICzOa8i8mPmF5oQPEuwek3Z+G4PzcTvJ6vkxmceRPklKi377KeSgTmCURY
vHi330+AT5igCE7VSDsRw9Sd8Mo1/qYzLHfGntKM1qjWgsrflc/A78s50ST6/Zh+
bCU3DNqU++oH+vI2+/nnlqIWeaTo8vQYQ9soY+UUZs6RzXT61pdYp/7tSjfB4AWq
cMjBM/AvzUvVAFyu15ks+6hzliMUBZFaFT0rFhxv+yUqTrFdWzJF1rs8+JAYgQiH
017ZS2fFSBHHtsuwiW/5KBDDXR7Jcw==
=xqMY
-----END PGP SIGNATURE-----

--vdBiV5XCzAI6XE1PJ0i3g6536CbUptKi7--
