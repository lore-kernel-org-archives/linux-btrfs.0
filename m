Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EF3C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD30206A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfBUOVL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:21:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:42556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725820AbfBUOVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 09:21:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F18DB183;
        Thu, 21 Feb 2019 14:21:09 +0000 (UTC)
Subject: Re: [bug report] btrfs: locking: Add extra check in
 btrfs_init_new_buffer() to avoid deadlock
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190221141347.GA20330@kadam>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <cef05cfd-2fdd-3c27-39d2-15d35b61d64a@suse.de>
Date:   Thu, 21 Feb 2019 22:21:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190221141347.GA20330@kadam>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1GkfEK7Wx4qB9n2LAKCUdQWD376fPIf0B"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1GkfEK7Wx4qB9n2LAKCUdQWD376fPIf0B
Content-Type: multipart/mixed; boundary="OXKofnd9cBXyiE4L5BPSU9UJtwOG0PnbI";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <cef05cfd-2fdd-3c27-39d2-15d35b61d64a@suse.de>
Subject: Re: [bug report] btrfs: locking: Add extra check in
 btrfs_init_new_buffer() to avoid deadlock
References: <20190221141347.GA20330@kadam>
In-Reply-To: <20190221141347.GA20330@kadam>

--OXKofnd9cBXyiE4L5BPSU9UJtwOG0PnbI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/21 =E4=B8=8B=E5=8D=8810:13, Dan Carpenter wrote:
> [ This one is not actually your fault.  It's the core code which is
>   confusing.  -dan ]
>=20
> Hello Qu Wenruo,
>=20
> The patch b72c3aba09a5: "btrfs: locking: Add extra check in
> btrfs_init_new_buffer() to avoid deadlock" from Aug 21, 2018, leads
> to the following static checker warning:
>=20
> 	fs/btrfs/extent-tree.c:8556 btrfs_init_new_buffer()
> 	warn: possible NULL dereference of 'buf'
>=20
> fs/btrfs/extent-tree.c
>     8540 static struct extent_buffer *
>     8541 btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct=
 btrfs_root *root,
>     8542 		      u64 bytenr, int level, u64 owner)
>     8543 {
>     8544 	struct btrfs_fs_info *fs_info =3D root->fs_info;
>     8545 	struct extent_buffer *buf;
>     8546=20
>     8547 	buf =3D btrfs_find_create_tree_block(fs_info, bytenr);
>=20
> The btrfs_find_create_tree_block() function either returns
> alloc_test_extent_buffer() which returns NULL on error

You caught me!

Indeed that's a possible NULL return case.

The only good news is it shouldn't affect release build which normally
doesn't enabled CONFIG_BTRFS_FS_RUN_SANITY_TESTS.

I'll fix it by unifying the return pointer.

Thanks for pointing this out,
Qu

> or
> alloc_extent_buffer() which returns error pointers on error.  It
> confuses static checkers and me also.
>=20
>     8548 	if (IS_ERR(buf))
>     8549 		return buf;
>     8550=20
>     8551 	/*
>     8552 	 * Extra safety check in case the extent tree is corrupted an=
d extent
>     8553 	 * allocator chooses to use a tree block which is already use=
d and
>     8554 	 * locked.
>     8555 	 */
> --> 8556 	if (buf->lock_owner =3D=3D current->pid) {
>     8557 		btrfs_err_rl(fs_info,
>     8558 "tree block %llu owner %llu already locked by pid=3D%d, extent=
 tree corruption detected",
>     8559 			buf->start, btrfs_header_owner(buf), current->pid);
>     8560 		free_extent_buffer(buf);
>=20
> regards,
> dan carpenter
>=20


--OXKofnd9cBXyiE4L5BPSU9UJtwOG0PnbI--

--1GkfEK7Wx4qB9n2LAKCUdQWD376fPIf0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxus88ACgkQwj2R86El
/qjC0Qf+IuS1/sZ/HXBbyTmTsA5jjd+aYGz2q/r7vF1kNkA/CBzR4Rv7ivDeB23S
i1ZOtjZn6wHnYHFgbQhMdjJkXu2moVWaV6t2kqTla29OAX1oCwslj3P6izg9doXz
nU7dVSN9jNHlp99vgV8nkAR9Hog4FMEU2HDb6qOLV/JyyGTxgvUrNYe11+dlRrq1
kmpofuURydlQLr9zLtT1uEJm7MTC+d8J3BiGdwSWva628/nCs3luJVIwHLyLiwn/
Xb6ZwGx7XQRxvmJN+wuwIlIdUJ1yqdIUGTUxwmzjg/8GwQl9Ino+WHLjuZsvRsdy
wv6MBeDOboS8ERRmFI/KwGs+Vva3CA==
=GWLm
-----END PGP SIGNATURE-----

--1GkfEK7Wx4qB9n2LAKCUdQWD376fPIf0B--
