Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36817 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbcEQSDh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 14:03:37 -0400
Received: by mail-ig0-f172.google.com with SMTP id qe5so74857614igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 11:03:36 -0700 (PDT)
Subject: Re: Corrupted system due to imbalanced metadata chunks
To: Peter Kese <peter.kese@viidea.com>, linux-btrfs@vger.kernel.org
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4218ab2f-def8-6541-427d-49091f70e342@gmail.com>
Date: Tue, 17 May 2016 14:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-17 11:45, Peter Kese wrote:
> I've been using btrfs on my main system for a few months. I know btrfs
> is a little bit beta, but I thought not using any fancy features like
> quotas, snapshotting, raid, etc. would keep me on the safe side.
>
> Then I tried a software upgrade (Ubuntu 15.10 -> 16.04) and it turned
> out that while there was more than 100 GB (45%) of free disk space,
> the upgrade process broke down somewhere in the middle reporting IO
> errors and lack of free disk space.
>
> As I have learned later on, my problem was lack of available metadata
> blocks and a couple of tries at btrfs-balance remedied the space
> problem, but I nevertheless ended up with a broken Ubuntu distribution
> (there were broken packages and apt-get/dpkg hacking failed to fix the
> problem).
>
> So there wasn't any major data loss (apart from some .deb packages
> missing some files, my personal data is intact). But I'd still
> consider this a major loss, because I'll end up having to reinstall
> the whole system.
>
> Now here's what I think:
>  1) I may have been a bit unfortunate to experience this particular
> issue but there's a large audience of people who might get bitten as
> well,
>  2) I find it hard to blame it on Ubuntu's upgrade process, as it does
> check for free space availability before starting the upgrade,
The upgrade process is also naive and only checks what df says about 
free space.  It could stand to be taught to pay better attention and 
check repeatedly throughout the process.
>  3) A file system should not refuse to store files (during system
> upgrade or any other time), when there is 100 GB of free disk space
> available,
If you're checking just df, then that is by no means the full story.  In 
BTRFS and some other filesystems, df is advisory, not authoritative, and 
it doesn't provide any way to say things like 'you have a bunch of free 
space, but can only store lots of really small files right now', which 
is exactly the situation you were in.
>  4) Not anywhere in any btrfs documentation (not even in btrfs
> Gotchas) did I read any bold text saying *If installing btrfs, you
> should always keep an eye on free space for metadata and perform
> regular balances or otherwise you may corrupt your system.*
>
> And finally my question:
>
>  Is there a plan to detect such situation and perform an automatic
> inline rebalance rather than reporting out-of-disk-space when there's
> actually lots of free disk space available?
There are some things already in place to try and prevent this on recent 
kernels (for example, completely empty chunks are automatically 
deallocated), but it's not easy to solve completely without making 
performance absolutely horrible.  Installing large numbers of packages 
at once (like a distro upgrade) is a particularly bad case for this, 
because most package managers unpack to a temporary location on-disk 
before copying the files in, and that tends to leave a lot of free space 
fragmentation within the chunks.  Ideally, this free space gets 
back-filled by new data, but that may not happen depending on numerous 
factors.

One thing I would suggest in the future though is to run a full balance 
just before doing the upgrade.  It's not very likely that just the 
upgrade was fully responsible for this, which would mean that the 
problem existed at least partially before the upgrade.  As such, running 
a full balance just before the upgrade should help prevent this from 
happening.
