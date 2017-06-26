Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751402AbdFZO4O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:56:14 -0400
Date: Mon, 26 Jun 2017 16:55:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, marc@merlins.org
Subject: Re: [PATCH v2] btrfs-progs: lowmem check: Fix false alert about file
 extent interrupt
Message-ID: <20170626145504.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170622075237.1852-1-lufq.fnst@cn.fujitsu.com>
 <20170622081256.4981-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622081256.4981-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 04:12:56PM +0800, Lu Fengqi wrote:
> As Qu mentioned in this thread
> (https://www.spinics.net/lists/linux-btrfs/msg64469.html), compression
> can cause regular extent to co-exist with inlined extent. This coexistence
> makes things confusing. Since it was permitted currently, so fix
> btrfsck to prevent a bunch of error logs that will make user feel
> panic.
> 
> When check file extent, record the extent_end of regular extent to check
> if there is a gap between the regular extents. Normally there is only one
> inlined extent, so the extent_end of inlined extent is useless. However,
> if regular extent can co-exist with inlined extent, the extent_end of
> inlined extent also need to record.
> 
> Reported-by: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.

Do you have a test for that?
