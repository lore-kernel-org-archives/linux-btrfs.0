From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: NULL Pointer Dereference While Scrubbing
Date: Tue, 17 Jan 2012 10:35:15 -0600
Message-ID: <CAKcLGm-WbMm+RLu9DY1ggriCAWMM0mKNH650WdwfVEjb_cJYsg@mail.gmail.com>
References: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>
	<CAKcLGm-s_ZUGNGUaQysKG6=AyUvE-c+q199UiK2H7GU1ksXaEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm-s_ZUGNGUaQysKG6=AyUvE-c+q199UiK2H7GU1ksXaEA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 16, 2012 at 6:10 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Tue, Jan 3, 2012 at 11:35 AM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> I've recently run into a kernel "NULL pointer dereference" while
>> scrubbing a partition that had picked up error.
>>
>
> I'm no longer getting the NULL pointer panic on this partition.
>
> I'm running into a new BUG_ON() now resulting from a EFBIG error in
> btrfs_add_system_chunk(...) (in fs/btrfs/volumes.c).
>
> I'm not sure if it is still interesting to pursue this issue. =A0If I
> could reproduce the NULL Pointer panic, it might be worth tracking
> down. =A0But as it stands now, btrfs is handling the corruption as be=
st
> as it knows how.

I've been able to clear this BUG_ON() after applying Miao Xie's
"[PATCH] Btrfs: fix enospc error caused by wrong checks of the chunk"
on top of the rebased integration branch with a 3.2.1 kernel.

Btrfsck still shows the same inode errors 400 message, but I can
complete a balance of the filesystem without encountering a BUG_ON().
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
