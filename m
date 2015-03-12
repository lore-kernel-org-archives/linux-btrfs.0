Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbCLUJp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 16:09:45 -0400
Date: Fri, 13 Mar 2015 04:09:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
Message-ID: <20150312200935.GA10724@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
 <20150312172513.GD20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150312172513.GD20767@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 12, 2015 at 06:25:13PM +0100, David Sterba wrote:
> On Thu, Mar 12, 2015 at 01:40:47PM +0800, Liu Bo wrote:
> > This reverts commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007.
> > 
> > This was used to make sure that a fresh btrfs from an older mkfs.btrfs,
> > and it also allows us to mount a buggy btrfs if this btrfs has the right
> > superblock head part but has something wrong with chunk tree part[1], and
> > after that we can hit BUG_ON()s set in the code to prevent something
> > impossible.
> > 
> > Since David has gave us "Btrfs progs v3.19-rc2", just remove the check,
> > if anyone who wants to make a fresh btrfs, please use the latest one.
> 
> I think the fixed progs are out long enough and the combination of
> really old progs + really new kernel is very uncommon and we don't need
> to care about that anymore.
> 
> However, please do not do it as a revert, it's a normal patch although
> it effectively reverts some other patch.

Okay, I'll update this ASAP, thanks for your review.

Thanks,

-liubo
