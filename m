Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:46480 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752103AbdDGX5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 19:57:08 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:36602)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cwdkY-002IQm-Al
        for linux-btrfs@vger.kernel.org; Sat, 08 Apr 2017 00:57:06 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cwdkM-0007KF-Ss
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Apr 2017 00:56:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22760.10054.539993.564874@tree.ty.sabi.co.uk>
Date: Sat, 8 Apr 2017 00:56:54 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent reason
In-Reply-To: <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
References: <572D0C8B.8010404@mendix.com>
        <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
        <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]
>>> I've got a mostly inactive btrfs filesystem inside a virtual
>>> machine somewhere that shows interesting behaviour: while no
>>> interesting disk activity is going on, btrfs keeps
>>> allocating new chunks, a GiB at a time.
[ ... ]
> Because the allocator keeps walking forward every file that is
> created and then removed leaves a blank spot behind.

That is a typical "log-structured" filesystem behaviour, not
really surprised that Btrfs is doing something like that being
COW. NILFS2 works like that and it requires a compactor (which
does the requivalent of 'balance' and 'defrag'). It is all about
tradeoffs.

With Btrfs I figured out that fairly frequent 'balance' is
really quite important, even with low percent values like
"usage=50", and usually even 'usage=90' does not take a long
time (while the default takes often a long time, I suspect
needlessly).

>> From the exact moment I did mount -o remount,nossd on this
>> filesystem, the problem vanished.

Haha. Indeed. So it switches from "COW" to more like "log
structured" with the 'ssd' option. F2FS can switch like that
too, with some tunables IIIRC. Except that modern flash SSDs
already do the "log structured" bit internally, so doing in in
Btrfs does not really help that much.

>> And even I saw some early prototypes inside the codes to
>> allow btrfs do allocation smaller extent than required.
>> (E.g. caller needs 2M extent, but btrfs returns 2 1M extents)

I am surprised that this is not already there, but it is a
terrible fix to a big mistake. The big mistake, that nearly all
filesystem designers do, is to assume that contiguous allocation
must bew done by writing contiguous large blocks or extents.

This big mistake was behind the stupid idea of the BSD FFS to
raise the block size from 512B to 4096B plus 512B "tails", and
endless stupid proposals to raise page and block sizes that get
done all the time, and is behind the stupid idea of doing
"delayed allocation", so large extents can be written in one go.

The ancient and tried and obvious idea is to preallocate space
ahead of it being written, so that a file physical size may be
larger than its logical length, and by how much it depends on
some adaptive logic, or hinting from the application (if the
file size if known in advance it can be to preallocate the whole
file).

> [ ... ] So, this is why putting your /var/log, /var/lib/mailman and
> /var/spool on btrfs is a terrible idea. [ ... ]

That is just the old "writing a file slowly" issue, and many if
not most filesystems have this issue:

  http://www.sabi.co.uk/blog/15-one.html?150203#150203

and as that post shows it was already reported for Btrfs here:

  http://kreijack.blogspot.co.uk/2014/06/btrfs-and-systemd-journal.html

> [ ... ] The fun thing is that this might work, but because of
> the pattern we end up with, a large write apparently fails
> (the files downloaded when doing apt-get update by daily cron)
> which causes a new chunk allocation. This is clearly visible
> in the videos. Directly after that, the new chunk gets filled
> with the same pattern, because the extent allocator now
> continues there and next day same thing happens again etc... [
> ... ]

The general problem is that filesystems have a very difficult
job especially on rotating media and cannot avoid large
important degenerate corner case by using any adaptive logic.

Only predictive logic can avoid them, and since psychic code is
not possible yet, "predictive" means hints from applications and
users, and application developers and users are usually not
going to give them, or give them wrong.

Consider the "slow writing" corner case, common to logging or
downloads, that you mention: the filesystem logic cannot do well
in the general case because it cannot predict how large the
final file will be, or what the rate of writing will be.

However if the applications or users hint the total final size
or at least a suitable allocation size things are going to be
good. But it is already difficult to expect applications to give
absolutely necessary 'fsync's, so explicit file size or access
pattern hints are a bit of an illusion. It is the ancient
'O_PONIES' issue in one of its many forms.

Fortunately it possible and even easy to do much better
*synthetic* hinting than most library and kernels do today:

  http://www.sabi.co.uk/blog/anno05-4th.html?051012d#051012d
  http://www.sabi.co.uk/blog/anno05-4th.html?051011b#051011b
  http://www.sabi.co.uk/blog/anno05-4th.html?051011#051011
  http://www.sabi.co.uk/blog/anno05-4th.html?051010#051010

But that has not happened because it is no developer's itch to
fix. I was instead partially impressed that recently the
'vm_cluster' implementation was "fixed", after only one or two
decades from being first reported:

  http://sabi.co.uk/blog/anno05-3rd.html?050923#050923
  https://lwn.net/Articles/716296/
  https://lkml.org/lkml/2001/1/30/160

And still the author(s) of the fix don't see to be persuaded by
many decades of research on paging that show that read-ahead on
fault is in the general case a stupid idea (at least for what
are called in Linux "anonymous" pages).

I have found over time that reports and discussions like this
are mostly pointless: some decades ago I pointed out to L McVoy
when he was a developer at Sun that tools like 'cp' and 'tar'
have *totally predictable* access patterns and (almost always)
file sizes are know in advance, so they could trivially do
access patterns hinting and preallocation. Yet it is decades
later and most such tools don't. "because can't be bothered to
read papers", "because boring", "because not my itch".
For another example someone has finally started looking into
writeback errors: https://lwn.net/Articles/718734/ that usually
don't get reported, but then how many developers check the
return code of 'close'(2)?
I wonder sometimes how M Stonebraker feels about having written
in "Operating System Support for Database Management" entirely
obvious things and it having been steadfastly ignored since 1981
by most kernel and filesystem authors.
