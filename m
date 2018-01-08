Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754955AbeAHDQx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jan 2018 22:16:53 -0500
Subject: Re: [PATCH] btrfs: add missing BTRFS_SUPER_FLAG define
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180105092422.9794-1-anand.jain@oracle.com>
 <20180105142606.GO3553@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2824fe75-94fe-ba4b-2b86-66255d188df7@oracle.com>
Date: Mon, 8 Jan 2018 11:17:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180105142606.GO3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/05/2018 10:26 PM, David Sterba wrote:
> On Fri, Jan 05, 2018 at 05:24:22PM +0800, Anand Jain wrote:
>> btrfs-progs uses additional two super flag bits. So just define
>> that so that we know its been used.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> The btrfs-progs commits (very old) introduced them,
>>
>>   commit 7cc792872a133cabc3467e6ccaf5a2c8ea9e5218
>>      btrfs-progs: Add CHANGING_FSID super flag
>>
>>   commit 797a937e5dd8db0092add633a80f3cd698e182df
>>      Btrfs-progs: Introduce metadump_v2
>>
>> Appears that we need bit of support from the kernel side like
>> failing to mount if CHANGING_FSID is set. And device mounted
>> with metadump_v2 flag is kind of broken on the kernel side
>> as of now, this patch does not fix those.
> 
> Please add the code that uses the flags, at least the for the pending
> uuid change.

  OK. I have sent them as a set.
   [PATCH 1/2] btrfs: add missing BTRFS_SUPER_FLAG define
   [PATCH 2/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in btrfs.ko


Thanks, Anand
