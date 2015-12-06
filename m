Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35366 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbbLFVQY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 16:16:24 -0500
Received: by wmuu63 with SMTP id u63so118685759wmu.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 13:16:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56618E4A.2000905@gmail.com>
References: <CABXGCsMYdfSpZeUbWut1p542XA-L99iXM0Ero8tAFVhU9xhzkw@mail.gmail.com>
 <56618E4A.2000905@gmail.com>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Mon, 7 Dec 2015 02:16:08 +0500
Message-ID: <CABXGCsONoHDYX-deg=2s5xNsQ1XjrL=o1t4CbRJqEt=TR4y5Zw@mail.gmail.com>
Subject: Re: Very various speed of grep operation on btrfs partition
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-12-04 17:59 GMT+05:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> Well, what other things are accessing the filesystem at the same time? If
> you've got something like KDE running with the 'semantic desktop' stuff
> turned on, than that will seriously impact the performance of other things
> using that filesystem.
>
> The other thing to keep in mind, is that caching may be impacting things
> somewhat.  To really get a good idea of performance for something like this,
> you should run 'sync' followed by 'echo 3 > /proc/sys/vm/drop_caches'
> (you'll need to be root for the second one) prior to each run, and ideally
> have nothing else running on that filesystem.

Thanks for clarifying.

I was able to further clarify:

After resetting the cache on a clean machine after a reboot grep
operation was take:
real 2m54.549s
user 0m0.662s
sys 0m1.062s

After turning off the indexing service (tracker) result improved:
real 2m12.182s
user 0m0.657s
sys 0m1.021s


If the cache is not cleaned:
real 0m0.575s
user 0m0.467s
sys 0m0.108s


And the result is stable and all subsequent launches, even when the
indexing service is enabled.

A day later noticed that the effect of the cache is missing:
real 4m33.940s
user 0m0.862s
sys 0m1.711s


As I understand to solve my problem just need to do the cache is
always effective, even if memory occupied by other applications.

Is possible to specify minimal size of disk cache?

Pity that I can't do 'echo 3 > /proc/sys/vm/drop_caches' on Windows
machine. It be interesting how fast grep would be work without cache.

> On a separate note, if you're either running on a 64-bit system, or have
> less than about 2^31 files on the FS, inode_cache will slow things down.
> It's intended for stuff like mail spools where you have billions of files
> being created and deleted over a few weeks, and quickly use up the inode
> numbers.  On almost all systems, it will make things run slower, and
> possibly result in non-=deterministic filesystem performance like what you
> are seeing here.

Hmm, less than about 2^31 ? Maybe you mean more?

> Additionally, do you have some particular reason that you absolutely _need_
> nodatacow to be enabled for the FS?  It usually has no impact on
> performance, but it removes any kind of error correction for file data
> (checksums can't be used safely without COW semantics).  It probably has no
> direct impact on what you're seeing here, but it is something that really
> shouldn't be used in most cases at the filesystem level (it can be done on
> given subvolumes or directories, and that's the recommended way to do it if
> you don't want to go down to the per-file level).
>

I see that some issue with btrfs still not closed:
https://code.google.com/p/chromium/issues/detail?id=284738
And gnome-boxes still very slow when COW is enable.



--
Best Regards,
Mike Gavrilov.
