Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753560AbeGCIyO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 04:54:14 -0400
Subject: Re: [PATCH] btrfs: qgroups: Move transaction managed inside
 btrfs_quota_enable
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        misono.tomohiro@jp.fujitsu.com, wqu@suse.com
References: <1530529234-13170-1-git-send-email-nborisov@suse.com>
 <20180702154036.GB3126@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ea44a848-5331-7970-5a7d-fb824d1acb8b@suse.com>
Date: Tue, 3 Jul 2018 11:54:11 +0300
MIME-Version: 1.0
In-Reply-To: <20180702154036.GB3126@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 18:40, David Sterba wrote:
> On Mon, Jul 02, 2018 at 02:00:34PM +0300, Nikolay Borisov wrote:
>> Commit 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to
>> btrfs_quota_enable") not only resulted in an easier to follow code but
>> it also introduced a subtle bug. It changed the timing when the initial
>> transaction rescan was happening - before the commit it would happen
>> after transaction commit had occured but after the commit it might happen
>> before the transaction was committed. This results in failure to
>> correctly rescan the quota since there could be data which is still not
>> committed on disk.
>>
>> This patch aims to fix this by movign the transaction creation/commit
>> inside btrfs_quota_enable, which allows to schedule the quota commit
>> after the transaction has been committed.
>>
>> Fixes: 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable")
>> Link: https://marc.info/?l=linux-btrfs&m=152999289017582
> 
> Please use https://lkml.kernel.org/r/<message-id>

That won't work since lkml.kernel is , well, only for lkml and this was
posted to the btrfs mailing list.

> 
>> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
