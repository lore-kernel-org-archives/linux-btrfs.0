Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD46C356754;
	Fri,  3 Jul 2026 11:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079194; cv=none; b=EIGTihfsnUMk2py2YUcqynhabKu+gGU7aKBN9tdlE5LbcsBw2Dv3r/UQXGuTM1L4BfSg5+qM1By1suqtzU2ZQDSiovfTiAcdYk1JjubDGpwugjEeNY3Qo2lafH8tm0U4e7hEWK40l3LNXBs8w+TDpR2BuZw9TStazu023z35XO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079194; c=relaxed/simple;
	bh=sGrf/1wcBYwf2qq0py12iLKgY8IWKaYthWYb/NqEouc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hUT8SHKeYdzUSXErmgCAfulTG5S0LPyY4JxvdFE8Zt3qO+OQ++cn3pwovA23IwYvo01CXc7WgsH+AYTl9g6VqE5nFEW2dUIj6cWv5wOPHsJZ56tRoJ/b9Z736BVqk0lBjaPK8U6ub7uF4pP+Q1liv6McFuJ2Z05XXNwDywnCS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=0HEPMvON; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="0HEPMvON"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gsBmK3N4nz8tys;
	Fri, 03 Jul 2026 13:46:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1783079185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xkbjq85tWAeo3PRPsB3s6iEDUUdxOC/4B213PD2McXg=;
	b=0HEPMvON1FsPisZPkQuIvRgL3qKuSJd1nf9FZJqSrlWVvUVD99WpuWNMalmJF29qgj++PC
	5YbdxNQHeR+QDDLcf6B6eF8IcClNqv4/7Nq+Lyk33Dohid/WrThz+sjpYPOxu0aJLqXqAm
	C+ksn5L8TsMHhNZgDtNkVPwjrG5o5KfxEKPWjyaROBhh65KwE3G0eEtFYOkIs6UvCVMsrk
	7OTQ7I0rynymSLrOd3bwxKJOtBhn+E9V1dwne0EBTm8HtgsclGR8oSe/P2j5+7/WXqUCxJ
	9FipVbaytqZ2Sjf7rz+XOV9RXd79BLnIJgl9BrG/VDgF5+TC1CDHBgF4i820QQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=softfail (outgoing_mbo_mout: 2001:67c:2050:b231:465::1 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
In-Reply-To: <9c8421f2-7f17-430a-9f87-26fab7b1d73d@wdc.com> (Johannes
	Thumshirn's message of "Fri, 3 Jul 2026 12:01:22 +0200")
References: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
	<9c8421f2-7f17-430a-9f87-26fab7b1d73d@wdc.com>
Date: Fri, 03 Jul 2026 13:46:22 +0200
Message-ID: <87jyrc70tt.fsf@>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspamd-Queue-Id: 4gsBmK3N4nz8tys

--=-=-=
Content-Type: text/plain

Johannes Thumshirn @ 2026-07-03 12:01 +02:

> On 7/3/26 10:45 AM, Johannes Thumshirn wrote:
>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
>> block group from zone_active_bgs, but only the path in
>> check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
>> Any other finish path leaves active_meta_bg / active_system_bg pointing
>> at an inactive, fully written block group.
>>
>> Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish()
>> so it can never go stale.
>>
>> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>   fs/btrfs/zoned.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 44a13ed6b8b2..c8c850de1702 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -2539,6 +2539,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
>>   	const bool is_metadata = (block_group->flags &
>>   			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
>>   	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>> +	struct btrfs_block_group **active_bg = NULL;
>>   	int ret = 0;
>>   	int i;
>>   @@ -2636,6 +2637,20 @@ static int do_zone_finish(struct btrfs_block_group
>> *block_group, bool fully_writ
>>   	/* For active_bg_list */
>>   	btrfs_put_block_group(block_group);
>>   +	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
>> +		active_bg = &fs_info->active_system_bg;
>> +	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
>> +		active_bg = &fs_info->active_meta_bg;
>> +
>> +	if (active_bg) {
>> +		btrfs_zoned_meta_io_lock(fs_info);
>> +		if (*active_bg == block_group) {
>> +			btrfs_put_block_group(block_group);
>> +			*active_bg = NULL;
>> +		}
>> +		btrfs_zoned_meta_io_unlock(fs_info);
>> +	}
>> +
>>   	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
>>     	return 0;
>
> I think Sashiko has a point here:
>
> https://sashiko.dev/#/patchset/20260703084559.136605-1-johannes.thumshirn%40wdc.com
>
> check_bg_is_active() should take a reference before calling into
> do_zone_finish() or actually clearing fs_info->active_{meta,system}_bg can even
> be done in check_bg_is_active() after calling do_zone_finish().
>
> That'll then also eliminate Miquel's concerns.

I'd maybe take the latter to avoid adding more complexity to an already
complex do_zone_finish(). Besides, I see that do_zone_finish() is
already called in many other places throughout btrfs/zoned.c, so I
wonder if having the changes in do_zone_finish() would also "spill" over
there.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmpHoQ4bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
Za2AD/4q8vKER+44H86pKGnSr+12cK98Uo510nLSg0xOZaTTw9DbPDDg1Shb/Bcg
qolF0/i5zsdXXE5CuKUduPECDgUXpMeB0DvS251BqSbOv1PMX69zXfT0bQFEQipu
w7fJIPfd08gwoyAIyHN2BPdnnyoe7f8w8oNtHPGDEg5nIp0z+iyEOdhCFkv6ta3P
xaynLdiDTCDLN43+8dtTQQoErf4r24l4TaO3ndo5gyZ294iMNvzQA9tdrmiGPA5J
vdwVNDvNOsMij3Rk5x/b2w4SJRXFYnbbP5HZk4m/dFxdBF8HgZ+vf5BC06J2TL1Y
KiNty8mKoB9zJux30/IctEs53l1ioCKjMmamClORJ0vs97Mm/sdkkt7Y8WQsCktV
2kO0vbhkr7MNOBbp6VbdLQ7gS1rwLOgj5iXDo6z5yIrcHhWzFcHnWjKcZo/r10Wx
M9mmW3pn7I52dubPHjZy8MdsK1C5dTTQXnjNf4gN0LkUAObm0a15GKytxZnRhHPT
ppNe2ah37GFFBCwkDOu3fF/9mparqD9D1ai8qDktKEkBa2ZQa/OmfOUkl9p/0eGR
IUn9GrVishpIdmwqEboiR7Vvd0WA9cq+6n9Wu9gEGreyswqTePY40lE3IUUkM+Jw
HtPd7q0XGWIc4C4whInzPBtuqq/YHatHqRn6qO8vAXzCMACosA==
=bcxr
-----END PGP SIGNATURE-----
--=-=-=--
