Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755286AbcHXSRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 14:17:47 -0400
Subject: Re: [PATCH] Btrfs: handle pending renames with recycled inodes
 properly
To: <fdmanana@gmail.com>
References: <1471972923-4833-1-git-send-email-jbacik@fb.com>
 <CAL3q7H6pnkr+BDyAc4sMo7i15Lrmee+GUfc6cJnBFfpOFJVZiQ@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <kernel-team@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <6e411424-555d-8052-7f49-08351a444c91@fb.com>
Date: Wed, 24 Aug 2016 14:17:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6pnkr+BDyAc4sMo7i15Lrmee+GUfc6cJnBFfpOFJVZiQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/24/2016 05:07 AM, Filipe Manana wrote:
> On Tue, Aug 23, 2016 at 6:22 PM, Josef Bacik <jbacik@fb.com> wrote:
>> Suppose you have the following tree in snap1 on a file system mounted with -o
>> inode_cache so that inode numbers are recycled
>>
>> └── [    258]  a
>>     └── [    257]  b
>>
>> and then you remove b, rename a to c, and then re-create b in c so you have the
>> following tree
>>
>> └── [    258]  c
>>     └── [    257]  b
>>
>> and then you try to do an incremental send you will hit
>>
>> ASSERT(pending_move == 0);
>
> Hi Josef,
>
> Would you care submitting a regression test for xfstests?
> The change looks good to me.
>

Yeah I sent one yesterday, btrfs/131.  Thanks,

Josef

