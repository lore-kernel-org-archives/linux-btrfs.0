Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655DF27B32C
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 05:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776575349; cv=none; b=V3U3W38gdwBQUTVlSxsL+3Kks5/0MVwsQFuTkxJWL6A8mAhE2d/Hj8KaUvi2SINgUNyTn21j4V+buFl/5ZY0u8qad6chwltmA2bNU7fqGERgoL3TB9I/Xim1HAP45eSh7klSjmL02kqYeNkf1Uy06KxCwl0jWS/79Ud6mm3LxDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776575349; c=relaxed/simple;
	bh=T5s8Y/AWy/M7G7Wf37TIPGCRBtd468CkrFEZuIFM5Lo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=E4gG17fTFg2l4HAbVA3edaRcJAuNohOUEugKxwf7MkiiZejGIXE7OhFTXlqzwsS4TeCAUEGJkr/iw0W2y1hNdG6kYhwtrK8/ckIIPcv7k+gP86n2A1CY7K6LQ4aRImw0eU1qhnEQqohpE5+7Hor9yRrvdGh0PKw8v/VEqdnwbaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=TnxlZGD1; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="TnxlZGD1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776575343; x=1777180143; i=quwenruo.btrfs@gmx.com;
	bh=oK0mLLTwN7SZ+aTtG8Bxgo8g3m2Ftqnknkg9yoYJuLA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=TnxlZGD1vyTrVgGP7kn4MmmWkLwtRQD9Dt9cEIb4SGjI69C0Hkyr8sjRfHRVmue2
	 KPuPyY4gTaEAuojkXKipd0vtABXoXek0JkY7d6kLY15p2NT5k6LV1HCZ8L4I0vof0
	 TVy6puXMT/w8Oitg31K7zcR/FLGsQaTPW6dvsXf66gFR3/HYYreY6WITTLPUB48G0
	 6qDT+bzg6LyrJF02bwdTPIxUEW7yXTY0euuro0mQgAo3+LxSggCIvkeTgQfAayE2i
	 kNBzpBBXQrA68FxkFlexx7Nrj6nE5E6pRYGoqI01V/6EZPwx0DolrEpvtFr4jB46I
	 L7FcHK+3Ex9QKlejvA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mgeo8-1vknXm1JM4-00mJQ3; Sun, 19
 Apr 2026 07:09:02 +0200
Message-ID: <412d6926-8613-4377-8f33-3cf0194f685b@gmx.com>
Date: Sun, 19 Apr 2026 14:38:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] btrfs: implement FALLOC_FL_COLLAPSE_RANGE and
 FALLOC_FL_INSERT_RANGE
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Paul Richards <paul.richards@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260418143808.199603-1-paul.richards@gmail.com>
 <92c96052-6619-4c25-8add-a85a4b76c060@gmx.com>
Content-Language: en-US
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
In-Reply-To: <92c96052-6619-4c25-8add-a85a4b76c060@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QcJA+37DHWuWBouJ/JPoCab57Etf8deARN4zq1r/0fcacspwjAz
 UVYkZXt1l6N3ZtI9pGUVassAdesQEaWYZq8X/zM/kzb3iaJnJj20bGW8jYWsY1BS3aFXYYn
 PFiijVwka/SU8erCffWQD5978CWMtb68HPjkTFPd2sCP5cfDsTKqs93TiVqWpVWT4foqfWC
 Kw30GwUZcXzKn9wz6Dh7A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cYcyh4iCziI=;LnkxogQSuyxio+sIn6XuglK2Fr2
 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



=E5=9C=A8 2026/4/19 09:55, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/4/19 00:08, Paul Richards =E5=86=99=E9=81=93:
>> This series adds support for FALLOC_FL_COLLAPSE_RANGE and
>> FALLOC_FL_INSERT_RANGE to btrfs_fallocate(). Both operations are
>> already supported by ext4 and xfs. The userspace contract is
>> documented in fallocate(2).
>>
>> Patch 1 refactors btrfs_fallocate() to dispatch via a switch statement,
>> moving punch_hole into its own function and decoupling locking from the
>> per-operation helpers. This is similar to the implementaitons for ext4
>> and xfs. The allocate-range and zero-range paths remain coupled since
>> they share some setup logic.
>>
>> Patches 2 and 3 add COLLAPSE_RANGE and INSERT_RANGE respectively.
>>
>> =3D=3D Implementation approach =3D=3D
>>
>> For COLLAPSE_RANGE:
>> =C2=A0 - The removed region [offset, offset+len) is punched out via
>> =C2=A0=C2=A0=C2=A0 btrfs_replace_file_extents(), which handles boundary=
 splitting.
