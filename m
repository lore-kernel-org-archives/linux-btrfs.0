Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211A538331C
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779095904; cv=none; b=TCgLvjXQRjZbnGs4vFbLRv+5pi7XWy3vDAJweQbr3o5jzlkIY/tEAWbnNGlKIzqaURovljNmOO4ZJWjMwkvhYdDwuLWJ5uHUC+3IG005VkHNSOmot5chlCM31hx83uEJSIk3N1dYWS6WC0GWcOUdeYelu8se+nrt+OTCAc3I9vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779095904; c=relaxed/simple;
	bh=UqraEZWIQD3+rB5NWoiYdi9BD4TOw7o34NcVTFs9ZjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=W61sTaY5xQx8+cSLmKovHrrCwHSKFEZKQ0TO8K3dgoL/WZHB9eMfg52VlM/QmGAtDwMopuxuhYkFS4rN3GCyxEVd4r7DjriQ6gTuzHOeJpjsMhab9IHZNHV9oplIhLrN9KAqOof8zlJzum1pFOz1pjEc4jynctnztVhYD61SfHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j4LE1Awt; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j4LE1Awt"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so719316a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 02:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779095902; x=1779700702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d3WfNQrBreZMgVFprO6wrTETmV0ftNt8tbh0Jz4OC0A=;
        b=j4LE1AwtcsrB3I++Zt8mIhy5DL9rIJzmobaEu3hLdfLrPRK1jz/UX1dhknrbuFUrTc
         ZZ59ppsFW2c040vtNEbcW0KfouvVD6vTy/JGg0x+HzGakUrlkRKrJQWsZ13K3N4D8j3/
         zoBZMWJiXOwFCyhXSMXL0b3bdwQNHhohmqFIpBwPSQx+uKnXYyIXVxgdStlc7G/XGYz5
         iBFtOpCNy/HLVL3hhVC4KnEDTRpLrhOPubWGiOCpAES2WAdB9HN6hRfPziOJEx7VllS+
         kif5QtTpijg0O8Y1aoRgFNAwDxwsXya7amkRgcqLU3pJW240bUh0tk1qHInD+4aLisd1
         6FGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779095902; x=1779700702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d3WfNQrBreZMgVFprO6wrTETmV0ftNt8tbh0Jz4OC0A=;
        b=Kt3EMJ6lj+579evyqgTmiCYVn51Ninrk8ipPc8kcW32Bzqe4hOf9EHZL7gg5FBuHS5
         CDc4IhHWLnPJvu+D7syjRm+B5I8ZR0tPR4G8E2tljuPVSFaDlZMtmGXacHFmAMTXMZ69
         Fhb0ecCvvHRL6fdsBwuYgiG5PANydrAqCZA/1lYLnBHyOhIvbwOg901niEs1Ola/0ESH
         VtjkIdaClpwo/vbdornUG5NCdVT8qn/0PKBGE4nquoW5iQq8q7pf90P2ogKU2pFfIESs
         f5zMdSTWV6Rb3x+Vp/H4btOZnGAFdnEPsMOm8c4wQ7D74ctr8KGs/QkygfT+C+J4gJWj
         /teA==
X-Forwarded-Encrypted: i=1; AFNElJ/5u0bxU+Q4OmBme6iitEmdOpHRvuswNRWbnmx+XfFyJpOCkoXUWhDkqQFw+4n9NKK46oQgisC6KcgfHw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy41vqjJiZzyKc+L+YLoC9JPCNci0AQK0EXdu/tpLR+4+WMjM+C
	OmmVPyEUBV+K02vaX4rdDe2/OWZm2M43hFh3dZwPAGZMu6r2kTO8diYPRUiKQg==
X-Gm-Gg: Acq92OExrLt1VuF2VpvNOxeQvC5HqVqOaX7g10noFNSQem56MUpNyyQeXQHWTMwh+1i
	V+UMcvKgSVYKHlWO/Gf1hsZyMq7ViL7jAwF7jOEJO8P4POYfcSWek+87tcLZ7i9sAc1f2b6RnT0
	bWB5S8r1nwd1MTbVEaVy8QdSbxX95m1VT3Y6PoRHCIBojlVdKI/bjQISJ7D+6GIiZgUoz7IWYmw
	weVvmcV3NN/7kXF2WwNf5UQHdqHiLD/09Gw00G04PVYUnQnvz14JADgcD+w8mw7dLTm72kd5ZmI
	Z+GfuZzvHeErmOjUSavinDGJTXMtPMZWrIy198lat/ypG+dcU3weRF9o77GqY5DgF7WzEFXuXj6
	wropNzis1DNnEhMbdW/ZnbAYgYFs+yQvFlGA6EB+cFL4p9qWwx0UkzH+mxg3nWq/wG67dAp5Wcg
	1GIIPSu6VZH7B2++92wso8bMYqKwSOPOfNAgxBwwi7
