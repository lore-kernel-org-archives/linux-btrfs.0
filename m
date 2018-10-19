Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D071FECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 09:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83EF821476
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 09:46:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83EF821476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbeJSRv4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:51:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:48980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbeJSRv4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 13:51:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2C31AEB0;
        Fri, 19 Oct 2018 09:46:34 +0000 (UTC)
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
To:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com> <20181018162059.GJ29418@twin.jikos.cz>
 <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
 <20181019091516.GB16290@twin.jikos.cz>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
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
Message-ID: <63697e20-9c39-da22-437d-b43612f25d3c@suse.de>
Date:   Fri, 19 Oct 2018 17:46:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181019091516.GB16290@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F2N84YK6LLJXClFdOqgwCIfCyLEVXertE"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F2N84YK6LLJXClFdOqgwCIfCyLEVXertE
Content-Type: multipart/mixed; boundary="3Cz2OiUUrvaBOVrB08XAbacoJFG2yQozq";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <63697e20-9c39-da22-437d-b43612f25d3c@suse.de>
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com> <20181018162059.GJ29418@twin.jikos.cz>
 <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
 <20181019091516.GB16290@twin.jikos.cz>
In-Reply-To: <20181019091516.GB16290@twin.jikos.cz>

--3Cz2OiUUrvaBOVrB08XAbacoJFG2yQozq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/19 =E4=B8=8B=E5=8D=885:15, David Sterba wrote:
> On Fri, Oct 19, 2018 at 07:29:26AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/10/19 =E4=B8=8A=E5=8D=8812:20, David Sterba wrote:
>>> On Thu, Oct 18, 2018 at 07:17:27PM +0800, Qu Wenruo wrote:
>>>> +void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root)
>>>> +{
>>>> +	struct btrfs_qgroup_swapped_blocks *swapped_blocks;
>>>> +	struct btrfs_qgroup_swapped_block *cur, *next;
>>>> +	int i;
>>>> +
>>>> +	swapped_blocks =3D &root->swapped_blocks;
>>>> +
>>>> +	spin_lock(&swapped_blocks->lock);
>>>> +	if (!swapped_blocks->swapped)
>>>> +		goto out;
>>>> +	for (i =3D 0; i < BTRFS_MAX_LEVEL; i++) {
>>>> +		struct rb_root *cur_root =3D &swapped_blocks->blocks[i];
>>>> +
>>>> +		rbtree_postorder_for_each_entry_safe(cur, next, cur_root,
>>>> +						     node) {
>>>> +			rb_erase(&cur->node, cur_root);
>>>
>>> https://elixir.bootlin.com/linux/latest/source/include/linux/rbtree.h=
#L141
>>>
>>> rb_erase must not be used on the same pointer that
>>> rbtree_postorder_for_each_entry_safe iterates, here it's cur.
>>
>> Oh, thanks for pointing this out.
>>
>> So we must go the old while(rb_first()) loop...
>=20
> I just realized the postorder iterator can be used here. The forbidden
> pattern is
>=20
> rbtree_postorder_for_each_entry_safe() {
> 	rb_erase();
> }

Did you mean some like this is possible?

rbtree_postorder_for_each_entry_safe() {
	kfree(entry);
}

If so, I still don't really believe it's OK.

For the following tree:
                          4
                       /     \
                      2       6
                    /  \     / \
                   1    3   5   7

If current entry is 2, next is 3.
And 2 get freed.
Then we go 3, to reach next we need to go back to access 2, which is
already freed, we will trigger use-after-free.

So the only correct way to free the whole rbtree is still that tried and
true while(rb_first()) loop.

Or did I miss something?

Thanks,
Qu

>=20
> But you also do kfree right after the erase, and the iterator is fine
> with that and rb_erase is pointless for an entry that's being freed
> anyway.
>=20


--3Cz2OiUUrvaBOVrB08XAbacoJFG2yQozq--

--F2N84YK6LLJXClFdOqgwCIfCyLEVXertE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvJp/QACgkQwj2R86El
/qj/qgf9GfbJXAkg8GZdMMhPpHg0wo8Z2Pz8n/da8f3kNziBMNdN/h/nva8dnli2
Aro3PKmmpKh/FI+KOj+4fViIQqmLVocO8sbYdE2MZ/a41OtkSMd3YPdu/dFU0Z4B
kEL3V23Uuk1zFcPCGkWhSPX7tSKOmPqanNbUgamLf37dOElr9oiCVGMkMQMDIpu3
+YGFTGUoYvyVaIXRCge6xkpMAu+0ito7iyl75LQDabuKpMc2ab/cu38SAwUtMYIy
+d8iHAtcUk5MmXHdocHodt4SazJkHHP2i7qioXgLVQ4oGk+AE79P0L3SkswFvPea
4hQwNsWDVKT4bX/Tdac/pOEFVj7NfQ==
=UoMx
-----END PGP SIGNATURE-----

--F2N84YK6LLJXClFdOqgwCIfCyLEVXertE--
