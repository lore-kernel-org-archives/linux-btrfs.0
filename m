Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaANCVa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 21:21:30 -0500
Message-ID: <52D49F80.6020604@cn.fujitsu.com>
Date: Tue, 14 Jan 2014 10:22:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Btrfs: fix protection between send and root deletion
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140113182745.GS6498@twin.jikos.cz>
In-Reply-To: <20140113182745.GS6498@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 13 Jan 2014 19:27:45 +0100, David Sterba wrote:
> On Tue, Jan 07, 2014 at 05:25:19PM +0800, Wang Shilong wrote:
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1971,6 +1971,19 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
>>  	}
>>  	root = list_first_entry(&fs_info->dead_roots,
>>  			struct btrfs_root, root_list);
> 
> You're pulling the root from dead_roots here ...
> 
>> +	/*
>> +	 * Make sure root is not involved in send,
> 
> ... and there's no way to send such a thing.

The root what is about to be sent out may be deleted after we get it, if
there is no in-memory i-node in it, it will be inserted into the dead_roots list
immediately, then the cleaner thread will drop it. But the sender doesn't know,
the sender will access a broken tree.

Thanks
Miao

> 
>> +	 * if we fail with first root, we return
>> +	 * directly rather than continue.
>> +	 */
>> +	spin_lock(&root->root_item_lock);
>> +	if (root->send_in_progress) {
>> +		spin_unlock(&fs_info->trans_lock);
>> +		spin_unlock(&root->root_item_lock);
>> +		return 0;
>> +	}
>> +	spin_unlock(&root->root_item_lock);
>> +
>>  	list_del_init(&root->root_list);
>>  	spin_unlock(&fs_info->trans_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

