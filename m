Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:35351 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbcG3SuC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 14:50:02 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 7B54A9B991
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 19:49:57 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 59CAD5FBA0
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 19:49:57 +0100 (BST)
Subject: Re: Btrfs send to send out metadata and data separately
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
From: g.btrfs@cobb.uk.net
Message-ID: <579CF6D5.7030300@cobb.uk.net>
Date: Sat, 30 Jul 2016 19:49:57 +0100
MIME-Version: 1.0
In-Reply-To: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
Content-Type: text/plain; charset=gbk
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29/07/16 13:40, Qu Wenruo wrote:
> Cons:
> 1) Not full fs clone detection
>    Such clone detection is only inside the send snapshot.
> 
>    For case that one extent is referred only once in the send snapshot,
>    but also referred by source subvolume, then in the received
>    subvolume, it will be a new extent, but not a clone.
> 
>    Only extent that is referred twice by send snapshot, that extent
>    will be shared.
> 
>    (Although much better than disabling the whole clone detection)

Qu,

Does that mean that the following, extremely common, use of send would
be impacted?

Create many snapshots of a large and fairly busy sub-volume (say,
hourly) with few changes between each one. Send all the snapshots as
incremental sends to a second (backup) disk either as soon as they are
created, or maybe in bunches later.

With this change, would each of the snapshots require separate space
usage on the backup disk, with duplicates of unchanged files?  If so,
that would completely destroy the concept of keeping frequent snapshots
on a backup disk (and force us to keep the snapshots on the original
disk, causing **many** more problems with backref walks on the data disk).

(Does the answer change if we do non-incremental sends?)

I moved to this approach after the problems I had running balance on my
(very busy, and also large) data disk because of the number of snapshots
I was keeping on it.  My data disk has about 4TB in use, and I have just
bought a 10TB backup disk but I would need about 50 more of them if the
hourly snapshots were no longer sharing space! If that is the case, the
cure seems much worse than the disease.

Apologies if I have misunderstood the proposal.

