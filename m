Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444862236E0
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780435251; cv=none; b=CzR3AvXxrp76K6r8yrl1FjpeCJGmB2OTPvMjjw0XImIDDT3N/WdU5t3f1xeodamehnTZCZmTHeX9XZiIAh0xXDjEiaf4uU+MS604r/BGxFvLThN5/Jq/gA0V1jhNjhOSfIrNstcvQel9asDdCODZkZQj/zSqCg7Vd1NTvBcyXHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780435251; c=relaxed/simple;
	bh=Dd/6DK1/HkjhTE+CPFM/1nJiJoU1g0M4Fwb0VapmEmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lzW9G1lhJFkOl+2F7RRnDznFcQWaXum7FLZcmZRrUNakAWeueaDkmqdznmbZaBwYaRUQN0aQYxR2wu9nAMUmRXglFArrasDAU+SEhhOCv2IUGVMRhMRC93OjBDmiHXfJmpOsSilvF5RLrosEEoirhKucRw2aQLeaDbcZPGyKfLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=BQLvkSjh; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="BQLvkSjh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780435247; x=1781040047; i=quwenruo.btrfs@gmx.com;
	bh=w61uVUtnY0vBTmfgRsLXX84ETa8jny3lu1xJC+3wamM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BQLvkSjhfzcsHuRaelt9iEcAgK8fDdu3wMOg3epmm9KjZXzCZEXeSkzlEhNuLy5j
	 4+BrkSf50/3BEDJWJUHFEKo8snwV4IJUTo0A0UHrlFHOI1j/5GjAiPHS0q3fFF1xE
	 SpxRUKHS/jlWj1r0dTzNKoyRLnuC+Wsul/0nW2HZUP4IwGiKrOEegsh+6guvsH9cT
	 COF8dpqes4iWhhCUt1zLBYzxJGl6JxLplVg0hPMklp123OCvNXa2BU+AoW1znidoi
	 yET2LIKPumXqRd+aHcP1pyXe3VU8KPLZSb4AaR84BaBmz2LsZOD4UxncgEIND1Hez
	 Tigq6S6CjOxt4CHCuA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N8GMq-1xPqDW1K2i-00req7; Tue, 02
 Jun 2026 23:20:47 +0200
Message-ID: <83a31e9c-349e-47dc-a63e-1038284754c6@gmx.com>
Date: Wed, 3 Jun 2026 06:50:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use verbose assertions in backref.c
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b6f6b52824e4b9e6ee9f883e09e53da9eb8152ee.1780409231.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <b6f6b52824e4b9e6ee9f883e09e53da9eb8152ee.1780409231.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6KtYhQC+5abFVRRHTwG7y4PjwY2jdG2AUzaQwTZJAjX1hVpPLxf
 BSVqNfuPlmhgPByczo0WHgKo4pXFrK5U34txZSWvesopXgULGyxUA9itX3Y+eWNuSx7LTzv
 wzBhOE6F2P5jib2CJtHeD/G4gn0jPl2fi2BZnjB9UUy/B8M/8VqPpDwsqjNHP9Ml8flvbQz
 o7uwmjZYJO8j4oqPlm/wA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ip0x531vMNg=;Zkem9+74cQ5zeTEgXlFkm+l8t11
 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



