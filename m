Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD3FC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90530205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 15:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1Pr2vKg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90530205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbeKBAOD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:14:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40894 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbeKBAOD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2018 20:14:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id b9-v6so9080760pls.7
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 08:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gGt/tPykMo2hgiUYmG1DC5D9mHS/UuBBSeDqRCa6kXE=;
        b=D1Pr2vKgIWHPzY6r2YzxnjjLZrMpWcpFRN9ei9J6XOk0ch8QXpNqmJh0N0c2YJFpr1
         sZ6O+Zarx1H5WybUGZyq+vVJyiXmAineun60J8srGBI8WrX98lmq1IIOtZnkm/J7YwWT
         4q8bTMj2m3HeLkg94M7m/cZG7fFJ5FJbDBDYtuoDZSvblIUsxu6JPcRh5YsrmFWwJkiG
         ElqyifDuxN6Bvju8GGihjh2JXsnp0+mp9eiQsTlcDRFGpLKbUxH2Ql/cOil2kP5jg6Xk
         dsCkKQxT+dqnMzNVy4XDSlhpoQREhjXmzwvYSdNCcj3Rk2RfUo44CRjM3TpRvDl3/HBE
         FAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gGt/tPykMo2hgiUYmG1DC5D9mHS/UuBBSeDqRCa6kXE=;
        b=cUwvaGr30vd+IoMu7G6Whq9MqEsLI0WfPXNafI4UJQ3fpHcEKdgxnaL8nYoqehOJtV
         f4yGHYnymnGzSumzcJY9jD/gtxg4eVIhQxZg46gXMVel8remkzgJpafBrzDhEWsGJGfk
         6VOq0Lg4NVNiSOT1FAZ259joHY9D8XIso8Ee2fn0NzAyLuDfGW1d6Bnpu87vhTlYTdPH
         mwkYB5L+fGP3HGF94hQEE/f0wJqd8pRHP/I8IowwgQYH/ttB8JPnYjew/mK19S0JOooQ
         SWUhlLwCvbjJF/1KQsFarTV6oajxcP3qdzO+bMJz/oHtxZZHI2u1jAVIB1OGYJNWqS6j
         plcg==
X-Gm-Message-State: AGRZ1gKAcuGb+fln7lnhLSCOfUnzoVpSFhfRcaqo+n3hdg7M2eX1rwIs
        R/Lr2YcRsoTdFrAQIPPVJ5QSo2GN
X-Google-Smtp-Source: AJdET5c6cHCaIov0Yv8LG03JMWmrG8WfqIgw06ei3vQowqDqLII4+MnCEC70cp9CTIaHMYjZKVoNcA==
X-Received: by 2002:a17:902:6e08:: with SMTP id u8-v6mr8000378plk.64.1541085041362;
        Thu, 01 Nov 2018 08:10:41 -0700 (PDT)
Received: from [10.20.1.223] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id q25-v6sm51440222pfk.154.2018.11.01.08.10.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 08:10:40 -0700 (PDT)
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
To:     Nikolay Borisov <nborisov@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <a0a00740-6c97-7689-54dd-b381d4c8a2db@suse.com>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <44d61374-3250-2cb5-b4f0-dd8f4d3678c6@gmail.com>
Date:   Thu, 1 Nov 2018 17:10:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <a0a00740-6c97-7689-54dd-b381d4c8a2db@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 1.11.18 г. 16:35 ч., Nikolay Borisov wrote:
> 
> 
> On 31.10.18 г. 19:06 ч., Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> There's a race between close_ctree() and cleaner_kthread().
>> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
>> sees it set, but this is racy; the cleaner might have already checked
>> the bit and could be cleaning stuff. In particular, if it deletes unused
>> block groups, it will create delayed iputs for the free space cache
>> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
>> longer running delayed iputs after a commit. Therefore, if the cleaner
>> creates more delayed iputs after delayed iputs are run in
>> btrfs_commit_super(), we will leak inodes on unmount and get a busy
>> inode crash from the VFS.
>>
>> Fix it by parking the cleaner before we actually close anything. Then,
>> any remaining delayed iputs will always be handled in
>> btrfs_commit_super(). This also ensures that the commit in close_ctree()
>> is really the last commit, so we can get rid of the commit in
>> cleaner_kthread().
>>
>> Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
> 
> Also I believe this patch renders the wake_up_process in
> btrfs_commit_super a null op so it can also be removed, which leaves a
> single place that could wake up the cleaner - transaction_kthread.
> 
> So can't we stop transaction and cleaner thread right after setting
> CLOSING_FS. And commit the transaction in close_ctree whenever we deem
> necessary (in btrfs_commit_super for example) ?

