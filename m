Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692A736A37E;
	Fri, 21 Aug 2026 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787328458; cv=none; b=b/lXv0bg3INfHZaGM9/o7y7EIwMkBf57TE97nQQ1oAAT5SXyIoa+nvPokAQN/O6Ly8BowK5EyGRaHIcml7FeFEF34pSgpXXwsznnGf9AWtOZpVcM+N6OsTkcUfnH87eQWQ6MGTgkV+BebRB104dLn7nFidk2HuvDwsXPzp+7fMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787328458; c=relaxed/simple;
	bh=hu2EuQi3O1U0NVE3JAsp3PlZXH5sAd5GXRgTLfAmxys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqEis5HoihFK1UW0DfncL80cgpo7y3UE6Z5oLatHUPFYSe6pghhAhQitBXGoUDuwtMQAgndhN2ys2rhXO0W8UFelMArM6FO1IrNDFJFCrDql3OzL6EVPQoZjAcQhHxp+UA5vpku6AQfEfb6tRI+kviT5wgP25xYruNFSkYwMSy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=tVoubcx2; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="tVoubcx2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=5UiZnvCnxPJ4A5JsUpA0UPmyeavl+DHNrDKIttVzZBE=; b=tVoubcx2sa8vfW7la9ik/a2IVt
	FAACyelQ/Wuy7fKk6oPRLBY4m8eMMz2tuYhj0Z3jt5meRh1Qxv+YLcJiUje/sBB1dISP7F8+DChHg
	9OAiPbeqst0jCJG6AjxEc/tjB03f1Gue9vqUEgu08K3eB0qmyUbgH+ToaHRwHJ7GmCiNhXMw4f5dL
	XSPDGzrcHAsVgav+dLoeSbTHDxvITjezcXYGoLii3UvEhZp6jQN4o/00xk2kk3DtWbjpi/2mEpUBT
	jh8rTRvgtbCqYYHvf18B3IgzV50cw+xA1L9pcGooqMDIYxXETkkk67T0y0L1ovC8POlCWwQYEoDRu
	YTiCKNkA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxRmC-00BSM8-0e;
	Fri, 21 Aug 2026 16:07:28 +0000
Date: Fri, 21 Aug 2026 09:07:23 -0700
From: Breno Leitao <leitao@debian.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	fdmanana@suse.com, boris@bur.io, wqu@suse.com, layton@kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] btrfs: skip the extent map tree lock for inodes without
 extent maps
Message-ID: <aohiK3N9IVncuRbI@gmail.com>
References: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
 <CAL3q7H4MW6AXhz=EnEawJNU_OEFVqdeXUaivY30cb1Lqxeqdfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H4MW6AXhz=EnEawJNU_OEFVqdeXUaivY30cb1Lqxeqdfg@mail.gmail.com>
X-Debian-User: leitao

Hello Filipe,

On Fri, Aug 21, 2026 at 12:17:26PM +0100, Filipe Manana wrote:
> On Fri, Aug 21, 2026 at 11:39 AM Breno Leitao <leitao@debian.org> wrote:
> > +               if (!READ_ONCE(tree->root.rb_node))
> 
> Please use the proper rbtree api to check if a tree is empty:
> 
> RB_EMPTY_ROOT(&tree->root)
> 
> That's a lot more elegant and hides the use of READ_ONCE().
> 
> But really when there are harmless races, I like to see an explicit
> data_race() annotation and a comment about why the race is harmless.
> 
> Nevertheless, first, I would like to know how much the performance
> improvement was...

Sorry for not posting it earlier.

How I got into this: I've found while profiling arm64 production hosts
that had high system utilization and : _raw_write_trylock and xa_find
dominated, and the callchain pointed at find_first_inode_to_shrink()
locking every inode it walks.

Looking at the whole the Meta production fleet, the extent map shrinker
is ~0.35% of non-idle kernel CPU.  Within it, and attributing callees to
their caller, find_first_inode_to_shrink() is ~65% and the
write_trylock() it does is ~30% of the whole shrinker. Two thirds of
what the shrinker costs is looking for inodes that have anything to
shrink, and half of that is a lock we do not need to take.


micro benchmarks
================

I've hacked up a 6 GiB btrfs on a loop device, 100000 empty files
kept open, plus 200 1 MiB files created last, so they have the highest
inode numbers and every scan has to walk all the empty ones first.

Each round drops the page cache, re-reads the data files to recreate the
extent maps, then triggers the shrinker with "echo
2 > /proc/sys/vm/drop_caches". 15 rounds per run, arm64 (Neoverse V2),
8 CPUs, no lock debugging, cost of find_first_inode_to_shrink() from the
 ftrace function profiler:

  ns per inode walked, median of runs

                          base   patched    delta
    idle                  46.4      40.1   -13.6%
    4 concurrent readers  47.8      38.4   -19.7%

A separate build with CONFIG_LOCK_STAT, same test, for the extent map
tree rwlock.  Note the shrinker is not the only user of that lock, every
extent map insert and lookup takes it too, which is why the acquisition
count drops by two thirds rather than to nothing:

                              base   patched    delta
    write acquisitions      628016    228000   -63.7%
    hold time total (us)     47512     22717   -52.2%
    acq cacheline bounces     1574      1288   -18.2%

Does it help?

Thanks for the quick reply,
--breno

