From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Btrfs: potential NULL dereferences
Date: Sun, 06 Sep 2009 09:36:51 +0200
Message-ID: <874org5xt8.fsf@basil.nowhere.org>
References: <4A9BCD64.8010308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-btrfs@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A9BCD64.8010308@gmail.com> (Roel Kluin's message of "Mon, 31 Aug 2009 15:17:24 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Roel Kluin <roel.kluin@gmail.com> writes:

> Allocations may fail, prevent NULL dereferences.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> In several sections of fs/btrfs code a kmalloc() occurs without a
> check whether it succeeded. this potentially leads to dereferences
> of a NULL pointer. Are there reasons why we do not check the
> allocations? Did I choose an incorrect way to err out? please
> review.

Yes, the erroring out needs much more work because often
the callers don't handle errors and it can need quite a lot of surgery
Until that is done it's actually better to oops than to silently
leak resources. BUG_ON(name == NULL) is also fairly useless
because it oopses anyways in a obvious way.

I had some patches to add more error handling for ENOMEM, but it's
fairly complicated. Should probably resurrect my old patchkit. It
still wasn't fully complete.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
