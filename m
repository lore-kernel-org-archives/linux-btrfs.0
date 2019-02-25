Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D55C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE296213A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfBYMrr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:47:47 -0500
Received: from mout.gmx.net ([212.227.15.15]:33411 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfBYMrr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:47:47 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MCcja-1gorjU3Jze-009O2E; Mon, 25
 Feb 2019 13:47:39 +0100
Subject: Re: [PATCH] btrfs: Don't panic when we can't find a root key
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190225051106.22091-1-wqu@suse.com>
 <20190225122611.GO9874@twin.jikos.cz>
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
Message-ID: <de131fa7-f87e-7be9-39de-bc0475c86c7c@gmx.com>
Date:   Mon, 25 Feb 2019 20:47:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190225122611.GO9874@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="snMSzLjTttJKHMXWzyTKDAyqpWwQNDzAK"
X-Provags-ID: V03:K1:m4fBvt/Q7VrxoyL15RTec+lfon23oAB4IcwHPvqt5AP/uD8++z6
 s7rC3od5CtxAt9msQWs7er2/ej19lU2b0SEk2qaDKHqPF+b7x8KvrLyJNtekYhLQtSjGOOC
 by5nzXAFRCU/fcdJSmELndpjgHb2YMJ0pSpOvBEb5HH57S4ZG4ZUIQxOX4wuO2JVgYFM/sb
 QbubEF9QGYQsyzjMb5X6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:P+bRnyQk+8o=:HQtQmuyRuWzroIxMoP4lqY
 5h4LC2aCSMdD+u9e5TMaCeWBoW9v9S/NMzQOkHCnudzZ3g0JD4iMnxxOG30UroZGHf5U0Hvb6
 l9DM6fuhXqWPsYIzpl3qnGUhF1D07wsW/z4OVpM1uZ/YpiNmgicrtQW645YEif1YRRYNZ6Nlf
 zCpI5xteBxfOjh9xdYnDzHQbu9TRhbHPSKOxLwsObKj9to6xENZRdw1MjmG+3gyp8YznR3zf2
 OnNJzl9UN1bfKwQUNArwVr3OEo8xDZ62YQKoLh8nL291oroB/blr0oMcTruab4OYospnsTdra
 L9r8vGzDunc8U9Z54KPZbHO31owyS2ttKj4efAIMoLu3HO+PBITWW2So5nH9bkObp8o6fcIhK
 ALTHuklGBxu4NEVKcb9Xo49w2MXypcTQjpjz+JQqPhdLpT1PX1DKwIkm5SyBLnKG8xI71qRmG
 j4+mBSxIibi/+tx06MHmRD7x78AW6H7zrNmk1Sff6yIi1p4tZgVk5LZB42sE88Xn05Ar+7I/G
 lX6+j6kOZpCNTh2PAijA4Qp6I4kFI3oR4Tl3rve5FxM4R69PXDbldR0IkV0f5jkzQJsqL0zU8
 jBMSAikg/En6EVk1PFbOZw5QmsO0KpS0N6QR7dtEVZ7YwHoPuvKKOTS+0WQxcbQJnp3uO3xve
 7qX6b7KZ2HZ5m6+CjV+LeULiEkU11L60vZcktUVE80kq3/hbDSL2JhBiw9bBxujepoyB/OrGn
 LJvb0lgyw55/gnB/VoN0NP0t6NQB8WB1jU1TFRf2KizA9avo4JO91nw2/4QMZa0dEkrEPlPjI
 bx9StIyiBMK9Gw+8SpRqXLYowlr4soZE7hCsK1KiwOe+EpmJsUsFpO6H0jK8NOBCX/6ZB8A0r
 7wgWTmghGZR9Doh7CP0icEH2ZVy7Wd0hznJ78vDlBLin3CHLck8EKrEEKQBAWq
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--snMSzLjTttJKHMXWzyTKDAyqpWwQNDzAK
Content-Type: multipart/mixed; boundary="1u3uONFd0k1EPNB49WdYfqb3xOQrOU51a";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <de131fa7-f87e-7be9-39de-bc0475c86c7c@gmx.com>
Subject: Re: [PATCH] btrfs: Don't panic when we can't find a root key
References: <20190225051106.22091-1-wqu@suse.com>
 <20190225122611.GO9874@twin.jikos.cz>
In-Reply-To: <20190225122611.GO9874@twin.jikos.cz>

--1u3uONFd0k1EPNB49WdYfqb3xOQrOU51a
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/25 =E4=B8=8B=E5=8D=888:26, David Sterba wrote:
> On Mon, Feb 25, 2019 at 01:11:06PM +0800, Qu Wenruo wrote:
>> When we failed to find a root key in btrfs_update_root(), we just pani=
c.
>>
>> That's definitely not cool, fix it by aborting current transaction and=

>> return an error value.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/root-tree.c | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
>> index 65bda0682928..c48a3e18866d 100644
>> --- a/fs/btrfs/root-tree.c
>> +++ b/fs/btrfs/root-tree.c
>> @@ -137,11 +137,15 @@ int btrfs_update_root(struct btrfs_trans_handle =
*trans, struct btrfs_root
>>  		goto out;
>>  	}
>> =20
>> -	if (ret !=3D 0) {
>> +	if (ret > 0) {
>>  		btrfs_print_leaf(path->nodes[0]);
>=20
> You leave the leaf dump here, which I believe was related to the BUG_ON=

> so there's information for later analysis. This is not usually done
> where transaction is aborted and error returned. I'm not saying it's no=
t
> worth keeping it here, as the logic that would lead to this error is
> in the 'never happens' category. But we know such things happen due to
> the bitflips and random memory corruptions so a dump might make sense.
>=20
> If you think this makes sense, please put it to the changelog and write=

> a comment before the leaf dump. This will be a good pattern to follow a=
s
> there are many instances of leaf_dump/BUG to clean up or review.

I think the dump makes sense, but didn't think so deep to make it as an
example for later cleanup.

If we're going to use this as an example for later cleanups.
I won't keep it.

The message itself should be enough to locate the cause, and the tree
dump doesn't help as much as we expected.

So I'm going to remove it in next update.

Thanks,
Qu


--1u3uONFd0k1EPNB49WdYfqb3xOQrOU51a--

--snMSzLjTttJKHMXWzyTKDAyqpWwQNDzAK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxz4+EACgkQwj2R86El
/qhvWwf/ZWhkVm8DMVM/dWIll/TAcdIY/iS1SZRN+qUHtclLupHNkM66WLnUn0Ai
WCoWil1wj+Rvv3pqt+sehNnnQqG4qa5MQxeAvmTj7x/CKfJ4fVVhallvFJu+1ZTQ
472IYkDfdKT/HxNeYrdLh4ORf71jNaTYq1NLU/PhJHYBK8UZ/v+Uq2AyygQo3Lc3
IiX+56I9aq6kJHR97ru9ZXQTqzPv1JxuU9aLyaVU0eq3dvKr7XkYe/b57j5+jTMV
w/ERDuGBWqlDRlTryJ0bHPyqz6nnh5X2JMpFBF+Ckh6JPjnMcW8uoK/KTJQ6GxOW
E1lUixr7ooLbx7Ez+550G/6XAUz8Vw==
=D+tv
-----END PGP SIGNATURE-----

--snMSzLjTttJKHMXWzyTKDAyqpWwQNDzAK--
