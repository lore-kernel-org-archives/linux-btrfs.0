Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31669 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab3DKHKa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 03:10:30 -0400
Message-ID: <516662DF.5080400@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 15:14:39 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: make some functions return type be void in
 backref.c
References: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com> <1365592971-1535-3-git-send-email-wangshilong1991@gmail.com> <20130410150110.GM18193@twin.jikos.cz>
In-Reply-To: <20130410150110.GM18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, David

Patch V2 has been sent out,many thanks for your review ^_^

Thanks,
Wang

> On Wed, Apr 10, 2013 at 07:22:51PM +0800, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> __merge_refs() and __add_missing_keys() always return 0, it is unnecessary
>> for the caller to check the return value.
> 
> ok for __merge_refs, nak for __add_missing_keys: there's unhandled
> BUG_ON from read_tree_block
> 
>  422                 eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
>  423                                      fs_info->tree_root->leafsize, 0);
>  424                 BUG_ON(!eb);
> 
> this should become a proper error handling someday and use the int return
> value. Keep the callers aware of that.
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



