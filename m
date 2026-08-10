Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2121E9B1A
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 00:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786321722; cv=none; b=Jb5txJ5cPQoee3oWwtHsM3cTjMoN4pSe4BCVfoIy29U0dY9kA/xLIIzcG6BYWwuySS8WaPT2fqME4DvQap3tg3OX7EBXZYKGH4ZryDf0NbaP0NibtDNWSaKilpk8XGEVn9eRwdM4VRgvrUO0KGvZzBVdjsJq45wdULB26sM8/yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786321722; c=relaxed/simple;
	bh=B8JiHvnKBJPCIhYQdwVmqB+KUZuzC+/hDNB4UQgj+SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mV6j+PxBo+vsIEpG9kYhsDpwvB4Es4KNPwUuJc5YNPPA8hI4gP1WgOmALkb26AUuY6UMn/4RQS14UM0upuYeOwJ4F8VnAH7wmBxX74utFQC14eCvYldo2QP3iwDCErdMID5q1OGTpkH0mxKeMcp3EkGqcqNYXRhZLkvB1wvZ/ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id BB2291B1FA6D; Sun, 09 Aug 2026 20:28:38 -0400 (EDT)
Date: Sun, 9 Aug 2026 20:28:38 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <wqu@suse.com>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
	clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
Message-ID: <ankbNtvLr3ZnFjEk@hungrycats.org>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>

On Mon, Aug 10, 2026 at 08:50:45AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/10 08:47, Zygo Blaxell 写道:
> > On Sun, Aug 09, 2026 at 10:30:45AM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/8/9 10:05, koraynilay 写道:
> > > > On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
> > > > > I'm not sure if this is the correct behavior in the first place.
> > > > > 
> > > > > As you already mentioned, zstd and zlib have very different compression
> > > > > level range, using the incorrect level makes no sense (and it's being
> > > > > clamped anyway).
> > > > > 
> > > > > I think we should go the default level when not specified, which makes
> > > > > more sense, and that would definitely be something worth fixing.
> > > > 
> > > > Yes, I also think that would be best, but my main concern would be it
> > > > changing how chattr +c behaves (I'm less concerned about the btrfs prop
> > > > set file compression "zstd" case, since IMO that implies the user wants
> > > > the default level).
> > > 
> > > Mind to explain more about the "chattr +c" problem?
> > > 
> > > IIRC "chattr +c" just set the btrfs.compression XATTR to the default zlib if
> > > no mount option is specified.
> > 
> > chattr with _any_ argument resets the btrfs.compression xattr _every_
> > time, even if the caller changes a flag something that doesn't look like
> > it would affect compression, e.g. chattr +A or +d.
> 
> This is the known problem of chattr.
> 
> > 
> > That can lead to surprising results, like changing compress type from
> > zstd to zlib, if the original btrfs.compression attribute doesn't match
> > the mount option.
> 
> This doesn't only apply to c, but all other chattr options.
> 
> That's why proper chattr should always include the full attrs, not only the
> one to change.
> 
> > 
> > > In that case it should be no difference compared to any existing XATTR based
> > > compression setting.
> > > 
> > > Thus it's just the same missing level handling, and IMHO since XATTR
> > > compression level is never specified in XATTR, then the behavior is never
> > > fully determined, and users should not depend on it.
> > > 
> > > Even if we changed the behavior to option 3, it should not be a super huge
> > > user affecting change.
> > > In the end, it's just compression level, affecting compression ratio and
> > > speed, not really a huge behavior change.
> > > 
> > > > 
> > > > The options I considered were:
> > > > 1) keep the "bug", like I did for now;
> > > > 2) keep the "bug", but only if the compress= algo is the same
> > > >      as the btrfs.compression one, if they aren't, use the default for the
> > > >      btrfs.compression algo (e.g. compress=zstd:15 and btrfs.compression=zlib
> > > >      would compress the extent at zlib:3 instead of clamp(zlib, 15) = 9)
> > > >      (suggested by Zygo);
> > > > 3) fix the "bug" entirely, which is what I actually accidentally did at
> > > >      first, by just setting compress_level = inode->prop_compress_level
> > > >      without any check prior to that (which means that by default it would
> > > >      use algo:0).
> > > 
> > > IHMO both option 2 and 3 are acceptable.
> > > 
> > > 
> > > The only extra concern is, if we have a new level field in XATTR, can older
> > > kernels handle it?
> > > 
> > > And thankfully the existing prop apply handler is checking only the first
> > > several bytes for different algos, thus the existing code should handle the
> > > extra appended ":<level>" correctly by just ignoring the level.
> > > 
> > > So either option 2 or 3 would be fine to me. Although I personally prefer
> > > option 3 a little more, just because it's much cleaner code wise.
> > 
> > Option 2 preserves legacy behavior that is 12 years old now, and it
> > costs a single comparison in two 'if' statements.
> > 
> > Option 3 makes an already confusing situation worse--it makes the
> > underspecified behavior change depending on kernel version.
> 
> One should never rely on something not documented in the first place.

Option 3 prevents existing mount-option compression level specifications
from working when the attribute agress with the mount option; otherwise,
they would be blocked by a btrfs.compression string that doesn't specify
a level.  That's a _regression_.

The current behavior is documented all over the place, used in scripts,
etc.  The top two from Google:

    https://wiki.tnonline.net/w/Btrfs/Compression
    https://fedoraproject.org/wiki/Changes/BtrfsTransparentCompression#Q:_If_I_use_'btrfs_property'_to_set_compression,_what_level_is_used_for_zstd?

followed by dozens of posts on forums and reddit, as users discover
how it works by experimentation or reading the kernel code.

The Fedora link is interesting because it describes two opposite
behaviors: once in prose and once in a code example (the code example
is correct, the prose is wrong).

One notably missing reference is the btrfs documentation itself:

    https://btrfs.readthedocs.io/en/latest/ch-mount-options.html
    https://btrfs.readthedocs.io/en/latest/Compression.html

Neither of these completely describe the current behavior, other than
to say that if the level is specified in btrfs.compression, it will be
implemented one day.  That statement is not inconsistent with option 2,
since attributes with level specifications don't need to consider any
of the options, and the statement doesn't say what happens when the
level isn't specified in the attribute.

Documented or not, it's been _established_ behavior for over a decade.
At this point, documentation that contradicts the status quo is wrong,
and should be corrected--as long as the status quo makes sense, which
it currently does.

There does seem to be a use case for having "zstd" continuing to
mean "defer to the mount option for level"--otherwise, to be able to
dynamically change the compress level (e.g. to reduce it under load, and
raise it during maintenance windows), one has to change every inode's
level individually.  This has obvious problems with snapshots that the
current arrangement doesn't have.

> We're to make it more clear, not making some undocumented BS to be the
> common case.
> 
> > 
> > > Thanks,
> > > Qu
> > > 
> > > > 
> > > > Option 2) is probably the best compromise between breaking existing
> > > > scripts and the behaviour making sense, plus it shouldn't change the
> > > > chattr +c behaviour, since btrfs takes the algorithm from compress=.
> > > > 
> > > > Thanks.
> > > > 
> > > > Best,
> > > > koraynilay
> > > 
> > > 
> 
> 
