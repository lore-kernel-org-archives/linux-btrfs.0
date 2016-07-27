Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33983 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbcG0RTE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 13:19:04 -0400
Received: by mail-qk0-f174.google.com with SMTP id o67so40277606qke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 10:19:02 -0700 (PDT)
MIME-Version: 1.0
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Wed, 27 Jul 2016 13:19:01 -0400
Message-ID: <CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>
Subject: Re: btrfs fi defrag does not defrag files >256kB?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <pan$acc$75dc71b8$532c7a5c$47aab598@cox.net>

On 26 July 2016 at 21:10, Duncan <1i5t5.duncan@cox.net> wrote:
> Nicholas D Steeves posted on Tue, 26 Jul 2016 19:03:53 -0400 as excerpted:
>
>> Hi,
>>
>> I've been using btrfs fi defrag with out the "-r -t 32M" option for
>> regular maintenance.  I just learned, in
>> Documentation/btrfs-convert.asciidoc, that there is a recommendation
>> to run with "-t 32M" after a conversion from ext2/3/4.  I then
>> cross-referenced this with btrfs-filesystem(8), and found that:
>>
>>     Extents bigger than value given by -t will be skipped, otherwise
>>     this value is used as a target extent size, but is only advisory
>>     and may not be reached if the free space is too fragmented. Use 0
>>     to take the kernel default, which is 256kB but may change in the
>>     future.
>>
>> I understand the default behaviour of target extent size of 256kB to
>> mean only defragment small files and metadata.  Or does this mean that
>> the default behaviour is to defragment extent tree metadata >256kB,
>> and then defragment the (larger than 256kB) data from many extents
>> into a single extent?  I was surprised to read this!
>>
>> What's really happening with this default behaviour?  Should everyone
>> be using -t with a much larger value to actually defragment their
>> databases?
>
> Something about defrag's -t option should really be in the FAQ, as it is
> known to be somewhat confusing and to come up from time to time, tho this
> is the first time I've seen it in the context of convert.
>
> In general, you are correct in that the larger the value given to -t, the
> more defragging you should ultimately get.  There's a practical upper
> limit, however, the data chunk size, which is nominally 1 GiB (tho on
> tiny btrfs it's smaller and on TB-scale it can be larger, to 8 or 10 GiB
> IIRC).  32-bit btrfs-progs defrag also had a bug at one point that would
> (IIRC) kill the parameter if it was set to 2+ GiB -- that has been fixed
> by hard-coding the 32-bit max to 1 GiB, I believe.  The bug didn't affect
> 64-bit.  In any case, 1 GiB is fine, and often the largest btrfs can do
> anyway, due as I said to that being the normal data chunk size.
>
> And btrfs defrag only deals with data.  There's no metadata defrag, tho
> balance -m (or whole filesystem) will normally consolidate the metadata
> into the fewest (nominally 256 MiB) metadata chunks possible as it
> rewrites them.

Thank you for this metadata consolidation tip!

> In that regard a defrag -t 32M recommendation is reasonable for a
> converted filesystem, tho you can certainly go larger... to 1 GiB as I
> said.
>

I only mentioned btrfs-convert.asciidoc, because that's what led me to
the discrepancy between the default target extent size value, and a
recommended value.  I was searching for everything I could find on
defrag, because I had begun to suspect that it wasn't functioning as
expected.

Is there any reason why defrag without -t cannot detect and default to
the data chunk size, or why it does not default to 1 GiB?  In the same
way that balance's default behaviour is a full balance, shouldn't
defrag's default behaviour defrag whole chunks?  Does it not default
to 1 GiB because that would increase the number of cases where defrag
unreflinks and duplicates files--leading to an ENOSPC?

https://github.com/kdave/btrfsmaintenance/blob/master/btrfs-defrag.sh
uses -t 32M ; if a default target extent size of 1GiB is too radical,
why not set it it 32M?  If SLED ships btrfsmaintenance, then defrag -t
32M should be well-tested, no?

Thank you,
Nicholas
