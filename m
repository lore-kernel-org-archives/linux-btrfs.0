Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdLEBwx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 20:52:53 -0500
Subject: Re: [PATCH v2 0/5] define BTRFS_DEV_STATE
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171204045456.8602-1-anand.jain@oracle.com>
 <20171204202842.GB3553@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c152b897-2309-18ac-cf78-e4215973dcbd@oracle.com>
Date: Tue, 5 Dec 2017 09:20:38 +0800
MIME-Version: 1.0
In-Reply-To: <20171204202842.GB3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/05/2017 04:28 AM, David Sterba wrote:
> On Mon, Dec 04, 2017 at 12:54:51PM +0800, Anand Jain wrote:
>> As of now device properties and states are being represented as int
>> variable. So clean that up using bitwise operations. Also patches in
>> the ML such as device failed state needs this cleanup as well.
>>
>> V2:
>>   Accepts all comments from Nikolay.
>>   Drops can_discard.
>>   Adds BTRFS_DEV_STATE_REPLACE_TGT and BTRFS_DEV_STATE_FLUSH_SENT
>>      patches.
>>
>> Anand Jain (5):
>>    btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
>>    btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
>>    btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
>>    btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
>>    btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT
> 
> 1-5 added to next. I had to tweak the whitespace in the conditions.

  Oops I did run, checkpatch, not too sure how did I still missed it.
  Sorry about that. Thanks.
  Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
