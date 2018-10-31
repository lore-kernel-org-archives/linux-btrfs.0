Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6237FC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2410920664
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:40:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2410920664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbeKABjX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 21:39:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:57958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729341AbeKABjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 21:39:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B44B2AE85;
        Wed, 31 Oct 2018 16:40:34 +0000 (UTC)
Subject: Re: [PATCH] Btrfs: fix missing delayed iputs on unmount
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
 <4817ac90-a79d-c258-96e1-f1108cfe7225@suse.com> <20181031163522.GA8563@vader>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a1504a83-1806-f248-3dcf-1cc83f49d1a8@suse.com>
Date:   Wed, 31 Oct 2018 18:40:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181031163522.GA8563@vader>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 31.10.18 г. 18:35 ч., Omar Sandoval wrote:
> On Wed, Oct 31, 2018 at 10:43:02AM +0200, Nikolay Borisov wrote:
>>
>>
>> On 31.10.18 г. 2:14 ч., Omar Sandoval wrote:
>>> From: Omar Sandoval <osandov@fb.com>
>>>
>>> There's a race between close_ctree() and cleaner_kthread().
>>> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
>>> sees it set, but this is racy; the cleaner might have already checked
>>> the bit and could be cleaning stuff. In particular, if it deletes unused
>>> block groups, it will create delayed iputs for the free space cache
>>> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
>>> longer running delayed iputs after a commit. Therefore, if the cleaner
>>> creates more delayed iputs after delayed iputs are run in
>>> btrfs_commit_super(), we will leak inodes on unmount and get a busy
>>> inode crash from the VFS.
>>>
>>> Fix it by parking the cleaner before we actually close anything. Then,
>>> any remaining delayed iputs will always be handled in
>>> btrfs_commit_super(). This also ensures that the commit in close_ctree()
>>> is really the last commit, so we can get rid of the commit in
>>> cleaner_kthread().
>>>
>>> Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
>>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>>> ---
>>> We found this with a stress test that our containers team runs. I'm
>>> wondering if this same race could have caused any other issues other
>>> than this new iput thing, but I couldn't identify any.
>>>
>>>  fs/btrfs/disk-io.c | 40 +++++++---------------------------------
>>>  1 file changed, 7 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index b0ab41da91d1..7c17284ae3c2 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -1664,9 +1664,8 @@ static int cleaner_kthread(void *arg)
>>>  	struct btrfs_root *root = arg;
>>>  	struct btrfs_fs_info *fs_info = root->fs_info;
>>>  	int again;
>>> -	struct btrfs_trans_handle *trans;
>>>  
>>> -	do {
>>> +	while (1) {
>>>  		again = 0;
>>>  
>>>  		/* Make the cleaner go to sleep early. */
>>> @@ -1715,42 +1714,16 @@ static int cleaner_kthread(void *arg)
>>>  		 */
>>>  		btrfs_delete_unused_bgs(fs_info);
>>>  sleep:
>>> +		if (kthread_should_park())
>>> +			kthread_parkme();
>>> +		if (kthread_should_stop())
>>> +			return 0;
>>>  		if (!again) {
>>>  			set_current_state(TASK_INTERRUPTIBLE);
>>> -			if (!kthread_should_stop())
>>> -				schedule();
>>> +			schedule();
>>>  			__set_current_state(TASK_RUNNING);
>>>  		}
>>> -	} while (!kthread_should_stop());
>>> -
>>> -	/*
>>> -	 * Transaction kthread is stopped before us and wakes us up.
>>> -	 * However we might have started a new transaction and COWed some
>>> -	 * tree blocks when deleting unused block groups for example. So
>>> -	 * make sure we commit the transaction we started to have a clean
>>> -	 * shutdown when evicting the btree inode - if it has dirty pages
>>> -	 * when we do the final iput() on it, eviction will trigger a
>>> -	 * writeback for it which will fail with null pointer dereferences
>>> -	 * since work queues and other resources were already released and
>>> -	 * destroyed by the time the iput/eviction/writeback is made.
>>> -	 */
>>> -	trans = btrfs_attach_transaction(root);
>>> -	if (IS_ERR(trans)) {
>>> -		if (PTR_ERR(trans) != -ENOENT)
>>> -			btrfs_err(fs_info,
>>> -				  "cleaner transaction attach returned %ld",
>>> -				  PTR_ERR(trans));
>>> -	} else {
>>> -		int ret;
>>> -
>>> -		ret = btrfs_commit_transaction(trans);
>>> -		if (ret)
>>> -			btrfs_err(fs_info,
>>> -				  "cleaner open transaction commit returned %d",
>>> -				  ret);
>>>  	}
>>> -
>>> -	return 0;
>>>  }
>>>  
>>>  static int transaction_kthread(void *arg)
>>> @@ -3931,6 +3904,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>>>  	int ret;
>>>  
>>>  	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
>>> +	kthread_park(fs_info->cleaner_kthread);
>>
>> Can't you directly call kthread_stop here? When you park the thread it
>> will sleep and then when you call kthread_stop that function will unpark
>> the thread and the cleaner kthread will see KTHREAD_SHOULD_STOP bit and
>> just return 0. So the from the moment the thread is parked until it's
>> stopped it doesn't have a chance to do useful work.
> 
> kthread_stop() frees the task_struct, but we might still try to wake up
> the cleaner kthread from somewhere (e.g., from the transaction kthread).
> So we really need to keep the cleaner alive but not doing work.

This dependency then needs to be documented via a comment or at the very
least mentioned in the changelog. Is it possible to refactor the code
(in a different patch) to actually ensure that transaction is stopped
and then kthread as well to remove this dependency ?

> 
