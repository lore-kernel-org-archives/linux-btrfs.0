Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30924 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754165AbcJYKtm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 06:49:42 -0400
Subject: Re: [PATCH 2/2] btrfs: fix false enospc for compression
To: <dsterba@suse.cz>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>, <dsterba@suse.com>
References: <20161006025139.22776-1-wangxg.fnst@cn.fujitsu.com>
 <20161006025139.22776-2-wangxg.fnst@cn.fujitsu.com>
 <5800E4AB.2010701@applied-asynchrony.com> <5804937A.2060506@cn.fujitsu.com>
 <20161019142344.GR11398@twin.jikos.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <580F3746.3030509@cn.fujitsu.com>
Date: Tue, 25 Oct 2016 18:43:18 +0800
MIME-Version: 1.0
In-Reply-To: <20161019142344.GR11398@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/19/2016 10:23 PM, David Sterba wrote:
> On Mon, Oct 17, 2016 at 05:01:46PM +0800, Wang Xiaoguang wrote:
>>> [..]
>>>>    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
>>>> -			      struct extent_state **cached_state);
>>>> +			      struct extent_state **cached_state, int flag);
>>>>    int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
>>>> -			    struct extent_state **cached_state);
>>>> +			    struct extent_state **cached_state, int flag);
>>> [..]
>>>>    int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
>>>>    		      struct page **pages, size_t num_pages,
>>>>    		      loff_t pos, size_t write_bytes,
>>>> -		      struct extent_state **cached);
>>>> +		      struct extent_state **cached, int flag);
>>> Instead of adding "int flag" why not use the already defined
>>> btrfs_metadata_reserve_type enum? I know it's just an int at the end of
>>> the day, but the dedupe support already added another "int dedupe" argument
>>> and it's probably easy to cause confusion.
>>> Maybe later it would be beneficial to consolidate the flags into a consistent
>>> set of enum values to prevent more "int flag" inflation and better declare the
>>> intent of the extent state change. Not sure if that makes sense.
>> Yes, agree.
>> I'll rebase them later, thanks.
> Would be great. I won't manually merge the patch now as it's not a
> conflict against the current state, btrfs_set_extent_delalloc has the
> extra parameter already. Please consolidate them before this patch is
> supposed to be merged. Thanks.
Sorry for being late, I have just finished the rebase work now.
I'll run some fstests job, if no regressions, I'll send two patches 
tomorrow :)

Regards,
Xiaoguang Wang

>
>



