Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753722AbeGELxG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 07:53:06 -0400
Subject: Re: [PATCH v2] btrfs: qgroups: Move transaction management inside
 btrfs_quota_enable/disable
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com, misono.tomohiro@jp.fujitsu.com
References: <1530791448-12743-1-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d4c2f2d7-f640-514b-37ce-f699243ce0f2@suse.com>
Date: Thu, 5 Jul 2018 14:53:03 +0300
MIME-Version: 1.0
In-Reply-To: <1530791448-12743-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.07.2018 14:50, Nikolay Borisov wrote:
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
> ---
> 
> Hello, 
> 
> One open-ended question this patch puts is how many items should be reserved
> to guarantee successful qgroup disable. Before this patch quota disable was 
> always using the arbitrary reservation of 2 items. Since this patch makes the 
> the transaction for enable/disable independent we have a chance to actually 
> set appropriate values for both transactions. In any case this patch doesn't 
> make things worse than before. 
> 
>  fs/btrfs/ioctl.c  | 15 ++--------
>  fs/btrfs/qgroup.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  fs/btrfs/qgroup.h |  6 ++--
>  3 files changed, 76 insertions(+), 31 deletions(-)
>

Changes since v2:

* Actually implemented proper transaction unwiding in both functions.
