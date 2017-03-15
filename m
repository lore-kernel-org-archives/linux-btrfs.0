Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14224 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750853AbdCOAfS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 20:35:18 -0400
Subject: Re: [PATCH v3 0/7] convert: rollback rework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
 <20170314115506.GT14605@twin.jikos.cz> <20170314115554.GU14605@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <01347a96-33eb-f028-fb09-08f44fdfc945@cn.fujitsu.com>
Date: Wed, 15 Mar 2017 08:35:06 +0800
MIME-Version: 1.0
In-Reply-To: <20170314115554.GU14605@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/14/2017 07:55 PM, David Sterba wrote:
> On Tue, Mar 14, 2017 at 12:55:06PM +0100, David Sterba wrote:
>> On Tue, Mar 14, 2017 at 04:05:02PM +0800, Qu Wenruo wrote:
>>> v2:
>>>   Abstract the original code to read out data in one btrfs file to
>>>   btrfs_read_file().
>>>   Use simple_range and btrfs_reserved_ranges[] to cleanup open code.
>>> v3:
>>>   Rebased to v4.10.
>>>   Squash modification in later commits to their previous owner.
>>>   Fix a converity report, which doesn't exit when an error is found in
>>>   check_convert_image()
>>>   Fix a lot of check scripts warning
>>
>> I did not mention that explicitly under v2, but the series has been
>> merged to devel so incremental changes should be sent from now on.

Sorry, but IIRC it's recommended to base the code to latest 
stable/release branch, so I rebase them all to v4.10 code base.
(Last time you said basing code upon devel is quite a bad behavior and 
makes merging painful)

And yes, it's quite a pain to rebase them. I totally understand the pain 
during the v4.9.1->v4.10 rebase.

>> I
>> went through the patches almost line by line and fixed things here and
>> there. The patchset-to-patchset diff is not large (attached).

Sorry for the trouble and thanks for the effort.

But I'm afraid it may still happen time by time.
As you already see, we have several pending big patchset for btrfs-progs.
(Lowmem mode repair, offline scrub, and maybe some other things)

So to save your time, could you info us before merging large patchset 
and provide a base commit for us to rebase for you?

I think this would save time for both.

Thanks,
Qu
>
> Now attached.
>
>


