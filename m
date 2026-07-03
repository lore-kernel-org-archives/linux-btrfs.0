Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93F3CB2E5;
	Fri,  3 Jul 2026 11:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079496; cv=none; b=gHIei33wd86auxrX/7Do3RMug6HJ6Ku3bsJ3nDuHOsUc/SENwzHVdUDAYAqRnj/6wbiAkqjLMJEXDCjb8AxC/kA35B10CQVvvPtZyGK6hqEattbZX6IIhLND/iqZe7Hj7w69eGH/GHgxdr/uS5jkDG68bZXd8ibMknlume0Ct8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079496; c=relaxed/simple;
	bh=EN1FoxVYcSZZrRZfuiIGBF7q61Fq5UvtH7L7Z6USWoU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NxMVjKNAWH33cQ5ZD1gAI+US+L84Jh5ktXus6fjkTrjkUZqYcHlS5VhLByKqrz/P9uF+H9+57yDAfHHy4mv29aAZ220YOLvk4UX3spL2xkCllM49G3QLK4A1DMmzwmxQo5zr6mk/fZ5Ytt3FIsRjTILvmIkS7weiKtKEcwTKiME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=PrbOPp5Y; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="PrbOPp5Y"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4gsBg82b8Gz9trT;
	Fri,  3 Jul 2026 13:41:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1783078916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5ijYd4+DDU74Lv+YgQXZzF3vZnpBfVx9YRqkbIMycs=;
	b=PrbOPp5YJVzJBAlgSQngjEYN5cGl8t5+wfQRxSYtBhF9rYE4n3A4vFlSkggqCZUuRJaUwb
	NSxTWUNmBNn3NAbeV1yTNMiZQXriKJFOPGFxsmFnBHpGCwhqplGCvWVuR5GMiDSWP6bwPT
	+hHjIAR7+/vhu90gkw5jhYdCkyMcweiQcrfRfNPDixaFGM/8bWvEK0uICQWF5Avf5RHqqF
	CuDlsFLxiNt/4ypE69imV45//XOWbdVRXx3/653JbGi3DeDYhsXK82xLYUJxyrHZ9haGp8
	Y9Wq8tsqRsf9dv7yECZyctQVgkcjSKRP3O0+U4MqtAbp8Dlv5gKe774xejIuCA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=softfail (outgoing_mbo_mout: 2001:67c:2050:b231:465::202 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
In-Reply-To: <b0d5ea81-37bd-44c3-b69c-ce7d47d02cdc@wdc.com> (Johannes
	Thumshirn's message of "Fri, 3 Jul 2026 11:50:46 +0200")
References: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
	<b0d5ea81-37bd-44c3-b69c-ce7d47d02cdc@wdc.com>
Date: Fri, 03 Jul 2026 13:41:53 +0200
Message-ID: <87pl14711a.fsf@>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspamd-Queue-Id: 4gsBg82b8Gz9trT

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Johannes Thumshirn @ 2026-07-03 11:50 +02:

> On 7/3/26 11:31 AM, Miquel Sabat=C3=A9 Sol=C3=A0 wrote:
>> Hi,
>>
>> If you don't mind, a couple of questions from a newcomer that is trying
>> to grok this part of the code :)
>>
>> Johannes Thumshirn @ 2026-07-03 10:45 +02:
>>
>>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
>>> block group from zone_active_bgs, but only the path in
>>> check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
>>> Any other finish path leaves active_meta_bg / active_system_bg pointing
>>> at an inactive, fully written block group.
>>>
>>> Reset the corresponding active_{meta,system}_bg pointer in do_zone_fini=
sh()
>>> so it can never go stale.
>>>
>>> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on wr=
ite time")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>> ---
>>>   fs/btrfs/zoned.c | 15 +++++++++++++++
>>>   1 file changed, 15 insertions(+)
>>>
>>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>>> index 44a13ed6b8b2..c8c850de1702 100644
>>> --- a/fs/btrfs/zoned.c
>>> +++ b/fs/btrfs/zoned.c
>>> @@ -2539,6 +2539,7 @@ static int do_zone_finish(struct btrfs_block_grou=
p *block_group, bool fully_writ
>>>   	const bool is_metadata =3D (block_group->flags &
>>>   			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
>>>   	struct btrfs_dev_replace *dev_replace =3D &fs_info->dev_replace;
>>> +	struct btrfs_block_group **active_bg =3D NULL;
>>>   	int ret =3D 0;
>>>   	int i;
>>>
>>> @@ -2636,6 +2637,20 @@ static int do_zone_finish(struct btrfs_block_gro=
up *block_group, bool fully_writ
>>>   	/* For active_bg_list */
>>>   	btrfs_put_block_group(block_group);
>>>
>>> +	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
>>> +		active_bg =3D &fs_info->active_system_bg;
>>> +	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
>>> +		active_bg =3D &fs_info->active_meta_bg;
>>> +
>>> +	if (active_bg) {
>>> +		btrfs_zoned_meta_io_lock(fs_info);
>> If you need to lock/unlock in order call btrfs_put_block_group() and
>> then reset *active_bg, couldn't the previous if statement be written
>> like so?
>>
>> if (active_bg && (*active_bg =3D=3D block_group)) {
>>
>> This would then only lock/unlock just in the case we really want to
>> touch this 'block_group', no?
>
>
> Yes it could be simplified, but I'm thinking what it would buy us. For su=
re we
> would not take the lock when finishing a DATA block-group here. Note the =
lock is
> not protecting a data structure but is for serializing metadata writes, s=
o we do
> a QD=3D1 write to the drive for METADATA/SYSTEM block-groups as we cannot=
 use
> REQ_OP_ZONE_APPEND on these.
>
>
>>> +		if (*active_bg =3D=3D block_group) {
>>> +			btrfs_put_block_group(block_group);
>> Also, hasn't 'block_group' already been put before your patch? Won't
>> this try to double-free this pointer? Or it is about decreasing the
>> reference twice for this block group?
> The put before is for the reference on the active_bgs_list, so we should =
still
> have a reference left.

Points raised by Sashiko aside, thanks for the clarifications, much
appreciated.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmpHoAEbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZZafEACHG+6V1Jnv5fthtlSYk49/3DwGhiKWwHVv8D8ZOvwFi6UBV3vWJ3LGNrd9
trjHoOovSB5imGqbjiLy0a9ShB05Al+b2mnlgblQRxIAegpYuKWogo7TLlORDfcF
XaQAr6SKRa++6gwOHqBw0VJA3Tegd6qx9HdOqwEM8NmCvomzBAHGdqr7DNiZgm1y
rb4nhaALv18eTzHMyUzBBn6Gixm3meQBQvxpOT0id3o88PCJHlAw7Gn0oX+ToFCB
o0+nDckpWOhPAEdtLdeT+0YQIOQjxn7XdgJxeKkWEWe3COdqSNd4FYsBSO/CRtfV
6hjbHsu3KipMaVwBck2IViqQmmSoEhP+sMEYc68rnmFBdyyzjHLY9Vd+r20e331b
yMBo8lJSorNYS3MiwRSZOE3h1x9vsTge60iMrQYNHQRmFTqc3L5bb1/JTOX6kuLo
eTmCkJdNvOGgCofYutGwS42dvTPIJWh48fzgE1BZzbjJIpgDm2Hxc0fGorIkaDCT
hfmmN9EbbKNmD/cAYExGz1Ks2bfYqxshdvJLzODbcOpimAzTNDR7MGWPYML3f4b+
WvJhT/55e2hcZhqxCvYWicroxZPpBJjYV2cnZpLD1svVShsGXLPKERml6yuhrq/T
TdSM9Lz9DLBYVA8l41iFuCbjgxYDL2ea+8RgUGexi27Jmu702A==
=K/xi
-----END PGP SIGNATURE-----
--=-=-=--
