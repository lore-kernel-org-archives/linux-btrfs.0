From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Tue, 16 Nov 2010 08:38:13 -0500
Message-ID: <1289914577-sup-8535@think>
References: <1289618724.28645.1405062363@webmail.messagingengine.com> <20101116125445.GA3229@brong.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101116125445.GA3229@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bron Gondwana's message of 2010-11-16 07:54:45 -0500:
> Just posting this again more neatly formatted and just the
> 'meat':
> 
> a) program creates piles of small temporary files, hard
>    links them out to different directories, unlinks the
>    originals.
> 
> b) filesystem size: ~ 300Gb (backed by hardware RAID5)
> 
> c) as the filesystem grows (currently about 30% full) 
>    the unlink performance becomes horrible.  Watching
>    iostat, there's a lot of reading going on as well.
> 
> Is this expected?  Is there anything we can do about it?
> (short of rewrite Cyrus replication)

Hi,

It sounds like the unlink speed is limited by the reading, and the reads
are coming from one of two places.  We're either reading to cache cold
block groups or we're reading to find the directory entries.

Could you sysrq-w while the performance is bad?  That would narrow it
down.

Josef has the reads for caching block groups fixed, but we'll have to
look hard at the reads for the rest of unlink.

-chris
