Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48732 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752765AbdDMAmt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 20:42:49 -0400
Subject: Re: [PATCH] fstests: introduce btrfs-map-logical
To: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1491960463-28680-1-git-send-email-bo.li.liu@oracle.com>
 <5d7f7d05-b7af-5d8d-93f6-0db2db4ade85@cn.fujitsu.com>
 <20170412123201.GG4781@twin.jikos.cz> <20170412125222.GI4781@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2842eab0-6295-d81d-6c7e-da52d4e00755@cn.fujitsu.com>
Date: Thu, 13 Apr 2017 08:42:43 +0800
MIME-Version: 1.0
In-Reply-To: <20170412125222.GI4781@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/12/2017 08:52 PM, David Sterba wrote:
> On Wed, Apr 12, 2017 at 02:32:02PM +0200, David Sterba wrote:
>> On Wed, Apr 12, 2017 at 09:35:00AM +0800, Qu Wenruo wrote:
>>>
>>>
>>> At 04/12/2017 09:27 AM, Liu Bo wrote:
>>>> A typical use case of 'btrfs-map-logical' is to translate btrfs logical
>>>> address to physical address on each disk.
>>>
>>> Could we avoid usage of btrfs-map-logical here?
>>
>> Agreed.
>>
>>> I understand that we need to do corruption so that we can test if the
>>> repair works, but I'm not sure if the output format will change, or if
>>> the program will get replace by "btrfs inspect-internal" group.
>>
>> In the long-term it will be repleaced, but there's no ETA.
> 
> Possibly, if fstests maintainer agrees, we can add btrfs-map-logical to
> fstests. It's small and uses headers from libbtrfs, so this would become
> a new dependency but I believe is still bearable.
> 
> I'm not sure if we should export all debuging functionality in 'btrfs'
> as this is typically something that a user will never want, not even in
> the emergency environments. There's an overlap in the information to be
> exported but I'd be more inclined to satisfy user needs than testsuite
> needs. So an independent tool would give us more freedom on both sides.
> 
I'm working on the new btrfs-corrupt-block equivalent, considering the 
demand to corrupt on-disk data for recovery test, I could provide tool 
with fundamental corruption support.

Which could corrupt on-disk data, either specified by (root, inode, 
offset, length) or just (logical address, length).
And support to corrupt given mirror or even P/Q for RAID56.
(With btrfs_map_block_v2 from offline scrub)

I'm not sure if I should just replace btrfs-corrupt-block or add a new 
individual prog or add a btrfs subcommand group which is disabled by 
default?

Thanks,
Qu


