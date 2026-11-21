Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795263046;
	b=kf0FFtU0T5OE14bnUfo/KBFGrdaVXu3Ko0KRNpMBAZzDVAWu2XNW1hb4bZ/Koxv/axZR
	 uuSK3U3eGbFb+mhrviLm2VFLRyyZhRSvWFj8Vq0sq0zkhzPzVD5IbydDijtzhghlulHc5
	 tFYrmPFQwQH7FgcR/jCj6Vz0Ej/IIVk6vT6olVbbWkBugvhG5MEEp3NpUIXzhUwCj87IE
	 wpr9ep5nzv0zMFU1/AoC80r6qQ+GVQPKxld4XpOcbZtcIB73VbkWb2M2a8pY7waL3BfC5
	 oIZztbjFcLnmEcLCTj+Kgi3JsDZTMiAN7RksBOaHa1GSmfY9l7ZCgoemB9rj8t51R6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795263046;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=wBac+v4fBKiwSpBWCxyLKlLb4EBnT8hxj94EO4RzRH8=;
	b=XFBbHbBApLVcliu3re2RkJMkWx6AJolQIrK+0BIYcL4/qiQfEgyfzMFsEEqo0xqTWmNT
	 ZPWnKKz6XrXvoEL0ZSaDCaLOjh9ruuoCFF8ZmZyBUcAY8ca2v3MFA5MaQn9jC4HxY0wAM
	 4NuFJ8SFq+rOp3Iec7Q6OrrVLWIquqDeOe29lRCRi/ZiowHdWhla9C7YRg7E581kj6Jhi
	 5z0m7F5LuHJDWukBhV7sAo+2zLQSpeCJ+TT58Qv/p26nn5h/ymJUSCwB2mplBb9dB21Pm
	 DXQS9fkPMkfEDCWUneiOCq1pvE6GaWf0Bt+WH2MNpAWn8fOA6Uq34LdGZ6+62WSusqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClFx6Hom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31723606A320;
	Sat, 21 Nov 2026 12:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClFx6Hom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082451F000C0;
	Sat, 21 Nov 2026 12:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795263045;
	bh=wBac+v4fBKiwSpBWCxyLKlLb4EBnT8hxj94EO4RzRH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ClFx6HomIOpqiuxnhzY8Pvwa7hghJqvePYG90avqQLHxaxto8FixbKXq5xy5/eTgP
	 bhDikGHSuW2IN90I4NQsbN02Me1CBgnH8uArrqNEro07wEzvJdqz7M307vN+9KPQO4
	 yIa88dxLA13obIKexU1deAf3kZ8JDZyF4xfrSicdGS0u+tLwKnqSEPlvqBJBuBSutj
	 w2WPDw8IPtHZHMTED3axUfmptMnmyUNd95WhqfkzsGuQz9Q14Htg8QIshKMN81AcbE
	 +MFrmbczUIG7cBgN+EPagHiwYIwikz1kYZaCoRs28Ijvb3JYxWVDZ/EyfBEeEcXCCn
	 J8NcT6z8/jGmQ==
Date: Sat, 21 Nov 2026 20:10:35 +0800
From: Zorro Lang <zlang@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	fstests@vger.kernel.org
Subject: Re: [PATCH v2] generic: test that fsync on zoned doesn't fail with
 -EAGAIN
Message-ID: <awGKG7Z5XBiqzxdu@zlang-mailbox>
Mail-Followup-To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org
References: <20261117065848.3825371-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261117065848.3825371-1-johannes.thumshirn@wdc.com>

On Tue, Nov 17, 2026 at 07:58:48AM +0100, Johannes Thumshirn wrote:
> On a zoned btrfs, btrfs_start_transaction() forces a transaction commit
> when the delayed refs reservation exceeds its zoned cap. If the cap is
> still exceeded after the commit, it returned -EAGAIN, which fsync passed
> on to user space.
> 
> Run parallel writers creating, overwriting and deleting small files with
> an fsync after every write on a zoned device with a limited number of
> active zones, and check that no fsync fails.
> 
> Assisted-by: LLM
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v1:
> - Move to a generic test

Thanks for this update.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> 
>  tests/generic/814     | 83 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/814.out |  2 ++
>  2 files changed, 85 insertions(+)
>  create mode 100755 tests/generic/814
>  create mode 100644 tests/generic/814.out
> 
> diff --git a/tests/generic/814 b/tests/generic/814
> new file mode 100755
> index 00000000..316925c1
> --- /dev/null
> +++ b/tests/generic/814
> @@ -0,0 +1,83 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 814
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
> +_fixed_by_fs_commit btrfs XXXXXXXXXXXX \
> +	"btrfs: zoned: don't fail start_transaction() after a forced commit"
> +
> +_require_scratch_size $((4 * 1024 * 1024)) # kB
> +
> +if [ -b "$SCRATCH_RTDEV" ]; then
> +	zoned_dev=$SCRATCH_RTDEV
> +else
> +	zoned_dev=$SCRATCH_DEV
> +fi
> +
> +_require_zoned_device "$zoned_dev"
> +_require_limited_active_zones "$zoned_dev"
> +
> +nr_writers=$((8 * LOAD_FACTOR))
> +nr_files=250
> +nr_rounds=$((4 * TIME_FACTOR))
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
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
> +_scratch_cycle_mount
> +find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.after
> +diff -q $tmp.md5.before $tmp.md5.after > /dev/null || echo "data mismatch"
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/814.out b/tests/generic/814.out
> new file mode 100644
> index 00000000..95532d3d
> --- /dev/null
> +++ b/tests/generic/814.out
> @@ -0,0 +1,2 @@
> +QA output created by 814
> +Silence is golden
> -- 
> 2.56.1
> 
