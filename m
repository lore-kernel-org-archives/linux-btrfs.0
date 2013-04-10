Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935753Ab3DJPPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 11:15:15 -0400
Date: Wed, 10 Apr 2013 17:15:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Lockdep warning on for-linus branch (umount vs. evict_inode)
Message-ID: <20130410151513.GN18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5165785B.7030407@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5165785B.7030407@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 10, 2013 at 04:34:03PM +0200, Jan Schmidt wrote:
> I was running fsstress to trigger a tree mod log problem on a current kernel
> with some custom debug patches applied, so if anyone looking at this needs any
> line numbers let me know:
> 
> <4>[ 1221.749586] [ INFO: possible circular locking dependency detected ]
> <4>[ 1221.749589] 3.8.0+ #9 Not tainted
> <4>[ 1221.749590] -------------------------------------------------------
> <4>[ 1221.749591] fsstress/3108 is trying to acquire lock:
> <4>[ 1221.749592]  (sb_internal){.+.+..}, at: [<ffffffffa0183cde>] start_transaction+0x2de/0x4f0 [btrfs]
> <4>[ 1221.749614] 
> <4>[ 1221.749614] but task is already holding lock:
> <4>[ 1221.749616]  (&fs_info->ordered_operations_mutex){+.+...}, at: [<ffffffffa019c089>] btrfs_wait_ordered_extents+0x49/0x270 [btrfs]

I've seen and reported this warning a few days ago on IRC, Josef sent me
some patches to test, but it's not fixed yet.

david
