Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B6DC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F6C2086E
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40F6C2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbeIZUyT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:54:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:44347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbeIZUyT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 16:54:19 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MUI8w-1gDWhK2suA-00R3is; Wed, 26
 Sep 2018 16:40:53 +0200
Subject: Re: [PATCH v3 3/7] btrfs: qgroup: Introduce function to find all new
 tree blocks of reloc tree
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-4-wqu@suse.com> <20180926142945.GK3255@twin.jikos.cz>
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
Message-ID: <0b646fb0-02d1-6a39-e038-6f5ec156212c@gmx.com>
Date:   Wed, 26 Sep 2018 22:40:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180926142945.GK3255@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TsTbqkAqCx1YvccqdbPfUspD1ct7Ioxlf"
X-Provags-ID: V03:K1:UH1Fr3CPeModMWkSn9uUqz03JNQ8SNSNMBUnwPuGY5vyjmza8IV
 XxrQ26pFMA43Z/9rp+YVfrcvt5HmJW2sYrpgHg6QHzsJplTMxb75yFIz06E3Mpz2iLRAfwX
 a5yYVLUiuUALqYzsq8HS1ytyux7l3oFFs9yEkPH6Ndy4lz7h5TZ0N5f77hY+Yj6A2zTFCtq
 3SdNB2B6eYCevZHpc0XDw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:OpqspewoGD0=:dHhxeRTpyEBSdABOPC0/X1
 ScCIkwYFD5NPhFSyP8yNCXmI9Lz4z0EjCPe2JGByIME4JxBiKZ7wurfpDr6y4m0AdTOukV/GO
 wP9giv8nLkte7jgM42Zr4MPL9FhzYrbkvYzuiGpwbzZOyAE/u5gcQSZwLKRaZmnWVJRnnL8Ys
 jNZm7LFfmyIfnfIbynkXHWtxB02Z5TafUqevZmJVJg64FI0w+759KvYnbdlpn2Es3+qdIalTK
 gW7+fSjcN13ns+Jpy+AKSadlBONnFvwK8hmHXJyHR7dj9qwv9v5S39gpP4Y0U6VapQ+jG91Sl
 dCjCbaX4EFnmmTqmBJDB3nNjCO+AufgFZR+RJ1zNPdrGWc/KrsqVsA2o0VwdxX73EO7HnFCXX
 IxAdEPC2I/J8WeK+egDqP7b+flrBqBibRzRmKqVqgNgw/EeP87dKW2CX107J8ySbEJOyWxG4g
 GsC5xideGHbyQnVOYyZtKV5tiSnxmDjisw/pVipt9FidU4z5gJFgjrlZV30yJuDNiaFEEK2wR
 vkQLnQkSt71Dpn1aUAIAlstlU/W53wh/08oLOp6ddyfx8nKi+cZrgqGsNkTsXADo7+e4b/K8T
 dPpRAGT7K2bdPKQIcBbYCufQU0IhNE9lLVynu6D6pmwYT8SM5z0zBwHKduD+fTSIxWbCeipot
 c4ZkY0cwnZBECYxSMdbUWcSS5jHy+EVazw8c0jCUt2xF7VGB9EIEHxzWdCINePEQV6N0rHqA2
 4uf+sfc1ANSRUV9+zdlruAyomIX42oZ0BR1IqaLGOpfZPocmoaW/Gyxbc33ieycVPsXnNkiO5
 0DqUjxkN4fiuUzb0jiy2NojnJtfgw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TsTbqkAqCx1YvccqdbPfUspD1ct7Ioxlf
Content-Type: multipart/mixed; boundary="hIlJ1EW20QmGRXHbNQE5Dmq4lEqd2TTSc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <0b646fb0-02d1-6a39-e038-6f5ec156212c@gmx.com>
Subject: Re: [PATCH v3 3/7] btrfs: qgroup: Introduce function to find all new
 tree blocks of reloc tree
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-4-wqu@suse.com> <20180926142945.GK3255@twin.jikos.cz>
In-Reply-To: <20180926142945.GK3255@twin.jikos.cz>

