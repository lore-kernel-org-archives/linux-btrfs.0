Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8658 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753616AbcHSKO0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 06:14:26 -0400
Subject: Re: [PATCH 00/13] btrfs-progs: check: check fs roots in low_memory
 mode
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160817170018.GA16983@twin.jikos.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <57B6D818.5020501@cn.fujitsu.com>
Date: Fri, 19 Aug 2016 17:57:44 +0800
MIME-Version: 1.0
In-Reply-To: <20160817170018.GA16983@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On 08/18/2016 01:00 AM, David Sterba wrote:
> On Thu, Jul 28, 2016 at 03:08:12PM +0800, Lu Fengqi wrote:
>> This patchset implements check fs trees in low memory mode, and fix the
>> return value bug of the function cmd_check().
>>
>> Lu Fengqi (13):
>>    btrfs-progs: move btrfs_extref_hash() to hash.h
>>    btrfs-progs: check: introduce function to find dir_item
>>    btrfs-progs: check: introduce function to check inode_ref
>>    btrfs-progs: check: introduce function to check inode_extref
>>    btrfs-progs: check: introduce function to find inode_ref
>>    btrfs-progs: check: introduce a function to check dir_item
>>    btrfs-progs: check: introduce function to check file extent
>>    btrfs-progs: check: introduce function to check inode item
>>    btrfs-progs: check: introduce function to check fs root
>>    btrfs-progs: check: introduce function to check root ref
>>    btrfs-progs: check: introduce low_memory mode fs_tree check
>>    btrfs-progs: check: fix the return value bug of cmd_check()
>>    btrfs-progs: check: fix false warning for check_extent_item()
> FYI, I'm going to promote this series within devel and schedule it for
> the next release. The preparatory subset will be merged, but I might do
> some modificaions to the command line interface.
In current low memory fs trees check, it dose not check whether
node or leaf is shared, which will casue btrfsck much slower when
fs has one or more snapshots. I have prepared a patch to improve
this issue, if you have some free time, please check it, thanks.

And this patch is based on my previous patch "btrfs-progs: eliminate 
some unnecessary
btrfs_lookup_extent_info() calls in walk_down_tree()".


Regards,
Xiaoguang Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



