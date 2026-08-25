Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE8E1A6822
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 03:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787627821; cv=none; b=r9g/rimvdbyr6Sn2IxJV5sfUSs0SE98llc3RDvvJP9fHbo3wWDsRs5C1c8tpGyfstROryEjAavjES6OxHwy30/PgC9LxiFTHgocDLoLEC5QrH2evBe4OA9LAF1BjvyqrtmwlnbyZHWWFBpPAOkDr0rkHzwGFPEN5y79jRErrhcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787627821; c=relaxed/simple;
	bh=Zrkxo2Qwa23wdkNE3kljCsLNBAnDc0lnRPBr8Rw2Eog=;
	h=In-Reply-To:References:To:Message-Id:Mime-Version:Cc:From:Subject:
	 Content-Type:Date; b=IEaCXp5qPQOCrCxktyxA5eaBf5dLWPMNZQfHJ0tOMzLdbt3TRjM9Tub3h4JJoM8+OOfwKPNJHjQkzWnMU3oz82LV6KX2exr0tXztgBzIKzf4Xq09tLY9bY+BRv3FuwVEC7wi9HmUPgOH00nW8FhZgFqYNc+EA1Kky2VkJ/wVqgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RAKNI3Lg; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RAKNI3Lg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787627807;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Aph8zmei7FIJ6kouIrO7ryV8GSGsTw7Up6+dWr41KO8=;
 b=RAKNI3LgShDTrL5mxnSpzYUNxcLxdUI3RUJjpZc0U+Ddx7cidjCSSwXYJ0CQVbnrEv8Yhy
 G3kCi8rSs/OzjroNv6cIcQtBX2pNPEjR89j0MOz+Q8Yz5fkMDZKqo+4Z09hRAHid85xm1G
 agAhiktn4Z8tEZU55bpsNEt2r1emQlytJ1CgUF56gHVUiMqegFQoWZ1442l/T3W1bNfHze
 OU6zIOgrPlzeCGskkwBEsHhONWXRVVUtvQmSqnqlcsN87DIpWt7IjOSSkWHGFDaeC3Hx/Q
 Mn7IuC7q70G4aIohwDjmuFo4bjuoniBbfr267tBo5DoGP+4LSH/+en9Sw+zQPQ==
In-Reply-To: <aoxpGiMYRNdRX0wA@mayhem.fritz.box>
References: <cover.1787551793.git.zhudongjiang@fygo.io> <388e4a6778d65d6d08c7f921c629d4645bac9959.1787551793.git.zhudongjiang@fygo.io> <aoxpGiMYRNdRX0wA@mayhem.fritz.box>
Content-Transfer-Encoding: quoted-printable
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>
Message-Id: <93d07ed9-6425-4d78-ab9a-198cfdfae5ea@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-btrfs@vger.kernel.org>, <naohiro.aota@wdc.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] btrfs: zoned: serialize zone finishing per block group
Received: from [192.168.8.64] ([183.34.169.70]) by smtp.larksuite.com with ESMTPS; Tue, 25 Aug 2026 03:16:46 +0000
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 11:16:42 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
X-Lms-Return-Path: <lba+26a8d091e+aea034+vger.kernel.org+zhudongjiang@fygo.io>

=E5=9C=A8 2026/8/25 0:00, Johannes Thumshirn =E5=86=99=E9=81=93:
> On Mon, Aug 24, 2026 at 02:49:56PM +0800, Dongjiang Zhu wrote:
>> [BUG]
>> On an HC620 with max_active_zones=3D128, buffered writes occupied all 12=
8
>> active-zone slots.  A metadata-heavy create/delete workload followed by
>> sync then forced a metadata block group switch.
>=20
> Can you explain that to me. In my mental model, if all 128 active-zones a=
re
> used and you call sync, we need to add a treelog-bg. But there is no more
> active zone resource available so we cannot create the treelog bg. This i=
s why
> we fail, so we need to finish a zone first to then create a treelog bg.
>=20
>>
>> A kernel with additional zone finish tracing reported:
>>
>>    zoned-debug: finish clear-runtime bg=3D140928614400 caller=3Dbtrfs_zo=
ne_finish_endio_workfn comm=3Dkworker/u8:7
>>    zoned-debug: finish early-inactive bg=3D140928614400 caller=3Dbtrfs_c=
heck_meta_write_pointer comm=3Dsync
>>    zoned-debug: pivot finish ret=3D0 old_bg=3D140928614400 new_bg=3D3398=
39287296
>>    zoned-debug: activate fail slot bg=3D339839287296 type=3Dmetadata lef=
t=3D0 max_active=3D128 comm=3Dsync
>>    zoned-debug: finish zone-mgmt bg=3D140928614400 ret=3D0 left=3D0 call=
er=3Dbtrfs_zone_finish_endio_workfn comm=3Dkworker/u8:7
>>    BTRFS error (device sdb): error while writing out transaction: -EAGAI=
N
>>    BTRFS error (device sdb state A): Transaction 67 aborted (-EAGAIN)
>>    BTRFS info (device sdb state EA): forced readonly
>>    zoned-debug: clear-active dev=3D/dev/sdb pos=3D140928614400 left=3D1 =
max_active=3D128
>>
>> The transaction was aborted before the old block group returned its
>> active-zone slot, forcing the filesystem read-only.
>=20
> Ah now I see we're on the same page.
>>
>> [CAUSE]
>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before issuing
>> the zone finish operation.  This allows the following interleaving:
>>
>>    Thread A, endio worker              Thread B, transaction writeback
>>
>>    clear ZONE_IS_ACTIVE
>>    call_zone_finish(old)
>>                                          observe old as inactive
>>                                          return from do_zone_finish(old)
>>                                          activate(new)
>>                                          fail with left =3D=3D 0
>>    clear the device active bit
>>    increment active_zones_left
>>
>> Thread B treats the cleared active bit as a completed finish while threa=
d
>> A is still performing the device operation.
>>
>> [FIX]
>> Add BLOCK_GROUP_FLAG_ZONE_FINISHING and keep ZONE_IS_ACTIVE set until th=
e
>> zone finish operation and active-list cleanup are complete.
>>
>> Concurrent finishers wait for ZONE_FINISHING to be cleared instead of
>> returning early.  Wake them after clearing ZONE_IS_ACTIVE and removing
>> the block group from the active list.  If a waiter acquired a temporary
>> read-only reference, release it after the wait.
>>
>=20
> Stupid question, wouldn't it be enough to re-order the call to
> do_zone_finish() vs the clearing of  BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE?

Do you mean keeping BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE set while
call_zone_finish() is running, and clearing it together with
list_del_init() after the device operation completes?

If so, I think that closes the early-inactive window, but it still allows
two callers to finish the same block group concurrently:

   Thread A                         Thread B

   call_zone_finish()
                                    observe ZONE_IS_ACTIVE
                                    call_zone_finish()

While thread A is blocked in blkdev_zone_mgmt(), thread B still sees the
block group as active and can enter call_zone_finish() as well.

Even if issuing ZONE_FINISH twice is harmless at the device level, the
software cleanup is not idempotent. If both calls succeed for a non-data
block group, both increment reserved_active_zones, while
active_zones_left is restored only once because the device active bitmap
uses test_and_clear_bit(). Both callers would also remove the same
active-list entry and drop its reference.

Am I missing some existing serialization that prevents two
do_zone_finish() callers for the same block group from reaching
call_zone_finish() concurrently?

Thanks,
Dongjiang Zhu
