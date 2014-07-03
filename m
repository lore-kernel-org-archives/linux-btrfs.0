Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaGCR53 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 13:57:29 -0400
Date: Thu, 3 Jul 2014 19:57:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Add superblock checksum check for btrfs-progs
Message-ID: <20140703175727.GK1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 05:36:34PM +0800, Qu Wenruo wrote:
> Before this patchset, btrfs-progs will overall ignore the superblock
> checksum and continue the routine.
> Sometimes this may cause disasters like checking a btrfs with corrupted
> superblock will lead to crash in btrfs-progs.
> 
> This patch introduces superblock checksum check into btrfs_read_dev_super(),
> making btrfs-progs much more restricted and robust.
> To allow super-recover to open devices, add options to scan all 3
> superblocks when using super-recover.
> Also updated the related error string and fix a bug in chunk-recover that
> will not be triggered until superblock csum is calculated.
> 
> Qu Wenruo (4):
>   btrfs-progs: Check superblock's checsum when read dev super
>   btrfs-progs: Allow btrfs_read_dev_super() to read all 3 super for    
>     super_recover.
>   btrfs-progs: Add more meaningful return value for
>     btrfs_read_dev_super()     and corresponding error string.
>   btrfs-progs: Fix size for malloc for superblock checksum.

Nice work. I've added 1, 2 and 4 it to integration. Please update the
patch 3 (printf/fprintf).
