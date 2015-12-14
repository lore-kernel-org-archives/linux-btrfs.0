Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39857 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbbLNFtN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 00:49:13 -0500
Subject: Re: btrfs check inconsistency with raid1, part 1
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566E584B.5040104@cn.fujitsu.com>
Date: Mon, 14 Dec 2015 13:48:59 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2015/12/13 21:16 -0700:
> Part 1= What to do about it? This post.
> Part 2 = How I got here? I'm still working on the write up, so it's
> not yet posted.
>
> Summary:
>
> 2 dev (spinning rust) raid1 for data and metadata.
> kernel 4.2.6, btrfs-progs 4.2.2
>
> btrfs check with devid 1 and 2 present produces thousands of scary
> messages, e.g.
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000

Checked the full output.
The interesting part is, the calculated result is always E4E3BDB6, and 
wanted is always all 0.

I assume E4E3BDB6 is crc32 of all 0 data.


If there is a full disk dump, it will be much easier to find where the 
problem is.
But I'm a afraid it won't be possible.

At least, 'btrfs-debug-tree -t 2' should help to locate what's wrong 
with the bytenr in the warning.


The good news is, the fs seems to be OK without major problem.
As except the csum error, btrfsck doesn't give other error/warning.
>
> btrfs check with devid 1 or devid2 separate (the other is missing)
> produces no such scary messages at all, but instead messages e.g.
> failed to load free space cache for block group 357585387520
>
> a. This inconsistency is unexpected.
> b. the 'btrfs check' with combined devices gives no insight to the
> seriousness of "checksum verify failed" messages, or what the solution
> is.

I guess btrfsck did the wrong device assemble, but that's just my 
personal guess.
And since I can't reproduce in my test environment, it won't be easy to 
find the root cause.

> c. combined or separate+degraded, read-only mounts succeed with no
> errors in user space or dmesg; only normal mount messages happen. With
> both devs ro mounted, I was able to completely btrfs send/receive the
> most recent two ro snapshots comprising 100% (minus stale historical)
> data on the drive, with zero errors reported.
> d. no read-write mount attempt has happened since "the incident" which
> will be detailed in part 2.
>
>
> Details:
>
>
> The full devid1&2 btrfs check is long and not very interesting, so
> I've put that here:
> https://drive.google.com/open?id=0B_2Asp8DGjJ9Vjd0VlNYb09LVFU
>
> btrfs-show-super shows some differences, values denoted as
> devid1/devid2. If there's no split, those values are the same for both
> devids.
>
>
> generation        4924/4923
> root            714189258752/714188554240
> sys_array_size        129
> chunk_root_generation    4918
> root_level        1
> chunk_root        715141414912
> chunk_root_level    1
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        1500312748032
> bytes_used        537228206080
> sectorsize        4096
> nodesize        16384
> [snip]
> cache_generation    4924/4923
> uuid_tree_generation    4924/4923
> [snip]
> dev_item.total_bytes    750156374016
> dev_item.bytes_used    541199433728
>
> Perhaps useful, is at the time of "the incident" this volume was rw
> mounted, but was being used by a single process only: btrfs send. So
> it was used as a source. No writes, other than btrfs's own generation
> increment, were happening.
>
> So in theory, this should perhaps be the simplest case of "what do I
> do now?" and even makes me wonder if a normal rw mount should just fix
> this up: either btrfs uses generation 4924 and updates all changes
> from 4923 and 4924 automatically to devid2 so they are now in sync, or
> it automatically discards generation 4924 from devid1, so both devices
> are in sync.
>
> The workload, circumstances of "the incident", the general purpose of
> btrfs, and the likelihood a typical user would never have even become
> aware of "the incident" until much later than I did, makes me strongly
> feel like Btrfs should be able to completely recover from this, with
> just a rw mount and eventually the missync'd generations will
> autocorrect. But I don't know that. And I get essentially no advice
> from btrfs check results.
>
> So. What's the theory in this case? And then does it differ from reality?

Personally speaking, it may be a false alert from btrfsck.
So in this case, I can't provide much help.

If you're brave enough, mount it rw to see what will happen(although it 
may mount just OK).

Thanks,
Qu


