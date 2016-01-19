Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32869 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbcASM3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 07:29:49 -0500
Received: by mail-io0-f172.google.com with SMTP id q21so579148603iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 04:29:49 -0800 (PST)
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <loom.20160116T132316-196@post.gmane.org>
 <569C41B1.1090206@cn.fujitsu.com>
 <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
 <569C58FB.70407@cn.fujitsu.com> <pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net>
 <569CDF0D.9030609@gmail.com> <pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
 <pan$85c04$d9fd4f4d$1304efda$85c18be@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <569E2BFC.8080107@gmail.com>
Date: Tue, 19 Jan 2016 07:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <pan$85c04$d9fd4f4d$1304efda$85c18be@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-19 04:14, Duncan wrote:
> Oh, I also don't allow any crazy indexers, like kde's baloo or the older
> updatedb for (s)locate, to go crazy indexing everything, thereby wasting
> valuable cache memory on files I won't actually be using.  These things
> get shut down as soon as I discover new ones, and preferably get
> uninstalled, with dependencies on them turned off (on gentoo, via
> appropriate USE flag) as well.  On kde4 I was even carrying my own no-
> semantic-desktop patches for awhile, when gentoo/kde decided they weren't
> going to support kde without semantic-desktop.  Fortunately they changed
> their minds.  I'm now finally updated to kde-frameworks5 with plasma5,
> and have baloo installed for that as I don't yet grok how to keep it off
> the system entirely in frameworks/plasma5, but it's definitely shut down
> as far as runtime goes.
There's a reason I don't use KDE...
(Well, a couple actually, the indexing getting pulled in is only part of 
it, I also dislike the all-or-nothing packaging (everything seems to 
depend on everything else), and having to update the whole thing in 
lock-step; somewhat ironically, GNOME has the same issues these days, so 
I don't use that either).

That aside, it's probably worth noting that updatedb used by 
{,m,s}locate only indexes metadata, and it does so a lot more 
efficiently than most of the desktop search-engine indexers out there, 
so it's not quite as bad as baloo or tracker or some of the other 
options.  Unlike those, updatedb pretty much just calls stat on 
everything it's told to index, which takes time, but is not particularly 
bad for your cache if you're just running it on your home directory.
>
> There is a package indexer that runs, and of course syncing package
> updates loads all that in cache, but all that's on my packages partition,
> unmounted when I'm not actively doing package updates, etc, thereby
> freeing the package updates subsystem caches.
For those who might be interested, autofs is wonderful for handling 
stuff like this.

