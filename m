Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C36735E958
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 01:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784684485; cv=none; b=gYOuTs12mpyVwAcHlo6BHSu/hjFxGVZRNrpHf2Ou84+ZOp1CsMaMh46tWMkpK6krxQAR8dZ96MF/lRSLfERcsQVjRgmYcd24esRYSWtXnRE3kC3bAIgP1Wi6+qCC0crtKyaMWyC+HQRVkUMF77oP7dKYNN4Fuz4NvZp8BW2O+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784684485; c=relaxed/simple;
	bh=JRyjwZaJvakR50fv/H9rJrvH8iIRDicO8iEjIrG2Y7w=;
	h=Cc:Date:Message-Id:In-Reply-To:To:Subject:References:From:
	 Mime-Version:Content-Type; b=iIzgIP2R/UGWCCMGiAuAeEZd5dM5+zL5foEcqM54XJ4hMCzqGQ0Ij6Ldw2SncutIiWMFk01KHPyqWDXMG+2bVFI9Sb6i/GtCvFL6UwY8pwyM9lscxjr312pN8xjkVFxYpB/DIEcYnsWM15qFTIyjNoIsPfxSGMYK3YIrDllilcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=L0psx1bE; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="L0psx1bE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784684473;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=BrA68DRO+4HbSp9tlbSGx3d+JQI6YM9S/PalwWuElcE=;
 b=L0psx1bE4QpT8wKR09BUL7665Rgv1ef6V1TBKzqUFz556Lirgf4Ipw52K8bb103dx3ls2w
 uptAulTrPDmBmZz0+roNWctCQv0dpfg7gKPp2SBUBcXGzALmBbETwb8Woz613Q7gSHByw0
 vFIY9ebT2+tamx++UNgoc3qNQesZyRwmAsLE5lO/vW6EWGSx7unuSmtppqqyTevkyGvRZA
 Oa3xf1y+5Xp0nsim0Y4NpOUeTyBRoYqmtYwy4N2i4Q2bcLGTE9aM0oVy2Zp/IglmzJzV3a
 zHuX3nt8dkpaJ0zMiuh8QfPxs/e/rGIrbynEz772QXM9NBiOklLNB+iUsj/MiA==
Cc: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>, 
	"Sun YangKai" <sunyangkai@fnnas.com>
Date: Wed, 22 Jul 2026 09:41:03 +0800
Message-Id: <202dfd21-9876-4092-9ed6-99e9ba73bb74@fnnas.com>
Content-Language: en-US
In-Reply-To: <CAL3q7H7WBKk70cRmURvwx5O+hHouFH-Dt_6W3pJmsR85ODP4sw@mail.gmail.com>
To: "Filipe Manana" <fdmanana@kernel.org>
Subject: Re: [PATCH v2] btrfs: test POSIX ACL changes for RO btrfs property
Received: from [192.168.10.244] ([183.34.163.75]) by smtp.feishu.cn with ESMTPS; Wed, 22 Jul 2026 09:41:10 +0800
References: <20260709082500.17907-2-sunk67188@gmail.com> <20260713094611.19703-1-sunk67188@gmail.com> <CAL3q7H7WBKk70cRmURvwx5O+hHouFH-Dt_6W3pJmsR85ODP4sw@mail.gmail.com>
From: "Sun YangKai" <sunyangkai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Sun YangKai <sunyangkai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a601fb7+9085b6+vger.kernel.org+sunyangkai@fnnas.com>

This is my first time to contribute to fstests project so thanks a lot=20
for pointing those things out and it really helps a lot. I'll fix them=20
and send a v2 version later.

Thanks,
Sun YangKai

