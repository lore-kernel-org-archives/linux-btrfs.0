Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54641 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2G3K2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 06:28:41 -0400
Message-ID: <501661A6.7040301@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 18:27:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix the snapshot that should not exist
References: <5010EA3E.4040009@cn.fujitsu.com> <501248B5.8010408@jp.fujitsu.com> <20120727122957.GL17430@twin.jikos.cz>
In-Reply-To: <20120727122957.GL17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 27 Jul 2012 14:29:57 +0200, David Sterba wrote:
> On Fri, Jul 27, 2012 at 04:52:21PM +0900, Hidetoshi Seto wrote:
>> (2012/07/26 15:57), Miao Xie wrote:
>>>  	btrfs_abort_transaction(trans, root, ret);
>>>  	goto fail;
>>>  }
>>> @@ -1386,13 +1408,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>>  	 */
>>>  	mutex_lock(&root->fs_info->reloc_mutex);
>>>  
>>> -	ret = btrfs_run_delayed_items(trans, root);
>>> +	ret = create_pending_snapshots(trans, root->fs_info);
>>>  	if (ret) {
>>>  		mutex_unlock(&root->fs_info->reloc_mutex);
>>>  		goto cleanup_transaction;
>>>  	}
>>>  
>>> -	ret = create_pending_snapshots(trans, root->fs_info);
>>> +	ret = btrfs_run_delayed_items(trans, root);
>>>  	if (ret) {
>>>  		mutex_unlock(&root->fs_info->reloc_mutex);
>>>  		goto cleanup_transaction;
>>
>> It would be nice to have a patch description to tell why you
>> have to change the order here.
> 
> Not only nice but necessary, as this order will cause corruption under
> certain conditions. I'd like to hear the reason behind.

What you worried is the corruption of the snapshots, right?
It is impossible because we will flush all the delayed items before the
creation of the snapshot(in create_pending_snapshot()). and we also will
force the tree to COW if we want to change it after it is snapshoted.
These two method will make sure the snapshots is healthy.

Thanks
Miao
