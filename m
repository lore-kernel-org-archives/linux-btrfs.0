Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab3JDWJb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Oct 2013 18:09:31 -0400
Date: Fri, 4 Oct 2013 15:09:28 -0700
From: Zach Brown <zab@redhat.com>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Simplify the logic in alloc_extent_buffer() for
 existing extent buffer case
Message-ID: <20131004220928.GE25712@lenny.home.zabbo.net>
References: <1380916529.22521.122.camel@chandra-dt.ibm.com>
 <20131004213814.GC25712@lenny.home.zabbo.net>
 <1380924026.22521.141.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380924026.22521.141.camel@chandra-dt.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > > +struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
> > > +					 u64 start, unsigned long len)
> > 
> > len isn't used.
> 
> Thought about removing the unused argument. But didn't know all the
> history behind why it was there in the first place. So, didn't bother
> it.
> 
> You think I should remove it.

Yeah, I would remove it.  Leave the tiny job of adding it to whoever
needs it in the future.  Until then we don't need the noise.

> How does this commit message sound:

Yup, seems fine to me.

Reviewed-by: Zach Brown <zab@redhat.com>

- z
