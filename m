Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63962 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752832AbdFWB1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 21:27:25 -0400
Subject: Re: Stability status of btrfs-convert...
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
 <c32c656c-fb94-e44c-fcf6-0f0c352c75b1@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <98355296-e1fe-7de7-d97f-8ca6dd8eaa29@cn.fujitsu.com>
Date: Fri, 23 Jun 2017 09:27:16 +0800
MIME-Version: 1.0
In-Reply-To: <c32c656c-fb94-e44c-fcf6-0f0c352c75b1@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/22/2017 07:31 PM, Austin S. Hemmelgarn wrote:
> On 2017-06-22 05:37, Shyam Prasad N wrote:
>> Hi,
>>
>> I'm planning to use the btrfs-convert tool to convert production data
>> in ext4 filesystem into btrfs.
>> What is the stability status of this feature?
>>
>> As per the below link, this tool is not in frequent use in latest 
>> linux kernels.
>> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>>
>> Can I know the reason why? Is it because most existing ext4
>> filesystems are already converted?
>> Is this tool supported, at least? Can I use this tool as a part of
>> software upgrade to change the data filesystem to btrfs?
> Yes, it's supported, but unless you need the ability to switch back as 
> quickly as possible, you are almost certainly better off restoring data 
> from a fresh backup onto a new BTRFS filesystem than you are converting 
> it in-place.  I have heard of no currently extant bugs in btrfs-convert, 
> but they usually don't show up immediately, and even if there are no 
> bugs, you still end up with a very sub-optimal on-device layout which 
> isn't even completely fixed by deleting the ext4 metadata and 
> re-balancing, and that will in turn hurt performance somewhat.  At a 
> minimum, I would suggest running e4defrag over the whole filesystem 
> prior to converting, as that will at least reduce the degree of 
> fragmentation you start with.

Although the tool *seems* stable in recent releases, but Austin is right:

The converted btrfs extent layout is not the same as normal btrfs.

The difference is:
1) Chunk fragments
    Due to the fact that btrfs MUST put all old ext* data into DATA
    chunks, data chunk size is smaller than normal btrfs.
    Although this can be somewhat addressed by deleting ext* subvolume
    and then do a balance.

2) More shared extents
    Unlike normal btrfs usage, convert create as large extent as possible
    to cover all ext* used data, then create file/dir layous reusing
    (reflinking) the those large extents.
    This heavy use of reflink is normally observed in dedupe, but without
    any space saving.

    The behavior itself is completely valid for btrfs, but this makes us
    quite hard to free disk space.

    Just deleting ext* subvolume can't really free much space now.
    Defrag should handle it but it's not working for shared extents for a
    long time.


So the short conclusion is:
a) Convert is good if you want to try btrfs using old ext* data
    As you can rollback without losing any data.
    And it's super fast compared to copying data from backup.

b) You can use converted btrfs without problem for a short time
    The converted btrfs is a completely valid btrfs, although not
    as normal as original btrfs.
    You can take full advantage of btrfs features, from snapshot to
    offline dedupe.

c) If you want to use converted btrfs in long term, at least
    keep an eye on the available space.
    Converted btrfs layout makes it hard to free space of ext* data.
    And there is no working defragmentation for shared extent, user
    should pay extra attention of the available space.

Thanks,
Qu

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


