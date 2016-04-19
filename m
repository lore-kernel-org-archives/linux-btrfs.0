Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbcDSWTs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 18:19:48 -0400
Date: Tue, 19 Apr 2016 15:19:46 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
Message-ID: <20160419221946.GT2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2016 at 05:08:22PM +0800, Qu Wenruo wrote:
> Current btrfs qgroup design implies a requirement that after calling
> btrfs_qgroup_account_extents() there must be a commit root switch.
> 
> Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
> inside btrfs_commit_transaction() just be commit_cowonly_roots().
> 
> However there is a exception at create_pending_snapshot(), which will
> call btrfs_qgroup_account_extents() but no any commit root switch.
> 
> In case of creating a snapshot whose parent root is itself (create a
> snapshot of fs tree), it will corrupt qgroup by the following trace:
> (skipped unrelated data)
> ======
> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
> ======
> 
> The problem here is in first qgroup_account_extent(), the
> nr_new_roots of the extent is 1, which means its reference got
> increased, and qgroup increased its rfer and excl.
> 
> But at second qgroup_account_extent(), its reference got decreased, but
> between these two qgroup_account_extent(), there is no switch roots.
> This leads to the same nr_old_roots, and this extent just got ignored by
> qgroup, which means this extent is wrongly accounted.
> 
> Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
> create_pending_snapshot(), with needed preparation.
> 
> Reported-by: Mark Fasheh <mfasheh@suse.de>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Ok, this version seems to be giving me the right numbers. I'll send a test
for it shortly. I'd still like to know if this patch introduces an
unintended side effects but otherwise, thanks Qu.
	--Mark

--
Mark Fasheh
