Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A43C2E401
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 23:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786317457; cv=none; b=VO2SmZxmWarl5OCG1l39Afa1dpzJBtKyMtWlAOWGgiZ+FK7X09xsh3GUh3K2URZiakvHY/61g4XNU7wIiaec4QHzTxPHzlyHLliC5zEg9CYlTnFYilDuB3qyMj9y4tnXnuPvIq6KNkBhI4bR2A1ISJ25/DgP+DWr0PpS/0uaWUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786317457; c=relaxed/simple;
	bh=jRjUmgHce9wXVhIQclBRGjLrvqCK7MmzJdiBrRwpYzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecrQbS/S/B/9icgX6puE7GwW+TREXD+3qizGWu8d0NWTeh6j8wMw4EEfgRU22lf+6RuVUib2PBV+fCRi5veLEdx3XUKsTbWWSSZixx3Fe2A86IUTzA6EQOhBtuCq1pa7cYELdnUTuYTJ9NS9h2lrwrKmVPuXQT/0z4jGuxQ9/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id 959421B1F849; Sun, 09 Aug 2026 19:17:34 -0400 (EDT)
Date: Sun, 9 Aug 2026 19:17:34 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <wqu@suse.com>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
	clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
Message-ID: <ankKjqr72aD8Ka8w@hungrycats.org>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>

On Sun, Aug 09, 2026 at 10:30:45AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/9 10:05, koraynilay 写道:
> > On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
> > > I'm not sure if this is the correct behavior in the first place.
> > > 
> > > As you already mentioned, zstd and zlib have very different compression
> > > level range, using the incorrect level makes no sense (and it's being
> > > clamped anyway).
> > > 
> > > I think we should go the default level when not specified, which makes
> > > more sense, and that would definitely be something worth fixing.
> > 
> > Yes, I also think that would be best, but my main concern would be it
> > changing how chattr +c behaves (I'm less concerned about the btrfs prop
> > set file compression "zstd" case, since IMO that implies the user wants
> > the default level).
> 
> Mind to explain more about the "chattr +c" problem?
> 
> IIRC "chattr +c" just set the btrfs.compression XATTR to the default zlib if
> no mount option is specified.

chattr with _any_ argument resets the btrfs.compression xattr _every_
time, even if the caller changes a flag something that doesn't look like
it would affect compression, e.g. chattr +A or +d.

That can lead to surprising results, like changing compress type from
zstd to zlib, if the original btrfs.compression attribute doesn't match
the mount option.

> In that case it should be no difference compared to any existing XATTR based
> compression setting.
> 
> Thus it's just the same missing level handling, and IMHO since XATTR
> compression level is never specified in XATTR, then the behavior is never
> fully determined, and users should not depend on it.
> 
> Even if we changed the behavior to option 3, it should not be a super huge
> user affecting change.
> In the end, it's just compression level, affecting compression ratio and
> speed, not really a huge behavior change.
> 
> > 
> > The options I considered were:
> > 1) keep the "bug", like I did for now;
> > 2) keep the "bug", but only if the compress= algo is the same
> >     as the btrfs.compression one, if they aren't, use the default for the
> >     btrfs.compression algo (e.g. compress=zstd:15 and btrfs.compression=zlib
> >     would compress the extent at zlib:3 instead of clamp(zlib, 15) = 9)
> >     (suggested by Zygo);
> > 3) fix the "bug" entirely, which is what I actually accidentally did at
> >     first, by just setting compress_level = inode->prop_compress_level
> >     without any check prior to that (which means that by default it would
> >     use algo:0).
> 
> IHMO both option 2 and 3 are acceptable.
> 
> 
> The only extra concern is, if we have a new level field in XATTR, can older
> kernels handle it?
> 
> And thankfully the existing prop apply handler is checking only the first
> several bytes for different algos, thus the existing code should handle the
> extra appended ":<level>" correctly by just ignoring the level.
> 
> So either option 2 or 3 would be fine to me. Although I personally prefer
> option 3 a little more, just because it's much cleaner code wise.

Option 2 preserves legacy behavior that is 12 years old now, and it
costs a single comparison in two 'if' statements.

Option 3 makes an already confusing situation worse--it makes the
underspecified behavior change depending on kernel version.

> Thanks,
> Qu
> 
> > 
> > Option 2) is probably the best compromise between breaking existing
> > scripts and the behaviour making sense, plus it shouldn't change the
> > chattr +c behaviour, since btrfs takes the algorithm from compress=.
> > 
> > Thanks.
> > 
> > Best,
> > koraynilay
> 
> 
