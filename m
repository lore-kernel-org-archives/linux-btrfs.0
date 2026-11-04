Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794262;
	b=gbW0mOM/DEecx8M1xwHoeiSvCVXGQlpKw4ZQ/Z6XOUVkIubkgdvAVIHgwCebVp/ejJoM
	 HOE/ZqfxgE7tTJl6+UnUFUlMtxTmDRcxKZoqkcvBHLrktlrJoBeRIz9cOGiQv6o9jDHgF
	 YY26O8Z51jOJbxSdoTjFdYal2ZHmjQKQ4mt4NEln8mkO5UFzhEjZ1mURMipKhNZyLiePB
	 0bu3KqY0xUgnsU3+2feJVvG+XUqh+Ly76sOe21yBHZ3ZFTl+Zj6H9E+bozp4ujPVv1skA
	 x4TgZnW8V1/L8QegdP48g2SgsnQyMB0Kf7b3IQTWe3LbwTNVjE+creoiIfcxsqQoChQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794262;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Debian-User;
	bh=PM+1SXBE1tO8IGolYslHAuqq+HDTOKBxAOZ2o3BRaQ0=;
	b=qAZGTtd6UdXsl5ZypcsskiEF3uG8oTDtHR0ymTCMvEvdhyozv8zbXile9WAfJo9SN6Df
	 cR9S+YwZCNhB2vPLqDWadhcT0LkofaLglO3tWGbm5f3gTd+mPxHSrLoaELxIZL28irqD9
	 OPh7RqIz6FCwZ9YZ0AbsAkWCiWlnvWyJsfi2lVf1tNwxNLcvVv4v87lvxeaSjujOi4ef+
	 iyTIOML8oCStPR+KYooBEQ8IS88nFVAJ1T4VbGTkkwJDwRtzjvO42biFOuoJKUF4aUxfH
	 IbETd9AwAlh2ChZlaXqbHo9RlyzIT8QYFp490MuDclwk8G6r6pq+ZxHAMnqe3uHQDvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=DPtVCVe+;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB18606A31B;
	Wed,  4 Nov 2026 12:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FB18606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=DPtVCVe+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PM+1SXBE1tO8IGolYslHAuqq+HDTOKBxAOZ2o3BRaQ0=; b=DPtVCVe+pcamCzJc01XI7O4qkX
	yYweOEk5BL88jVN6149yTUKRNpjMgHL52CAErHZFrEv/+eRNPDatL2ZAn2BmumA9wYAXxfPvPIfnJ
	RazZoDmf0tVwNNPNcVy5UgOi/LJ3hpwamdFIo5kFwCvOoKe0tYBgWUboFgn97ov7IND0nVMYH9A6C
	ifQvaYbClrAq5k6AjQFw/r2ulk6HiG/J4++BpWUm6jIgbYtW7TWw4LGVQKRyww+H91BmLEy7JCGKL
	KA2swXz/S1unrolO/+TY4ic8tp/lb0+zSs27fiVp044phprOel4bGfW3h73sk7d6AWQic9psFni2x
	ETp4vWCw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOZpS-007hWX-1p;
	Wed, 04 Nov 2026 12:10:58 +0000
Date: Wed, 4 Nov 2026 04:10:53 -0800
From: Breno Leitao <leitao@debian.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org, boris@bur.io, jlayton@kernel.org, 
	linux-arm-kernel@lists.infradead.org
Subject:  btrfs: bug report: reflink racing with async compression forces
 read-only
Message-ID: <ause7k_HjzUWT3D-@gmail.com>
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
X-Debian-User: leitao

Hi,

We are seeing btrfs go read-only on arm64 production hosts (64K pages,
4K blocks, compress-force=zstd:3), on 6.16-based kernels and up, still
being reproduced in linux-next as of today:

  BTRFS warning (device nvme0n1p2): no extent map found for inode ...
  when unpinning extent range [20480, 24576), generation ...
  BTRFS: error (device nvme0n1p2 state A) in btrfs_finish_one_ordered:3200:
  errno=-2 No such entry
  BTRFS info (device nvme0n1p2 state EA): forced readonly

A quick bissection seems to point to commit 1d2fbb7f1f9e ("btrfs: allow
compression even if the range is not page aligned")

I've able to come up with a reproducer that hits the issue within
seconds with 64K pages:

	https://github.com/leitao/btrfs-reflink-async-compress

My robot identified this as the root cause, but I am not smart enough to
understand: 

A reflink into a range that is still being compressed does not wait
for it:

1. Another part of the same folio starts writeback first, which clears
   the folio's dirty tag.
2. The second filemap_fdatawrite_range() in btrfs_fdatawrite_range()
   finds folios by that tag, so btrfs_wait_ordered_range() returns
   before the async extent has an ordered extent.
3. btrfs_clone() drops or splits the extent map pinned for that extent,
   and the transaction aborts when it completes. If the clone wins the
   race instead, the compressed write lands after it and the cloned data
   is silently lost.

Thanks,
--breno
