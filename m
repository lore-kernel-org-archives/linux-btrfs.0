From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: NULL Pointer Dereference While Scrubbing
Date: Mon, 16 Jan 2012 18:10:09 -0600
Message-ID: <CAKcLGm-s_ZUGNGUaQysKG6=AyUvE-c+q199UiK2H7GU1ksXaEA@mail.gmail.com>
References: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 3, 2012 at 11:35 AM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I've recently run into a kernel "NULL pointer dereference" while
> scrubbing a partition that had picked up error.
>

I'm no longer getting the NULL pointer panic on this partition.

I'm running into a new BUG_ON() now resulting from a EFBIG error in
btrfs_add_system_chunk(...) (in fs/btrfs/volumes.c).

I'm not sure if it is still interesting to pursue this issue.  If I
could reproduce the NULL Pointer panic, it might be worth tracking
down.  But as it stands now, btrfs is handling the corruption as best
as it knows how.
