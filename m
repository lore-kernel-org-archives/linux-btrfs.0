Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794672182;
	b=1iCRExWCMCBbu5JUOTfDlPsBvKhis7WHwgt4Cy0WYd8sJd5ur4nZccX4g61fJ/3D1qpY
	 Ia6blMVRKDRn/egCpnddLZrQHbBFYXf14Sn04WMCt52f4dHs4ajqfHUc8HDPlK7nIr5Ij
	 Q5IasM5T0fDwyN+WM2J/TZiR1vwyP/2pEPjdlOL+BGN+6uIkmU3gcwkjOUWJMekuF1e9m
	 VqVFO51fLlKXtgS24zQmVfdZ7FUUqgN6I3NkBtsmb+S0XS6OeNmZaqfqwEHk/TvrHCh1J
	 kjb4brQO9Om4QeGHJuahUxfFb5v7kQiPc6XNdAHp4BtV2SE1ta6wQDEW0xQi7m+IiXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794672182;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=0tTk22qfiajFPEjGHRMjxjKiO96lwUDSzByYmBbTZfQ=;
	b=Aw7i+I3ZDYtIAn28FRD/aXsjXFe65nsDosMUVS/R7D3L3prDMkgoTl/nVAlY4mrGTEDz
	 HC7x/M2OYmEvNNJGZ6w98Dx8zel84UyZAEdZQrM49KTAtdx55YvHQPCmQnZd2qAMCbC0G
	 pMa53KjMAx3I4+Xhfp1NOwLZ4IGZafXA465gQdQ5ZWYM56iEi1mIVkWnApsj3RimxrTGV
	 3HywEG0a6/Ma87SHp7migpzZHa3dyzRHI2keKDx8aK68d4+eT/eNb6bQFp/yV1e606RSS
	 FiJ/wtMp6q+/kTGoBuWLfA/VIf+onxDrCtX9tveBSdNPuFvoq4RGdCm6vWtbNrWaUvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGmV5BNM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2DF606A329;
	Sat, 14 Nov 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGmV5BNM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFE01F000C4;
	Sat, 14 Nov 2026 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794672182;
	bh=0tTk22qfiajFPEjGHRMjxjKiO96lwUDSzByYmBbTZfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iGmV5BNMpYEN84MEeQ2p4eEv0ZTZRY/Ion1gpkKwBxurdIYzsTa5T7fy4s8ITAJbH
	 FakJfi61GJebjH3m8h3VcxN6BF9NpsLKC+/Yrwo7JoOEnVgTZP6nGj2MwxNNSEWuQE
	 KNBtWrG9Hu7QUL16LCez3qRkshn3z1BKKSwEI9imhZIFORsAgG7eaoIeaIJB+BytCk
	 dkXC9x1JkOJ7kmOYSprWr677yay7+31NQlHTZeyPBuHIYlQbTVvUp4/qXkW6eNug02
	 dv8q652a69szBV21mOX1QMyOEASwjpgpA8gSS2jBCReWXjHDamG1zlA8kpaHuSi9rP
	 zQcJ4Ad+vG11w==
Date: Sun, 15 Nov 2026 00:02:52 +0800
From: Zorro Lang <zlang@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH] btrfs: test that fsync on zoned doesn't fail with -EAGAIN
Message-ID: <aviB404o-v7VT09w@zlang-mailbox>
Mail-Followup-To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261110095911.2013053-1-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110095911.2013053-1-johannes.thumshirn@wdc.com>

On Tue, Nov 10, 2026 at 10:59:11AM +0100, Johannes Thumshirn wrote:
> On a zoned filesystem, btrfs_start_transaction() forces a transaction
> commit when the delayed refs reservation exceeds its zoned cap. If the
> cap is still exceeded after the commit, it returned -EAGAIN, which
> fsync passed on to user space.
> 
> Run parallel writers creating, overwriting and deleting small files with
> an fsync after every write on a zoned device with a limited number of
> active zones, and check that no fsync fails.
> 
> Assisted-by: LLM
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  tests/btrfs/364     | 76 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/364.out |  2 ++
>  2 files changed, 78 insertions(+)
>  create mode 100755 tests/btrfs/364
>  create mode 100644 tests/btrfs/364.out
> 
> diff --git a/tests/btrfs/364 b/tests/btrfs/364
> new file mode 100755
> index 00000000..39b0141e
> --- /dev/null
> +++ b/tests/btrfs/364
> @@ -0,0 +1,76 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 364
> +#
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +_cleanup()
> +{
> +	cd /
> +	[ -n "$pids" ] && kill $pids &> /dev/null
> +	wait
> +	rm -r -f $tmp.*
> +}
> +
> +. ./common/zoned
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"btrfs: zoned: don't fail start_transaction() after a forced commit"
> +
> +_require_scratch_size $((4 * 1024 * 1024)) # kB
> +_require_zoned_device "$SCRATCH_DEV"
> +_require_limited_active_zones "$SCRATCH_DEV"
> +
> +nr_writers=$((8 * LOAD_FACTOR))
> +nr_files=250
> +nr_rounds=$((4 * TIME_FACTOR))
> +
> +_scratch_mkfs -d single -m single >> $seqres.full 2>&1 || _fail "mkfs failed"

Is -d single -m single strictly necessary here? I think mkfs.btrfs defaults to
single for both data and metadata on zoned devices (right?), and hardcoding it
overrides user-provided MKFS_OPTIONS.

In fact, once -d single -m single is dropped, there is nothing btrfs-specific
left in this test at all, then it can be a  generic case. Moving it to
generic/ would let other zoned-capable filesystems (e.g., f2fs, xfs) benefit
from this stress test as well.

> +_scratch_mount
> +
> +# Every other file is deleted per round to churn data and metadata.
> +writer()
> +{
> +	local dir=$SCRATCH_MNT/w$1
> +	local r i sz
> +
> +	mkdir -p $dir
> +	for r in $(seq $nr_rounds); do
> +		for i in $(seq $nr_files); do
> +			# 4K - 256K
> +			sz=$(( ((i + r + $1) % 64 + 1) * 4096 ))
> +			$XFS_IO_PROG -f -c "pwrite -q -S $i -b 64k 0 $sz" \
> +				-c fsync $dir/$i || return 1
> +		done
> +		for i in $(seq 1 2 $nr_files); do
> +			rm -f $dir/$i
> +		done
> +	done
> +}
> +
> +pids=""
> +for w in $(seq $nr_writers); do
> +	writer $w > $tmp.writer.$w 2>&1 &
> +	pids="$pids $!"
> +done
> +
> +ret=0
> +for p in $pids; do
> +	wait $p || ret=1
> +done
> +unset pids
> +cat $tmp.writer.* >> $seqres.full
> +[ $ret -eq 0 ] || echo "writer failed, see $seqres.full"
> +
> +find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.before

A minor nitpick: if `find` happens to produce no output for some unexpected
reason, `xargs md5sum` could hang waiting on stdin. Passing -r
(--no-run-if-empty) to xargs would help to avoid that.

> +_scratch_cycle_mount
> +find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.after

Thanks,
Zorro

> +diff -q $tmp.md5.before $tmp.md5.after > /dev/null || echo "data mismatch"
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/btrfs/364.out b/tests/btrfs/364.out
> new file mode 100644
> index 00000000..6bc54ae6
> --- /dev/null
> +++ b/tests/btrfs/364.out
> @@ -0,0 +1,2 @@
> +QA output created by 364
> +Silence is golden
> -- 
> 2.56.0
> 
