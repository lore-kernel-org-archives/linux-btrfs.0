Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932809AbeGBLCg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 07:02:36 -0400
Subject: Re: [PATCH] btrfs: qgroups: Move transaction managed inside
 btrfs_quota_enable
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, wqu@suse.com
References: <1530529234-13170-1-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <75b8baf7-61c9-68ff-6917-a6679d056458@suse.com>
Date: Mon, 2 Jul 2018 14:02:34 +0300
MIME-Version: 1.0
In-Reply-To: <1530529234-13170-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 14:00, Nikolay Borisov wrote:
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
> Link: https://marc.info/?l=linux-btrfs&m=152999289017582
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

David,

This is a fix for an issue which Misono is seeing. So far neither I nor
Qu were able to reproduce it. Imho it should be material for this RC.
