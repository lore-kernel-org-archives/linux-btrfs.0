Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2AC2F7EE8;
	Sat, 10 Oct 2026 08:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791619330; cv=none; b=gW4ruNHJeFuNmaP8IoRKzciUz4xz1XKpDcrEkTQL2wXAONzF8Zk1VVap0Leg3U/Ip4x5qPL9x5lrhnyyYLE6wMozFsUDv/uEWZx8ahkpQxdQY+PhVem4EB/ROy7IuVsV0nt3x+L4MVErBdgX23QVPyUYkSg0Hz6dgoRfG6dR54I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791619330; c=relaxed/simple;
	bh=NLHcsxQQgnwrsiIb3kVTkC0Pf/hYRNKtLDx9h4iqbpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8H7AyT9Ucgb8PtLuuYdlyfJ9Y4g45XftoU87UQaNsodx7+DNDirX06c4AnYHtDaUnWT9DOO2SvwPw8OGMKp+gj137FBIkCIIFtHk9bQnjTqlRz/4cMKrQShKTwT0+/LWvQ+u7EtHFGcoagZhUAabamTgk8rfQ/WY5bvXJxLLuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDY60C9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDY60C9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92221F000FF;
	Sat, 10 Oct 2026 08:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791619328;
	bh=x6qD0evWKzKr5dPI/QVrRfRNpvxoJoNt4NxX7jOVVtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fDY60C9xoTOLhWg5sGwSpHIVZP7LFBCpfUV8+HzhAvi0wTSIy8Ekkt1nYXL/Z+vTB
	 hoaYO05LXurfVcDQzo9ampCajvR6fUmtGb/5XTRUzcPJJD+CCTXuPoEr2X0j+jt2T/
	 WgwhRfhXuM1ME8Uri4T7xGrwZ7xWIaUuuN6dqG0xZYuS1fYOchQbZM3QKFGmUD8Nc1
	 UOxcukZ+h69mSAcJsLjQnWAziHf7xDMALw6WCJP8qPlSrp+vAqZqEmfyts+eaoED3k
	 U7hHsrIQWGBiU9X3569wW07J9/HpDhBi3eYOevLoJERCF17phT8JKSJ2eifE4Cqq6U
	 do4X9utYqkq7Q==
Date: Sat, 10 Oct 2026 10:02:03 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add a test case to verify fsverity on
 compressed files
Message-ID: <20261010080203.GB1946@quark>
References: <20261010032508.36935-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010032508.36935-1-wqu@suse.com>

On Sat, Oct 10, 2026 at 01:55:08PM +1030, Qu Wenruo wrote:
> There is a bug report that with the recently enabled large folios
> support, compressed files on btrfs can give random but reproducible
> warnings about file corruption.
> 
> It turns out to be a bug in the verification range, where blocks not
> included in the read range are passed to be verified.
> 
> Add a new regression test case for it, the workload is pretty simple:
> 
> - Create a 64M file with compressed file extents
> - Enable fsverity digest on that file
> - Drop page cache
> - Read that file
> - Verify there is no "FILE CORRUPTED!" warning
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/359     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/359.out |  6 ++++++
>  2 files changed, 51 insertions(+)
>  create mode 100755 tests/btrfs/359
>  create mode 100644 tests/btrfs/359.out
> 
> diff --git a/tests/btrfs/359 b/tests/btrfs/359
> new file mode 100755
> index 00000000..2047d965
> --- /dev/null
> +++ b/tests/btrfs/359
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 359
> +#
> +# Test if btrfs handles fsverity read correctly without corruption warning
> +#
> +. ./common/preamble
> +_begin_fstest auto quick verity compress
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: fix the fsverity callback where unexpected range is verified"
> +
> +. ./common/filter
> +. ./common/verity
> +
> +_require_scratch_verity

Missing _require_check_dmesg?

Also, sourcing common/verity adds nodatasum to the mount options.
Doesn't that disable compression too?

- Eric
