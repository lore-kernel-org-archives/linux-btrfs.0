Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43470 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab2JLKG1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 06:06:27 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1950879lbo.19
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 03:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm8-FYv7CSZ+W9DKtL95fA3nt0Uv9xK77AvqqPeeefySsw@mail.gmail.com>
References: <CAKcLGm8-FYv7CSZ+W9DKtL95fA3nt0Uv9xK77AvqqPeeefySsw@mail.gmail.com>
Date: Fri, 12 Oct 2012 12:06:25 +0200
Message-ID: <CAOcd+r3stdeUUN=YJyMj3dgb5qYht5OaFvD-rJJmsqvNhfBV8A@mail.gmail.com>
Subject: Re: Two Issues with Btrfs Delayed Cleaner Process (linux-next)
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mitch,
for issue (1) I proposed a small patch here:
http://www.spinics.net/lists/linux-btrfs/msg19574.html
which resolves it for me. The problem is that there are subvolumes
that still exist in the root tree, but don't have their ROOT_BACKREF
entry anymore.

However, Miao's rework of the subvolume listing code was to improve
its scalability, which my quick patch somewhat breaks....So you can
try the patch meanwhile, but Miao will probably want to something
smarter...

Thanks,
Alex.



On Mon, Oct 8, 2012 at 7:41 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I've run across two issues with the delayed cleaner process running a
> kernel based on the 3.6.0 btrfs-next branch in Josef's git repository.
>
> (1)  I'm getting an error when trying to list my subvolumes whenever
> the cleaner thread is running:
>
> # btrfs su li /mnt/benchmark/
> ERROR: Failed to lookup path for root 0 - No such file or directory
>
> As long as the cleaner thread is idle, I can run this command without error.
>
> (2)  I ran into an issue on a slower x86 machine (AMD Athlon XP 2600+)
> where the cleaner thread literally required an hour to finish deleting
> a subvolume that contained the sources for a kernel I had previously
> built.
>
> The machine was responsive the whole time, and the cleaner thread
> never required much more than 5-10% of the CPU, leaving ample idle
> time.
>
> Interestingly, every attempt to replicate this behaviour resulted in
> the cleaner thread finishing in a few seconds.
>
> My first issue replicates every time the cleaner thread is running.
>
> I'll need to work on the second issue for a while to see if I can get
> it to replicate.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
