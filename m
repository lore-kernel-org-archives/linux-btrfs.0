Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44447 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751783AbcISSul (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:50:41 -0400
Subject: Re: [PATCH] btrfs: Fix handling of -ENOENT from btrfs_uuid_iter_rem
To: <dsterba@suse.cz>, Nikolay Borisov <kernel@kyup.com>,
        <linux-btrfs@vger.kernel.org>
References: <b369cabe-9269-800c-cce7-5f5c71147660@fb.com>
 <1473233938-21560-1-git-send-email-kernel@kyup.com>
 <20160919181315.GS16983@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <2c9c27c6-5e2d-5035-de11-0cf021dfd9a1@fb.com>
Date: Mon, 19 Sep 2016 14:49:41 -0400
MIME-Version: 1.0
In-Reply-To: <20160919181315.GS16983@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2016 02:13 PM, David Sterba wrote:
> On Wed, Sep 07, 2016 at 10:38:58AM +0300, Nikolay Borisov wrote:
>> btrfs_uuid_iter_rem is able to return -ENOENT, however this condition
>> is not handled in btrfs_uuid_tree_iterate which can lead to calling
>> btrfs_next_item with freed path argument, leading to a null pointer
>> dereference. Fix it by redoing the search but with an incremented
>> objectid so we don't loop over the same key.
>>
>> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
>> Suggested-by: Chris Mason <clm@fb.com>
>> Link: https://lkml.kernel.org/r/57A473B0.2040203@kyup.com
>
> I'll queue the patch for 4.9, thanks.
>

Not having a good test for this kept me from trying the patch cold.  I 
think bumping the objectid will end up missing items.

We know its returning -ENOENT, so it should in theory be enough to just 
goto again_search_slot, assuming that we just raced with the deletion.

-chris
