From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: NULL Pointer Dereference While Scrubbing
Date: Tue, 17 Jan 2012 17:41:09 +0100
Message-ID: <4F15A4A5.8040501@jan-o-sch.net>
References: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>	<CAKcLGm-s_ZUGNGUaQysKG6=AyUvE-c+q199UiK2H7GU1ksXaEA@mail.gmail.com> <CAKcLGm-WbMm+RLu9DY1ggriCAWMM0mKNH650WdwfVEjb_cJYsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm-WbMm+RLu9DY1ggriCAWMM0mKNH650WdwfVEjb_cJYsg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.01.2012 17:35, Mitch Harder wrote:
> I've been able to clear this BUG_ON() after applying Miao Xie's
> "[PATCH] Btrfs: fix enospc error caused by wrong checks of the chunk"
> on top of the rebased integration branch with a 3.2.1 kernel.
> 
> Btrfsck still shows the same inode errors 400 message, but I can
> complete a balance of the filesystem without encountering a BUG_ON().

Did you also try to scrub the device again (which I thought that's was
this thread is all about)?

However, I'm not sure whether it's worth investigating any further, as
the bug seems to be readahead-related which is presumably being replaced
soon.

-Jan
