Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEB41A76BB
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 00:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086331; cv=none; b=IbCGCnVkIg22NCEaTw4vqYV5dsk1x0jPBscuax9zEUIFscyXqvTQwOqJOlPor8h0vaYPlWQm9TuDoYpJpNI92vk7b4J6a0LbwSUu2bCntHOnyj87oJsCTou6tvposTSOohESuFQzWRu1pd3aGu6mO0oUyTQRAKm1+LRb8mP3KnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086331; c=relaxed/simple;
	bh=CzDpYsm9HEoBvzQqb50oTw4XjINkwZaIKvmkCJnjOkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfrH0iwK73P1oitASwZt4s8wxopYpiQxbetro/7su9gfIQ7yHkMj02bUrWDVoh/M9qAgQXq1IcD72yowC3+6UthKjhTGkWmQYDhfby5EO6JNza1syffSP5rjhDkC2AsRtHDQAvmDlIesJZqSOCwINQe13k3LNkjqIETArVHRf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=NX2B8uXU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=arSVOFdD; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="NX2B8uXU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="arSVOFdD"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1BA507A0067;
	Thu, 10 Sep 2026 20:25:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 10 Sep 2026 20:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789086328;
	 x=1789172728; bh=MStD7nD+oVQyPy1wilBDSuSELRqeEopPaycUdqqWZgU=; b=
	NX2B8uXUtBZtNDjwHY1wYtvabp2bu3jQBqCZnJkrc3CcG8zzm6X900LA6km8vtkz
	kNI3XDEmLzCbTcNGgqS5RvzCdd0IXJbSRjO1yZQmqj4i4Msh1+6HR/0yYb4ayVKR
	9HZvPgyh6/NQjPZlyboGD1JmszTKlG9/CpPM8JsIWaC/TYKPHOY1tbmxdqmyH5dw
	AZ4pN7S1jaJpgH+D239BSR0Vg+LIUhxmE8jyai+QncM6leUVRFfuaW1Un2/7XaIr
	G4wTysF7hOAXWFvyRQAdAIAne5MYPgkAIgWhqZFeVaGsOvCTxhTeWTwVKzBJX9wp
	v/ZGKfh1bfjkwFpmSVvZEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789086328; x=
	1789172728; bh=MStD7nD+oVQyPy1wilBDSuSELRqeEopPaycUdqqWZgU=; b=a
	rSVOFdD4Y5nlPBwceZ+ZTM9OjjwtBMOoBfEZ6qJKdjvN02DFKxFwmKjdnMqz6bUc
	aC7yuPrg8jQiG94BZxVZuoch9px2JryP+nTbh2YnfirtYMuJjiRobaZg28hYdcio
	pKbYdGPJ6e3BrXzV0Pp7obcYCBah4Y3haNYlyPKy3zwVIWqckkBCPn5jeZt81xtr
	NjcRP0ovB17PQzAWC/jLTVqt8dYTTQbrPtrLRVnl2W43GyygcVmFMWCekWMMp2HQ
	KBfoMRA2M2rADc7wdrB2UhxuXpgJV7TTra2SH7DgHgXouYCGOS8ivb/JmynefkGq
	QLS2qmlCmZotL1aVWyUKQ==
X-ME-Sender: <xms:eEqjav50sVn3LHEPn3fjI8czI01IYbnWjnchguvcKn3WvhJ75E5ucw>
    <xme:eEqjasX7pG_f96n0rFUGRj7GP_NjhDMgFuWMoeNqOBOUn91kdXHh09wSd28pF51GQ
    70eEV7VgfB7LbQ-A9x7Pi51UVKUpR4kIi6JFjZ3qYtXnIWixWWjSL1q>
