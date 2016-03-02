Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbcCBIuX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 03:50:23 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D5C64F.3000800@gmail.com> <56D64590.1090108@cn.fujitsu.com>
Cc: clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D6A93F.8020603@oracle.com>
Date: Wed, 2 Mar 2016 16:50:07 +0800
MIME-Version: 1.0
In-Reply-To: <56D64590.1090108@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks! for commenting Qu.

  As you are working near these codes appreciate any
  code review comments.

> +1 here, but in fact, it's easy to deal with.
> As long as not implement encryption as a compression method.
>
> Just like inband dedup, we use the following method to support dedup and
> compression while still using most of CPU cores like compression:
>
> Old compression only implement:
> inode needs compress will go into async_cow_start()
> async_cow_start()
>    |- compress_file_range()
>
> Compression with dedup implement:
> inode needs compress *OR* dedup will go into async_cow_start()
> async_cow_start()
>    |
>    |- if (!inode_need_dedup())
>    |  |- compress_file_range()  <<Just as normal one
>    |     |- btrfs_compress_pages()
>    |     |- add_async_extent()
>    |
>    |- else
>       |- hash_file_range()      <<Calculate file hashes
>          |- normal dedup hash
>          |- if (inode_need_compress())
>          |  |- btrfs_compress_pages()
>          |- add_async_extent()
>
> Although not the most elegant method, but it shows that we can
> co-operate compress and encrypt.
>
> However the most elegant method, is to rework current cow_file_range()
> and its variant, to an unified btrfs internal API.

  Thanks for this. Right. Currently there is no elegant way of doing it.
  Tried a bit of juggles. Unless rework.

  But I am confused. Are you suggesting we should cascade compress engine
  and then an encryption engine ? Austin said against such an approach.
  And I have included it under limitation section just to mention, and
  what's the idea if at all someone seeks such a configurations, which
  is to use engine which provides both instead.

Thanks, Anand