Ok, that won't work because commit_super is called in other contexts
where it can genuinely wake up the trans kthread, blimey. Why can't we
stop transaction kthread first thing in close_ctree ?



> 
>> ---
>> Changes from v1:
>>
>> - Add a comment explaining why it needs to be a kthread_park(), not
>>   kthread_stop()
>> - Update later comment now that the cleaner thread is definitely stopped
>>
>>  fs/btrfs/disk-io.c | 51 ++++++++++++++--------------------------------
>>  1 file changed, 15 insertions(+), 36 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index b0ab41da91d1..40bcc45d827d 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1664,9 +1664,8 @@ static int cleaner_kthread(void *arg)
>>  	struct btrfs_root *root = arg;
>>  	struct btrfs_fs_info *fs_info = root->fs_info;
>>  	int again;
>> -	struct btrfs_trans_handle *trans;
>>  
>> -	do {
>> +	while (1) {
>>  		again = 0;
>>  
>>  		/* Make the cleaner go to sleep early. */
>> @@ -1715,42 +1714,16 @@ static int cleaner_kthread(void *arg)
>>  		 */
>>  		btrfs_delete_unused_bgs(fs_info);
>>  sleep:
>> +		if (kthread_should_park())
>> +			kthread_parkme();
>> +		if (kthread_should_stop())
>> +			return 0;
>>  		if (!again) {
>>  			set_current_state(TASK_INTERRUPTIBLE);
>> -			if (!kthread_should_stop())
>> -				schedule();
>> +			schedule();
>>  			__set_current_state(TASK_RUNNING);
>>  		}
>> -	} while (!kthread_should_stop());
>> -
>> -	/*
>> -	 * Transaction kthread is stopped before us and wakes us up.
>> -	 * However we might have started a new transaction and COWed some
>> -	 * tree blocks when deleting unused block groups for example. So
>> -	 * make sure we commit the transaction we started to have a clean
>> -	 * shutdown when evicting the btree inode - if it has dirty pages
>> -	 * when we do the final iput() on it, eviction will trigger a
>> -	 * writeback for it which will fail with null pointer dereferences
>> -	 * since work queues and other resources were already released and
>> -	 * destroyed by the time the iput/eviction/writeback is made.
>> -	 */
>> -	trans = btrfs_attach_transaction(root);
>> -	if (IS_ERR(trans)) {
>> -		if (PTR_ERR(trans) != -ENOENT)
>> -			btrfs_err(fs_info,
>> -				  "cleaner transaction attach returned %ld",
>> -				  PTR_ERR(trans));
>> -	} else {
>> -		int ret;
>> -
>> -		ret = btrfs_commit_transaction(trans);
>> -		if (ret)
>> -			btrfs_err(fs_info,
>> -				  "cleaner open transaction commit returned %d",
>> -				  ret);
>>  	}
>> -
>> -	return 0;
>>  }
>>  
>>  static int transaction_kthread(void *arg)
>> @@ -3931,6 +3904,13 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>>  	int ret;
>>  
>>  	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
>> +	/*
>> +	 * We don't want the cleaner to start new transactions, add more delayed
>> +	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
>> +	 * because that frees the task_struct, and the transaction kthread might
>> +	 * still try to wake up the cleaner.
>> +	 */
>> +	kthread_park(fs_info->cleaner_kthread);
>>  
>>  	/* wait for the qgroup rescan worker to stop */
>>  	btrfs_qgroup_wait_for_completion(fs_info, false);
>> @@ -3958,9 +3938,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>>  
>>  	if (!sb_rdonly(fs_info->sb)) {
>>  		/*
>> -		 * If the cleaner thread is stopped and there are
>> -		 * block groups queued for removal, the deletion will be
>> -		 * skipped when we quit the cleaner thread.
>> +		 * The cleaner kthread is stopped, so do one final pass over
>> +		 * unused block groups.
>>  		 */
>>  		btrfs_delete_unused_bgs(fs_info);
>>  
>>
