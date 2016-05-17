Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34683 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbcEQUG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 16:06:29 -0400
Received: by mail-oi0-f43.google.com with SMTP id k142so43451672oib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 13:06:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4218ab2f-def8-6541-427d-49091f70e342@gmail.com>
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
	<4218ab2f-def8-6541-427d-49091f70e342@gmail.com>
Date: Tue, 17 May 2016 14:06:28 -0600
Message-ID: <CAJCQCtRCFTEHoGxDMccJx7CLSPwLqSiqhd6--niCzrQ1FtJ+Bg@mail.gmail.com>
Subject: Re: Corrupted system due to imbalanced metadata chunks
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Peter Kese <peter.kese@viidea.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 12:03 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-05-17 11:45, Peter Kese wrote:
>>
>> I've been using btrfs on my main system for a few months. I know btrfs
>> is a little bit beta, but I thought not using any fancy features like
>> quotas, snapshotting, raid, etc. would keep me on the safe side.
>>
>> Then I tried a software upgrade (Ubuntu 15.10 -> 16.04) and it turned
>> out that while there was more than 100 GB (45%) of free disk space,
>> the upgrade process broke down somewhere in the middle reporting IO
>> errors and lack of free disk space.
>>
>> As I have learned later on, my problem was lack of available metadata
>> blocks and a couple of tries at btrfs-balance remedied the space
>> problem, but I nevertheless ended up with a broken Ubuntu distribution
>> (there were broken packages and apt-get/dpkg hacking failed to fix the
>> problem).
>>
>> So there wasn't any major data loss (apart from some .deb packages
>> missing some files, my personal data is intact). But I'd still
>> consider this a major loss, because I'll end up having to reinstall
>> the whole system.
>>
>> Now here's what I think:
>>  1) I may have been a bit unfortunate to experience this particular
>> issue but there's a large audience of people who might get bitten as
>> well,
>>  2) I find it hard to blame it on Ubuntu's upgrade process, as it does
>> check for free space availability before starting the upgrade,
>
> The upgrade process is also naive and only checks what df says about free
> space.  It could stand to be taught to pay better attention and check
> repeatedly throughout the process.

Yeah I don't know what the right design is to check for free space
that's fs agnostic. If only it were simple to do a fallocate for 3000
8KiB files and 4000 2MiB files and if either of those fails, don't
start the upgrade. It would have to be some kind of virtual fallocate,
I bet 7000 fallocates at once is not so fast.

>>
>>  3) A file system should not refuse to store files (during system
>> upgrade or any other time), when there is 100 GB of free disk space
>> available,
>
> If you're checking just df, then that is by no means the full story.  In
> BTRFS and some other filesystems, df is advisory, not authoritative, and it
> doesn't provide any way to say things like 'you have a bunch of free space,
> but can only store lots of really small files right now', which is exactly
> the situation you were in.

I *think* he was in the opposite where a bunch of near empty data
chunks were allocated and the metadata chunks were nearly full. So
actually a bunch of big files was no problem, but an OS upgrade tends
to leverage Btrfs inline data, which is probably why it ran out of
space. Just a guess.


>>
>>  4) Not anywhere in any btrfs documentation (not even in btrfs
>> Gotchas) did I read any bold text saying *If installing btrfs, you
>> should always keep an eye on free space for metadata and perform
>> regular balances or otherwise you may corrupt your system.*
>>
>> And finally my question:
>>
>>  Is there a plan to detect such situation and perform an automatic
>> inline rebalance rather than reporting out-of-disk-space when there's
>> actually lots of free disk space available?
>
> There are some things already in place to try and prevent this on recent
> kernels (for example, completely empty chunks are automatically
> deallocated), but it's not easy to solve completely without making
> performance absolutely horrible.  Installing large numbers of packages at
> once (like a distro upgrade) is a particularly bad case for this, because
> most package managers unpack to a temporary location on-disk before copying
> the files in, and that tends to leave a lot of free space fragmentation
> within the chunks.  Ideally, this free space gets back-filled by new data,
> but that may not happen depending on numerous factors.

Yeah there's all sorts of crusty behaviors in OS installers and
updaters on all platforms that really need to be refactored but that's
a lot of work for something that doesn't happen that often.


>
> One thing I would suggest in the future though is to run a full balance just
> before doing the upgrade.  It's not very likely that just the upgrade was
> fully responsible for this, which would mean that the problem existed at
> least partially before the upgrade.  As such, running a full balance just
> before the upgrade should help prevent this from happening.

In some sense maybe btrfs-progs should ship with an upstream
maintained version of opensuse's btrfsmaintenance-refresh.service?
That has gotten stale for example:

- snapshot aware defrag was pulled out of btrfs a while ago due to
problems, so I question the value and appropriateness of
btrfs-defrag.sh being run on a regular basis when opensuse uses
snapper by default, resulting in many dozens or hundreds of read only
snapshots in short order
- btrfs-trim.sh is obsoleted by systemd provided fstrim.timer, which
is enabled by
default, there's no good reason to run both of these;
- btrfs-balance.sh uses filters -dusage=0 and -musage=0 which is now
handled by the kernel, this should probably be something like
-dusage=5 and -musage=15 to consolidate extents from minimally used
chunks and then revert them to unallocated space.


Until such time there's an in-kernel fix for this...



-- 
Chris Murphy