On 2026/7/21 00:16, Filipe Manana wrote:
> On Mon, Jul 13, 2026 at 10:50=E2=80=AFAM Sun YangKai <sunk67188@gmail.com=
> wrote:
>>
>> From: Sun YangKai <sunyangkai@fnnas.com>
>>
>> Test creation, modification and deletion of POSIX ACLs on a btrfs
>> filesystem that has the read-only property set to true, and re-test the
>> same after the property is cleared.
>>
>> Commit 353c2ea735e4 ("btrfs: remove redundant readonly root check in
>> btrfs_setxattr_trans") removed the read-only root check from
>> btrfs_setxattr_trans() under the assumption that none of its callers can
>> run on a read-only root.  That assumption does not hold for the ->set_ac=
l
>> path: btrfs_set_acl() -> __btrfs_set_acl() reaches
>> btrfs_setxattr_trans() directly, bypassing the handler-level read-only
>> checks that were later (re)added by commit b51111271b03 ("btrfs: check
>> if root is readonly while setting security xattr").  As a result, ACLs
>> could still be set or removed on a read-only subvolume, bypassing the RO
>> protection that applies to every other xattr.
>=20
> You don't need to explain this in a test case, those are details for
> the kernel patch...
>=20
> Just say what the test does and that it exercises a bug fixed by a
> kernel patch that has the subject:
>=20
>       "btrfs: check if root is readonly when setting posix acl"

>>
>> The restoring kernel fix adds the read-only check directly to
>> btrfs_set_acl().  This test complements btrfs/275, which covers the
>> generic ->setxattr path.
>>
>> The test exercises the set, get and remove cycle of an access ACL on a
>> regular file, and expects all modifications to fail with EROFS while the
>> subvolume is read-only, then succeed once it is writable again.
>>
>> Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
>> ---
>> Changes from v1:
>>
>> - fix copywrite header
>> - better wording for commit message
>>
>> Sorry for bothering.
>>
>> ---
>>   tests/btrfs/353     | 97 +++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/353.out | 39 ++++++++++++++++++
>>   2 files changed, 136 insertions(+)
>>   create mode 100755 tests/btrfs/353
>>   create mode 100644 tests/btrfs/353.out
>>
>> diff --git a/tests/btrfs/353 b/tests/btrfs/353
>> new file mode 100755
>> index 00000000..586f722a
>> --- /dev/null
>> +++ b/tests/btrfs/353
>> @@ -0,0 +1,97 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2026 Fygo OS. All Rights Reserved.
>> +#
>> +# FS QA Test No. 353
>> +#
>> +# Test that POSIX ACLs cannot be changed once a btrfs subvolume has the
>> +# read-only property set.
>> +#
>> +# Setting or removing a POSIX ACL goes through the ->set_acl inode
>> +# operation, which is a different code path from the generic ->setxattr
>> +# one covered by btrfs/275.  It used to be allowed on a read-only
>> +# subvolume and thus bypassed the RO protection.  Such modifications mu=
st
>> +# fail with EROFS, just like any other xattr.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick acl attr
>> +
>> +. ./common/filter
>> +. ./common/attr
>> +
>> +# TODO: fill in the kernel commit hash that fixes the ->set_acl path on=
ce
>> +# it is merged.
>> +# _fixed_by_kernel_commit <HASH> \
>> +#      "btrfs: check if root is readonly when setting posix acl"
>=20
> That's not how we handle patches not yet in Linus' tree.
> First don't comment it, second use xxxxxxxxxxxx for the hash.
> Like this:
>=20
> _fixed_by_kernel_commit xxxxxxxxxxxx \
>       "btrfs: check if root is readonly when setting posix acl"
>=20
> We normally find and update tests that need the hash by greping with
> something like:  egrep -ri 'commit xxxxx' tests/
>=20
>=20
>=20
>> +
>> +_require_acls
>> +_require_btrfs_command "property"
>> +_require_scratch
>> +
>> +_scratch_mkfs >> $seqres.full 2>&1
>=20
> Nowadays we have the practice of also adding:   || _fail "mkfs failed"
>=20
>> +_scratch_mount
>> +
>> +FILENAME=3D$SCRATCH_MNT/foo
>=20
> Don't use upper case variable names.
>=20
> With that fixed:
>=20
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>=20
> Thanks.
>=20
>=20
>> +
>> +set_acl()
>> +{
>> +       local perm=3D$1
>> +
>> +       # Use -n so setfacl does not recalculate the mask, keeping the
>> +       # golden output deterministic regardless of the named user's
>> +       # permissions.
>> +       setfacl -n -m u:$acl2:$perm,m::rwx $FILENAME 2>&1 | _filter_scra=
tch
>> +}
>> +
>> +get_acl()
>> +{
>> +       getfacl --absolute-names -n $FILENAME | _filter_scratch | _getfa=
cl_filter_id
>> +}
>> +
>> +del_acl()
>> +{
>> +       setfacl -b $FILENAME 2>&1 | _filter_scratch
>> +}
>> +
>> +_acl_setup_ids
>> +
>> +# Create a test file.
>> +echo "hello world" > $FILENAME
>> +
>> +# Set an initial ACL while the subvolume is writable.
>> +set_acl rwx
>> +
>> +# Attempt to change the ACL once the subvolume is read-only.  This must
>> +# fail with EROFS.
>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT ro true
>> +$BTRFS_UTIL_PROG property get $SCRATCH_MNT ro
>> +
>> +set_acl r--
>> +
>> +# The ACL must not have changed.
>> +get_acl
>> +
>> +# Attempt to remove the ACL from the read-only subvolume.  This must
>> +# fail with EROFS as well.
>> +del_acl
>> +
>> +# The ACL must still be present.
>> +get_acl
>> +
>> +# Make the subvolume writable again.
>> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT ro false
>> +$BTRFS_UTIL_PROG property get $SCRATCH_MNT ro
>> +
>> +# Now changing the ACL must succeed.
>> +set_acl r--
>> +
>> +get_acl
>> +
>> +# And removing it must succeed too.
>> +del_acl
>> +
>> +# Check the ACL is really gone.
>> +get_acl
>> +
>> +status=3D0
>> +exit
>> diff --git a/tests/btrfs/353.out b/tests/btrfs/353.out
>> new file mode 100644
>> index 00000000..66f4a0e5
>> --- /dev/null
>> +++ b/tests/btrfs/353.out
>> @@ -0,0 +1,39 @@
>> +QA output created by 353
>> +ro=3Dtrue
>> +setfacl: SCRATCH_MNT/foo: Read-only file system
>> +# file: SCRATCH_MNT/foo
>> +# owner: 0
>> +# group: 0
>> +user::rw-
>> +user:id2:rwx
>> +group::r--
>> +mask::rwx
>> +other::r--
>> +
>> +setfacl: SCRATCH_MNT/foo: Read-only file system
>> +# file: SCRATCH_MNT/foo
>> +# owner: 0
>> +# group: 0
>> +user::rw-
>> +user:id2:rwx
>> +group::r--
>> +mask::rwx
>> +other::r--
>> +
>> +ro=3Dfalse
>> +# file: SCRATCH_MNT/foo
>> +# owner: 0
>> +# group: 0
>> +user::rw-
>> +user:id2:r--
>> +group::r--
>> +mask::rwx
>> +other::r--
>> +
>> +# file: SCRATCH_MNT/foo
>> +# owner: 0
>> +# group: 0
>> +user::rw-
>> +group::r--
>> +other::r--
>> +
>> --
>> 2.54.0
>>
>>
