Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:39274 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3JSOD6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Oct 2013 10:03:58 -0400
Message-ID: <5262914D.7030306@giantdisaster.de>
Date: Sat, 19 Oct 2013 16:03:57 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Shilong Wang <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing
 supers
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>	<526247E3.9000804@giantdisaster.de> <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com>
In-Reply-To: <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/19/2013 12:32, Shilong Wang wrote:
> 2013/10/19, Stefan Behrens <sbehrens@giantdisaster.de>:
>> On 10/19/2013 06:17, Wang Shilong wrote:
>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>
>>> Scrubing supers is not in a transaction context, when trying to
>>> write supers to disk, we should check if we are trying to
>>> scrub supers.Fix it.
>>>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> ---
>>>    fs/btrfs/disk-io.c     | 2 ++
>>>    fs/btrfs/transaction.c | 2 ++
>>>    2 files changed, 4 insertions(+)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 419968e..0debb19 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -3582,7 +3582,9 @@ int btrfs_commit_super(struct btrfs_root *root)
>>>    		return ret;
>>>    	}
>>>
>>> +	btrfs_scrub_pause_super(root);
>>>    	ret = write_ctree_super(NULL, root, 0);
>>> +	btrfs_scrub_continue_super(root);
>>>    	return ret;
>>>    }
>>>
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index 277fe81..3ebcbbd 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -1892,7 +1892,9 @@ int btrfs_commit_transaction(struct
>>> btrfs_trans_handle *trans,
>>>    		goto cleanup_transaction;
>>>    	}
>>>
>>> +	btrfs_scrub_pause_super(root);
>>>    	ret = write_ctree_super(trans, root, 0);
>>> +	btrfs_scrub_continue_super(root);
>>>    	if (ret) {
>>>    		mutex_unlock(&root->fs_info->tree_log_mutex);
>>>    		goto cleanup_transaction;
>>>
>>
>> What kind of race do you see between writing the 4K superblock and scrub
>> checking its checksum? Or in other words, what could happen?

 > Yeah, it did not hurt. but it may  output checksum mismatch.  For 
example:
 > Writing 4k superblock is not totally finished, but we are trying to 
scrub it.

Have you ever seen this issue?

If yes, let's find a different solution. You scrub, let's say, once a 
week. Scrubbing the superblock takes, let's say, 100ms, then it's 
finished. This short race doesn't justify to add such code to 
btrfs_commit_transaction and btrfs_commit_super IMHO. And commiting a 
transaction is synchronized to scrub already when the commit root is 
updated.

If this is really an issue and these 4K disk writes and reads interfere, 
let's find a better solution please.


