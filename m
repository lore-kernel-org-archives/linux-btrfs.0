Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739933ACEFB;
	Fri,  6 Mar 2026 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807744; cv=none; b=m+GcoIeFZQkNBoHpMgLmRiJSzaiRGln0yfiKZ9/vOn4bV1IqaFCFlbXf/KBVw1ExsT/wSwCC9U0jcd/T5UkTxaLaiAOwojts1xu0AKkTtYjm8Z5EgESEaXWSHf570m0ZAQSiLP1riq7hak/nJ795I2/TKBzVFKq9qb+gjZ2T1mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807744; c=relaxed/simple;
	bh=/D6sTAuZQFRZuaBu+ck+yhr3Nxs0p+a1UdstZnoNyUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRJ23oN/tfEh2fxe+hl5hFV9wFf+K7orwdJCnPzcbSQ580G/2XZYoIScOBKnbZmfemVPnjhLOl9BN+KtfBeUsLKwyy3J6yNT0+4a7XOylBL5Ol2HmK5wgqXk7JCDDwsWhKoZIZKSaIPwU8RqezsvJYxmFbDo+d69ujmydJZomWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FVzutWuk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FVzutWuk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eThVjv8gxts8tqgQuxq5jwgcQU6x5IEdSK/NmVmJ4vA=; b=FVzutWuk1LPw3Am8jtvhJvTyfS
	AfILgoAAwVTVHDanwAgmvCQ0pcXNO+rcV+xmyIoH9n0pTPAiEsFyGFahWuFPlKGIFcoPP66x6Psao
	DUARA9qHmV7WyhDHRU9ZyFi8SJ2LjrCGD5NyE/koqZvJIGm9Z0B7eyix99PR75RWiP4njSVWyUQRI
	HEH4qhZU7n7HPbe63SvnpxwgHnt9u5t3pSy5zQckhSwnMECriYGW6Ig4ZdpxSu3+J0sA3XXBAmDr4
	6bUOaqc1DViZf0nvuW0cRak4lPTOZYecg48ZzvqbECdPws3FksjmVaAeB1C7b8IoqwMWLEhklYpBo
	Jct+nNMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyWHE-00000003uwH-3QPs;
	Fri, 06 Mar 2026 14:35:40 +0000
Date: Fri, 6 Mar 2026 06:35:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: test create a bunch of files with name hash
 collision
Message-ID: <aarmPHmLnGtvhUcO@infradead.org>
References: <a1e2690efeb8570651894567d80511144424fb5e.1772106022.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1e2690efeb8570651894567d80511144424fb5e.1772106022.git.fdmanana@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 26, 2026 at 02:34:37PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we create a high number of files with a name that results in
> a hash collision, the filesystem is not turned to RO due to a transaction
> abort. This could be exploited by malicious users to disrupt a system.

Umm, file systems must handle an unlimited number of name collisions.
While going read-only is of course really bad, just rejecting them
can also pretty easily break things.

Also it seems like part of this test is generic, and only the subvolume
creation part is btrfs-specific?

