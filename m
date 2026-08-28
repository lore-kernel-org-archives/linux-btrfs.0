Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B243FD32
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787918879; cv=none; b=DPh8eSURog4TcDKbYNKtNhnwfaewPuXyHAoKMTk+ZIycuwAqRvKmmpSabNmpIkr5Mx4C3SahkS6UhNkZX+o5UtEM2HSLP3eTQpvgmeDfGbDscgusHc0jTVsTCKw3wL5ZPAYr2jkL7v2RZbK3h28zWv7KdSXbANMmZprRcFsdhiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787918879; c=relaxed/simple;
	bh=U+fyn697Qc0cXqOq9rUglAAyZ93NfI0S2acfJl6cDKc=;
	h=Date:Mime-Version:To:Cc:From:Content-Type:Subject:Message-Id:
	 References:In-Reply-To; b=kb4MvDKxoNmsXiogI2FmB0qjfLuMT5ocpEOcNYwlWRSd8gCX0ZFNCvNGzvmypLCEDAG9zLM/EqBU4UYM3eiCGLsZPzgt5uQ2pFeHT7bJ2/kzDqvQevogG1LNABrwIrRB69+cVY7/yjS4w/563M2O+NvT5koV5IHvK5PN9SJTvys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=LMug17ce; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="LMug17ce"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787918859;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jHHT0Ju4FVlxtCLgQjoTklKadA1SkcJ/0a0yiQvNCMk=;
 b=LMug17ceLSs2f211BQthm9aUmTA7mcfCFjHBSI7SZ6yUd+LalcgKMhm1NihjOIZ0f7h73I
 tW3uL3JBpMPrcshAdkkIODcUNhMk9MNS0iPujiH2j2KmBl1vXH4Z57t+4TeFE/6vIm3EtP
 qqSN+unVtUkETz17aubLKcYNsmKhbKXYyQczIgJNLWjS0v8sYgfnUVEe7I+LJpNHsTgORh
 PiS7D7KTdj2zBGYAnMVpmqTkxDby0BERNCh+Qnfai6eG3q2uqqkoQQ/fmP0zo8o/rJ64LE
 SsvHGfgwnMeB0YYIqu+jft1dKcZXDGtTbuXgp1rFP2AwAm5JS5hE6jcaCxx0Tw==
Date: Fri, 28 Aug 2026 20:07:32 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: "Naohiro Aota" <Naohiro.Aota@wdc.com>, <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v3 2/4] btrfs: zoned: recover active non-data block group roles on mount
Message-Id: <7364a62a-a6be-458a-8d46-f101434235a0@fygo.io>
Received: from [192.168.8.64] ([14.21.226.247]) by smtp.larksuite.com with ESMTPS; Fri, 28 Aug 2026 12:07:38 +0000
References: <cover.1787887776.git.zhudongjiang@fygo.io> <65f5e1ca743e6c224009c4fe639945ee6c851d0c.1787887776.git.zhudongjiang@fygo.io> <DL0C63K7IW67.257PVUA638Z6E@wdc.com>
X-Lms-Return-Path: <lba+26a917a0a+5f97aa+vger.kernel.org+zhudongjiang@fygo.io>
In-Reply-To: <DL0C63K7IW67.257PVUA638Z6E@wdc.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>

=E5=9C=A8 2026/8/28 13:43, Naohiro Aota =E5=86=99=E9=81=93:
> On Fri Aug 28, 2026 at 12:51 PM JST, Dongjiang Zhu wrote:
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
>=20
> Please show the reproducer.
>=20

Sure.  The two block groups were not both for normal metadata.  One was
the existing partially used normal metadata block group, while the other
was newly allocated for the tree log, as confirmed by the tree-log
allocation trace.

The original reproducer contains a fairly large setup stage.  I will
simplify it and include the exact reproducer in the next revision of the
commit message.

>>
>> active_meta_bg and active_system_bg assign active block groups to the
>> normal metadata and system write roles.  These runtime-only pointers are
>> reset to NULL on every mount.
>>
>> Mount reconstructs partially used sequential block groups in
>> zone_active_bgs and adjusts their reservations, but does not recover the
>> role assignments.
>>
>> The write-time pivot can finish the previous block group only when the
>> corresponding role pointer is set.  If it is NULL, activation proceeds
>> without releasing an already active block group of the same role.
>=20
> True. But, it is set to the written block group if e.g, active_meta_bg
> =3D=3D NULL. Given that metadata is properly written to partially used bl=
ock
> group, isn't it no problem with that? Apparently, this write-time
> setting can be considered as the role recovery.
>=20
> If it is writing into another block group leaving partially used one
> intact, then that is an issue on metadata allocation.
>=20

