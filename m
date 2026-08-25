Received: from sg-3-44.ptr.tlmpb.com (sg-3-44.ptr.tlmpb.com [101.45.255.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40B33372A
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 03:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787627413; cv=none; b=AB0nw7OWMr5NDNzPBiBF2q03OQdgnm7IFUkiyPHcGYHxAhpHgeXWfAfHzTwcxE95C8D0j3KeK84QTnfC3cltBQ+ttN/E4imsZ4u2Jjk/ZsmQiuQML0Fetbb3tA0ZQCKGcfLZxjs5COubEn2gQqFjRaKoTwsJ3ID7tmHPgSLWkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787627413; c=relaxed/simple;
	bh=5NnoxSbUVl894KvJzFCLxm2L6YXLH40Tmp99HOrKuHY=;
	h=From:Mime-Version:Subject:References:In-Reply-To:To:Date:
	 Message-Id:Cc:Content-Type; b=Fr56KCGCoJSkv7IjbwzZizEMbNODdELfo4JEWbWa34DOlxRNn4e0ouqTFcb9Uq6eKd9wrYV0wyu4GYniOZ54wqiggisnC5ZsECQ7EKrda1VP+MaelhhQ/dOcx4OUopgI+vK3cgHE9y3FK5QR2K3hNYaFmPU08NstKOoDVRTZ2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=TjaCNcwE; arc=none smtp.client-ip=101.45.255.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="TjaCNcwE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787627319;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=e6QJXzb1bScEP7/96hw9C50Y4fAy4XZ9jSGxL1qzdrI=;
 b=TjaCNcwEnrLaMbHpTz6RDJWUlwIEcG0jVdzAtSwZpsqbuzBSi0EaTMvhOvpSBQrpOa5uOQ
 uIeFZpk0cu3h5XyBLGnZD/r+UhdwuR2WQL3S6fqjtYg1F2IodkB4qqR3jFJ5CbYyJFWWi7
 VXEwmAGPqEhBxL3zqqaLNFRduCUk4wlXEhwysMDj7L4ZgIP99S1dqIQ6XBZLF++++U1v6I
 fkdYICUxdfsKEpAoC8LtCjeCmbGX+4C3A7BA01NmPN4RDXlm4X/WmZZgz+vy1vDESi0gaH
 m4GG0j7JMN8KHA41c27yUD7O4IgPuyYXXP2/30IV8WJQYIGLIOuF8RZ0QA/sDg==
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [192.168.8.64] ([183.34.169.70]) by smtp.larksuite.com with ESMTPS; Tue, 25 Aug 2026 03:08:38 +0000
Subject: Re: [PATCH 2/4] btrfs: zoned: recover active non-data block group roles on mount
References: <cover.1787551793.git.zhudongjiang@fygo.io> <8956aae5225383d3c9ec3b08a3a9d42da1396eb2.1787551793.git.zhudongjiang@fygo.io> <aoxPwPbpoad66hrG@mayhem.fritz.box>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
In-Reply-To: <aoxPwPbpoad66hrG@mayhem.fritz.box>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>
Date: Tue, 25 Aug 2026 11:08:34 +0800
Message-Id: <810f5525-58c7-4cfb-ae3c-c7e4e0ed0f2b@fygo.io>
X-Lms-Return-Path: <lba+26a8d0736+223d52+vger.kernel.org+zhudongjiang@fygo.io>
Cc: <linux-btrfs@vger.kernel.org>, <naohiro.aota@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/8/24 22:42, Johannes Thumshirn =E5=86=99=E9=81=93:
> On Mon, Aug 24, 2026 at 02:49:54PM +0800, Dongjiang Zhu wrote:
>> [BUG]
>> After a remount, a later write can activate a new metadata or system
>> block group without finishing the recovered one.  Repeating this across
>> remounts consumes additional active-zone slots and reservations, and can
>> eventually exhaust all active-zone slots.
>>
>> Once no slot is available, activation of a metadata or system block grou=
p
>> fails.  During synchronous transaction writeback this propagates as
>> -EAGAIN, aborting the transaction and forcing the filesystem read-only.
>>
>> A remount/fsync/remount reproducer on an HC620 left two partially used
>> sequential metadata block groups active while active_meta_bg remained
>> NULL:
>>
>>    bg=3D343865819136 alloc=3D176095232 cap=3D268435456
>>    bg=3D344402690048 alloc=3D3260416   cap=3D268435456
>>
>=20
> Can you submit a fstest for that please? Maybe even in generic/ so XFS an=
d
> F2FS also get coverage?
>=20

Yes, I can work on a separate fstest. To make sure I understand the
suggestion correctly, do you have in mind a zoned-device test that
creates a metadata-heavy workload, syncs, fully unmounts and mounts the
filesystem repeatedly, and then verifies that further writes and syncs
still succeed?

>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>> index 10e15a319b93..aa3d6b66495e 100644
>> --- a/fs/btrfs/fs.h
>> +++ b/fs/btrfs/fs.h
>> @@ -931,6 +931,10 @@ struct btrfs_fs_info {
>>   	u64 data_reloc_bg;
>>   	struct mutex zoned_data_reloc_io_lock;
>>  =20
>> +	/*
>> +	 * Active block groups for normal metadata and system writes. Mount
>> +	 * recovery restores one block group for each role and finishes any ex=
tras.
>> +	 */
>=20
> I don't think this comments adds any value.
>=20

Agreed, I will remove it.

>>   	struct btrfs_block_group *active_meta_bg;
>>   	struct btrfs_block_group *active_system_bg;
>>  =20
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index bd079d3b31ba..7d91c074a24a 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -3050,22 +3050,73 @@ int btrfs_zoned_activate_one_bg(struct btrfs_spa=
ce_info *space_info, bool do_fin
>>   	return 0;
>>   }
>>  =20
>> +static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_inf=
o)
>> +{
>> +	struct btrfs_block_group *block_group;
>> +	struct btrfs_block_group *next;
>> +	u64 tail_unusable;
>> +	int ret;
>> +
>> +	list_for_each_entry_safe(block_group, next, &fs_info->zone_active_bgs,
>> +				 active_bg_list) {
>> +		if (!(block_group->flags &
>> +		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>> +			continue;
>> +
>> +		if (block_group =3D=3D fs_info->active_meta_bg ||
>> +		    block_group =3D=3D fs_info->active_system_bg)
>> +			continue;
>> +
>> +		btrfs_get_block_group(block_group);
>> +		tail_unusable =3D block_group->zone_capacity - block_group->alloc_off=
set;
>=20
> Shouldn't these be accessed under the block_group->lock?
>=20
> [...]
>=20
> Same here, don't you need the block_group->lock?

Both accesses only happen during open_ctree(), after all block groups
have been loaded and before the background threads are started. Following
other mount-time initialization code, I assumed that block_group->lock
was not necessary because the allocation state cannot change concurrently.

On the other hand, taking the lock would make the usual protection of
alloc_offset explicit and avoid relying on the mount-time context for
future maintenance. Would you prefer that I add the locking around both
reads in v2?

Thanks,
Dongjiang Zhu
