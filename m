From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read implementation.
Date: Tue, 23 Mar 2010 17:44:37 -0400
Message-ID: <4BA93645.3060901@gmail.com>
References: <4BA6E563.4090206@gmail.com> <87sk7r60zw.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87sk7r60zw.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:

> One thing that stroke me while reading is that, except for the out of line no data
> checksum case, this isn't real classical zero copy direct IO because
> you always have to copy through some buffer.

Uh no, unless I really messed up or don't understand what you mean.

Uncompressed data with no checksums only buffers on an error or EOF. 

With checksums enabled, uncompressed reads aligned on the 4k block
are classic direct IO to user memory except at EOF.

With checksums, unaligned reads still go direct to user memory, I
just have to read the extra head and tail to kernel buffers to
make the start and end 4k aligned.  This is efficient for large
reads but maybe not so efficient for small ones.

The special no-checksum EOF buffering is only for consistency, we
could choose to read the whole disk block like classic direct IO.

With checksums, unaligned reads < 4K always have some buffered part
for the (4k - user_length) so that may be what you mean.

> It's more like "uncached IO"
> 
> I was wondering that at least for those cases wouldn't it be simpler
> to use the normal page cache IO path and use new hints that disable
> prefetch/write-behind/caching in the page cache after the IO operation?

Maybe.

> Is there any particular reason this wasn't done? Was it because
> of aio?
> 
> I know the page cache currently doesn't support that today, but
> presumably it wouldn't be too hard to add.

The only reason I did not do something like that is:
1) I did not want to disturb the page cache with throw-away pages.
2) "uncached IO" makes it even less like classic direct IO.
3) Writing that page cache code might not be simpler.

As further argument against "uncached IO", Chris sent a very simple
patch up to read into page cache then purge it for btrfs direct IO
reads and it was NACKed.
 
> I guess the code would be much simpler if it only did the no checksum
> case.

yes, yes, yes :)

jim
