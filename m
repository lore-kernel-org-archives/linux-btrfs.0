Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4B412C03;
	Mon, 31 Aug 2026 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182181; cv=none; b=bJkChCqdddijjGA2iHL9dmE6TXmfnbW7Zca8AxdEn3ay5ApKJyjOWPu3+u6fVBs51qc3/yQJjhAe5ae6A+ljLQJrASBPNOnh6st59LQUADmviZF6HCG4jrpQ83LgYKlw0CcXgpf5nWuHgtyak+XhIaNtqtDnbnyjc8GLCWTEHwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182181; c=relaxed/simple;
	bh=m5rhbb3kERiMS+SIZ+xL58axwEhMOeJwVoJ5OlJZd0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V47M4KCX4yxQDmDj5flRGAsWquFT6f8YEX9b/0gMn8yHMFOthxsoYrEj+MhVtsPvAG7QfbxXYhAqDBB2GmTUvS/26OUIM0PjyNK8+ngQRiYmrV60vYHvw57G9OF3TO/ki0niLcPBIbrBIpjjwgYXJtqhb6k2wdGWyoKgTdlIZ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fs3oB1Yc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fs3oB1Yc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uLmu7+yhi8DjY+Bw3Ri3Boq/4F9KHI8ZuE5NwmHnL2c=; b=Fs3oB1YcgBmEpoRyFyrn1FxHXc
	1q25xR/OKD+XZHPAn8bWKmJc0uY8st/1gcYGuTGg08CJbrjpVsohSJXZPTzdOKId5x3Pn9eCdTv4L
	h64U+dySawqit4XVbJRZQPKHjyv01gdEkbDYKGouyRGYEKST6wSwVqrEZaVNt7rNJMhT4BeEdRV/l
	YAwriqe5DV4rfs/xr47PIJsHEXbduIy2lLi2CDBPjd9v3NZxUFws+DJBebpfkxxWfYu4KnopwZJLn
	aT4I6+7ZbXMcL1gIIUvkbbLrUepYCaNUjSTao+hzFt6oT3riU0DRFoJjLN4LhpQ1YP9fcYlq9hTuk
	joAZK3pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x11s2-00000009NO7-0TIj;
	Mon, 31 Aug 2026 13:16:18 +0000
Date: Mon, 31 Aug 2026 06:16:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Matthew Wilcox <willy@infradead.org>, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Add test of seek in directories
Message-ID: <apV-omM4s58KtkRz@infradead.org>
References: <20260827234743.2389778-1-neilb@ownmail.net>
 <20260827234743.2389778-2-neilb@ownmail.net>
 <apEK5uirjyLZUfmA@casper.infradead.org>
 <178791556100.3510150.18132687067056760170@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178791556100.3510150.18132687067056760170@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 28, 2026 at 09:12:41PM +1000, NeilBrown wrote:
> If you happened to know the sizes of the all the names in the directory,
> you could make a sequence of getdents calls which each return precisely
> 1 entry,  You could then use lseek to determine the seek offset at every
> point.

No, you can't.  Despite the historic naming d_off is not an offset, but
a cookie.  You can not arithmetics on it.

> Linux getdents64 makes this a bit simpler by returning exactly that same
> number (the seek offset to the next name) in the d_off field.
> 
> So posix certainly allows, indirectly, seeking to each d_off.

Posix and Linux allow to seekdir to each cookie returned from telldir,
it does not allow to do arithmetics on it.

> 
> Posix refers to one directory entry "immediately following" another
> which clearly implies a well defined sequence (if you exclude names
> added and removed during the read).

I think you're talking about posix_getdents here, which isn't really
Posix as we know it, but was added in the 2024 edition without actually
having relevant implementation so far.  It does however implement
the syscall-level API in most modern Unixes.  It does not mention
d_off at all, just the lseek-able file offset, though.

> I think a strong argument for Linux needing something is that NFS needs
> working directory offsets to be able to support READDIR, because there
> is no "OPEN" request for directories.

I don't think anyone disputes the need for stable directory offsets,
and we should (*knock on wood*) have implementation of native
file systems that fail this.

What the test tries to force is a specific behavior for rename onto
existing file names, replacing the original file name entry with
a new one of the same name.  The test expects that to reuse the
previous d_off, which is not required by any real or de facto standard.

> I know less about btrfs.  It appears to always add new names to the end
> of the directory listing.  When you rename over an existing name, that
> existing name is relocated to the end.  I can only guess why it might do
> that.  I have no idea if it "needs" to do that.

btrfs doesn't manage freespace for the d_off space (doing so is quite
complicated and requires a lot of code in XFS for example), so it
simply uses a monotonically increasing counter for the value reported
in d_off.  This simplifies things a lot, and should work well on 64-bit
systems were you are basically impossible to round out of d_off values.
It might be a lot more problematic on 32-bit systems because the
seekdir/telldir cookie is a long and not a guaranteed 64-bit value.

> Fun fact: This behaviour of btrfs (which I think is perfectly defensible
> for new names) resulted in generic/736 (which I think is an unreasonable
> test to impose) which btrfs "fixed" with a mechanism that doesn't work
> over NFS.  i.e.  it doesn't work if you close and re-open the file for
> each getdents call.
> If I mount a btrfs filesystem over nfs with rsize=4096, then generic/736
> fails.

That code and the tests looks a bit questionable, as readdir by
definition can't every complete in other file systems either if you add
new entries faster than the pace of readdir calls.  I.e. if you replace
the rename there with link calls adding new entries you run into the
same issue with every file system.

> The link you provided says:
>   If a sequence of calls to posix_getdents() is made that reads from
>   offset zero to end-of-file and a file is removed from or added to the
>   directory between the first and last of those calls, whether the
>   sequence of calls returns an entry for that file is unspecified. 
> 
> which unfortunately doesn't cover what happens when a file is renamed.
> When renamed to a non-existing name, it might be reasonable to describe
> this as "removed from" and "added to" so its appearance could be
> unspecified.
> When renamed to an existing name, I don't think it reasonable to
> describe the target name a being either "removed from" or "added to" the
> directory.

If we are talking about files, it is very clear that the target over
which is renamed is removed from the directory.  And if the source
was outside the directory it also is very clearly added.  The only
gray area is a source file that already was in the same directory.

