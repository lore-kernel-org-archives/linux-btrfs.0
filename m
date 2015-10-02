Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58877 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbbJBBIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 21:08:31 -0400
Subject: Re: [PATCH 1/2] btrfs: Add support to do stack item key operation
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, stephane_btrfs@lesimple.fr
References: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1443148681-3015-2-git-send-email-quwenruo@cn.fujitsu.com>
 <20151001164643.GH5885@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <560DD8FD.5020502@gmx.com>
Date: Fri, 2 Oct 2015 09:08:13 +0800
MIME-Version: 1.0
In-Reply-To: <20151001164643.GH5885@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年10月02日 00:46, David Sterba 写道:
> On Fri, Sep 25, 2015 at 10:38:00AM +0800, Qu Wenruo wrote:
>> +static inline void btrfs_stack_item_key(char *stack_leaf,
>> +					struct btrfs_disk_key *disk_key,
>> +					int nr)
>
>> +static inline void btrfs_stack_item_key_to_cpu(char *stack_leaf,
>> +					       struct btrfs_key *key,
>> +					       int nr)
>
> The functions do not follow the pattern of btrfs_stack_*,

The extent buffer version is btrfs_item_key() and btrfs_item_key_to_cpu()
So I don't see the problem with the naming.
Would you please pointing out what's wrong with the naming?

> also passing
> 'char *' is not right, it should be 'struct extent_buffer *'.

The problem is, extent_buffer is not some thing we can operate directly 
in memory.
It uses page pointer to do read/write.

So we read out the real extent buffer content and do operation.

I can change the struct name to btrfs_header, but not extent_buffer.

>
> IOW the manually created structure accessors must match the prototypes
> that would result from BTRFS_STACK_FUNCS and BTRFS_SETGET_STACK_FUNCS.

Unfortunately, the original btrfs_item_key() and its variants are not 
from BTRFS_STACK_FCUNS.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
