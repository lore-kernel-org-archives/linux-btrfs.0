Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5A5C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 11:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19DC32073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 11:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfDPLc0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 07:32:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:34844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbfDPLcZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 07:32:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ADC68B024;
        Tue, 16 Apr 2019 11:32:22 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs-progs: Avoid nested chunk allocation call
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190416102144.12173-1-wqu@suse.com>
 <20190416102144.12173-2-wqu@suse.com>
 <CAL3q7H7h8LJr98RBZeXbH12LFM4VO5SA1N1XVfAEPhEoZPv8dQ@mail.gmail.com>
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
Message-ID: <2a5af300-3db0-8fd7-cacb-012988a79b7a@suse.de>
Date:   Tue, 16 Apr 2019 19:32:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7h8LJr98RBZeXbH12LFM4VO5SA1N1XVfAEPhEoZPv8dQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hAXlZ4o9tXJUrmJNvqdfWMmZtP1U39tFF"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hAXlZ4o9tXJUrmJNvqdfWMmZtP1U39tFF
Content-Type: multipart/mixed; boundary="xgrV6kXmJwvrlXk6QSjFghOkvEMr0P4BX";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2a5af300-3db0-8fd7-cacb-012988a79b7a@suse.de>
Subject: Re: [PATCH 1/2] btrfs-progs: Avoid nested chunk allocation call
References: <20190416102144.12173-1-wqu@suse.com>
 <20190416102144.12173-2-wqu@suse.com>
 <CAL3q7H7h8LJr98RBZeXbH12LFM4VO5SA1N1XVfAEPhEoZPv8dQ@mail.gmail.com>
In-Reply-To: <CAL3q7H7h8LJr98RBZeXbH12LFM4VO5SA1N1XVfAEPhEoZPv8dQ@mail.gmail.com>

--xgrV6kXmJwvrlXk6QSjFghOkvEMr0P4BX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/16 =E4=B8=8B=E5=8D=887:22, Filipe Manana wrote:
> On Tue, Apr 16, 2019 at 11:23 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> There is a hidden call loop which can trigger itself:
>>
>> btrfs_reserve_extent()             <--|
>> |- do_chunk_alloc()                   |
>>    |- btrfs_alloc_chunk()             |
>>       |- btrfs_insert_item()          |
>>          |- btrfs_reserve_extent() <--|
>>
>> Currently, we're using root->ref_cows to determine whether we should d=
o
>> chunk prealloc to avoid such loop.
>>
>> But that's still a hidden trap. Instead of solving it using some hidde=
n
>> tricks, this patch will make chunk/block group allocation exclusive.
>>
>> Now if do_chunk_alloc() determines to alloc chunk, it will set a speci=
al
>> flag in transaction handler so it new do_chunk_alloc() will refuse to
>> allocate new chunk until current chunk allocation finishes.
>=20
> What if the chunk allocated during the recursion is of a different type=
?
> I.e. we're allocating a data chunk, then when inserting the items in th=
e
> extent, chunk, device, etc trees, we run out of metadata data space and=

> need to allocate a metadata chunk. What you are doing skips the allocat=
ion
> of the metadata chunk and makes the inserts/updates of the trees fail
> with ENOSPC.

That's why we do preallocation to avoid such problem.

Just as the old code shows, even when we're allocating data chunks, it
will try to check metadata space first.

And for the profile we're asking, we over-allocate 2M, definitely not
the best solution but should be enough for extent/chunk tree update.

To make it as good as kernel, we need a lot of accounting which is not
here in btrfs-progs.

So in your case, every btrfs_reserve_extent() call should either trigger
 chunk allocation (either metadata or data, or both), or have 2M overhead=
=2E

If that 2M can not meet the metadata space requirement for
chunk/extent/root tree update, then we hit the problem you described.

However 2M looks pretty generous to me, so it should just work.

Thanks,
Qu

