Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:33874 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbbKULSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Nov 2015 06:18:25 -0500
Subject: Re: 4.2.6: livelock in recovery (free_reloc_roots)?
To: Duncan <1i5t5.duncan@cox.net>
References: <564EE213.3060007@lukas-pirl.de> <564FBCD1.1020009@lukas-pirl.de>
 <pan$3f62e$32bded6f$af93867e$b809a854@cox.net>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <565052F8.2080904@lukas-pirl.de>
Date: Sun, 22 Nov 2015 00:18:16 +1300
MIME-Version: 1.0
In-Reply-To: <pan$3f62e$32bded6f$af93867e$b809a854@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2015 08:16 PM, Duncan wrote as excerpted:
> Lukas Pirl posted on Sat, 21 Nov 2015 13:37:37 +1300 as excerpted:
> 
>> > Can "btrfs_recover_relocation" prevented from being run? I would not
>> > mind losing a few recent writes (what was a balance) but instead going
>> > rw again, so I can restart a balance.
> I'm not familiar with that thread name (I run multiple small btrfs on 
> ssds, so scrub, balance, etc, take only a few minutes at most), but if 

First, thank you Duncan for taking the time to hack in those broad
explanations.

I am not sure if this name also corresponds to a thread name, but it is
for sure a function that appears in all the dumped traces when trying to
'mount -o recovery,degraded' the file system in question:

 [<ffffffffa030964d>] ? free_reloc_roots+0x1d/0x30 [btrfs]
 [<ffffffffa030f6e5>] ? merge_reloc_roots+0x165/0x220 [btrfs]
 [<ffffffffa0310343>] ? btrfs_recover_relocation+0x293/0x380 [btrfs]
 [<ffffffffa02bcaa2>] ? open_ctree+0x20d2/0x23b0 [btrfs]
 [<ffffffffa02933fb>] ? btrfs_mount+0x87b/0x990 [btrfs]

> it's the balance thread, then yes, there's a mount option that cancels a 
> running balance.  See the wiki page covering mount options.

Yes, the file system is mounted with '-o skip_balance'.
(Although the '-o recovery' might trigger relocations?!)

>> > From what I have read, btrfs-zero-log would not help in this case (?) so
>> > I did not run it so far.
> Correct.  Btrfs is atomic at commit time, so doesn't need a journal in 
> the sense of older filesystems like reiserfs, jfs and ext3/4.
> …
> Otherwise, it generally does no good, and while 
> it generally does no serious harm beyond the loss of a few seconds worth 
> of fsyncs, etc, either, because the commits /are/ atomic and zeroing the 
> log simply returns the system to the state of such a commit, it's not 
> recommended as it /does/ needlessly kill the log of those last few 
> seconds of fsyncs.

So I see that it does no good but no serious harm (generally). Since it
is related to writes (not relocations, I assume) clearing the log is
unlikely to fix the problem with btrfs_recover_relocation or
merge_reloc_roots, respectively.

Maybe a dev helps us and shines some light in the (I assume) impossible
relocation issue.

Best,

Lukas
