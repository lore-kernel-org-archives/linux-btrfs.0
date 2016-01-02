Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33290 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbcABVTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 16:19:20 -0500
Received: by mail-lb0-f170.google.com with SMTP id sv6so136881460lbb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 13:19:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160102115318.4e76f773@hydra>
References: <pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
	<20160102115318.4e76f773@hydra>
Date: Sat, 2 Jan 2016 22:19:18 +0100
Message-ID: <CAPmG0jb1HF6Mnfi3ObqUfPHs4RNLCDvsnuncvX-=LGZazDHnYg@mail.gmail.com>
Subject: Re: Unrecoverable fs corruption?
From: Henk Slager <eye1tm@gmail.com>
To: Alexander Duscheleit <alexander.duscheleit@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[...]
> [13984.341838] BTRFS info (device sdc2): allowing degraded mounts
> [13984.341844] BTRFS info (device sdc2): disk space caching is enabled
> [13984.341846] BTRFS: has skinny extents
> [13984.538637] BTRFS critical (device sdc2): corrupt leaf, bad key
> order: block=6513625202688,root=1, slot=68 [13984.546327] BTRFS
> critical (device sdc2): corrupt leaf, bad key order:
> block=6513625202688,root=1, slot=68 [13984.552233] BTRFS: Failed to
> read block groups: -5 [13984.585375] BTRFS: open_ctree failed
> [13997.313514] BTRFS info (device sdb2): allowing degraded mounts
> [13997.313520] BTRFS info (device sdb2): disk space caching is enabled
> [13997.313522] BTRFS: has skinny extents [13997.522838] BTRFS critical
> (device sdb2): corrupt leaf, bad key order: block=6513625202688,root=1,
> slot=68 [13997.530175] BTRFS critical (device sdb2): corrupt leaf, bad
> key order: block=6513625202688,root=1, slot=68 [13997.538289] BTRFS:
> Failed to read block groups: -5 [13997.582019] BTRFS: open_ctree failed
>
>
>>
>> [...]
>>
>
> So I can't mount either disk as ro and I can't afford another drive
> to store the data.
>
> I can confirm that I can get at least a subset of the data off the
> drives via btrfs-restore. (In fact I already restored the only chunk of
> data that's newer than the old disk set AND not easily recreated, which
> makes the whole endeavour a bit less nerve-wracking.)
>
> As I see it, my best course of action right now is wiping one of the
> two disks and then using btrfs restore to copy the data off the other
> disk onto the now blank one. I'd expect to get back a large percentage
> of the inaccessible data that way. That is unless someone tells me
> there's an easy fix for the "corrupt leaf, bad key order" fault and
> I've been chasing ghosts the whole time.
I had once this error:
BTRFS critical (device sdf1): corrupt leaf, slot offset bad:
block=77130973184,root=1, slot=150

Not the same, but the 'corrupt leaf' part was due to memory module
bit-failures I had some time ago. At least I haven't seen these kind
of errors in other btrfs fs failure cases. I my case, no raid
profiles, and I could fix it with --repair.
It also might be that your 'corrupt leaf,...' error is caused by the
earlier --repair action, otherwise I wouldn't know from experience how
to fix it.

If you think btrfs raid (I/O)fault handling etc is not good enough
yet, instead of raid1, you might consider 2x single (dup for
metadata), with 1 the main/master fs and the other one the slave fs,
created by send | receive (incremental). If you scrub both on regular
basis, email or so the error cases, you can act if something is wrong.
And every now and then do a brute-force diff to verify that contents
of both filesystems (snapshots) are still the same.
