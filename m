Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab3BFPxI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Feb 2013 10:53:08 -0500
Message-ID: <51127C61.3070503@redhat.com>
Date: Wed, 06 Feb 2013 09:53:05 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Zach Brown <zab@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] btrfs: add delayed_iput list head to btrfs inode
References: <511180E4.2020600@redhat.com> <20130205231405.GM14246@lenny.home.zabbo.net> <20130206020854.GA2278@liubo.jp.oracle.com>
In-Reply-To: <20130206020854.GA2278@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/5/13 8:08 PM, Liu Bo wrote:
> On Tue, Feb 05, 2013 at 03:14:05PM -0800, Zach Brown wrote:
>>> +	struct btrfs_inode *b_inode = BTRFS_I(inode);
>>> +	struct btrfs_fs_info *fs_info = b_inode->root->fs_info;
>>>  
>>>  	if (atomic_add_unless(&inode->i_count, -1, 1))
>>>  		return;
>>>  
>>> -	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
>>> -	delayed->inode = inode;
>>> -
>>>  	spin_lock(&fs_info->delayed_iput_lock);
>>> -	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
>>> +	list_add_tail(&b_inode->delayed_iput, &fs_info->delayed_iputs);
>>>  	spin_unlock(&fs_info->delayed_iput_lock);
>>>  }
>>
>> Hmm.  I'm not great with inode life cycles, but isn't this only safe if
>> someone else can't get an i_count reference while this is in flight?  It
>> looks like the final iput does the unhashing, and so on, so couldn't an
>> iget/iput race with this and try to add the inode's list_head twice?
> 
> Yeah, same concern here.  Basically this will result in inodes still being
> in use on unmount.
> 
> Actually I did a similar one, here is some disscussion:
> 
> https://patchwork.kernel.org/patch/1824711/

I read it, thanks.  Did you try the counter approach?

-Eric

> thanks,
> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