>> =C2=A0 - All EXTENT_DATA keys with key.offset >=3D offset+len are shift=
ed
>> =C2=A0=C2=A0=C2=A0 leftward by len in forward order.
>>
>> For INSERT_RANGE:
>> =C2=A0 - All EXTENT_DATA keys with key.offset >=3D offset are shifted r=
ightward
>> =C2=A0=C2=A0=C2=A0 by len in reverse order (required to avoid key colli=
sions).
>> =C2=A0 - No pre-splitting of straddling extents is needed: the left por=
tion
>> =C2=A0=C2=A0=C2=A0 of a straddling extent stays in place, the right por=
tion is shifted;
>> =C2=A0=C2=A0=C2=A0 both reference the same physical extent via their ex=
isting
>> =C2=A0=C2=A0=C2=A0 extent_offset fields.
>>
>> For each shifted key, the corresponding back-reference in the extent
>> tree is updated via a shared helper btrfs_shift_extent_backref().

After looking into each patch, I do not think the low level direct file=20
item change is a good idea, especially with your current implement:

- Can lock the inode for a very long time
   E.g. inserting a hole into the beginning of a very large file.
   We will lock the inode until all file items are iterated, which kills
   concurrency.

- Possible problems with metadata reservation

- Problems with ^no-holes collapse
   Will cause duplicated file offsets with hole file items.

On the other hand, with reflink the insert/collapse can even be=20
implemented in user space, with a proper step setting, we can still=20
allow concurrent read/write out of the reflink ranges.

This makes me wonder, is these features really that necessary?

If you know some programs actively utilize these features for real world=
=20
benefits, but can not be done through reflink, please provide them.

Thanks,
Qu


