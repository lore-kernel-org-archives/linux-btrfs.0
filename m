Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51826 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470AbbDQS0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 14:26:15 -0400
Message-ID: <55315041.4070509@fb.com>
Date: Fri, 17 Apr 2015 14:26:09 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix data loss after concurrent fsyncs for files
 in the same subvol
References: <1429289031-1088-1-git-send-email-fdmanana@suse.com> <1429294846-9021-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1429294846-9021-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/17/2015 02:20 PM, Filipe Manana wrote:
> If we have concurrent fsync calls against files living in the same subvolume,
> we have some time window where we don't add the collected ordered extents
> to the running transaction's list of ordered extents and return success to
> userspace. This can result in data loss if the ordered extents complete after
> the current transaction commits and a power failure happens after the current
> transaction commits and before the next one commits.
>
> A sequence of steps that lead to this:
>
>          CPU 0                                                         CPU 1
>
> btrfs_sync_file(inode A)                               btrfs_sync_file(inode B)
>    btrfs_log_inode_parent()                               btrfs_log_inode_parent()
>
>      start_log_trans()
>        lock root->log_mutex
>        ctx->log_transid = root->log_transid = N
>        unlock root->log_mutex
>
>                                                             start_log_trans()
>                                                               lock root->log_mutex
>                                                               ctx->log_transid = root->log_transid = N
>                                                               unlock root->log_mutex
>
>      btrfs_log_inode()                                          btrfs_log_inode()
>        btrfs_get_logged_extents()                                 btrfs_get_logged_extents()
>           --> gets orderede extent A                                -> gets ordered extent B
>               into local list logged_list                              into local list logged_list
>        write items into the log tree                              write items into the log tree
>        btrfs_submit_logged_extents(&logged_list)
>          --> splices logged_list into
>              log_root->logged_list[N % 2]
>              (N == log_root->log_transid)
>
>    btrfs_sync_log()
>      lock root->log_mutex
>
>      atomic_set(&root->log_commit[N % 2], 1)
>        (N == ctx->log_transid)

Except this can't happen, we have a wait_for_writer() in between here 
that will wait for CPU 1 to finish doing it's logging since it has 
already done it's start_log_trans().  Thanks,

Josef
