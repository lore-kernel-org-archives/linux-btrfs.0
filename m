From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 00/12] btrfs core patches for direct I/O
Date: Wed, 06 Jan 2010 12:50:23 +0100
Message-ID: <87ocl7bgg0.fsf@basil.nowhere.org>
References: <4B425968.4020308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B425968.4020308@hp.com> (jim owens's message of "Mon, 04 Jan 2010 16:11:04 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

jim owens <jowens@hp.com> writes:

> The existing core code for pagecache
> doesn't work for directio because the existing I/O routines depend
> on peeking inside a struct page to get the valid btrfs inode info.
> Sorry, no can do, we don't own that page. And rewriting the whole
> pagecache I/O stack to eliminate dependence on struct page would
> be too scary IMO.

That would simply need another passed argument in a few strategic
places, won't it? I can't imagine it would need a full "rewrite"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
