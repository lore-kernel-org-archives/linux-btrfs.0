Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:28524 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbeEQI0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 04:26:20 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id BE9DAAC02B0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 17:26:15 +0900 (JST)
Subject: Re: [PATCH v5 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <1de3700b-47ef-979a-3c72-8897601b2214@gmx.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <12111e16-91f6-c6e3-338e-0192ad03adad@jp.fujitsu.com>
Date: Thu, 17 May 2018 17:25:50 +0900
MIME-Version: 1.0
In-Reply-To: <1de3700b-47ef-979a-3c72-8897601b2214@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/05/17 15:56, Qu Wenruo wrote:
> 
> 
> On 2018年05月16日 13:49, Tomohiro Misono wrote:
>> [based on current misc-next]
>>
>> changelog:
>> v4 -> v5
>>   - Update error handling of 1st/2nd patch. See each log for details
>>   - Fix misspelling
>> v3 -> v4
>>   - call btrfs_next_leaf() after btrfs_search_slot() when the slot
>>     position exceeds the number of items
>>   - rebased to current misc-next
>> v2 -> v3
>>   - fix kbuild test bot warning
>> v1 -> v2
>>   - completely reimplement 1st/2nd ioctl to have user friendly api
>>   - various cleanup, remove unnecessary goto
>> ===
>>
>> This adds three new unprivileged ioctls:
>>
>> 1st patch:
>>   ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
>> 2nd patch:
>>   ioctl which returns subvolume information of ROOT_REF (without subvolume name)
> 
> First 2 patches looks mostly fine.
> 
>> 3rd patch: 
>>   user version of ino_lookup ioctl which also performs permission check.
> 
> I'm a little concerned about this.
> 
> What will happen in the following scenario?
> - Environment is container whose rootfs is a subvolume of btrfs
> - The root and normal use try to call subvolume list on their rootfs
> 
> Will it leak the real subvolume layout to the container root/normal user?
> 
> Or it will leak anyway even without the unprivileged ioctl?

Hi,

I'm not sure about container, but these ioctls searches subvolume (fs tree) of
fd with witch ioctl is called (i.e. the caller needs to open the subvolume first)
and cannot search arbitrary tree. So, normal user can only get the information
under the rootfs's subvolume.

On the other and, root can use TREE_SEARCH/INO_LOOKUP ioctl too which can search
arbitrary tree and get all info. So, I think root can get real layout.

Does this answer make sense?

> 
> Thanks,
> Qu
> 
>>
>> They will be used to implement user version of "subvolume list/show" etc.
>> in user tools.
>> See each commit log for more detals.
>>
>> The implementation of btrfs-progs can be found in the ML titled as follows: 
>>   [PATCH 0/11] btrfs-progs: Rework of "subvolume list/show" and relax the root privileges of them
>>
>> Tomohiro Misono (3):
>>   btrfs: Add unprivileged ioctl which returns subvolume information
>>   btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
>>   btrfs: Add unprivileged version of ino_lookup ioctl
>>
>>  fs/btrfs/ioctl.c           | 452 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/btrfs.h |  84 +++++++++
>>  2 files changed, 536 insertions(+)
>>
> 