=E5=9C=A8 2026/6/2 23:44, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> While debugging a relocation issue I hit an assertion in backref.c but i=
t
> was not super useful, since it could not tell what was the unexpected
> value that triggered the assertion. The stack trace was this:
>=20
>    [583246.338097] assertion failed: !cache->nr_nodes, in fs/btrfs/backr=
ef.c:3158
>    [583246.339588] ------------[ cut here ]------------
>    [583246.340573] kernel BUG at fs/btrfs/backref.c:3158!
>    [583246.342075] Oops: invalid opcode: 0000 [#1] SMP PTI
>    [583246.343294] CPU: 5 UID: 0 PID: 677957 Comm: btrfs Not tainted 7.1=
.0-rc4-btrfs-next-234+ #1 PREEMPT(full)
>    [583246.345715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>    [583246.348694] RIP: 0010:btrfs_backref_release_cache.cold+0x61/0x84 =
[btrfs]
>    [583246.350759] Code: 90 d5 7c (...)
>    [583246.354923] RSP: 0018:ffffd4fc88c93ad8 EFLAGS: 00010246
>    [583246.355982] RAX: 000000000000003e RBX: ffff8dec90d97020 RCX: 0000=
000000000000
>    [583246.357459] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000=
0000ffffffff
>    [583246.359517] RBP: ffff8dec8eeb78c0 R08: 0000000000000000 R09: 3fff=
ffffffefffff
>    [583246.361180] R10: ffffd4fc88c93970 R11: 0000000000000003 R12: ffff=
8decd21f3470
>    [583246.363184] R13: 00000000fffffffe R14: ffff8decd21f3000 R15: ffff=
8decd21f3000
>    [583246.364666] FS:  00007f9a51751400(0000) GS:ffff8df3f4255000(0000)=
 knlGS:0000000000000000
>    [583246.366287] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [583246.367443] CR2: 00007f9a518ed8f5 CR3: 00000004467c8002 CR4: 0000=
000000370ef0
>    [583246.368969] Call Trace:
>    [583246.369541]  <TASK>
>    [583246.370040]  relocate_block_group+0xf2/0x520 [btrfs]
>    [583246.371243]  btrfs_relocate_block_group+0x9a9/0x22e0 [btrfs]
>    [583246.372443]  ? preempt_count_add+0x47/0xa0
>    [583247.532978]  ? btrfs_tree_read_lock_nested+0x19/0x90 [btrfs]
>    [583247.534520]  ? mutex_lock+0x1a/0x40
>    [583247.602233]  ? btrfs_scrub_pause+0x2e/0x120 [btrfs]
>    [583247.603543]  btrfs_relocate_chunk+0x3b/0x1a0 [btrfs]
>    [583247.604893]  btrfs_balance+0x9d5/0x1920 [btrfs]
>    [583247.606189]  ? preempt_count_add+0x69/0xa0
>    [583247.607030]  btrfs_ioctl+0x260c/0x2a20 [btrfs]
>    [583247.608015]  ? __memcg_slab_free_hook+0x156/0x1a0
>    [583247.636971]  __x64_sys_ioctl+0x92/0xe0
>    [583247.679247]  do_syscall_64+0x60/0xf20
>    [583247.753297]  ? clear_bhb_loop+0x60/0xb0
>    [583247.756321]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    [583247.787018] RIP: 0033:0x7f9a5186a8db
>    [583247.787787] Code: 00 48 89 (...)
>    [583247.791410] RSP: 002b:00007fff2ffa6ac0 EFLAGS: 00000246 ORIG_RAX:=
 0000000000000010
>    [583247.792897] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000=
7f9a5186a8db
>    [583247.794319] RDX: 00007fff2ffa6bb0 RSI: 00000000c4009420 RDI: 0000=
000000000003
>    [583247.795714] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000=
000000000000
>    [583247.797149] R10: 0000000000000000 R11: 0000000000000246 R12: 0000=
7fff2ffa903f
>    [583247.798685] R13: 00007fff2ffa6bb0 R14: 0000000000000002 R15: 0000=
000000000002
>    [583247.800136]  </TASK>
>=20
> So update all simple assertions in backref.c to print out the values whe=
n
> they aren't testing simple boolean conditions.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/backref.c | 30 +++++++++++++++++++-----------
>   1 file changed, 19 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 0abcec0ceead..23c3eeb58dc1 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1256,7 +1256,7 @@ static bool lookup_backref_shared_cache(struct btr=
fs_backref_share_check_ctx *ct
>   	 * realizing. We cache results only for extent buffers that lead from
>   	 * the root node down to the leaf with the file extent item.
>   	 */
> -	ASSERT(level >=3D 0);
> +	ASSERT(level >=3D 0, "level=3D%d", level);
>  =20
>   	entry =3D &ctx->path_cache_entries[level];
>  =20
> @@ -1327,7 +1327,7 @@ static void store_backref_shared_cache(struct btrf=
s_backref_share_check_ctx *ctx
>   	 * realizing. We cache results only for extent buffers that lead from
>   	 * the root node down to the leaf with the file extent item.
>   	 */
> -	ASSERT(level >=3D 0);
> +	ASSERT(level >=3D 0, "level=3D%d", level);
>  =20
>   	if (is_shared)
>   		gen =3D btrfs_get_last_root_drop_gen(fs_info);
> @@ -2964,7 +2964,9 @@ int btrfs_backref_iter_next(struct btrfs_fs_info *=
fs_info, struct btrfs_backref_
>  =20
>   	if (btrfs_backref_iter_is_inline_ref(iter)) {
>   		/* We're still inside the inline refs */
> -		ASSERT(iter->cur_ptr < iter->end_ptr);
> +		ASSERT(iter->cur_ptr < iter->end_ptr,
> +		       "iter->cur_ptr=3D%u iter->end_ptr=3D%u",
> +		       iter->cur_ptr, iter->end_ptr);
>  =20
>   		if (btrfs_backref_has_tree_block_info(iter)) {
>   			/* First tree block info */
> @@ -3030,7 +3032,7 @@ struct btrfs_backref_node *btrfs_backref_alloc_nod=
e(
>   {
>   	struct btrfs_backref_node *node;
>  =20
> -	ASSERT(level >=3D 0 && level < BTRFS_MAX_LEVEL);
> +	ASSERT(level >=3D 0 && level < BTRFS_MAX_LEVEL, "level=3D%d", level);
>   	node =3D kzalloc_obj(*node, GFP_NOFS);
>   	if (!node)
>   		return node;
> @@ -3052,7 +3054,7 @@ void btrfs_backref_free_node(struct btrfs_backref_=
cache *cache,
>   	if (node) {
>   		ASSERT(list_empty(&node->list));
>   		ASSERT(list_empty(&node->lower));
> -		ASSERT(node->eb =3D=3D NULL);
> +		ASSERT(node->eb =3D=3D NULL, "node->eb->start=3D%llu", node->eb->star=
t);
>   		cache->nr_nodes--;
>   		btrfs_put_root(node->root);
>   		kfree(node);
> @@ -3155,15 +3157,18 @@ void btrfs_backref_release_cache(struct btrfs_ba=
ckref_cache *cache)
>  =20
>   	ASSERT(list_empty(&cache->pending_edge));
>   	ASSERT(list_empty(&cache->useless_node));
> -	ASSERT(!cache->nr_nodes);
> -	ASSERT(!cache->nr_edges);
> +	ASSERT(!cache->nr_nodes, "cache->nr_nodes=3D%d", cache->nr_nodes);
> +	ASSERT(!cache->nr_edges, "cache->nr_edges=3D%d", cache->nr_edges);
>   }
>  =20
>   static void btrfs_backref_link_edge(struct btrfs_backref_edge *edge,
>   				    struct btrfs_backref_node *lower,
>   				    struct btrfs_backref_node *upper)
>   {
> -	ASSERT(upper && lower && upper->level =3D=3D lower->level + 1);
> +	ASSERT(upper !=3D NULL);
> +	ASSERT(lower !=3D NULL);
> +	ASSERT(upper->level =3D=3D lower->level + 1, "upper->level=3D%d lower-=
>level=3D%d",
> +	       upper->level, lower->level);
>   	edge->node[LOWER] =3D lower;
>   	edge->node[UPPER] =3D upper;
>   	list_add_tail(&edge->list[LOWER], &lower->upper);
> @@ -3283,7 +3288,9 @@ static int handle_indirect_tree_backref(struct btr=
fs_trans_handle *trans,
>  =20
>   	if (btrfs_root_level(&root->root_item) =3D=3D cur->level) {
>   		/* Tree root */
> -		ASSERT(btrfs_root_bytenr(&root->root_item) =3D=3D cur->bytenr);
> +		ASSERT(btrfs_root_bytenr(&root->root_item) =3D=3D cur->bytenr,
> +		       "root_bytenr=3D%llu cur->bytenr=3D%llu",
> +		       btrfs_root_bytenr(&root->root_item), cur->bytenr);
>   		/*
>   		 * For reloc backref cache, we may ignore reloc root.  But for
>   		 * general purpose backref cache, we can't rely on
> @@ -3333,8 +3340,9 @@ static int handle_indirect_tree_backref(struct btr=
fs_trans_handle *trans,
>   	/* Add all nodes and edges in the path */
>   	for (; level < BTRFS_MAX_LEVEL; level++) {
>   		if (!path->nodes[level]) {
> -			ASSERT(btrfs_root_bytenr(&root->root_item) =3D=3D
> -			       lower->bytenr);
> +			ASSERT(btrfs_root_bytenr(&root->root_item) =3D=3D lower->bytenr,
> +			       "root_bytenr=3D%llu lower->bytenr=3D%llu",
> +			       btrfs_root_bytenr(&root->root_item), lower->bytenr);
>   			/* Same as previous should_ignore_reloc_root() call */
>   			if (btrfs_should_ignore_reloc_root(root) &&
>   			    cache->is_reloc) {

