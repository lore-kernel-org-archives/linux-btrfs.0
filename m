From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read implementation.
Date: Tue, 23 Mar 2010 06:49:39 +0100
Message-ID: <87sk7r60zw.fsf@basil.nowhere.org>
References: <4BA6E563.4090206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA6E563.4090206@gmail.com> (jim owens's message of "Sun, 21 Mar 2010 23:34:59 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

jim owens <owens6336@gmail.com> writes:

Hi Jim,

I read through large chunks of that patch. I don't claim to fully
understand all the btrfs infrastructure details enough, so it wasn't
really serious code review.

One thing that stroke me while reading is that, except for the out of line no data
checksum case, this isn't real classical zero copy direct IO because
you always have to copy through some buffer.

It's more like "uncached IO"

I was wondering that at least for those cases wouldn't it be simpler
to use the normal page cache IO path and use new hints that disable
prefetch/write-behind/caching in the page cache after the IO operation?

Is there any particular reason this wasn't done? Was it because
of aio?

I know the page cache currently doesn't support that today, but
presumably it wouldn't be too hard to add.

I guess the code would be much simpler if it only did the no checksum
case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