X-ME-Received: <xmr:eEqjaj05jOdhiW-TkPKYXL4Zo9c04lO8g1xrfK3myHh9CgdrXiZzC8s>
X-ME-Proxy-Cause: dmFkZTED9KAyJgFZegozdrwZtWFCAAXrhxh5DrX87CweISz0meMR58SrthUFeR0KcfqgS+
    Rr5ZPxVgE9Fcx33dAn5gcTg+Fj1clJyWcqiVmA0iUZ1Wnm8j2hOVDA/YldgtWiEU4RWU5R
    nDj1xS50Oaeujcdn+HLAnnqpHqoCF+j+HjMxHDgoyKKbPiVQ9ffBrB6Cbh6ypK5oQl/6XS
    /xOJqJrlZATjxV+DyYsWTyszOCny5w53cOKrHu0+tgKlUxKlHsmrlU+ygejOU+DpRNiesR
    pKA4O1TQ0lUNa4Ym93CxgDTgC8ZkqPMGA82iRVRiGw+jLsbOmftt+BUs8bryd2fjwIAyt/
    22XyzI2sydKwLUMMCVrgJVBjpcfYRKSAZOrW13l2+GjnsYlJXc7NpIAoHV0//RtnujJYre
    UxD35iuGBmThgh1llU5y3MMvlUA3I5JOjAVFU2SYVVOhPQ0xMpOigA3IiAht5ItsD+mUV7
    ZL/BP/NuqjCdPqBkE7xVldWV5BkldTW+9tKiJR4mFQUdZ7yG55uZzJ//dFEpMyVQ6qLSRH
    fmmGLzLIX78onP2zXwmw523MV8gwn+C2izBZPXfJyZ5+eUXS/vXA8VxEI8SD0GZbr6N0W+
    TqBcBDXmOxz+klWgyIXDLVBgQ7YgvCPFVVaP8vFRFH2neQQRdOtRkdmRrZTQ
X-ME-Proxy: <xmx:eEqjap2wJyVPp81_GnVqifw-heA9DaHCLLndH6dZnpeafWwcGnWWFw>
    <xmx:eEqjam-8sNuMTGRopl-isY77IfRFjcQpm6r8VQrOc3bfuQZXstgAjQ>
    <xmx:eEqjam12cVbPT6kIepYBg_QxaWgbSVP6IyhhPvL12LHuSjzNdLRs-A>
    <xmx:eEqjaj9kBN8CAkrqUcAjJxFy6XMOWqXMozp2UeUqasYmZvak16w2YQ>
    <xmx:eEqjai0Rd-p9s0T858YzteZPjksFMyDDAjsZ9dUWHgeL1uQGq-y5i0Ju>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 20:25:28 -0400 (EDT)
Date: Thu, 10 Sep 2026 17:25:53 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: downgrade the reflink source inode lock
Message-ID: <20260911002553.GA1910533@zen.localdomain>
References: <65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris@bur.io>
 <CAL3q7H5hG8MKbf4O5LhUJxg38BToPuOY69gjfc2tQdeUM5PYjA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H5hG8MKbf4O5LhUJxg38BToPuOY69gjfc2tQdeUM5PYjA@mail.gmail.com>

On Thu, Sep 10, 2026 at 03:31:57PM +0100, Filipe Manana wrote:
> On Wed, Sep 9, 2026 at 8:54 PM Boris Burkov <boris@bur.io> wrote:
> >
> > When doing a reflink, we are not writing to the src inode or modifying
> > it in any way, so it is counter-intuitive to have to lock it
> > exclusively. This has the cost of blocking other shared lock users of
> > the src file for the duration of all the writeback and reflinking.
> >
> > One sort of counter-intuitive exception is that dio writes that come in
> > under EOF try to take inode->i_rwsem shared, which would result in
> > messed up views of the extents in the reflinked file. Therefore, add
> > "being used as a reflink src" as another inode flag exception for the
> > dio write shared tests that already exist to check for other dangerous
> > conditions. In order to ensure that this flag is visible to the dio
> > writer, reflink must first take i_rwsem exclusive, then set the flag,
> > then downgrade to shared.
> >
> > I tested this with a concurrent reader on a 4G dirty source file
> > concurrent with a reflink and saw the read operation go from a ~1s
> > latency to milliseconds.
> 
> You mean a direct IO read operation happening in parallel with a
> reflink using the same file as a source right?
> And reflinking the entire file?
> 
> Because we only take the VFS lock (rwsem in struct inode) for direct IO reads.
> 
> However during reads (both direct IO and buffered) we always lock the
> extent range in the inode's extent io tree, and the reflink also locks
> the range.

I believe that as of your patch
5d6f0e9890ed ("btrfs: stop locking the source extent range during reflink")
we don't lock the src extent range, so dio reads of the src should not
contend with reflink on that. I only see btrfs_clone_files() locking
the dst inode range by inspection as well. Am I missing something else?

> So taking the rwsem in shared mode won't help much unless we are not
> reflinking the whole file and direct IO reads happen on a different
> range.
> I think that should be explicit in the change log.
> 
> 
> >
> > Note: if a writer arrives mid-clone it queues on the rwsem and later
> > readers will block behind it due to the rwsem fairness implementation.
> > Therefore this change does not rule out all possible reader blocking.
> 
> There is also an issue pointed out by sashiko that seems valid to me:
> 
> https://sashiko.dev/#/patchset/65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris%40bur.io
> 
> As every direct IO read and write increment i_dio_count with a call to
> inode_dio_begin() in iomap.
> 
> Thanks.
> 

