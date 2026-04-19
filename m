Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CC22F84F
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 00:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776558365; cv=none; b=Z+aeyjcfo79PPArRFX97L81CfBehdo5w3Q4t1/KO60lecgbg6fE7xQmU1odmuNRLu3DVLeR2BLApNiYFe7wPB2fuVbnMFVacsl4oKqOTeSgORGmvxgPEEz5cUiQGMR5xOz3OtHZJEBMEJsHCcezjEoe/F0qwvz44QaURsNMC12w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776558365; c=relaxed/simple;
	bh=65dnJOcF+HYVdqqnr7oGxZEg6N9HzsT367Lf2tOB8wU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UdW00smgIEojkxa+9ZmhQavPZTIFgfAJJRUy9Qv7vNHPNCWF/jgS0zFqfz31gu5thfhHeCQ1/da97FOUVSm4Udre00E/ljaTZW7DH6O4+kENhGhfaY/au5jgFHuxMT8CVd+PtnYtFfZ/3vHYwbBisVjlQa7sD3ZzhRLBetlfMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=jWP/Vpts; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="jWP/Vpts"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776558360; x=1777163160; i=quwenruo.btrfs@gmx.com;
	bh=xCOZ+yqVFafmolb1wPrb28Zfn7yIeGZJ//HZeu/tbpA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jWP/VptsLcN4Q3zhSADIT65q5pnpP8hOEKI4aXwCOvvZBgYmlQ1BYr7DslnXG08X
	 GwX9k4KH7VV3cTvoDBQejfIvDfIxG7TxSn27XrPI/iIYG8hDh3hSEGDL9jACaYLyL
	 3nVAYVmV76CQ0rHLrAA8tA4ylhaUo1oShvDSM4K4Ii7GzrfR4HlVjr9sYMEDzNLer
	 pr7yaRMCESGXkvZSnP/LULl3JjdplHSv4V3pSNz4dbQAFHbzjHrCD2wRPy/JRUf+P
	 N9VN/qrwTdit4FZtChunC1hiIJyCZFN3Jyb012xWIp+524m+qAt8kL0W34RYCRp8B
	 lOpPzmLpGK6+Jkcacw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQe5u-1w0bHF3WWk-00RuBt; Sun, 19
 Apr 2026 02:26:00 +0200
Message-ID: <92c96052-6619-4c25-8add-a85a4b76c060@gmx.com>
Date: Sun, 19 Apr 2026 09:55:57 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] btrfs: implement FALLOC_FL_COLLAPSE_RANGE and
 FALLOC_FL_INSERT_RANGE
To: Paul Richards <paul.richards@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260418143808.199603-1-paul.richards@gmail.com>
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
In-Reply-To: <20260418143808.199603-1-paul.richards@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uMqoICl8rtB+ASDS3ZaXrcGsE7LqyUafvFouH8gyRjFz1GXJCLH
 HmW00LBL0Ryy2rUdKpwb5a2t2UnaKiXnywuQwddYU01VENq1KKE0Y9HegnQJKp69eLPrLay
 2WT9aDpdY0onpo2FNqMrkSVlMiCstQioI47BF77J0UXA0CijQi4AocMcXdFVPv/cQM1MLUX
 jg+azPH4TMjux9IUj9f/g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cIS9oyvO5M0=;/4c+dFH1osWlFHvoseng6Kia7K/
 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



=E5=9C=A8 2026/4/19 00:08, Paul Richards =E5=86=99=E9=81=93:
> This series adds support for FALLOC_FL_COLLAPSE_RANGE and
> FALLOC_FL_INSERT_RANGE to btrfs_fallocate(). Both operations are
> already supported by ext4 and xfs. The userspace contract is
> documented in fallocate(2).
>=20
> Patch 1 refactors btrfs_fallocate() to dispatch via a switch statement,
> moving punch_hole into its own function and decoupling locking from the
> per-operation helpers. This is similar to the implementaitons for ext4
> and xfs. The allocate-range and zero-range paths remain coupled since
> they share some setup logic.
>=20
> Patches 2 and 3 add COLLAPSE_RANGE and INSERT_RANGE respectively.
>=20
> =3D=3D Implementation approach =3D=3D
>=20
> For COLLAPSE_RANGE:
>   - The removed region [offset, offset+len) is punched out via
>     btrfs_replace_file_extents(), which handles boundary splitting.
>   - All EXTENT_DATA keys with key.offset >=3D offset+len are shifted
>     leftward by len in forward order.
>=20
> For INSERT_RANGE:
>   - All EXTENT_DATA keys with key.offset >=3D offset are shifted rightwa=
rd
>     by len in reverse order (required to avoid key collisions).
>   - No pre-splitting of straddling extents is needed: the left portion
>     of a straddling extent stays in place, the right portion is shifted;
>     both reference the same physical extent via their existing
>     extent_offset fields.
>=20
> For each shifted key, the corresponding back-reference in the extent
> tree is updated via a shared helper btrfs_shift_extent_backref().
>=20
> After the key-shift loop, btrfs_drop_extent_map_range() is called to
> invalidate the in-memory extent map cache. This is important for reads
> after the fallocate operation to ensure they obtain data for the new
> offsets.
>=20
> The page cache is flushed and invalidated upfront (before any extent
> manipulation) following the ext4/xfs pattern. The inode lock
> (BTRFS_ILOCK_MMAP) is held throughout, preventing new dirty pages from
> appearing during the operation.

