Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50F3F9A08;
	Wed,  5 Aug 2026 22:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785969287; cv=none; b=RmYWtw8XSEiq5XZrA/dU4ZIXWfe61oy3eyYFl3v5EWEQ8Peed62Tbzow+K0eDv82l6N26KhCBQ/E6O3nBDW+rN2WWdPDQcl9OXk/+MaP+n3UtlzJyVYdRgCone+H2BeBtfNJwKWV2BXFtqEFsavnrubaPuWnZsDJsS+bRS04rv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785969287; c=relaxed/simple;
	bh=7vvtZtzmG8qU6I7FHPpvgid3pK73zviIiD4pPGhz72s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYQ+k+NvMxO8LiV9wYRHDwMqwjcYzXjGjI/gd2AagjtrHfvKnyyEiks3Pi6avBUzUTdEm4yFnHystm2uNoiTmwhWgvbnMJQE1vizqKaIAvd2KVv3qYa9vJwieLsCR9BjEubcVRXx+qnd1DAKs1hGWIF14NEHzjEE3nl613mCydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=YceZytdl; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="YceZytdl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785969273; x=1786574073; i=quwenruo.btrfs@gmx.com;
	bh=43poT/GSX/00QsRofOTuL3LfdN/J8ckcC52QpyfC3+A=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YceZytdlAEKJU7I2q8tqCZZ1ED4iuiiT2jJGRd4kLlB9Uf5m1/Xx/gjUNkQctmCY
	 /TIHEoAsRb86SsgGGV+e/X6Zft0kiETiWnLPZIxR8GZfOM5zVeIancy5lCJs3AfOF
	 rZ7wTk0vpOev5ZN2WYvLaOiyzb8RyjP7qWFeHXDg2Nfycbdsn3Ge+TtumZPU6u+Cz
	 bEveZqZgR6a4x5J6IhXoZrQrMNUNcry66mQ5V2sku3ldQ6ke4z/kmIQE2fM5krTQS
	 0G23H882l56pssFdL9qEDu6K65pfIFPNRLYGdDXwWuE2FeVf6iwh4bEEuEXP1cu5G
	 8SekqIBGgv6XmUvZGg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N5mKP-1wxOAO0TZD-010rsL; Thu, 06
 Aug 2026 00:34:33 +0200
Message-ID: <2527e1c9-a8cd-40bf-96a1-95f74359d21e@gmx.com>
Date: Thu, 6 Aug 2026 08:04:27 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] btrfs: split btrfs_insert_delayed_dir_index() into
 prealloc and commit phases
To: Jeff Layton <jlayton@kernel.org>, Qu Wenruo <wqu@suse.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
 <20260804-btrfs-enomem-v2-2-4d923170e8c1@kernel.org>
 <8b16c994-b322-42c9-b134-47dca5f2682e@suse.com>
 <8ebbafc475baff8aedf5e2b2718db867063fab07.camel@kernel.org>
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
In-Reply-To: <8ebbafc475baff8aedf5e2b2718db867063fab07.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G7dHypJ33gG5qyM6u5JFgVrnhFHSTw0oEd9wU4Gg1AO9sI+KXRl
 RFKxT5mv5dZfuWGwiBYvRH4mpxU+Vl5jgeggCXfiqErv44moPcDMY+FhyKvj/H6VQQzLUwB
 GAFdRM4rv9NMaAteJq3dQ8Z3wTvx1DZg2Jg4Jm2u2q8uEDBuF0Es2mtSry2ZDKZqeMQYmcM
 sUDOTKpEQ7O75YodydRBA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:j58oIA1yxIs=;MImOT53gICZdUuLdm5j/UlksEd6
 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



