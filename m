Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BB53B2FFB;
	Mon, 24 Aug 2026 05:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787550108; cv=none; b=J7CQPXcR5dXqB4zMrFA+C54bs1nrulJMcqN4iyqES85wMizZwz9kIHM4lNpYmsbOl55PKTreDIzDLCkprDsqP4yAL+VS2sGcqU5g2VjmEc+QiVb2J1cTFeISj54et2zmgUU7uyJtbakbGJ6usq5wOoAD8kYmxRS4cZnf8jDIOv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787550108; c=relaxed/simple;
	bh=vtBXSmr97fdxKpbsd8fMYJRRkUyqTEg271wwUSMrtZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssgk9Fd33LLrBtICOcJnwmAkqO6SbpZFudAayLponLjOQVaKqN0FKsw6K31vofijZPwV1FPC3g8Z7x5rA/59HXrP87repLi3y1E9ObJhI10UoiTPd8ORtKdD8CLblEDFObk53iqUbF/fihvvdhtaxokAhyIErJtCVkROpIrgaa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVQ+TuVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVQ+TuVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EEA1F000E9;
	Mon, 24 Aug 2026 05:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787550107;
	bh=rtLDm1LHdG8WVsTsWinQVUSlDvN3tHsCEqXyUA4lr1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FVQ+TuVnQj7aMkF022XbDh/VQII9D0eTB/TY44U07RXWcA99Gtpxep8DaZbLBgQGK
	 N8uwr4cODikzo6K0HwUqHS7THVTp0bO4dlG7w9SFD9CLOAllu17/F/6GwnWDcr1P8R
	 kgf9nD/14sEnHS38J9bWxTxX2CiAHBcm9CtewZ8hJbBkBhC8vTSNbwxRmLdfipy9YY
	 DOzVl/6IGJuBucS5T3IMtBxUEfV7OD95zipO/7N0keUpSnnYpiqJmmeYPpHVfPKgz9
	 HeQ/qCuUO3A1y2+W/bVPOn48D8g4TYV2LNUCQ374p3I7D24OKUh8FSO6KlfjVxLnsB
	 G9U55UzxZpqtQ==
Date: Mon, 24 Aug 2026 13:41:41 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] generic/746: skip on zoned btrfs
Message-ID: <aovWTFh_7Xo1s_i7@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-4-johannes.thumshirn@wdc.com>
 <aofkT7rrfQYCr6yK@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aofkT7rrfQYCr6yK@infradead.org>

On Thu, Aug 20, 2026 at 10:38:23PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 19, 2026 at 03:16:03PM +0200, Johannes Thumshirn wrote:
> > The test relies on loop device discards punching holes in the backing
> > image file (holes are then detected via fiemap on the backing file).
> > Zoned btrfs does not support fallocate/punch hole, so fstrim on the
> > loop device cannot free space in the backing file and the test cannot
> > work.
> > 
> > Skip the test on filesystems that do not support "fpunch"
> 
> Shouldn't _require_fstrim return false for zoned btrfs given that
> trimming makes zero sense?  Otherwise once zoned btrfs at some point
> supports fpunch (which it really should), this starts breaking again.

Currently _require_fstrim only checks whether the FSTRIM_PROG binary is
installed, can _require_batched_discard help that? Or should we explicitly
skip zoned btrfs inside this helper?

> 
> 
