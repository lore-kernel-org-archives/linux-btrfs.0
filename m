Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044213AA1A9;
	Sat, 15 Aug 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786819023; cv=none; b=B8f/hjr92th/6kq0LLWr7KYcSZSYHqPuDH6fUNkNno/2fAP7oATjsKaAYJkq6bSMSIeqSC3ULerFT0ukSGk4ZR/zDawwGq4XYfCckzwqqztVp2jRqPa3Z8xWb3PG4rsJt/m0iQabbK64dyVSZRQM+MaJnaDYUHaL2uUuK1DYyjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786819023; c=relaxed/simple;
	bh=Q1R/tQygWi46KOz8YmZAxAnZLA3LFMKIAemz0W80GOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rerizCLnlMKaQZS+XR9obcmuctilNgtAciZJPwFDVqgGzVNmBkKbyDEYY68tiSHM2yRmtoV1Z+ZtmL5TwIWEmnJQWObcFmAuD0iYFgs1BK3ywRkg0qoNg0fxNtdFho7ZeTjsqxTWeoQxk5JG5U9WX5agsqQWLeeH/nOh/k9ouZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUouCxsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUouCxsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656961F00A3E;
	Sat, 15 Aug 2026 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786819021;
	bh=twJXGTZzkB2PEGt+lRybxX1Kv+mFgAp2yMHNNV2FA0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mUouCxsppcLw+tVk38/m6HAGFinpHiLtYJM7ZZB6Sn/R4n6C+XEqxlCZQpgxOchxW
	 s0NVQs1ZfjMOdQO45YMi2UvjeFOJ/gFqhvPFcyQn54qHjx+0uAtJ78ZyA4b07WSFPc
	 5/NQyJG/Uehoj4sA1Lv0UEe8zxuk45Wap8Plwmsko634T3EfUoFWylkUkFLczpzQl+
	 Ch7gg8fxQWDh+kIc1eNcLkquVXgjOb+QK1gvAFwOVZNY4GgDM8ogtUfUgxcBdeVwGi
	 Ek6jNwx15MJItMaqz5u5zTS3wZw0iBoc6r7aH8INkZ31MCpXYwIk7/TrLsaV1YX2K5
	 lyoHNO2MCD1bw==
Date: Sat, 15 Aug 2026 13:36:42 -0500
From: Seth Forshee <sforshee@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: clm@fb.com, dsterba@suse.com, wqu@suse.com, josef@toxicpanda.com,
	brauner@kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] btrfs: allow idmapped DEFRAG ioctls
Message-ID: <aoCxuk2DJVPsOXoB@ubuntu-x1>
References: <20260815132259.3935817-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815132259.3935817-1-cui.tao@linux.dev>

On Sat, Aug 15, 2026 at 09:22:59PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> btrfs_ioctl_defrag() checks MAY_WRITE against nop_mnt_idmap, so on an
> idmapped mount the owner comparison uses the caller's fsuid against the
> raw on-disk uid and the ioctl fails with -EPERM even for the file's
> owner.  Pass the mount idmap down so defrag works on idmapped mounts.
> 
> The check, added in 616d374efa23 ("btrfs: allow defrag on a file opened
> read-only that has rw permissions"), is not a privilege gate.  It only
> tests whether the file could have been opened for writing, and a user
> who owns the file on the idmapped mount can already open it O_RDWR,
> write() to it or fallocate() it.  Defragmenting a regular file only
> rearranges the caller's own extents; there is nothing it can rewrite
> that the caller could not rewrite anyway.  Whole-subvolume defrag on a
> directory keeps its capable(CAP_SYS_ADMIN) requirement, and the
> !capable() guard around this check is left as is.
> 
> FIDEDUPERANGE already works this way for unprivileged callers:
> may_dedupe_file() in fs/remap_range.c compares the inode owner through
> file_mnt_idmap(file) and falls back to inode_permission() with the same
> idmap, and dedupe can rewrite one file's extents from another file's
> contents, which is a stronger operation than defrag.
> 
> On regular mounts file_mnt_idmap() is nop_mnt_idmap and nothing
> changes.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Thanks for the updated commit message!

Reviewed-by: Seth Forshee <sforshee@kernel.org>
