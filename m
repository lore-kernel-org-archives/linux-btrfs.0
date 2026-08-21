Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E71637A4AF;
	Fri, 21 Aug 2026 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330067; cv=none; b=M+V0GQWO47uF/Y0ZgbB2bAUMmjClKCNEb7YWRG1HAQqQ/mpE+L3XdbSJEK2c65OYrVdwl56NwqXTOSyRFl/j4OnDkobANs24XYby16MI9C+uS0j4ZMtH6LOeXBEv2OZRcTzjptmjsKizm/ttKgYyOrVz+XkJaGXJiJNJ+xXzY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330067; c=relaxed/simple;
	bh=O5m0OokGqQ9YpR10Tei56cJV/aNpibL19z11B/qqTuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgoqTXnAAuTsXhRKL7I74MB5AD2a3FbOtZCsHesblHpGzKWj3pXijDhpo3hyqKdXV+h+00axgPmdylUJ6KleZJuYHNiafBVH/xqkVK6JkjZBf3Ws9oiE88E2OrN2NC5rP4VTdZewhP6vu+oJSvD8ZLvW/Dt3OjcEBAMGj8mJ9bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=NsCoEnxa; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="NsCoEnxa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=nQHATPefjibSAukSjY2ojwTydu48Lw/JFyJxVMZfYxM=; b=NsCoEnxatKNr/lqXjosODQsKop
	DZ/VqNGNqjpHn2Xr7xZPd6hqDpfBHTe53sA/FdKPlQ8NaOtQnutmYylY+Q69VZJBvoCDgiG0m599Q
	XXQWmP7rgHnfWt/bPn1g5aOniWfhj3xy/PDOYY/Pwnyxvpx6ayRy5u9kyLE77bJz6T6qpM1ODgz9w
	ulxizgbmQHwD6B/MjAwGc0CCBCzGpX+2F7OWZEm2iYP2wKOLWqf8+SvS35shNE8fGx2FIHRhno7H9
	0d0BCv5p2rE7wKjS7V86Truzoy2MneVGBHlLCMa2g9YFkkByCiPDLrcYIX20Bsg+/Ns7Iai2Tt8Jy
	9yKNSbjA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxSCA-00BTOo-36;
	Fri, 21 Aug 2026 16:34:19 +0000
Date: Fri, 21 Aug 2026 09:34:14 -0700
From: Breno Leitao <leitao@debian.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	fdmanana@suse.com, boris@bur.io, layton@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] btrfs: skip the extent map tree lock for inodes without
 extent maps
Message-ID: <aoh6Hobk-wJ2ngDk@gmail.com>
References: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
 <a1eff18d-a630-4ea2-ac27-02c9252691d3@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1eff18d-a630-4ea2-ac27-02c9252691d3@suse.com>
X-Debian-User: leitao

Hello Qu,

On Fri, Aug 21, 2026 at 08:43:00PM +0930, Qu Wenruo wrote:
> 在 2026/8/21 20:08, Breno Leitao 写道:
> > The shrinker (find_first_inode_to_shrink()) takes inode->extent_tree.lock in write
> > mode on every inode it walks, only to find out whether that inode has
> > any extent maps.
> > 
> > Most have none, from what I understand, so, avoid the lock  by testing the
> > tree with a plain read before taking the lock. tree->root is only
> > modified with the tree lock held for write, so the unlocked read is
> > a benign race: a false negative just defers the inode to a later scan.
> > 
> > On my tests, find_first_inode_to_shrink() was a bit faster, so, if this
> > patch is correct, I think it is worth having to reduce lock contention.
> 
> How much faster?

Filipe has asked the same question, and I used that thread to reply,
let's use that thread for performance discussions.

> We are using write_trylock() already, meaning if it's not locked we should
> get the lock immediately, otherwise we skip the inode.

You are right that the shrinker itself never waits. But there are two
costs left that the trylock does not avoid:

1) Even uncontended, the atomic is not free.  write_trylock() is a
   cmpxchg that has to pull the extent_map_tree cache line in
   exclusive.

2) The trylock only protects the shrinker from waiting.  When it
   succeeds we do hold the lock, briefly, on an inode we are about to
   skip anyway, and anyone arriving in that window block

While my microbenchmark results in Filipe's answer might be skewed
toward this case, the fleet profiler shows find_first_inode_to_shrink()
is far from negligible in production.
