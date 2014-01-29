Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12210 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaA2CVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 21:21:25 -0500
Message-ID: <52E865FB.9050300@cn.fujitsu.com>
Date: Wed, 29 Jan 2014 10:22:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2 3/4] Btrfs: don't mix the ordered extents of all files
 together during logging the inodes
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com> <1389702712-26638-4-git-send-email-miaox@cn.fujitsu.com> <52E7C4FE.80104@fb.com>
In-Reply-To: <52E7C4FE.80104@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 28 Jan 2014 09:55:58 -0500, Josef Bacik wrote:
> 
> On 01/14/2014 07:31 AM, Miao Xie wrote:
>> There was a problem in the old code:
>> If we failed to log the csum, we would free all the ordered extents in the log list
>> including those ordered extents that were logged successfully, it would make the
>> log committer not to wait for the completion of the ordered extents.
>>
>> This patch doesn't insert the ordered extents that is about to be logged into
>> a global list, instead, we insert them into a local list. If we log the ordered
>> extents successfully, we splice them with the global list, or we will throw them
>> away, then do full sync. It can also reduce the lock contention and the traverse
>> time of list.
>>
> If we fail to log the csums we'll return an error and commit the transaction so it doesn't matter that we free all the ordered extents, everything will be waited on properly.  Thanks,


No. Maybe my explanation is not clear. Please consider the following case:

Task1 (sync file1)		Task2 (sync file2)
btrfs_sync_file()
				btrfs_sync_file()
  start_log_trans()
				  start_log_trans()
  btrfs_get_logged_extents()
  btrfs_log_changed_extents()
				  btrfs_get_logged_extents()
				  btrfs_log_changed_extents() failed
				  btrfs_free_logged_extents()
				    this function will free all logged extents
				    including the ones that are inserted by task1
  btrfs_end_log_trans()
  btrfs_sync_log()
    btrfs_wait_logged_extents()
      but no extents to be
      waited
  sync end
				  btrfs_wait_ordered_extents()
				    but this operation just wait for file2's
				    extents that is in the specified range.
				  btrfs_commit_transaction()
				    the committer also doesn't wait for the extents
				    of file1

Thanks
Miao
  
