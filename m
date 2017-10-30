Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:27191 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751310AbdJ3Bve (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 21:51:34 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: Re: [stable] btrfs name length fixes
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Ben Hutchings <ben@decadent.org.uk>
CC: <linux-btrfs@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <1509297309.2721.73.camel@decadent.org.uk>
 <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
Message-ID: <f120a6f9-6c38-4719-efdc-2199a2ba4578@cn.fujitsu.com>
Date: Mon, 30 Oct 2017 09:55:03 +0800
MIME-Version: 1.0
In-Reply-To: <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the late reply.

On 10/30/2017 07:59 AM, Qu Wenruo wrote:
> 
> 
> On 2017年10月30日 01:15, Ben Hutchings wrote:
>> You recently made a number of fixes to validation and use of name
>> lengths in btrfs:
>>
>> 286b92f43c0d btrfs: tree-log.c: Wrong printk information about namelen
>> 19c6dcbfa746 btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary
>> e79a33270d05 btrfs: Check name_len with boundary in verify dir_item
>> 26a836cec2ea btrfs: Check name_len on add_inode_ref call path
>> 8ee8c2d62d5f btrfs: Verify dir_item in replay_xattr_deletes
>> 3c1d41844896 btrfs: Check name_len in btrfs_check_ref_name_override
>> 59b0a7f2c7c1 btrfs: Check name_len before read in iterate_dir_item
>> 488d7c456653 btrfs: Check name_len before reading btrfs_get_name
>> 64c7b01446f4 btrfs: Check name_len before in btrfs_del_root_ref
>> fbc326159a01 btrfs: Verify dir_item in iterate_object_props
>>
>> The bugs these are fixing probably should also be fixed on the affected
>> stable branches.  Do you agree?  Can you provide any guidance about how
>> far back these fixes would be needed?
> 
> These fixes will soon be replace by centralized tree-checker facilities.
> 

As Qu said, tree-checker facilities will verify name_len too and I think
it is indeed more proper than my patchset.

Thanks,
Su

> Thanks,
> Qu
> 
>>
>> Ben.
>>
> 


