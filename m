Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D7CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E15217D7
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfBSMY2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:24:28 -0500
Received: from mout.gmx.net ([212.227.17.21]:48099 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfBSMY2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 07:24:28 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lqyi7-1hYgqX2pil-00egWj; Tue, 19
 Feb 2019 13:24:24 +0100
Subject: Re: [PATCH 2/2] Btrfs: report and handle error on unexpected first
 key on extent buffer
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190218165826.23549-1-fdmanana@kernel.org>
 <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
 <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com>
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
Message-ID: <19a9bca8-1861-ba0e-c495-3817ea051877@gmx.com>
Date:   Tue, 19 Feb 2019 20:24:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TeEda3Is88HzwgrW1sa9QeBHkYmRRn8Lo"
X-Provags-ID: V03:K1:k3XbZWqBl58osTe5KR9MyvGn9vaxbudksuNS5Ephy6FPk8cm+N/
 +jI+ojP7URGAMtoJM/PXtjgDSB5H4fb31G+AxyIDFE+BAqEKXEL74JbCAlsF0IRrUXkSixA
 rnGhpIEgSlROyR6EUh9gG7HK9o9DQXqMz//1u5MPCNIklUALUf50O69Y3aUk3xB5Yy1o4aZ
 A6DDYmeZwyp+zXa+FBqbA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8SZQCbYnaAo=:XILWYE0+Yf8RZq3MAYYf73
 IpcDknqHh3hG2QlimZzwyxRw8fS5OarFlTw5ygXlrDMtOaL8WI8wmIakm4O4D7O/23Y0y3ryv
 qcECYonmpBB/YXnoD5XQpOEN6XZzTZfUs1PE0909u1fjipAGZ/7kzMGAS+CkI+IsWHmvFz9dO
 kDWz/jj+bq8KBEOeu7e52HvvTL5A+4JwYfrVYDpSQGIg/DWgEHPEsaBQlOiPVp4j2nITS+XCI
 YC6n5FMs6qn7pj0q4TjN34gl6+uXoqxZgH/9cFKr7k0IB4T8KSbrLazHlzoG/9ksgomhg1Vx9
 D+TBUm82et5N9njY9wU6SVbPRDlVWdbT3QnaDoyCeUH1uI04HTh1eY0P696QzjIqOUPk7RV0z
 m7SLACjM0YDMJ++5HQHOA01Ef8gemgKD7sW5U2V7zaYuj/fv83qtPbxEToPbR8DAPz02BK20s
 eICx2xWpLXL8IeZoP124KVzhPf/+a55S01Z+q6GIMcWES6vLop/YNj0RvJmMSkgrc57Xzf4zn
 z46SaFzm0yUaTRcrGcoBKQQ6mzp3a0g2nCLFb1B+QRgdkYwOAGIIpcon3gPF0ybTCs8MWHG5M
 WhQ+klydowckfBDcxxKLh20UqLHdxZDNUUF24I0LeJC9F0z50q7KrI0GLSeAb3BHeucFJKvZH
 HM04KAgDfJSbgORYjxf3VbniuTiHmKyPcCaIP1fViaDxN0d05K9y955WPe+I1Jpw2+cwfMkW5
 rL+usKpkmhvgwzrMhRw0SeEmVlT/2r1dsquVL1ww7ugTlGFlv8trQqTkujz/sxYHSyJhqRsD1
 Knd5zJIzszQuvbzf8gR6GyBEwKZC1GjQyd0Ysizpq4Xd66ow02N8N5HTHu9Ya1SJnsgS1ZTi6
 sXlpnkdj1RA7pgD6coRxZkeNbcpQIR7moN0KZQalogH52vmRetBbzueyMOd5gt
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TeEda3Is88HzwgrW1sa9QeBHkYmRRn8Lo
Content-Type: multipart/mixed; boundary="IdXmTlhK5MK348YexQk95AT4K1ULqugH0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <19a9bca8-1861-ba0e-c495-3817ea051877@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs: report and handle error on unexpected first
 key on extent buffer
References: <20190218165826.23549-1-fdmanana@kernel.org>
 <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
 <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com>
In-Reply-To: <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com>

--IdXmTlhK5MK348YexQk95AT4K1ULqugH0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/19 =E4=B8=8B=E5=8D=887:59, Filipe Manana wrote:
> On Tue, Feb 19, 2019 at 12:54 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>>
>> On 2019/2/19 =E4=B8=8A=E5=8D=8812:58, fdmanana@kernel.org wrote:
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> When there is a kind of corruption in an extent buffer such that its =
first
>>> key does not match the key at the respective parent slot, one of two =
things
>>> happens:
>>
>> Isn't that handled by read_tree_block() already?
>=20
> It is, but only at the time we read a node/leaf from disk.
> By doing the check here we can actually catch other types of bugs and
> memory corruption.

Although when memory corruption happens it's more concerning than
mismatch keys.

>=20
> To be honest I missed that since this is motivated by a report on
> older kernel (SLE12 SP3).
> So I still find it useful to have due to the reason pointed above,
> however I'm not against simply removing the check from key_search().

Removing the check looks good to me.
Especially since we're going to have mandatory write time tree checker,
it should be mostly fine.

Thanks,
Qu

>=20
>> Thanks,
>> Qu
>>
>>>
>>> 1) When assertions are enabled, we effectively hit a BUG_ON() which
>>>    requires rebooting the machine later. This also does not tell any
>>>    information about which extent buffer is affected, from which root=
,
>>>    the expected and found keys, etc.
>>>
>>> 2) When assertions are disabled, we just ignore the mismatch and assu=
me
>>>    everything is ok, which can potentially lead to all sorts of unexp=
ected
>>>    problems later after a tree search (in the worst case, could lead =
to
>>>    further silent corruption).
>>>
>>> So improve this by always checking if the first key of an extent buff=
er is
>>> what it's supposed to be, when doing a key search at key_search(), an=
d
>>> report and return an appropriate error. The overhead is just comparin=
g one
>>> key, which is minimal and is anyway just done in a special case where=
 we
