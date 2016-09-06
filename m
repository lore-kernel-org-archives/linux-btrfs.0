Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933444AbcIFMyL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 08:54:11 -0400
Subject: Re: [PATCH] btrfs: let btrfs_delete_unused_bgs() to clean relocated
 bgs
To: Naohiro Aota <Naohiro.Aota@hgst.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1472802392-10851-1-git-send-email-naohiro.aota@hgst.com>
 <b5c2852a-fe0a-834e-0fcd-2b61b5c47088@fb.com>
 <1473049955.14093.37.camel@hgst.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsterba@suse.com" <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <698d961a-23a5-bb75-b220-8d9cd5658873@fb.com>
Date: Tue, 6 Sep 2016 08:52:57 -0400
MIME-Version: 1.0
In-Reply-To: <1473049955.14093.37.camel@hgst.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2016 12:32 AM, Naohiro Aota wrote:
> 2016-09-02 (金) の 09:35 -0400 に Josef Bacik さんは書きました:
>> On 09/02/2016 03:46 AM, Naohiro Aota wrote:
>>>
>>> Currently, btrfs_relocate_chunk() is removing relocated BG by
>>> itself. But
>>> the work can be done by btrfs_delete_unused_bgs() (and it's better
>>> since it
>>> trim the BG). Let's dedupe the code.
>>>
>>> While btrfs_delete_unused_bgs() is already hitting the relocated
>>> BG, it
>>> skip the BG since the BG has "ro" flag set (to keep balancing BG
>>> intact).
>>> On the other hand, btrfs cannot drop "ro" flag here to prevent
>>> additional
>>> writes. So this patch make use of "removed" flag.
>>> btrfs_delete_unused_bgs() now detect the flag to distinguish
>>> whether a
>>> read-only BG is relocating or not.
>>>
>>
>> This seems racey to me.  We remove the last part of the block group,
>> it ends up
>> on the unused_bgs_list, we process this list, see that removed isn't
>> set and we
>> skip it, then later we set removed, but it's too late.  I think the
>> right way is
>> to actually do a transaction, set ->removed, manually add it to the
>> unused_bgs_list if it's not already, then end the transaction.  This
>> way we are
>> guaranteed to have the bg on the list when it is ready to be
>> removed.  This is
>> my analysis after looking at it for 10 seconds after being awake for
>> like 30
>> minutes so if I'm missing something let me know.  Thanks,
>
> I don't think a race will happen. Since we are holding
> delete_unused_bgs_mutex here, btrfs_delte_unused_bgs() checks ->removed
> flag after we unlock the mutex i.e. we setup the flag properly. For a
> case btrfs_delete_usused_bgs() checks the BG before we hold
> delte_unused_bgs_mutex, then that BG is removed by it (if it's empty)
> and btrfs_relocate_chunk() should never see it.
>

Ok that's what I was missing, thanks

Reviewed-by: Josef Bacik <jbacik@fb.com>

Josef