>>
>> After the key-shift loop, btrfs_drop_extent_map_range() is called to
>> invalidate the in-memory extent map cache. This is important for reads
>> after the fallocate operation to ensure they obtain data for the new
>> offsets.
>>
>> The page cache is flushed and invalidated upfront (before any extent
>> manipulation) following the ext4/xfs pattern. The inode lock
>> (BTRFS_ILOCK_MMAP) is held throughout, preventing new dirty pages from
>> appearing during the operation.
>=20
> So far the explanation looks fine, but I'll need to dig deeper for each=
=20
> patch to be sure.
>=20
>>
>> Transaction cycling: the key-shift loop cycles transactions every
>> BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL (32) items to avoid
>> holding a single transaction open across a large number of extents.
>>
>> Both operations are gated on CONFIG_BTRFS_EXPERIMENTAL.
>>
>> =3D=3D Known limitations =3D=3D
>>
>> INSERT_RANGE returns -EOPNOTSUPP for inlined files. Supporting inline
>> files will require promoting the existing inline extent to a regular
>> one, since inline extends are supported only at the very start of a
>> file.
>=20
> This can be addressed, e.g. by reading out the inlined extent into the=
=20
> page cache and redirty the new page cache.
>=20
> But I'd say it's not a critical part thus I'm totally fine without this=
=20
> support for a while.
>=20
>>
>> In the opposite direction, COLLAPSE_RANGE will not create inline files
>> like it should if the remaining data is small enough.
>=20
> This is even less important, there are a lot of cases that we don't=20
> inline a data extent, so keeping the extent uninlined is completely fine=
.
>=20
>>
>> I intend to address both of these limitations.
>>
>> =3D=3D Testing =3D=3D
>>
>> Tested with a Rust-based functional test suite covering:
>> =C2=A0 - Collapse and insert at the start, middle of a file
>> =C2=A0 - Multiple sequential operations on the same file
>> =C2=A0 - Files with multiple extents (fsync between writes to force sep=
arate
>> =C2=A0=C2=A0=C2=A0 extent items)
>> =C2=A0 - Files with holes (explicit punch_hole and implicit sparse writ=
es)
>> =C2=A0 - Compressed extents (mount -o compress=3Dzstd)
>> =C2=A0 - Transaction cycling (interval reduced to 4 during testing, ver=
ified
>> =C2=A0=C2=A0=C2=A0 in dmesg logs)
>> =C2=A0 - Inline files, verified that -EOPNOTSUPP is returned.
>=20
> I guess that tool has never verify the contents, nor multi-thread stress=
=20
> tests, e.g. fsstress?
>=20
>>
>> The same tests pass on both btrfs and xfs (modulo the inline files).
>>
>> I have not run fstests which I know contains tests for INSERT_RANGE
>> and COLLAPSE_RANGE. I will do so.
>=20
> Thus I'd prefer a fstest run before whatever your local tool.
>=20
>>
>> =3D=3D Questions for reviewers =3D=3D
>>
>> 1. Transaction cycling interval: we use 32 items per cycle. Is this
>> =C2=A0=C2=A0=C2=A0 the right threshold, or is there an established conv=
ention in btrfs
>> =C2=A0=C2=A0=C2=A0 for this kind of loop?
>=20
>=20
> We have btrfs_should_end_transaction() to do it, thus you do not need to=
=20
> use a locally defined threshold.
>=20
>>
>> 2. Extent lock scope for collapse: we hold the extent lock only on
>> =C2=A0=C2=A0=C2=A0 [offset, offset+len) during the hole punch, not on t=
he full
>> =C2=A0=C2=A0=C2=A0 [offset, i_size) range that the key-shift loop opera=
tes on. Is
>> =C2=A0=C2=A0=C2=A0 this safe, or should we lock the full affected range=
?
>=20
> I think you should hold the lock range [offset, U64_MAX).
>=20
> Especially you have already dropped all cache for range [offset,=20
> U64_MAX) before the lock.
>=20
> The same will apply for insert, but it looks like you have not locked=20
> any extent range for insert?
>=20
>>
>> 3. CONFIG_BTRFS_EXPERIMENTAL gate: is this the right gate for these
>> =C2=A0=C2=A0=C2=A0 operations, or should they be unconditionally availa=
ble?
>=20
> It's strongly recommended in this case.
>=20
>>
>> =3D=3D Notes =3D=3D
>>
>> This is my first kernel contribution. Development was significantly
>> assisted by an LLM (Amazon Q Developer). The implementation, testing,
>> and final review decisions are my own.
>=20
> I'm very interested in how the LLM is involved.
>=20
> You mentioned "implementation, testing, review" are on your own, this=20
> looks like everything is on your own.
>=20
> I don't think you're only using LLM to help understanding the code, thus=
=20
> it looks like implementation is contributed by the LLM.
>=20
> Please remember, you're the one explaining/defending the code.
> But as long as you can explain/defend the code, I'm fine with that.
>=20
> Still a newcomer with not a small code change will always attract more=
=20
> scrutiny, so please don't expect rapid review/merge/etc.
>=20
>>
>> Various btrfs_info() print statements, assertions, and comments that
>> were useful during development and testing have been left in place,
>> but will be removed or streamlined in the next revision.
>=20
> Please don't. It's pretty easy to leave such scaffolding in the final=20
> code, and it will be time consuming to making they are properly removed=
=20
> in the final version.
>=20
> Furthermore, dmesg based printk() is slow thus it can mask a lot of race=
=20
> related bugs just by slowing down the opeartions.
>=20
> For critical operations, introduce trace events for them, there are=20
> examples across several inode operations.
>=20
> If you really want to debug during development, please introduce=20
> temporary trace_printk()s in a dedicated patch, and just don't send that=
=20
> debug patch.
>=20
> Thanks,
> Qu
>=20
>>
>> Paul Richards (3):
>> =C2=A0=C2=A0 btrfs: refactor btrfs_fallocate() ahead of supporting more=
 modes
>> =C2=A0=C2=A0 btrfs: support for FALLOC_FL_COLLAPSE_RANGE in btrfs_fallo=
cate()
>> =C2=A0=C2=A0 btrfs: support for FALLOC_FL_INSERT_RANGE in btrfs_falloca=
te()
>>
>> =C2=A0 fs/btrfs/file.c | 601 ++++++++++++++++++++++++++++++++++++++++++=
++++--
>> =C2=A0 1 file changed, 578 insertions(+), 23 deletions(-)
>>
>=20
>=20

