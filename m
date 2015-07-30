Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55278 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbG3JJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 05:09:15 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: INFO: task btrfs-transacti:204 blocked for more than 120 seconds. (more like 8+min)
Date: Thu, 30 Jul 2015 19:09:11 +1000
Cc: linux-btrfs@vger.kernel.org
References: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com> <pan$c1082$a7d4ba34$a423d8b6$984e3578@cox.net>
In-Reply-To: <pan$c1082$a7d4ba34$a423d8b6$984e3578@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201507301909.11061.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 24 Jul 2015 11:11:22 AM Duncan wrote:
> The option is mem=nn[KMG].  You may also need memmap=, presumably
> memmap=nn[KMG]$ss[KMG], to reserve the unused memory area, preventing its
> use for PCI address space, since that would collide with the physical
> memory that's there but unused due to mem=.
> 
> That should let you test with mem=2G, so double-memory becomes 4G. =:^)

That's a good thing to note.

> Meanwhile, does bonnie do pre-allocation for its tests?

http://www.coker.com.au/bonnie++/readme.html

No.  The above URL gives details on the tests.

> > What I did see from years ago seemed to be that you'd have to disable
> > COW where you knew there would be large files.  I'm really hoping
> > there's a way to avoid this type of locking, because I don't think I'd
> > be comfortable knowing a non-root user could bomb the system with a
> > large file in the wrong area.
> 
> The problem with cow isn't large files in general, it's rewrites into the
> middle of them (as opposed to append-writes).  If the writes are
> sequential appends, or if it's write-one-read-many, cow on large files
> doesn't tend to be an issue.

The Bonnie++ rewrite test might be a pathological case for BTRFS.  But it's a 
test that other filesystems have handled for decades.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
