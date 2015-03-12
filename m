Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbbCLRZP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 13:25:15 -0400
Date: Thu, 12 Mar 2015 18:25:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
Message-ID: <20150312172513.GD20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 12, 2015 at 01:40:47PM +0800, Liu Bo wrote:
> This reverts commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007.
> 
> This was used to make sure that a fresh btrfs from an older mkfs.btrfs,
> and it also allows us to mount a buggy btrfs if this btrfs has the right
> superblock head part but has something wrong with chunk tree part[1], and
> after that we can hit BUG_ON()s set in the code to prevent something
> impossible.
> 
> Since David has gave us "Btrfs progs v3.19-rc2", just remove the check,
> if anyone who wants to make a fresh btrfs, please use the latest one.

I think the fixed progs are out long enough and the combination of
really old progs + really new kernel is very uncommon and we don't need
to care about that anymore.

However, please do not do it as a revert, it's a normal patch although
it effectively reverts some other patch.
