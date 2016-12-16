Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33169 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933629AbcLPWrm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 17:47:42 -0500
Subject: Re: OOM: Better, but still there on 4.9
To: Michal Hocko <mhocko@kernel.org>
References: <20161215225702.GA27944@boerne.fritz.box>
 <20161216073941.GA26976@dhcp22.suse.cz>
 <1da4691d-d0da-a620-020c-c2e968c2a5ec@fb.com>
 <20161216221420.GF7645@dhcp22.suse.cz>
CC: Nils Holland <nholland@tisys.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, David Sterba <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <4e87e963-154a-df2c-80a4-ecc6d898f9a8@fb.com>
Date: Fri, 16 Dec 2016 17:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <20161216221420.GF7645@dhcp22.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2016 05:14 PM, Michal Hocko wrote:
> On Fri 16-12-16 13:15:18, Chris Mason wrote:
>> On 12/16/2016 02:39 AM, Michal Hocko wrote:
> [...]
>>> I believe the right way to go around this is to pursue what I've started
>>> in [1]. I will try to prepare something for testing today for you. Stay
>>> tuned. But I would be really happy if somebody from the btrfs camp could
>>> check the NOFS aspect of this allocation. We have already seen
>>> allocation stalls from this path quite recently
>>
>> Just double checking, are you asking why we're using GFP_NOFS to avoid going
>> into btrfs from the btrfs writepages call, or are you asking why we aren't
>> allowing highmem?
>
> I am more interested in the NOFS part. Why cannot this be a full
> GFP_KERNEL context? What kind of locks we would lock up when recursing
> to the fs via slab shrinkers?
>

Since this is our writepages call, any jump into direct reclaim would go 
to writepage, which would end up calling the same set of code to read 
metadata blocks, which would do a GFP_KERNEL allocation and end up back 
in writepage again.

We'd also have issues with blowing through transaction reservations 
since the writepage recursion would have to nest into the running 
transaction.

-chris

