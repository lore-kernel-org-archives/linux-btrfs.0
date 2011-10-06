From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v0 07/18] btrfs: generic data structure to build unique lists
Date: Thu, 06 Oct 2011 13:33:00 -0700
Message-ID: <m2y5wx3loj.fsf@firstfloor.org>
References: <cover.1317915010.git.sensille@gmx.net>
	<3a697c3e44dd5955c167f2f548ee4ced1e3dabef.1317915010.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a697c3e44dd5955c167f2f548ee4ced1e3dabef.1317915010.git.sensille@gmx.net>
	(Arne Jansen's message of "Thu, 6 Oct 2011 17:54:17 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen <sensille@gmx.net> writes:

> ulist is a generic data structures to hold a collection of unique u64
> values. The only operations it supports is adding to the list and
> enumerating it.
> It is possible to store an auxiliary value along with the key.
> The implementation is preliminary and can probably be sped up
> significantly.
> It is used by subvolume quota to translate recursions into iterative
> loops.

Hmm, sounds like a job for lib/idr.c 

What do your ulists do that idr doesn't?
Ok idr doesn't have merge, but that should be simple
enough to add.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