So far the explanation looks fine, but I'll need to dig deeper for each=20
patch to be sure.

>=20
> Transaction cycling: the key-shift loop cycles transactions every
> BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL (32) items to avoid
> holding a single transaction open across a large number of extents.
>=20
> Both operations are gated on CONFIG_BTRFS_EXPERIMENTAL.
>=20
> =3D=3D Known limitations =3D=3D
>=20
> INSERT_RANGE returns -EOPNOTSUPP for inlined files. Supporting inline
> files will require promoting the existing inline extent to a regular
> one, since inline extends are supported only at the very start of a
> file.

This can be addressed, e.g. by reading out the inlined extent into the=20
page cache and redirty the new page cache.

But I'd say it's not a critical part thus I'm totally fine without this=20
support for a while.

>=20
> In the opposite direction, COLLAPSE_RANGE will not create inline files
> like it should if the remaining data is small enough.

This is even less important, there are a lot of cases that we don't=20
inline a data extent, so keeping the extent uninlined is completely fine.

>=20
> I intend to address both of these limitations.
>=20
> =3D=3D Testing =3D=3D
>=20
> Tested with a Rust-based functional test suite covering:
>   - Collapse and insert at the start, middle of a file
>   - Multiple sequential operations on the same file
>   - Files with multiple extents (fsync between writes to force separate
>     extent items)
>   - Files with holes (explicit punch_hole and implicit sparse writes)
>   - Compressed extents (mount -o compress=3Dzstd)
>   - Transaction cycling (interval reduced to 4 during testing, verified
>     in dmesg logs)
>   - Inline files, verified that -EOPNOTSUPP is returned.

I guess that tool has never verify the contents, nor multi-thread stress=
=20
tests, e.g. fsstress?

>=20
> The same tests pass on both btrfs and xfs (modulo the inline files).
>=20
> I have not run fstests which I know contains tests for INSERT_RANGE
> and COLLAPSE_RANGE. I will do so.

Thus I'd prefer a fstest run before whatever your local tool.

>=20
> =3D=3D Questions for reviewers =3D=3D
>=20
> 1. Transaction cycling interval: we use 32 items per cycle. Is this
>     the right threshold, or is there an established convention in btrfs
>     for this kind of loop?


We have btrfs_should_end_transaction() to do it, thus you do not need to=
=20
use a locally defined threshold.

>=20
> 2. Extent lock scope for collapse: we hold the extent lock only on
>     [offset, offset+len) during the hole punch, not on the full
>     [offset, i_size) range that the key-shift loop operates on. Is
>     this safe, or should we lock the full affected range?

I think you should hold the lock range [offset, U64_MAX).

Especially you have already dropped all cache for range [offset,=20
U64_MAX) before the lock.

The same will apply for insert, but it looks like you have not locked=20
any extent range for insert?

>=20
> 3. CONFIG_BTRFS_EXPERIMENTAL gate: is this the right gate for these
>     operations, or should they be unconditionally available?

It's strongly recommended in this case.

>=20
> =3D=3D Notes =3D=3D
>=20
> This is my first kernel contribution. Development was significantly
> assisted by an LLM (Amazon Q Developer). The implementation, testing,
> and final review decisions are my own.

I'm very interested in how the LLM is involved.

You mentioned "implementation, testing, review" are on your own, this=20
looks like everything is on your own.

I don't think you're only using LLM to help understanding the code, thus=
=20
it looks like implementation is contributed by the LLM.

Please remember, you're the one explaining/defending the code.
But as long as you can explain/defend the code, I'm fine with that.

Still a newcomer with not a small code change will always attract more=20
scrutiny, so please don't expect rapid review/merge/etc.

>=20
> Various btrfs_info() print statements, assertions, and comments that
> were useful during development and testing have been left in place,
> but will be removed or streamlined in the next revision.

Please don't. It's pretty easy to leave such scaffolding in the final=20
code, and it will be time consuming to making they are properly removed=20
in the final version.

Furthermore, dmesg based printk() is slow thus it can mask a lot of race=
=20
related bugs just by slowing down the opeartions.

For critical operations, introduce trace events for them, there are=20
examples across several inode operations.

If you really want to debug during development, please introduce=20
temporary trace_printk()s in a dedicated patch, and just don't send that=
=20
debug patch.

Thanks,
Qu

>=20
> Paul Richards (3):
>    btrfs: refactor btrfs_fallocate() ahead of supporting more modes
>    btrfs: support for FALLOC_FL_COLLAPSE_RANGE in btrfs_fallocate()
>    btrfs: support for FALLOC_FL_INSERT_RANGE in btrfs_fallocate()
>=20
>   fs/btrfs/file.c | 601 ++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 578 insertions(+), 23 deletions(-)
>=20

