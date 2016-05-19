Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:39561 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbcESKLe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 06:11:34 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 092009B973
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 11:11:28 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id DD1825FB88
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 11:11:27 +0100 (BST)
Subject: Re: [Not TLS] Re: Reducing impact of periodic btrfs balance
To: linux-btrfs@vger.kernel.org
References: <573C6E47.2080109@cobb.uk.net>
 <d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
 <pan$549b5$526f9b98$5d8778de$5121c19f@cox.net>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <573D914F.8000305@cobb.uk.net>
Date: Thu, 19 May 2016 11:11:27 +0100
MIME-Version: 1.0
In-Reply-To: <pan$549b5$526f9b98$5d8778de$5121c19f@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/16 05:09, Duncan wrote:
> So to Graham, are these 1.5K snapshots all of the same subvolume, or 
> split into snapshots of several subvolumes?  If it's all of the same 
> subvolume or of only 2-3 subvolumes, you still have some work to do in 
> terms of getting down to recommended snapshot levels.  Also, if you have 
> quotas on and don't specifically need them, try turning them off and see 
> if that alone makes it workable.

I have just under 20 subvolumes but the snapshots are only taken if
something has changed (actually I use btrbk: I am not sure if it takes
the snapshot and then removes it if nothing changed or whether it knows
not to even take it).  The most frequently changing subvolumes have just
under 400 snapshots each.  I have played with snapshot retention and
think it unlikely I would want to reduce it further.

I have quotas turned off.  At least, I am not using quotas -- how can I
double check it is really turned off?

I know that very large numbers of snapshots are not recommended, and I
expected the balance to be slow.  I was quite prepared for it to take
many days.  My full backups take several days and even incrementals take
several hours. What I did not expect, and think is a MUCH more serious
problem, is that the balance prevented use of the disk, holding up all
writes to the disk for (quite literally) hours each.  I have not seen
that effect mentioned anywhere!

That means that for a large, busy data disk, it is impossible to do a
balance unless the server is taken down to single-user mode for the time
the balance takes (presumably still days).  I assume this would also
apply to doing a RAID rebuild (I am not using multiple disks at the moment).

At the moment I am still using my previous backup strategy, alongside
the snapshots (that is: rsync-based rsnapshots to another disk daily and
with fairly long retentions, and separate daily full/incremental backups
using dar to a nas in another building).  I was hoping the btrfs
snapshots might replace the daily rsync snapshots but it doesn't look
like that will work out.

Thanks to all for the replies.

Graham
