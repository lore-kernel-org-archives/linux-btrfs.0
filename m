Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6F940DFA5;
	Tue, 10 Mar 2026 13:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148432; cv=none; b=tvljGEKfxTJoGhSvDj8DKX9uNUsWUEPzmM8KVOUSV25c/FTyQrWNKxNxHz7ht/enFVXGzSnj8HcpAmOhLV+dXcuZmbZiJxwznhFAPTXRzjis7nhpRbHNDFMEAj3vdS78Ws2dQoTlOA1G06Z/xdZI0OecqFYNM3ij5bWvAcNEXXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148432; c=relaxed/simple;
	bh=e/pv3CxAxC2RnAlfOfrfKu284sfmuZfniHtWEju2ZC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoS+eWZo0xLHp1jHhulNGXBLlb0EMRZXrfYnBwxgOvwyQRJtCQpPHYMAFTJTzgTuZZIvuFhqciNMP+zLr0zNbvgFPYzKddalvLIdhHei17ym5y8DlQBGEcShIJkVB/f2PUH8adl4ovDl+8O8xuXdO8sdK6QwXTBlCTTZgo82rg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KXA2AVzj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KXA2AVzj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0uzoy50EcKDUvv4Q7osdCggdIiDAs86AMvSoYoV05Hc=; b=KXA2AVzjsScPXXh/0V/WwVZ1eX
	bcwt92TKX0DYfBXDXsioaNAIfVZuwN/7gkoBRMX8U9lRnnQABJddUJUgWCdk7wtXvSig2f2CzbcVz
	KYA6SZvHNw1p+Hrg51V79692tlF+JnUUhKwqVR0QPd+XoGbCZlAvRfZOb7uOOdU0rDJq8BWI8Ayi9
	XM07ulfjFRn97hX75IqocXPU6MRPED+umDdBoVHneseH4hMGdsYQpAfTKIVZxB1Algl538fw2YeI3
	4HxI1yCUGPZfLtOWruPVtxEEfsHo0XsIr1K++7skqxOi0xar8ZXeHWcaFXhpT9wDHvifxTM8aXP0v
	8V8E4mtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzwuE-00000009Z6w-2pw8;
	Tue, 10 Mar 2026 13:13:50 +0000
Date: Tue, 10 Mar 2026 06:13:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: test create a bunch of files with name hash
 collision
Message-ID: <abAZDvPLRbCeQh1D@infradead.org>
References: <a1e2690efeb8570651894567d80511144424fb5e.1772106022.git.fdmanana@suse.com>
 <aarmPHmLnGtvhUcO@infradead.org>
 <CAL3q7H5r5_FuTSUM_5TqFGFPSZ4qC=qG49_JuLpUfzFCa=8YyQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H5r5_FuTSUM_5TqFGFPSZ4qC=qG49_JuLpUfzFCa=8YyQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 06, 2026 at 02:55:23PM +0000, Filipe Manana wrote:
> > Umm, file systems must handle an unlimited number of name collisions.
> > While going read-only is of course really bad, just rejecting them
> > can also pretty easily break things.
> 
> I don't think in practice we get a large enough number of names with a
> crc32c hash collision in btrfs.

That's not the point.  Posix and Linux file systems don't have an
error code or defined condition for adding this file name would cause
a hash collision and we were to lazy to deal with it.

> Adding support for an unlimited number of collisions is simply not
> easily doable, it would require an on-disk format change (new key
> type, item, etc, update btrfs-progs, etc).
> The motivation for that is very low, as I'm not aware of users ever complaining.

Well, how would they know this happened?  The users only sees the file
system acting weird in completely unpredictable ways.

