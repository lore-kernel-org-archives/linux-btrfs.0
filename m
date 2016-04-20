Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50636 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbcDTOZ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 10:25:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ast4m-0007eE-G2
	for linux-btrfs@vger.kernel.org; Wed, 20 Apr 2016 16:25:56 +0200
Received: from pd953eff0.dip0.t-ipconnect.de ([217.83.239.240])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Apr 2016 16:25:56 +0200
Received: from holger.hoffstaette by pd953eff0.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Apr 2016 16:25:56 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
Date: Wed, 20 Apr 2016 14:25:34 +0000 (UTC)
Message-ID: <pan$bb805$371127c7$268323bd$37205c9c@googlemail.com>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20160419221946.GT2187@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 19 Apr 2016 15:19:46 -0700, Mark Fasheh wrote:

> On Fri, Apr 15, 2016 at 05:08:22PM +0800, Qu Wenruo wrote:
>> Current btrfs qgroup design implies a requirement that after calling
>> btrfs_qgroup_account_extents() there must be a commit root switch.
>> 
>> Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
>> inside btrfs_commit_transaction() just be commit_cowonly_roots().
>> 
>> However there is a exception at create_pending_snapshot(), which will
>> call btrfs_qgroup_account_extents() but no any commit root switch.
>> 
>> In case of creating a snapshot whose parent root is itself (create a
>> snapshot of fs tree), it will corrupt qgroup by the following trace:
>> (skipped unrelated data)
>> ======
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>> ======
>> 
>> The problem here is in first qgroup_account_extent(), the
>> nr_new_roots of the extent is 1, which means its reference got
>> increased, and qgroup increased its rfer and excl.
>> 
>> But at second qgroup_account_extent(), its reference got decreased, but
>> between these two qgroup_account_extent(), there is no switch roots.
>> This leads to the same nr_old_roots, and this extent just got ignored by
>> qgroup, which means this extent is wrongly accounted.
>> 
>> Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
>> create_pending_snapshot(), with needed preparation.
>> 
>> Reported-by: Mark Fasheh <mfasheh@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Ok, this version seems to be giving me the right numbers. I'll send a test
> for it shortly. I'd still like to know if this patch introduces an
> unintended side effects but otherwise, thanks Qu.
> 	--Mark

Hi Mark,

Can't speak about other side effects since I have not observed any so far,
but I can confirm that the previously failing case of deleting a renamed
snapshot [1] now works properly with v4 without getting the commit roots
in a twist. So:

Tested-by: holger.hoffstaette@googlemail.com

cheers
Holger

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/55052

