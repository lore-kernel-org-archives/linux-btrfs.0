Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbbGXMM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 08:12:29 -0400
Date: Fri, 24 Jul 2015 14:12:20 +0200
From: David Sterba <dsterba@suse.com>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: defrag: fix threshold overflow again
Message-ID: <20150724121220.GV6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1437726902-6458-1-git-send-email-patrik.lundquist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437726902-6458-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 10:35:02AM +0200, Patrik Lundquist wrote:
> Commit dedb1ebeee847e3c4d71e14d0c1077887630e44a broke commit
> 96cfbbf0ea9fce7ecaa9e03964474f407f6e76ab.
> 
> Casting thresh value greater than (u32)-1 simply truncates bits while
> desired value is (u32)-1 for max defrag threshold.
> 
> I.e. "btrfs fi defrag -t 4g" is trimmed/truncated to 0
> and "-t 5g" to 1073741824.
> 
> Also added a missing newline.
> 
> Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>

Applied, thanks.
