Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbcCXMfy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 08:35:54 -0400
Date: Thu, 24 Mar 2016 13:35:23 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com, jbacik@fb.com
Subject: Re: [RFC][PATCH] btrfs: allow balancing to dup with multi-device
Message-ID: <20160324123523.GO29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458757379-36299-1-git-send-email-ahferroin7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458757379-36299-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 02:22:59PM -0400, Austin S. Hemmelgarn wrote:
> Currently, we don't allow the user to try and rebalance to a dup profile
> on a multi-device filesystem.  In most cases, this is a perfectly sensible
> restriction as raid1 uses the same amount of space and provides better
> protection.
> 
> However, when reshaping a multi-device filesystem down to a single device
> filesystem, this requires the user to convert metadata and system chunks
> to single profile before deleting devices, and then convert again to dup,
> which leaves a period of time where metadata integrity is reduced.
> 
> This patch removes the single-device-only restriction from converting to
> dup profile to remove this potential data integrity reduction.
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Ack. I did exactly same patch a week ago, the changelogs sound
equivalent to me, so I'll drop my patch and take yours.

http://repo.or.cz/linux-2.6/btrfs-unstable.git/commitdiff/d9929bfeec0abf24ae7fdbc5855914fe7f3886c9?hp=b562e44f507e863c6792946e4e1b1449fbbac85d

I did the btrfs-progs side as well, that prints a warning but otherwise
lets the user create dup on multi-dev filesystem.

http://repo.or.cz/btrfs-progs-unstable/devel.git/commitdiff/22c67c3105c887f541d7353d79d9e11b68e70998
