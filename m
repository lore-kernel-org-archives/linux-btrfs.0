Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B05442B3F;
	Tue, 25 Aug 2026 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787662085; cv=none; b=dOCIHn2i4FcKVOPpPzECEK3LsR9RpH7le1BOQFQDC479ZxcCVVL4DcH9pdvddoqXZExQlo/AIAsWt6j+0eShwtdNs5CsCPSDCAB3eU7cC+ZrUpOwcfuM2qdoYVftdqsvPDzYD1pNgca+17SC3+MzeguUetXRKsTfclIYgDwEDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787662085; c=relaxed/simple;
	bh=OqrqU/2Ed5rwzqui8afuZaDGPHtphtPRvnBIsOY8Ylc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvMl8JWMMJjesPEWcvKsDXmzUTFUR1++ftTjMSRrt8xj2ldIAHbWyEpLd0k9ZDQwZo3/KdIqODPTQTy6IGewp4FvYASV28ZAETFoCvDN5foSLs2v4V7QjchWzzC4iXURud/Kbsx0Gstt7jHB64iq6Pl51/j62//9IHkBQZIZofk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyO7arxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyO7arxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE771F00A3A;
	Tue, 25 Aug 2026 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662078;
	bh=uvLSFBna8Q9cJU69LRFVCxwCgb+cCDLOAutOk7Jzz4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OyO7arxswsgVpSVcquHYay6KVDV8aNakQlfAjZ02eBRdhWPAJ99DhWb37ggz9m/az
	 T6lAs3O4ISqzr87P7VvSTeQUL21fNpwp3lQeW1qCcp27yswnsh/P8Yziyo3g/1iRV+
	 PT4AiQFGEx933y1+73j7+oCgmBSDZ9KQvqRCADsJ5pDWnmavO87KYRixP7is0Y1rcK
	 ynpcn69csMe5ds7L25FiK0AkhloAWbuDHebpz8liA3ROYZV1SVifDnRJqA11KvzbPL
	 NIEYN3FN1KN9s5j6mlRlsYqOy3gSpw2oKNxUROGZ95ItEYd+F3dYcNJuRg3M4JhgY/
	 LLHjfJeFVVVcg==
Date: Tue, 25 Aug 2026 14:47:54 +0200
From: Christian Brauner <brauner@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: clm@fb.com, dsterba@suse.com, sforshee@kernel.org, wqu@suse.com, 
	josef@toxicpanda.com, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] btrfs: allow idmapped DEFRAG ioctls
Message-ID: <20260825-vorbringen-bussard-angeln-5b353215ba73@brauner>
References: <20260815132259.3935817-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
> ---

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
