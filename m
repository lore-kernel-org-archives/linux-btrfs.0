Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbcFQPGl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 11:06:41 -0400
Date: Fri, 17 Jun 2016 17:07:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: qgroup: Fix a bug that fails to skip rescan
 running case
Message-ID: <20160617150716.GC4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160616011551.4356-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160616011551.4356-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 16, 2016 at 09:15:51AM +0800, Qu Wenruo wrote:
> Commit 6bdf962fe35a8648d(btrfs-progs: Read qgroup status for qgroup
> verify) will read qgroup status, and then use it to skip qgroup
> reporting.
> 
> However since the rescan_running/inconsistent flags are only 1 bit long,
> while qgroup flags & BTRFS_QGROUP_FLAGS returns value longer than 1bit,
> it doesn't work.
> 
> Fix it by doing double negation on (flags & BTRFS_QGROUP_FLAGS) to
> convert it to either 1 or 0.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
