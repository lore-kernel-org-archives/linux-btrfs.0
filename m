Received: from sg-3-41.ptr.tlmpb.com (sg-3-41.ptr.tlmpb.com [101.45.255.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB83A6B6F
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790919827; cv=none; b=bnPiwD+wbjisWVtIG0t3TXwQSKwvqQrR0S4eo4gw4nyglAVEz9aTg+CSuKahsoTltzK+DPV8+P1fj7fPq7VKtGD24f6XLxSjAVAsiHr+XUej7I2zcUX2djwZ/Z5hB/qMqRS7G/xjowxGg06+HMT07HcmHPIm+BgiURzNaCqgvpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790919827; c=relaxed/simple;
	bh=3sgJo4lO6+sqNr+5GQ6q0WZdBmSh/xFcsv44Z3tfIqc=;
	h=Subject:Date:Mime-Version:To:Message-Id:References:In-Reply-To:Cc:
	 From:Content-Type; b=l2lH/Rhhn8JMpQSSpKq/BeF4qt5CWDljFDgdytlkeZMYEPBM6JOB5qxymFWXzY5sZAeUslHWnNa+A2wELXvV99U2vc62VZ1LRQRnkZH2s2iujQDTGYmv6FEECzJNbMlFBfq66pdFCNFrSsupZ4hJ8z98rI03idPdLAEF2uNrrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=olWl+1tg; arc=none smtp.client-ip=101.45.255.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="olWl+1tg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790919771;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MSV2vzTXjAvuG3Rr4uxTEVVQfQzdDjvnZCgZSVbhgNM=;
 b=olWl+1tgXKWVTJsfxh1ZADQrdiDbwEoLMINCbZWRAPmscdiY/ReR5gELOVg8bZYDzN92yq
 NGWSfh+4pJBZPhLcMoyWBR1IqIBblKleZu+MRBbfxJv/GnxPKSmlfv+2adXL+HHuBqu9vg
 qcde8gU352wTMWV9Df58AalN4t1uEvNm2xx6wpZ5oMLaqrNgiSzWZxMdCrOJf1nrwVJy40
 KVjKqXBgkA4QNT7O+mgmyRmLINripM22lipOfCLkphjc0zGIn317Bp31VAggBfwwrE08i4
 rZcgOrKl480HkPBi1IBAVj86y0P1KTwWzedcBhZdzDxhVS6qwzQTy9pPu/CtNw==
Received: from [192.168.8.64] ([183.34.167.12]) by smtp.larksuite.com with ESMTPS; Fri, 02 Oct 2026 05:42:50 +0000
X-Lms-Return-Path: <lba+26abf445b+0b30b3+vger.kernel.org+zhudongjiang@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] btrfs: zoned: track only sequential zones as active
Date: Fri, 2 Oct 2026 13:42:45 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
To: "Naohiro Aota" <Naohiro.Aota@wdc.com>, <linux-btrfs@vger.kernel.org>
Message-Id: <c41ec3b1-ec5f-4407-b45a-f831fd091351@fygo.io>
References: <cover.1787717573.git.zhudongjiang@fygo.io> <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io> <DL0AVDP5O9C2.1VT2TYQXCL4B4@wdc.com> <3604f3af-2a44-4b8a-8b6b-67e8070308ed@fygo.io>
In-Reply-To: <3604f3af-2a44-4b8a-8b6b-67e8070308ed@fygo.io>
Cc: <johannes.thumshirn@wdc.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/8/28 20:03, Dongjiang Zhu =E5=86=99=E9=81=93:
> =E5=9C=A8 2026/8/28 12:42, Naohiro Aota =E5=86=99=E9=81=93:
>> On Wed Aug 26, 2026 at 1:27 PM JST, Dongjiang Zhu wrote:
>>> The runtime activation and finish paths apply active-zone accounting to
>>> both conventional and sequential stripes.
>>>
>>> At mount, however, active_zones_left is rebuilt from device zone
>>> conditions.=C2=A0 Conventional zones report NOT_WP and are therefore no=
t
>>> included.=C2=A0 Meanwhile, all-conventional block groups are marked act=
ive
>>> and added to zone_active_bgs, so mount recovery still decreases
>>> reserved_active_zones for their metadata and system stripes.
>>>
>>> The two counters can therefore diverge across a remount.
>>>
>>> Each unmatched reservation decrement lets data consume one more
>>> sequential active-zone slot.=C2=A0 Once the reservation becomes negativ=
e,
>>> data can exhaust all such slots.
>>
>> Yes, apparently, this was not a problem previously, Because,
>> max_active_zones > 0 mostly means there is no conventional zones. But,
>> we changed the btrfs_get_max_active_zones() behavior to also use
>> bdev_max_open_zones() to set the max_active_zones. This is a regressio
>> introduced by that change, which deserves Fixes tag.
>>
>=20
> Agreed.=C2=A0 I will add the Fixes tag in the next revision.
>=20
>>>
>>> [...]
>>>
>>> +static inline bool btrfs_needs_active_zone_tracking(struct btrfs_devic=
e *dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 u64 physical)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 if (!btrfs_dev_is_sequential(dev, physical))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (dev->zone_info->max_active_zones =3D=3D 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>>
>> Apparently, since we use bdev_max_open_zones() to populate
>> zone_info->max_active_zones, we won't have max_active_zones =3D=3D 0 now=
?
>>
>=20
> It can still be zero.=C2=A0 btrfs_get_max_active_zones() initially assign=
s a
> non-zero value, but btrfs_get_dev_zone_info() resets it to zero for
> backward compatibility when nactive exceeds the derived limit and the
> device reports no hardware max_active_zones limit.=C2=A0 The per-device c=
heck
> is therefore still needed.
>=20
>>>
>>> [...]
>>>
>>
>> Also, as you dropped a BG on conventional zones from the
>> zone_active_bgs, prepare_allocation_zoned() will never return the
>> conventional BG to allocate with.
>=20
> Thanks for pointing this out.
>=20
> I intentionally changed zone_active_bgs so that conventional-only block
> groups are excluded.=C2=A0 I understood that this would also affect the
> candidates used by prepare_allocation_zoned().
>=20
> As I understand it, this is only an initial allocation hint.=C2=A0 Conven=
tional
> block groups are no longer preferred through this path, but can still be
> selected by the subsequent block group scan.=C2=A0 Am I missing anything =
here?
>=20
> My original plan was to address the allocation policy separately after th=
is
> series.=C2=A0 I also compared the baseline and the full series with conve=
ntional
> and sequential data/metadata workloads and did not observe a measurable
> performance regression.
>=20
> As a separate question, on devices with both conventional and sequential
> zones, should allocation generally prefer conventional zones, or balance
> them with active sequential zones?=C2=A0 Besides preserving active-zone s=
lots,
> are there performance or endurance differences that should guide this
> policy?

Hi Naohiro,

A gentle ping before I send v4: could we clarify whether it is
acceptable to keep zone_active_bgs limited to sequential-zone
block groups?

I used dm-linear on an HC620 to construct a device with 4 GiB of
conventional zones and 128 GiB of sequential zones. Each sample
was independently prepared on baseline, using either a fresh or
an aged filesystem, before rebooting into the kernel under test.

I compared baseline and patch 1 with five A/B pairs per filesystem
state. The table shows the change in median throughput with
patch 1 relative to baseline; positive values mean faster:

+---------------------------+---------+---------+
| Workload                  | Fresh   | Aged    |
+---------------------------+---------+---------+
| 1 MiB sequential writes   |  -0.03% |  +1.74% |
| 4 KiB sequential writes   |  +0.05% |  -0.66% |
| 4 KiB mixed random R/W    |  +0.22% |  +0.70% |
| Postmark                  |  +0.87% |  -1.76% |
+---------------------------+---------+---------+

The median differences were small, suggesting no substantial
performance regression in these four workloads.

I'd still prefer to keep zone_active_bgs tracking only
sequential-zone block groups for now and address allocation-policy
changes separately.

Thanks,
Dongjiang
