Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaACRDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 12:03:52 -0500
Date: Fri, 3 Jan 2014 18:03:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, cml@fb.com, sbehrens@giantdisaster.de
Subject: Re: [PATCH] Btrfs: only fua the first superblock when writting supers
Message-ID: <20140103170350.GP6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388744577-13968-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388744577-13968-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 06:22:57PM +0800, Wang Shilong wrote:
> We only intent to fua the first superblock in every device from
> comments, fix it.

Good catch, this could gain some speedup when there are up to 2 less
flushes.

There's one thing that's a different from currnet behaviour:
Without this patch, all the superblocks are written with FUA, now only
the first one, so my question is what if the first fails and the others
succeed but do not get flushed immediatelly?

This is more of a theoretical scenario, and if the 1st superblock write
fails more serious problems can be expected. But let's say the write
error of 1st is transient, do you or others think that it's reasonable
to try to write all the remainig sb's with FUA?


david