X-Received: by 2002:a05:6a20:7293:b0:3a2:f14a:4290 with SMTP id adf61e73a8af0-3b22ec3f5a4mr16204652637.38.1779095902263;
        Mon, 18 May 2026 02:18:22 -0700 (PDT)
Received: from [10.203.107.185] ([129.126.14.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb116832sm12917110a12.24.2026.05.18.02.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:18:21 -0700 (PDT)
Message-ID: <e29e3b26-bd22-41d7-92f0-8d89bf73f5ea@gmail.com>
Date: Mon, 18 May 2026 17:18:18 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: test qgroup deletion races with squota writes
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com, fstests@vger.kernel.org
References: <cover.1778632843.git.boris@bur.io>
 <2c8668284ded13c7cc63ece213d9e1edc3e6ea85.1778632843.git.boris@bur.io>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <2c8668284ded13c7cc63ece213d9e1edc3e6ea85.1778632843.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



It appears that transaction commit could race with the testcase.


--------
SECTION       -- gen
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 vm1 7.1.0-rc3-gf5d9f327e4b2 #14 SMP
PREEMPT_DYNAMIC Sun May 17 21:25:06 +08 2026
MKFS_OPTIONS  -- -f /dev/vde
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vde
/mnt/scratch

btrfs/348    10s ... - output mismatch (see
/Volumes/work/ws/fstests/results//gen/btrfs/348.out.bad)
    --- tests/btrfs/348.out	2026-05-18 14:04:31.427635000 +0800
    +++ /Volumes/work/ws/fstests/results//gen/btrfs/348.out.bad
2026-05-18 17:13:33.000000000 +0800
    @@ -5,6 +5,4 @@
     ERROR: unable to destroy quota group: Device or resource busy
     ERROR: unable to create quota group: Invalid argument
     same txn destroy race
    -ERROR: unable to destroy quota group: Device or resource busy
     pre-existing data destroy
    -ERROR: unable to destroy quota group: Device or resource busy
    ...
    (Run 'diff -u /Volumes/work/ws/fstests/tests/btrfs/348.out
/Volumes/work/ws/fstests/results//gen/btrfs/348.out.bad'  to see the
entire di)

HINT: You _MAY_ be missing kernel fix:
      XXXXXXXXXXXX btrfs: check for subvolume before deleting squota qgroup

HINT: You _MAY_ be missing kernel fix:
      0c309d66dacd btrfs: forbid creating subvol qgroups

Ran: btrfs/348
Failures: btrfs/348
Failed 1 of 1 tests


Thanks, Anand







On 13/5/26 08:43, Boris Burkov wrote:
> When using simple quotas, an extent's EXTENT_OWNER_REF can long outlive
> the subvolume that created it, since the extent can pick up additional
> references that keep it alive after the owning subvolume is deleted.
> 
> Several lifecycle bugs around the owning qgroup arise from this:
> 
>   1. Freeing an extent whose owner qgroup is gone: must not cause an
>      underflow nor a transaction abort.
> 
>   2. Creating an extent in the same transaction that the owner subvolume
>      is deleted: the qgroup may already be gone by the time the squota
>      delta is recorded, leaving behind an EXTENT_OWNER_REF that points
>      at a qgroup that never accumulated a usage delta.  Manually
>      re-creating that qgroup and then freeing the extent would underflow
>      it.
> 
>   3. Destroying a live subvolume's qgroup while delayed refs for newly
>      allocated tree blocks have not yet flushed: rfer/excl read as 0,
>      so the destroy looked safe, but the alloc delta was silently lost.
> 
>   4. Destroying the qgroup of a live subvolume whose data predates
>      'btrfs quota enable --simple': pre-existing extents are not
>      accounted (generation < qgroup_enable_gen), so rfer/excl stay 0
>      permanently and a usage-only check happily destroys a qgroup
>      belonging to a still-mounted, still-writeable subvolume.
> 
> Add four cases covering these scenarios.  On a fixed kernel all four
> 'qgroup destroy' (and the re-create in case 2) operations are refused
> because the subvol check rejects the request; on an unfixed kernel
> they would succeed and leave the filesystem with broken accounting or
> trigger a transaction abort.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  tests/btrfs/348     | 136 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/348.out |  10 ++++
>  2 files changed, 146 insertions(+)
>  create mode 100755 tests/btrfs/348
>  create mode 100644 tests/btrfs/348.out
> 
> diff --git a/tests/btrfs/348 b/tests/btrfs/348
> new file mode 100755
> index 00000000..ab816301
> --- /dev/null
> +++ b/tests/btrfs/348
> @@ -0,0 +1,136 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Meta Platforms, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 348
> +#
> +# Test various race conditions between qgroup deletion and squota writes
> +#
> +. ./common/preamble
> +_begin_fstest auto qgroup subvol clone
> +
> +# Import common functions.
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_scratch_enable_simple_quota
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"btrfs: check for subvolume before deleting squota qgroup"
> +_fixed_by_kernel_commit 0c309d66dacd \
> +	"btrfs: forbid creating subvol qgroups"
> +
> +subv1=$SCRATCH_MNT/subv1
> +subv2=$SCRATCH_MNT/subv2
> +
> +prepare()
> +{
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount
> +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> +	$BTRFS_UTIL_PROG subvolume create $subv1 >> $seqres.full
> +	$BTRFS_UTIL_PROG subvolume create $subv2 >> $seqres.full
> +	$XFS_IO_PROG -fc "pwrite -q 0 128K" $subv1/f
> +	_cp_reflink $subv1/f $subv2/f
> +}
> +
> +# An extent can long outlive its owner. Test this by deleting the owning
> +# subvolume, committing the transaction, then deleting the reflinked copy.
> +free_from_deleted_owner()
> +{
> +	echo "free from deleted owner"
> +	prepare
> +	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> +
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +	$BTRFS_UTIL_PROG subvolume delete $subv1 >> $seqres.full
> +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT >> $seqres.full
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +	rm $subv2/f
> +	_scratch_unmount
> +}
> +
> +# A race where we delete the owner in the same transaction as writing the
> +# extent leads to incrementing the squota usage of the missing qgroup.
> +# This leaves behind an owner ref with an owner id that cannot exist, so
> +# freeing the extent now frees from that qgroup, but there has never
> +# been a corresponding usage to free.
> +add_to_deleted_owner()
> +{
> +	echo "add to deleted owner"
> +	prepare
> +	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> +
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +	$BTRFS_UTIL_PROG subvolume delete $subv1 >> $seqres.full
> +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT >> $seqres.full
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +	$BTRFS_UTIL_PROG qgroup create 0/$subvid1 $SCRATCH_MNT >> $seqres.full
> +	rm $subv2/f
> +	_scratch_unmount
> +}
> +
> +# Create a subvol, destroy its qgroup before delayed refs update rfer/excl.
> +# On an unfixed kernel the qgroup destroy succeeds (rfer == 0), silently
> +# losing the alloc delta. On a fixed kernel the destroy is refused because
> +# the ROOT_ITEM still exists.
> +same_txn_destroy_race()
> +{
> +	echo "same txn destroy race"
> +	prepare
> +
> +	# Commit so the next subvol create starts a fresh transaction.
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +
> +	# New subvol -- tree block alloc delayed ref is pending, rfer/excl=0.
> +	local subv3=$SCRATCH_MNT/subv3
> +	$BTRFS_UTIL_PROG subvolume create $subv3 >> $seqres.full
> +	local subvid3=$(_btrfs_get_subvolid $SCRATCH_MNT subv3)
> +
> +	# rfer/excl still 0 (delayed refs not flushed). Destroy should fail
> +	# because the ROOT_ITEM exists.
> +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid3 $SCRATCH_MNT 2>&1
> +
> +	_scratch_unmount
> +}
> +
> +# Enable squotas on a filesystem that already has a subvolume with data.
> +# Pre-existing extents have generation < qgroup_enable_gen, so the qgroup's
> +# rfer/excl stay 0 permanently. On an unfixed kernel can_delete_squota_qgroup
> +# only checks rfer/excl, so the qgroup can be destroyed for a live subvol.
> +# On a fixed kernel, the subvol check prevents deletion.
> +pre_existing_data_destroy()
> +{
> +	echo "pre-existing data destroy"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount
> +
> +	# Create subvol and write data BEFORE enabling squotas.
> +	$BTRFS_UTIL_PROG subvolume create $subv1 >> $seqres.full
> +	$XFS_IO_PROG -fc "pwrite -q 0 128K" $subv1/f
> +	sync
> +
> +	# Enable squotas. Pre-existing data is not accounted (gen < enable_gen).
> +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +
> +	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> +
> +	# Destroy the qgroup. rfer/excl = 0 because data predates squotas.
> +	# Should fail because the ROOT_ITEM still exists.
> +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT 2>&1
> +
> +	_scratch_unmount
> +}
> +
> +free_from_deleted_owner
> +add_to_deleted_owner
> +same_txn_destroy_race
> +pre_existing_data_destroy
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
> new file mode 100644
> index 00000000..0a1cf11f
> --- /dev/null
> +++ b/tests/btrfs/348.out
> @@ -0,0 +1,10 @@
> +QA output created by 348
> +free from deleted owner
> +ERROR: unable to destroy quota group: Device or resource busy
> +add to deleted owner
> +ERROR: unable to destroy quota group: Device or resource busy
> +ERROR: unable to create quota group: Invalid argument
> +same txn destroy race
> +ERROR: unable to destroy quota group: Device or resource busy
> +pre-existing data destroy
> +ERROR: unable to destroy quota group: Device or resource busy

