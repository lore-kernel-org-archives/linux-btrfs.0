Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753763AbeGEOjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 10:39:05 -0400
Date: Thu, 5 Jul 2018 16:39:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH v2] btrfs: qgroups: Move transaction management inside
 btrfs_quota_enable/disable
Message-ID: <20180705143902.GG3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530791448-12743-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530791448-12743-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2018 at 02:50:48PM +0300, Nikolay Borisov wrote:
> Commit 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to
> btrfs_quota_enable") not only resulted in an easier to follow code but
> it also introduced a subtle bug. It changed the timing when the initial
> transaction rescan was happening - before the commit it would happen
> after transaction commit had occured but after the commit it might happen
> before the transaction was committed. This results in failure to
> correctly rescan the quota since there could be data which is still not
> committed on disk.
> 
> This patch aims to fix this by movign the transaction creation/commit
> inside btrfs_quota_enable, which allows to schedule the quota commit
> after the transaction has been committed.
> 
> Fixes: 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable")
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Link: https://marc.info/?l=linux-btrfs&m=152999289017582
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next with the fixups (goto and whitespace).