=E5=9C=A8 2026/8/5 21:24, Jeff Layton =E5=86=99=E9=81=93:
> On Wed, 2026-08-05 at 08:44 +0930, 'Qu Wenruo' via Kernel Team wrote:
>>
>> =E5=9C=A8 2026/8/5 01:14, Jeff Layton =E5=86=99=E9=81=93:
>>> Split btrfs_insert_delayed_dir_index() into three functions using a ne=
w
>>> btrfs_dir_index_prealloc struct to bundle the pre-allocated resources:
>>>
>>> - btrfs_prealloc_delayed_dir_index(): performs the two GFP_NOFS
>>>     allocations (delayed node + delayed item) that can fail with -ENOM=
EM.
>>> - btrfs_insert_delayed_dir_index_prealloc(): populates the item data,
>>>     inserts into the rb-tree, and reserves metadata space. Cannot fail
>>>     with -ENOMEM since all allocations were done in the prealloc step.
>>> - btrfs_free_delayed_dir_index_prealloc(): frees pre-allocated
>>>     resources when the caller's btree insertion fails.
>>>
>>> The original btrfs_insert_delayed_dir_index() is refactored into a thi=
n
>>> wrapper that calls the prealloc and commit functions.
>>>
>>> This split allows callers to move the fallible memory allocations befo=
re
>>> the point of no return (the DIR_ITEM btree insertion), so that -ENOMEM
>>> can be returned cleanly without aborting the transaction.
>>>
>>> Assisted-by: LLM
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/btrfs/delayed-inode.c | 111 ++++++++++++++++++++++++++++++++++++=
+----------
>>>    fs/btrfs/delayed-inode.h |  17 ++++++++
>>>    2 files changed, 104 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
>>> index db2ffab0941a..95d2dca80444 100644
>>> --- a/fs/btrfs/delayed-inode.c
>>> +++ b/fs/btrfs/delayed-inode.c
>>> @@ -6,6 +6,7 @@
>>>   =20
>>>    #include <linux/slab.h>
>>>    #include <linux/iversion.h>
>>> +#include <linux/error-injection.h>
>>>    #include "ctree.h"
>>>    #include "fs.h"
>>>    #include "messages.h"
>>> @@ -1469,35 +1470,74 @@ static void btrfs_release_dir_index_item_space=
(struct btrfs_trans_handle *trans)
>>>    	trans->bytes_reserved -=3D bytes;
>>>    }
>>>   =20
>>> -/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpec=
ted). */
>>> -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>>> -				   const char *name, int name_len,
>>> -				   struct btrfs_inode *dir,
>>> -				   const struct btrfs_disk_key *disk_key, u8 flags,
>>> -				   u64 index)
>>> +/*
>>> + * Pre-allocate a delayed node and delayed item for a dir index inser=
tion.
>>> + * Call this before modifying the btree so that ENOMEM can be returne=
d
>>> + * before any on-disk state has changed.
>>> + *
>>> + * Returns 0 on success, -ENOMEM on allocation failure.
>>> + */
>>> +int btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
>>> +				     const char *name, int name_len,
>>> +				     struct btrfs_dir_index_prealloc *prealloc)
>>
>> We can directly return a btrfs_dir_index_prealloc pointer, which reduce
>> the parameter list.
>>
>=20
> ...but then we'd have to allocate it separately. It's currently
> allocated on the stack by the caller. I think we ought to keep it this
> way, but I'm willing to be convinced otherwise.

In the end, there are only two callsites using on-stack memory for=20
prealloc structure, one in btrfs_rename() and one in=20
btrfs_insert_dir_item().

So it would be not that hard to convert to heap memory based solution.


One thing I found a little weird is related to the lifespan management=20
of btrfs_dir_index_prealloc.

We have several call sites doing things like:

	struct btrfs_dir_index_prealloc prealloc =3D { };

	ret =3D btrfs_prealloc_delayed_dir_index();

	ret =3D btrfs_add_link(..., prealloc.item ? prealloc : NULL);
	prealloc.item =3D NULL;

Which looks a little weird to me, as we're using item to indicate if the=
=20
structure is properly allocated, not the structure itself.

If we go regular heap memory allocation, it would be more=20
straightforward and more common:

	struct btrfs_dir_index_prealloc *prealloc =3D NULL;

	prealloc =3D btrfs_prealloc_delayed_dir_index();

	ret =3D btrfs_add_link(..., prealloc);
	prealloc =3D NULL;

Feel free to ignore this one, it's mostly preference.

Thanks,
Qu

>=20
>> Otherwise looks good to me.
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>=20

