Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47718 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbaKMRn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 12:43:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XoyQW-0007RV-0Y
	for linux-btrfs@vger.kernel.org; Thu, 13 Nov 2014 18:43:24 +0100
Received: from pd953e883.dip0.t-ipconnect.de ([217.83.232.131])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 18:43:24 +0100
Received: from holger.hoffstaette by pd953e883.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 18:43:24 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: don't ignore log btree writeback errors
Date: Thu, 13 Nov 2014 17:43:12 +0000 (UTC)
Message-ID: <pan.2014.11.13.17.43.12@googlemail.com>
References: <1415897993-7556-1-git-send-email-fdmanana@suse.com>
	<pan.2014.11.13.17.33.19@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 Nov 2014 17:33:19 +0000, Holger Hoffstätte wrote:

> On Thu, 13 Nov 2014 16:59:53 +0000, Filipe Manana wrote:
> 
>> If an error happens during writeback of log btree extents, make sure the
>> error is returned to the caller (fsync), so that it takes proper action
>> (commit current transaction) instead of writing a superblock that points
>> to log btrees with all or some nodes that weren't durably persisted.
>> 
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/tree-log.c | 21 +++++++++++++++------
>>  1 file changed, 15 insertions(+), 6 deletions(-)
>> 
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 6d58d72..c8274d3 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -2599,12 +2599,14 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>>  	index2 = root_log_ctx.log_transid % 2;
>>  	if (atomic_read(&log_root_tree->log_commit[index2])) {
>>  		blk_finish_plug(&plug);
>> -		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
>> +		ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages,
>> +						mark);
>>  		wait_log_commit(trans, log_root_tree,
>>  				root_log_ctx.log_transid);
>>  		btrfs_free_logged_extents(log, log_transid);
>>  		mutex_unlock(&log_root_tree->log_mutex);
>> -		ret = root_log_ctx.log_ret;
>> +		if (!ret)
>> +			ret = root_log_ctx.log_ret;
>>  		goto out;
>>  	}
>>  	ASSERT(root_log_ctx.log_transid == log_root_tree->log_transid);
> 
> This first hunk didn't apply to my 3.14.x tree that is 99.999% in sync with
> btrfs-3.18+, as a line is missing from the context. See:
> 
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/tree/fs/btrfs/tree-log.c?h=for-linus#n2605
> 
> Any idea where that missing btrfs_free_logged_extents() went?

Found it: it went away with Josef's recent patch on Nov 6:
"Btrfs: make sure we wait on logged extents when fsycning two subvols"
(http://permalink.gmane.org/gmane.comp.file-systems.btrfs/40005)

..which I have applied. boohoo.

That patch also adds another call to btrfs_wait_marked_extents(), which should
then probably also have its return value handled?

thanks,
Holger