Thanks for pointing this out.  You are right that the commit message
overstates the problem.  With the current allocation behavior, normal
metadata continues to use the existing partially used block group, so
the sequence described in the commit message should not occur for normal
metadata.

A lazy recovery model can therefore work with the current allocator.
However, I still think restoring the role at mount is preferable, as it
keeps the write-time pivot state independent of allocator behavior.

Also, since the tree-log role is not persisted, mount must select one
metadata block group and finish the extras.  Restoring the normal
metadata role at the same time is straightforward.

I will correct the commit message accordingly.

>>
>> Restore the role assignments by selecting one active block group for the
>> normal metadata role and one for the system role from zone_active_bgs.
>> For each role, keep the block group with the largest writable tail and
>> finish the others.
>>
>> The tree-log block group role is runtime-only and cannot be recovered
>> after a remount.  Use the selected metadata block group for the normal
>> metadata role and leave one metadata reservation for a new tree-log bloc=
k
>> group.
>>
>> Run the recovery on every mount.  ZONE_FINISH preserves existing extents
>> but abandons the unused tail, so account that tail as zone unusable
>> immediately.
>>
>> Assisted-by: LLM
>> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
>> ---
>>   fs/btrfs/disk-io.c |  7 +++-
>>   fs/btrfs/zoned.c   | 97 ++++++++++++++++++++++++++++++++++++++++++----
>>   fs/btrfs/zoned.h   |  7 +++-
>>   3 files changed, 101 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index e6bbb0b1b38c..cd1f46ec62f0 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3713,7 +3713,12 @@ int __cold open_ctree(struct super_block *sb, str=
uct btrfs_fs_devices *fs_device
>>  =20
>>   	btrfs_free_zone_cache(fs_info);
>>  =20
>> -	btrfs_check_active_zone_reservation(fs_info);
>> +	ret =3D btrfs_restore_active_nondata_bgs(fs_info);
>> +	if (ret) {
>> +		btrfs_err(fs_info, "failed to restore active non-data block groups: %=
pe",
>> +			  ERR_PTR(ret));
>> +		goto fail_sysfs;
>> +	}
>>  =20
>>   	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
>>   	    !btrfs_check_rw_degradable(fs_info, NULL)) {
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 0d964ada3ad4..ee7d518bec15 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -3056,22 +3056,77 @@ int btrfs_zoned_activate_one_bg(struct btrfs_spa=
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
>=20
> Why do we need to do this?
>=20

I added the extra reference because do_zone_finish() removes the block
group from zone_active_bgs and drops the active-list reference before the
caller-side accounting.

However, the block group remains in the block-group cache and cannot be
removed concurrently in this mount-time context, so the extra reference
is not necessary.  Moving the tail accounting into do_zone_finish() also
removes all post-finish accesses here.  I will remove the get/put pair.

>> +		spin_lock(&block_group->lock);
>> +		tail_unusable =3D block_group->zone_capacity - block_group->alloc_off=
set;
>> +		spin_unlock(&block_group->lock);
>> +
>> +		ret =3D do_zone_finish(block_group, true);
>> +		if (!ret) {
>> +			struct btrfs_space_info *space_info =3D block_group->space_info;
>> +
>> +			/* Account for the unused tail abandoned by ZONE_FINISH. */
>> +			spin_lock(&space_info->lock);
>> +			spin_lock(&block_group->lock);
>> +			block_group->zone_unusable +=3D tail_unusable;
>> +			btrfs_space_info_update_bytes_zone_unusable(space_info,
>> +								    tail_unusable);
>> +			spin_unlock(&block_group->lock);
>> +			spin_unlock(&space_info->lock);
>> +		}
>=20
> So, basically, do_zone_finish() should have handled this...
>=20

Yes.  The fully_written=3Dfalse path already updates zone_unusable through
the temporary read-only transition, while the fully_written=3Dtrue path
assumes that no allocatable tail remains.

Mount recovery intentionally finishes partially used block groups, so
that assumption no longer holds for this caller.  I will move the unused
tail accounting into do_zone_finish() and remove the caller-side
accounting.

Thanks,
Dongjiang Zhu
