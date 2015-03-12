Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161025AbbCLReQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 13:34:16 -0400
Date: Thu, 12 Mar 2015 18:34:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
Message-ID: <20150312173414.GE20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
 <550127E1.4050606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <550127E1.4050606@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 12, 2015 at 01:45:05PM +0800, Qu Wenruo wrote:
> I sent such patch some time ago but was rejected by Chris,
> hopes this time it can be accepted.

http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34937.html

I'm OK with removing the special case now because there are additional
supreblock checks merged (3.19) that were motivated by your previous
attempt to remove it.

o btrfs: add more checks to btrfs_read_sys_array
o btrfs: cleanup, rename a few variables in btrfs_read_sys_array
o btrfs: add checks for sys_chunk_array sizes
o btrfs: more superblock checks, lower bounds on devices and sectorsize/nodesize


