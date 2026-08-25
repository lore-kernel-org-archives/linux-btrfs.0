Received: from va-2-51.ptr.blmpb.com (va-2-51.ptr.blmpb.com [209.127.231.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C99721257F
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 03:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787626925; cv=none; b=Z8rNGTDb44au3fa2519NGB7YAwuYK5IAmq9JFW8EY8inKvu5oDCnHmE2dH5lz0RYEZDGWk8u8AhjUNFBrPx5OU7Z7u+vEMB0ObeZZjNdsAN5ZDmUGyCDMOb/Jnh76+yLf5j6EmEaWAAmKI31IXyE+H3JM9HjuCiW8EyI6Wdrzxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787626925; c=relaxed/simple;
	bh=50ridU77KVD4tRIYxeG+d+ygNUDsZrTUHSQZL8+jVV8=;
	h=Content-Type:In-Reply-To:From:Subject:To:Date:Message-Id:
	 Mime-Version:References:Cc; b=UcJ4gs5jgouhEbpsOJWKgstMm87vmQK4k8tut4kLPRLiYHOQDado9NSR5ybrDucvsV9xjJqcvzG7iS28iHNpFnsiuKCbNU7BUzriXSdan+vzX5nzDyyTHHu7cMOeoWdn8m8Fean/4p0XPIBnueJIgu95pv35+cn90L4wnDBaI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=InlammKz; arc=none smtp.client-ip=209.127.231.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="InlammKz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787626914;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MwtIwOvIDBl+JhtHj6kpJm+8riycMwc8Qi7zpmusFcc=;
 b=InlammKzXfTiCaCqWR009ofaXADF5bLhPbcGfXh57zo9jLRjlxw4krDTzyaj1ZfGcPlw98
 YZsRJQdabfBp5a6YCPJfsoyyv13o00adRW8JUrXm/kA18JSgYBU0NFQvPz1FK2U4HagB2V
 0CH0nKDXVz1acvr/H4R9vGx+pQiDYAmKg5J09aYY81lNd7B1UkGObPhET4IGeOxjIMgVjV
 oMhc/ANRiquFkVlI8Jp5d2A/c1PIMQC2Wka470YARmjY/D3cB4L13FX3tvZcb25/hsU/FH
 v+0gHfH5YHZsODzOgMxnctzM4XgX33DJTK3n7Td9Fz0xUP5xD2N1Jh56VOl9Lg==
X-Lms-Return-Path: <lba+26a8d05a1+79ed83+vger.kernel.org+zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <aoxL1ZK42wn7VIwQ@mayhem.fritz.box>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Received: from [192.168.8.64] ([183.34.169.70]) by smtp.larksuite.com with ESMTPS; Tue, 25 Aug 2026 03:01:53 +0000
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Subject: Re: [PATCH 1/4] btrfs: zoned: track only sequential zones as active
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>
Date: Tue, 25 Aug 2026 11:01:49 +0800
Message-Id: <cdafbb62-cf65-46aa-a3bf-d04c6ad94768@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1787551793.git.zhudongjiang@fygo.io> <9b86d2db35ad9afc13069d6ee8fcf421c85ef030.1787551793.git.zhudongjiang@fygo.io> <aoxL1ZK42wn7VIwQ@mayhem.fritz.box>
Cc: <linux-btrfs@vger.kernel.org>, <naohiro.aota@wdc.com>

=E5=9C=A8 2026/8/24 21:55, Johannes Thumshirn =E5=86=99=E9=81=93:
> On Mon, Aug 24, 2026 at 02:49:53PM +0800, Dongjiang Zhu wrote:
>> [CAUSE]
>> The runtime activation and finish paths apply active-zone accounting to
>> both conventional and sequential stripes.
>>
>> At mount, however, active_zones_left is rebuilt from device zone
>> conditions.  Conventional zones report NOT_WP and are therefore not
>> included.  Meanwhile, all-conventional block groups are marked active
>> and added to zone_active_bgs, so mount recovery still decreases
>> reserved_active_zones for their metadata and system stripes.
>>
>> The two counters can therefore diverge across a remount.
>>
>> [BUG]
>> Each unmatched reservation decrement lets data consume one more
>> sequential active-zone slot.  Once the reservation becomes negative,
>> data can exhaust all such slots.
>>
>> A later transition from a conventional metadata or system target to a
>> sequential one can then fail, because finishing the conventional target
>> does not release a sequential active-zone slot.
>>
>> If this happens during synchronous transaction writeback,
>> btrfs_check_meta_write_pointer() returns -EAGAIN.  The transaction is
>> then aborted and the filesystem is forced read-only.
>>
>> The reservation mismatch was reproduced by creating small files with
>> large xattrs in batches, syncing them and remounting an HC620 filesystem
>> using SINGLE profiles:
>>
>>    active_zones_left:     126
>>    reserved_active_zones: 3 -> -8
>>
>> The active list contained one partially used conventional system block
>> group, nine full conventional metadata block groups and one partially
>> used conventional metadata block group.
>>
>> [FIX]
>> Use sequential stripes as the unit of active-zone tracking.
>>
>> Do not mark all-conventional block groups active.  Only sequential
>> stripes update the active-zone bitmap and non-data reservation during
>> activation, finish and mount recovery.
>>
>> Assisted-by: LLM
>> Signed-off-by: Dongjiang Zhu<zhudongjiang@fygo.io>
> Looks good, two small nits though in case you need to resend the series:
> 1) Please don't do the [CAUSE], [BUG], [FIX] thingy, I know Qu does it bu=
t
> noone else does that.

Sure, I will remove these headings from the commit messages in v2.

> 2) We now have a repeated pattern of:
>=20
>    if (!btrfs_dev_is_sequential())
> 	return
>    if (max_active_zones)
>          return
>=20
> Maybe have a helper for that? Something like
>=20
> static inline bool btrfs_needs_active_zone_tracking(struct btrfs_device *=
dev,
> 						    u64 physical)
> {
> 	if (!btrfs_dev_is_sequential(dev, physical))
> 		return false;
>=20
> 	if (dev->zone_info->max_active_zones =3D=3D 0)
> 		return false;
>=20
> 	return true;
> }
>=20

Good idea. I will add the helper and use it for the repeated checks in
v2.

Thanks for the review.

Dongjiang Zhu

> Otherwise looks good,
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
>
