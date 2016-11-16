Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52345 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752820AbcKPO0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 09:26:20 -0500
Subject: Re: [PATCH 1/2] Btrfs: fix file extent corruption
To: <bo.li.liu@oracle.com>
References: <1479150382-19273-1-git-send-email-jbacik@fb.com>
 <20161114231109.GA19953@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <fd55dad9-e8e6-2b47-87c8-197b2b8b2382@fb.com>
Date: Wed, 16 Nov 2016 09:26:05 -0500
MIME-Version: 1.0
In-Reply-To: <20161114231109.GA19953@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/14/2016 06:11 PM, Liu Bo wrote:
> On Mon, Nov 14, 2016 at 02:06:21PM -0500, Josef Bacik wrote:
>> In order to do hole punching we have a block reserve to hold the reservation we
>> need to drop the extents in our range.  Since we could end up dropping a lot of
>> extents we set rsv->failfast so we can just loop around again and drop the
>> remaining of the range.  Unfortunately we unconditionally fill the hole extents
>> in and start from the last extent we encountered, which we may or may not have
>> dropped.  So this can result in overlapping file extent entries, which can be
>> tripped over in a variety of ways, either by hitting BUG_ON(!ret) in
>> fill_holes() after the search, or in btrfs_set_item_key_safe() in
>> btrfs_drop_extent() at a later time by an unrelated task.  Fix this by only
>> setting drop_end to the last extent we did actually drop.  This way our holes
>> are filled in properly for the range that we did drop, and the rest of the range
>> that remains to be dropped is actually dropped.  Thanks,
>
> Can you pleaes share the reproducer?
>

Yup here you go

https://paste.fedoraproject.org/483195/30633414

Thanks,

Josef