--hIlJ1EW20QmGRXHbNQE5Dmq4lEqd2TTSc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/26 =E4=B8=8B=E5=8D=8810:29, David Sterba wrote:
> On Tue, Sep 11, 2018 at 01:38:14PM +0800, Qu Wenruo wrote:
>> Introduce new function, qgroup_trace_new_subtree_blocks(), to iterate
>> all new tree blocks in a reloc tree.
>> So that qgroup could skip unrelated tree blocks during balance, which
>> should hugely speedup balance speed when quota is enabled.
>>
>> The function qgroup_trace_new_subtree_blocks() itself only cares about=

>> new tree blocks in reloc tree.
>>
>> All its main works are:
>>
>> 1) Read out tree blocks according to parent pointers
>>
>> 2) Do recursive depth-first search
>>    Will call the same function on all its children tree blocks, with
>>    search level set to current level -1.
>>    And will also skip all children whose generation is smaller than
>>    @last_snapshot.
>>
>> 3) Call qgroup_trace_extent_swap() to trace tree blocks
>>
>> So although we have parameter list related to source file tree, it's n=
ot
>> used at all, but only passed to qgroup_trace_extent_swap().
>> Thus despite the tree read code, the core should be pretty short and a=
ll
>> about recursive depth-first search.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 114 +++++++++++++++++++++++++++++++++++++++++++++=
+
>>  1 file changed, 114 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 5155fb42ce79..0702953d70a7 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1839,6 +1839,120 @@ static int qgroup_trace_extent_swap(struct btr=
fs_trans_handle* trans,
>>  	return ret;
>>  }
>> =20
>> +/*
>> + * Helper function to do recursive generation aware depth-first searc=
h, to
>> + * locate all new tree blocks in a subtree of tree reloc tree.
>> + *
>> + * E.g. (OO =3D Old tree blocks, NN =3D New tree blocks, whose gen =3D=
=3D last_snapshot)
>> + *       Tree reloc tree
>> + * L2         NN (a)
>> + *          /    \
>> + * L1    OO        NN (b)
>> + *      /  \      /  \
>> + * L0  OO  OO    OO  NN
>> + *               (c) (d)
>> + * If we pass:
>> + * @dst_path =3D [ nodes[1] =3D NN(b), nodes[0] =3D NULL ],
>> + * @cur_level =3D 1
>> + * @root_level =3D 1
>> + *
>> + * We will iterate through tree blocks NN(b), NN(d) and info qgroup t=
o trace
>> + * above tree blocks along with their counter parts in file tree.
>> + * While during search, old tree blocsk OO(c) will be skiped as tree =
block swap
>> + * won't affect OO(c).
>> + */
>> +static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle*=
 trans,
