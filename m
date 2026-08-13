Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D7C376A00;
	Thu, 13 Aug 2026 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641285; cv=none; b=HdxlYFr4pFfU+b5rTLCKJ2rD+Xg6/hw05XYBIH2rLdnWVgtwJTHZ+nJ2piNjPprEtgWf3UtHqd3x6COjOV9p1+inP/k7CCXsQOaCMipWzUCtrLaCXbTQ+U4qG7cpSepDic6UbzRtcSir6Q2+T+SL18XeqaC/Il3UdXAhzDFQLaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641285; c=relaxed/simple;
	bh=mxnfmCugRRkA1czMGQcPwW0xl1kzsrQOXSdA7cSPUGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taCzp2WtWtZObvAVO2gNBdGJtW49LmQC6kXzeMmrXGTEwTY4OqEBxPhGkUQvvVn+4roZCdvw+jLRJp9B8LDTp+L5M1AyJRc2mD07xRgABDheUe4i3baJwoHc59/sO7Umxr+32mqBCEL/HQRtVRG/2l4HKo024lSIhijpp1yuzJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kc2CoMBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kc2CoMBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB8B1F000E9;
	Thu, 13 Aug 2026 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786641283;
	bh=ncbaBbbAdSG69T/4dyVL/Y8+rnJqwFhe/k8gWUksy34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kc2CoMBNE83qFspsqd/9x1KrTDPzUxK5LFSgYswYEkETzKJ4uILl8AQXrP1lth2RK
	 79nSg6Yl+VgL18am8b1hPLNFuM3CY+KK/b5Ki01UIRVCsOwcAD/gHGa+ZFA9DXjgfZ
	 7RN4uxu2Y7kjR0lvwgqiIflevZt4Z5oidpHzcyM+cuNSnMBRVDVtp0R7ldlYYPj8ts
	 DPVNhuqTLslFbn3cD78cjQy7IDIggg9pG7eVnwEm4zjVupU7jH+ukjJFfyYo+/BsFv
	 ydIteRA9F87w2qo9MGEtVFwMIItZ+VUNScYIlz4FnoXloWDpr+oguFKobSC/iP2CZ6
	 P1W9650oqiiUw==
Date: Thu, 13 Aug 2026 12:11:36 -0500
From: Seth Forshee <sforshee@kernel.org>
To: Tao Cui <cui.tao@linux.dev>, Qu Wenruo <wqu@suse.com>
Cc: clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, brauner@kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] btrfs: use mount idmap for defrag permission check
Message-ID: <an36yH30W965eqZk@ubuntu-x1>
References: <20260813034146.1207640-1-cui.tao@linux.dev>
 <bd66065f-bae5-482a-84d6-a78850c9cebe@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd66065f-bae5-482a-84d6-a78850c9cebe@suse.com>

On Thu, Aug 13, 2026 at 04:04:05PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/13 13:11, Tao Cui 写道:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > btrfs_ioctl_defrag() checks MAY_WRITE with nop_mnt_idmap, which skips
> > the mount idmap.  On an idmapped mount the owner comparison then uses
> > the caller's fsuid against the raw on-disk uid, dropping the mapping.
> > Every other permission/owner check in btrfs ioctl uses
> > file_mnt_idmap(file) (e.g. :1152, :1310, :1946); this one missed it.
> > 
> > Switch to file_mnt_idmap(file).  It equals nop_mnt_idmap on a normal
> > mount, and the check stays behind !capable(CAP_SYS_ADMIN), so only
> > unprivileged callers on idmapped btrfs change.  The RO-fd note in the
> > comment above is about the file descriptor, not this inode check, and
> > is unaffected.
> > 
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> Fixes: 4609e1f18e19 ("fs: port ->permission() to pass mnt_idmap")

This is a misattribution. Using nop_mnt_idmap there keeps the behavior
the same as it was before the commit. Switching to the mount idmap opens
up BTRFS_IOC_DEFRAG* to idmapped users when they weren't before, which
is a separate policy decision that didn't belong in that change.

Saying that these ioctls should be allowed for idmapped users just
because others are isn't a good justification. Why are these ioctls safe
for idmapped users?  Do they actually require this capability?

Thanks,
Seth