>>> skip the more expensive binary search (the binary search in the paren=
t
>>> node returned 0, exact key match).
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  fs/btrfs/ctree.c | 38 +++++++++++++++++---------------------
>>>  1 file changed, 17 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>> index 5b9f602fb9e2..a0bd0278208d 100644
>>> --- a/fs/btrfs/ctree.c
>>> +++ b/fs/btrfs/ctree.c
>>> @@ -2529,35 +2529,31 @@ setup_nodes_for_search(struct btrfs_trans_han=
dle *trans,
>>>       return ret;
>>>  }
>>>
>>> -static void key_search_validate(struct extent_buffer *b,
>>> -                             const struct btrfs_key *key,
>>> -                             int level)
>>> -{
>>> -#ifdef CONFIG_BTRFS_ASSERT
>>> -     struct btrfs_disk_key disk_key;
>>> -
>>> -     btrfs_cpu_key_to_disk(&disk_key, key);
>>> -
>>> -     if (level =3D=3D 0)
>>> -             ASSERT(!memcmp_extent_buffer(b, &disk_key,
>>> -                 offsetof(struct btrfs_leaf, items[0].key),
>>> -                 sizeof(disk_key)));
>>> -     else
>>> -             ASSERT(!memcmp_extent_buffer(b, &disk_key,
>>> -                 offsetof(struct btrfs_node, ptrs[0].key),
>>> -                 sizeof(disk_key)));
>>> -#endif
>>> -}
>>> -
>>>  static int key_search(struct extent_buffer *b, const struct btrfs_ke=
y *key,
>>>                     int level, int *prev_cmp, int *slot)
>>>  {
>>> +     struct btrfs_key found_key;
>>> +
>>>       if (*prev_cmp !=3D 0) {
>>>               *prev_cmp =3D btrfs_bin_search(b, key, level, slot);
>>>               return *prev_cmp;
>>>       }
>>>
>>> -     key_search_validate(b, key, level);
>>> +     if (level =3D=3D 0)
>>> +             btrfs_item_key_to_cpu(b, &found_key, 0);
>>> +     else
>>> +             btrfs_node_key_to_cpu(b, &found_key, 0);
>>> +
>>> +     if (btrfs_comp_cpu_keys(&found_key, key) !=3D 0) {
>>> +             btrfs_crit(b->fs_info,
>>> +"unexpected first key for extent buffer: bytenr=3D%llu level=3D%d ro=
ot=3D%llu expected key=3D(%llu %u %llu) found key=3D(%llu %u %llu)",
>>> +                        btrfs_header_bytenr(b), level, btrfs_header_=
owner(b),
>>> +                        key->objectid, key->type, key->offset,
>>> +                        found_key.objectid, found_key.type,
>>> +                        found_key.offset);
>>> +             return -EUCLEAN;
>>> +     }
>>> +
>>>       *slot =3D 0;
>>>
>>>       return 0;
>>>
>>


--IdXmTlhK5MK348YexQk95AT4K1ULqugH0--

--TeEda3Is88HzwgrW1sa9QeBHkYmRRn8Lo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxr9W0ACgkQwj2R86El
/qi+hQf/SqgcygiMnKi9DHuZKx5dIaFFdb/2Rgb6t8olECNTr8D9oPjujLmYh8T0
x6K20GvHhfVplpxmR3kfS5OQc9Kg8YitNAQheIxu8qmvxklPUWP8Mifw1gN9Jpeu
+loSc2UbQkP6+0ZKO78I1RxlIqLV8nc0vt/Kiv4Zfi8047lktVwQdRtD+3GjSfrY
fKH+RDlB4g/+p7dnsuuFVJezNTVlg0H7EbQGb/3Vv9iUHEqUL8lKXFz0Q+u2iAzl
IAU8+02JBUfffFFgtlNYDcKpvgAp2/q8mRMoTQp42NCoqxgRgFb97BqBjT/p+VCL
Dop+dpqaFlZ64xXVylM6BLceEnh0Kg==
=G/A0
-----END PGP SIGNATURE-----

--TeEda3Is88HzwgrW1sa9QeBHkYmRRn8Lo--