>> +					   struct extent_buffer *src_eb,
>> +					   struct btrfs_path *dst_path,
>> +					   int cur_level, int root_level,
>> +					   u64 last_snapshot)
>> +{
>> +	struct btrfs_fs_info *fs_info =3D trans->fs_info;
>> +	struct extent_buffer *eb;
>> +	bool need_cleanup =3D false;
>> +	int ret =3D 0;
>> +	int i;
>=20
> This function could be called recursively based on the value of
> cur_level so please add some sanity checks so this does not accidentall=
y
> escape. It needs to be a plain if/return, not just an assert or bug-on.=


OK, I'll add a cur_level check here, and also enhance tree-checker to do
a level check for nodes/leaves, so we could catch level problem even
earlier, and keep all level passed into this function is valid.

Thanks,
Qu

>=20
>> +
>> +	/* Read the tree block if needed */
>> +	if (dst_path->nodes[cur_level] =3D=3D NULL) {
>> +		struct btrfs_key first_key;
>> +		int parent_slot;
>> +		u64 child_gen;
>> +		u64 child_bytenr;
>> +
>> +		/*
>> +		 * We need to get child blockptr/gen from parent before
>> +		 * we can read it.
>> +		  */
>> +		eb =3D dst_path->nodes[cur_level + 1];
>> +		parent_slot =3D dst_path->slots[cur_level + 1];
>> +		child_bytenr =3D btrfs_node_blockptr(eb, parent_slot);
>> +		child_gen =3D btrfs_node_ptr_generation(eb, parent_slot);
>> +		btrfs_node_key_to_cpu(eb, &first_key, parent_slot);
>> +
>> +		/* This node is old, no need to trace */
>> +		if (child_gen < last_snapshot)
>> +			goto out;
>> +
>> +		eb =3D read_tree_block(fs_info, child_bytenr, child_gen,
>> +				     cur_level, &first_key);
>> +		if (IS_ERR(eb)) {
>> +			ret =3D PTR_ERR(eb);
>> +			goto out;
>> +		} else if (!extent_buffer_uptodate(eb)) {
>> +			free_extent_buffer(eb);
>> +			ret =3D -EIO;
>> +			goto out;
>> +		}
>> +
>> +		dst_path->nodes[cur_level] =3D eb;
>> +		dst_path->slots[cur_level] =3D 0;
>> +
>> +		btrfs_tree_read_lock(eb);
>> +		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>> +		dst_path->locks[cur_level] =3D BTRFS_READ_LOCK_BLOCKING;
>> +		need_cleanup =3D true;
>> +	}
>> +
>> +	/* Now record this tree block and its counter part for qgroups */
>> +	ret =3D qgroup_trace_extent_swap(trans, src_eb, dst_path, cur_level,=

>> +				       root_level);
>> +	if (ret < 0)
>> +		goto cleanup;
>> +
>> +	eb =3D dst_path->nodes[cur_level];
>> +
>> +	if (cur_level > 0) {
>> +		/* Iterate all children tree blocks */
>> +		for (i =3D 0; i < btrfs_header_nritems(eb); i++) {
>> +			/* Skip old tree blocks as they won't be swapped */
>> +			if (btrfs_node_ptr_generation(eb, i) < last_snapshot)
>> +				continue;
>> +			dst_path->slots[cur_level] =3D i;
>> +
>> +			/* Recursive call (at most 7 times) */
>> +			ret =3D qgroup_trace_new_subtree_blocks(trans, src_eb,
>> +					dst_path, cur_level - 1, root_level,
>> +					last_snapshot);
>> +			if (ret < 0)
>> +				goto cleanup;
>> +		}
>> +	}
>> +
>> +cleanup:
>> +	if (need_cleanup) {
>> +		/* Clean up */
>> +		btrfs_tree_unlock_rw(dst_path->nodes[cur_level],
>> +				     dst_path->locks[cur_level]);
>> +		free_extent_buffer(dst_path->nodes[cur_level]);
>> +		dst_path->nodes[cur_level] =3D NULL;
>> +		dst_path->slots[cur_level] =3D 0;
>> +		dst_path->locks[cur_level] =3D 0;
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>>  int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
>>  			       struct extent_buffer *root_eb,
>>  			       u64 root_gen, int root_level)
>> --=20
>> 2.18.0


--hIlJ1EW20QmGRXHbNQE5Dmq4lEqd2TTSc--

--TsTbqkAqCx1YvccqdbPfUspD1ct7Ioxlf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlurmmwACgkQwj2R86El
/qhqqggAoRVkUl4jLN6uM9nrLnAv59bybCUB24E9BTDd8/VqeLIBW0HYWDNS+W/W
KBYSY9klONMnR2SPBpfazstr7X9CC5cHukc7Z/RvC5fOOZH4mCk90w+RdDIE7Imc
wN8JuqikItOsNaWB+j2uunlSmtJd5b8ocbbxx5gKokZIfY0SzotoZTnd7bD5zBWK
3dahThVpi2oPQZN0oUGrcvztHWa8gukPNeeFBOb7urQ/2K/1trX88+mddSVs+opx
zURaOy1fVa6Va4/RWljd9FAqbIxFJDlMXU2rfFJK0gTFF3VxVFfTvlW/TKsn+nNn
4o/JSFje5NFJ8/aspAu6U5nLM23OxQ==
=G1a2
-----END PGP SIGNATURE-----

--TsTbqkAqCx1YvccqdbPfUspD1ct7Ioxlf--
