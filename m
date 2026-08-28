Received: from sg-3-43.ptr.tlmpb.com (sg-3-43.ptr.tlmpb.com [101.45.255.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D2B3D5666
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 12:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787918731; cv=none; b=JNyGR5cbKK69MY/M4w25JC5oHyzdgs5S9HSJdJR1o4SC2fU6SVEesexEEFDhjpJyls2svxMiy0aWOsH9XxRCPN4iZtqRyNWXasr50EJxqUC0bocEd5BwFifLgjRx7ROW4R7MukOuN8cqzhYQLSTzRahKHBnTsQtkfIiSc7QwMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787918731; c=relaxed/simple;
	bh=zxsf74GlXshtybKpBc6Tc+wE3y6dhaDmG1HZAhtBA6c=;
	h=To:Cc:Message-Id:References:Subject:Mime-Version:In-Reply-To:From:
	 Date:Content-Type; b=B6d2qm3c0SUAp7M5DnFTjUfNZU/5ZrMUSbKDdj0o596r2BgOMciXQSRHx42NZGvWNC+vSKSKjXYqqHSKzDaTgoVmS4WLQF4Anuw2UtYTiCDqdL556wUkwLvOU/dJNp+QeFgVBX1MQWnKWIOa1Zk0byP9nulzYAuexgOy8DoctVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=X/AbqnEA; arc=none smtp.client-ip=101.45.255.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="X/AbqnEA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787918594;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LOGHoHB91x6tHwBa0kPI3+QDrUqtBR21CtcG+t9JX84=;
 b=X/AbqnEAgrBMDVCM9RCYYBGGW/H6bXlSvks5Wv/q+di9VTy4qfGlZKWLJLOyYGxdQpB6Ev
 Ze1Q8Md/m15n+eEjICXjUpmT1ACsDhwPpPw6rCBbk/hGz6W/x5QuXK+XdF3EXNAqumUlap
 NgEffhLYd0w6uNwpZC7rpUUnRXATxNAvs7Riq7FIe+rOcUuJ27wU2+rC0KzgySrBRLGrnh
 6LI4kDUIVo1d2cih6icitQsv5YsfRFrHnC/60PAkqWHC8I4PEHthx0nmNYiSDnfZUHrOyi
 czXHjS6KFZWngh9XLwGuuc31qPzyCYaD0nWbTKnmEmFs+NbryKU3g9XA+YNLvQ==
To: "Naohiro Aota" <Naohiro.Aota@wdc.com>, <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>
Message-Id: <3604f3af-2a44-4b8a-8b6b-67e8070308ed@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
References: <cover.1787717573.git.zhudongjiang@fygo.io> <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io> <DL0AVDP5O9C2.1VT2TYQXCL4B4@wdc.com>
Subject: Re: [PATCH v2 1/4] btrfs: zoned: track only sequential zones as active
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <DL0AVDP5O9C2.1VT2TYQXCL4B4@wdc.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a9178fe+bbd06e+vger.kernel.org+zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Fri, 28 Aug 2026 20:03:04 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.8.64] ([14.21.226.247]) by smtp.larksuite.com with ESMTPS; Fri, 28 Aug 2026 12:03:09 +0000
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/8/28 12:42, Naohiro Aota =E5=86=99=E9=81=93:
> On Wed Aug 26, 2026 at 1:27 PM JST, Dongjiang Zhu wrote:
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
>> Each unmatched reservation decrement lets data consume one more
>> sequential active-zone slot.  Once the reservation becomes negative,
>> data can exhaust all such slots.
>=20
> Yes, apparently, this was not a problem previously, Because,
> max_active_zones > 0 mostly means there is no conventional zones. But,
> we changed the btrfs_get_max_active_zones() behavior to also use
> bdev_max_open_zones() to set the max_active_zones. This is a regressio
> introduced by that change, which deserves Fixes tag.
>=20

Agreed.  I will add the Fixes tag in the next revision.

>>
>> [...]
>>
>> +static inline bool btrfs_needs_active_zone_tracking(struct btrfs_device=
 *dev,
>> +						    u64 physical)
>> +{
>> +	if (!btrfs_dev_is_sequential(dev, physical))
>> +		return false;
>> +
>> +	if (dev->zone_info->max_active_zones =3D=3D 0)
>> +		return false;
>=20
> Apparently, since we use bdev_max_open_zones() to populate
> zone_info->max_active_zones, we won't have max_active_zones =3D=3D 0 now?
>=20

It can still be zero.  btrfs_get_max_active_zones() initially assigns a
non-zero value, but btrfs_get_dev_zone_info() resets it to zero for
backward compatibility when nactive exceeds the derived limit and the
device reports no hardware max_active_zones limit.  The per-device check
is therefore still needed.

>>
>> [...]
>>
>=20
> Also, as you dropped a BG on conventional zones from the
> zone_active_bgs, prepare_allocation_zoned() will never return the
> conventional BG to allocate with.

Thanks for pointing this out.

I intentionally changed zone_active_bgs so that conventional-only block
groups are excluded.  I understood that this would also affect the
candidates used by prepare_allocation_zoned().

As I understand it, this is only an initial allocation hint.  Conventional
block groups are no longer preferred through this path, but can still be
selected by the subsequent block group scan.  Am I missing anything here?

My original plan was to address the allocation policy separately after this
series.  I also compared the baseline and the full series with conventional
and sequential data/metadata workloads and did not observe a measurable
performance regression.

As a separate question, on devices with both conventional and sequential
zones, should allocation generally prefer conventional zones, or balance
them with active sequential zones?  Besides preserving active-zone slots,
are there performance or endurance differences that should guide this
policy?

Thanks for the review,
Dongjiang Zhu
