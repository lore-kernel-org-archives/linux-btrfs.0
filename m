Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89145316190;
	Wed, 25 Mar 2026 05:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774417816; cv=none; b=rkKv4yLZSWIi2iudD9+7C8wRwrAfyTLjvHR6EQGc1GVHovu4ByFiBkQdHsXeTTYQCqeZwYtW5kKIqxkEFXizoL47E+DPwh4KvpcrlX+U3/n29vDEzGyVfEEWJQJBE/6qfgo9JWEt0w+0z7oqomNlJn5O8thdENvvmhmHb4lccNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774417816; c=relaxed/simple;
	bh=zHV0NcklHnsPEfKc5mW2XniIaZ7C0ASFjF6FtOdI34s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctQyYDYUBvCmYBynpzOZSvv9TH8AV3pjN/YU6oASILyNlnMNCKLn80CpFzVRjzv1jSI+G9XTMEoPmuz3qcQVcWr9Ei78rmLVkyeB1ILOFLbqsTgJ/EbqpLw42qRfRzjqHrpwUtE21HcYtYfh/+qZO7czwoYyeNHdFC0aOSICGxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s3tGgNAJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s3tGgNAJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ix4gU+gLB7ytc2Bet7k8fUhKp89DbhxtPP920ichXe0=; b=s3tGgNAJj1b9BTud37sfXmUHHm
	AKznR7654sIMh+c7DUwt0RxAZrRvE4RUI9dWv+Z4iD2fBa8ST0Hnc94iE+KZk8rb9N93rtWVCnvcq
	81vi/+An8LVnVW8EOvcz/FYEiDWX85KdUBAV4aczmks3QwGjPEfS9x2HjAWRWzEkxsYABFy1lXcL0
	XF5Kq5Ow2DJwXdUpTqtlwnLcScoI3+CsvHR0UsiH7/cVSboZoa0g2NPhMhHV00yB7xUw8Yu7CONlg
	JmFGQ80bD+e5VB8b5Wzphm6N74TuSGQy+KhZEdml8AQv5hFWqLjeoN3G+POBJ19OIj+Ht9ZECom0N
	iHlZkoXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5H8B-00000002kSs-117I;
	Wed, 25 Mar 2026 05:50:15 +0000
Date: Tue, 24 Mar 2026 22:50:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: Re: [PATCH] generic/747: handle ENOSPC gracefully during
 write/delete cycles
Message-ID: <acN3l8gGjA8gaZeE@infradead.org>
References: <efcb3c8470bf099534fec1c1745780eba445e111.1774394322.git.loemra.dev@gmail.com>
 <20260324234010.590043-1-loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324234010.590043-1-loemra.dev@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 04:39:43PM -0700, Leo Martins wrote:
> > The test fills a filesystem to 95% then does mixed write/delete cycles,
> > using statfs to decide whether to write or delete. However, statfs
> > f_bavail may overestimate the actual available space. On btrfs, the
> > statfs implementation documents its estimate as "a close approximation"
> > (fs/btrfs/super.c). At high fill levels the discrepancy between what
> > statfs reports and what the filesystem can actually allocate becomes
> > significant, causing dd to hit ENOSPC even though statfs indicated
> > there was room.
> > This is not a filesystem bug. The filesystem correctly rejects the
> > write when it cannot reserve space. The test's purpose is to stress
> > garbage collection through write/delete churn, not to validate space
> > accounting.

f_bavail overestimating is a btrfs implementation bug that needs fixing.
It can be wrong, but it needs to be too low in doubt.  Without this
you're going to cause unexpected ENOSPC for real life applictions as
well (and btrfs does have a bit of a reputation for that, so fixing
this properly will benefit your users!)