>=20
> thanks
>=20
>=20
>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/main.c  |  2 +-
>>  extent-tree.c | 12 ++++++++++++
>>  transaction.c |  3 ++-
>>  transaction.h |  3 ++-
>>  4 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 683c322eba6f..121be4b73c4f 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -10185,7 +10185,7 @@ int cmd_check(int argc, char **argv)
>>                         goto close_out;
>>                 }
>>
>> -               trans->reinit_extent_tree =3D true;
>> +               trans->reinit_extent_tree =3D 1;
>>                 if (init_extent_tree) {
>>                         printf("Creating a new extent tree\n");
>>                         ret =3D reinit_extent_tree(trans, info,
>> diff --git a/extent-tree.c b/extent-tree.c
>> index 8c9cdeff3b02..e25ddf02e5cc 100644
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> @@ -1873,10 +1873,21 @@ static int do_chunk_alloc(struct btrfs_trans_h=
andle *trans,
>>             (flags & BTRFS_BLOCK_GROUP_SYSTEM))
>>                 return 0;
>>
>> +       /*
>> +        * We're going to allocate new chunk, during the process, we w=
ill
>> +        * allocate new tree blocks, which can trigger new chunk alloc=
ation
>> +        * again.
>> +        * Avoid such loop call
>> +        */
>> +       if (trans->allocating_chunk)
>> +               return 0;
>> +       trans->allocating_chunk =3D 1;
>> +
>>         ret =3D btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
>>                                 space_info->flags);
>>         if (ret =3D=3D -ENOSPC) {
>>                 space_info->full =3D 1;
>> +               trans->allocating_chunk =3D 0;
>>                 return 0;
>>         }
>>
>> @@ -1885,6 +1896,7 @@ static int do_chunk_alloc(struct btrfs_trans_han=
dle *trans,
>>         ret =3D btrfs_make_block_group(trans, fs_info, 0, space_info->=
flags,
>>                                      start, num_bytes);
>>         BUG_ON(ret);
>> +       trans->allocating_chunk =3D 0;
>>         return 0;
>>  }
>>
>> diff --git a/transaction.c b/transaction.c
>> index 3a63988b0969..21377282f806 100644
>> --- a/transaction.c
>> +++ b/transaction.c
>> @@ -46,7 +46,8 @@ struct btrfs_trans_handle* btrfs_start_transaction(s=
truct btrfs_root *root,
>>         fs_info->generation++;
>>         h->transid =3D fs_info->generation;
>>         h->blocks_reserved =3D num_blocks;
>> -       h->reinit_extent_tree =3D false;
>> +       h->reinit_extent_tree =3D 0;
>> +       h->allocating_chunk =3D 0;
>>         root->last_trans =3D h->transid;
>>         root->commit_root =3D root->node;
>>         extent_buffer_get(root->node);
>> diff --git a/transaction.h b/transaction.h
>> index 34060252dd5c..b426cd112447 100644
>> --- a/transaction.h
>> +++ b/transaction.h
>> @@ -28,7 +28,8 @@ struct btrfs_trans_handle {
>>         u64 transid;
>>         u64 alloc_exclude_start;
>>         u64 alloc_exclude_nr;
>> -       bool reinit_extent_tree;
>> +       unsigned int reinit_extent_tree:1;
>> +       unsigned int allocating_chunk:1;
>>         u64 delayed_ref_updates;
>>         unsigned long blocks_reserved;
>>         unsigned long blocks_used;
>> --
>> 2.21.0
>>
>=20
>=20


--xgrV6kXmJwvrlXk6QSjFghOkvEMr0P4BX--

--hAXlZ4o9tXJUrmJNvqdfWMmZtP1U39tFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly1vTAACgkQwj2R86El
/qimsAf+IJ78FR1WqY2LRGDwAYp3whqUKueBxH08NjTKOJg9yGFmJNLPt7tQJ8Im
/z6tnQbnUJisqSe8dt54oMwDbs9/znIYbA1XzC8Z5tghZeY1pHd8/tFEjZfL6xFA
yPwYdIBYP7Abp/zegNee6A3osNq71bGE1xvQZlpyxHegH9YzxnFIa9hATHupXFFA
kD3ldlZ4/WBTNHy9adTMr1zUatjpxC6do1hcOGkxWDeleJCnm69XrlAt7nTYpqq7
Tfeyk13RkcZA8Yzytsb3f7b7phmOP9HUsZxGr4k3erlNivkxxb5oxF6sr0l536J8
+7DS/Z5w4HtGxTl2KHlw5OPsVdSzNg==
=sTfd
-----END PGP SIGNATURE-----

--hAXlZ4o9tXJUrmJNvqdfWMmZtP1U39tFF--
