Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5011C2324;
	Fri, 12 Jun 2026 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781252102; cv=none; b=InQ/wS/MVXYnHgTkbzwiL8pmNDPJOEb4OrDyQYES4Yw8ptYT3uM7R2GSMnWxZcvYgFEHjg45o6ZrD7eXgzW1tY0mTUzLEmaF24YWHamUvB+Lt9p0na34wT24eNb9vXUc8rRbba5OohR1QLYkSThnbHHWPH/HBMr2TH2wkdvCBzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781252102; c=relaxed/simple;
	bh=eHo1/UJvIkKu1vEckkFFfw0jO4Y4w2qFsDl8uEk4OQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1LbRx0a1pWxJKq2CLYdn9JOTrHx75GailncSvOUbgyExZQUxOzWZzIsN35GFpPoybmbjNb+0rHYbYlyV4EXVhs8wcjOKql8bZwefGT04+OEFjpKSow49cdSE2+CAOJJp0Kcm9fAcMrfJVj6Jul0iYYP94VMt4tTKbGA7yeFGW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nMrOIgHb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nMrOIgHb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=bC82jPab6S3wVzMMxpsWQLnEuTGROvnPgIfnuq5vlbs=; b=nMrOIgHbeqs2wVJIEqvTcSh2u4
	+S719oQ0n5euK/SYW9MA8GnP+JgqOc1RZpFVdL7AyUKODwIb9wlLfowNhbx6rscZMUzIqO4ysOm3C
	0vX0Tj1g71AgfZtyiSNg/ORNHUQkZ1MdzMuZb1BtrCg3Z7VRqH5syq9aYU7QdE6HaM7CZPI5gYfDf
	gGBEx32/bimUkTTGXMqqr0CcqdFPJAZALpB95pAEUACO5cv6X+zOUkD/baBc/+XvIT2RsTpULnK0t
	wXX7n/1N2v/UMGtxYkTCByzpbsaJBSFA9rsTYHVtZZ0RyJ/XWVCCOzIDz/fFcBcShAc5rVUewb+dp
	xCW+HRqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXx2a-0000000AZA8-0hLA;
	Fri, 12 Jun 2026 08:15:00 +0000
Date: Fri, 12 Jun 2026 01:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: Direct IO page bouncing got some garbage?
Message-ID: <aivABK8nwNR6Z__A@infradead.org>
References: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
 <f1dbdcd6-4e6e-4304-8fa5-59c2c60252ad@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1dbdcd6-4e6e-4304-8fa5-59c2c60252ad@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 02:54:22PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/6/12 11:11, Qu Wenruo 写道:
> > Hi,
> > 
> > Recently I'm trying to make btrfs utilize IOMAP_DIO_BOUNCE, however I'm
> > experiencing weird data corruption.
> > 
> > During test case generic/708, I'm reliably hitting garbage pages at the
> > last 64KiB, the garbage even contains an ELF header.
> 
> Added ftrace shows that, since btrfs has to disable page fault to avoid
> certain deadlock, bio_iov_iter_bounced() failed with a short copy.
> 
> Initially bio_iov_iter_bounced() got a 1MiB page, but copy_iter_from() only
> copied 64K then failed due to the disabled page fault.
> 
> I don't think it's a coincident that the short 64K exactly matches where the
> garbage is (the last 64K).
> 
> I guess it's in the error path we didn't properly revert the iov iter?

Looks like it.  The better option would probably be not to give up on
a short copy, and just reduce the bio size to fit the short copy
even if that wastes a little memory.

