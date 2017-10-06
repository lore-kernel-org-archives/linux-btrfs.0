Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64564 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751395AbdJFBe6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Oct 2017 21:34:58 -0400
Subject: Re: [PATCH 1/5] btrfs-progs: check: return value of
 check_extent_refs()
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
 <20170927063440.25961-2-suy.fnst@cn.fujitsu.com>
 <20171005174625.GM3521@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <32020668-72b8-fe0c-cb13-145a46d1cbfe@cn.fujitsu.com>
Date: Fri, 6 Oct 2017 09:38:05 +0800
MIME-Version: 1.0
In-Reply-To: <20171005174625.GM3521@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/06/2017 01:46 AM, David Sterba wrote:
> On Wed, Sep 27, 2017 at 02:34:36PM +0800, Su Yue wrote:
>> In original check mode(without option "--repair"), check_extent_refs()
>> always returns 0.
>>
>> Add a variable @error to record status while checking extents.
>> At the end of check_extent_refs(), let it return -EIO if @error is
>> nonzero.
>>
>> Example:
>> $ btrfs check bad-extent-inline-ref-type.raw
>> Checking filesystem on bad-extent-inline-ref-type.raw
>> UUID: 1942d6fe-617b-4499-9982-cc8ffae5447f
>> checking extents
>> corrupt extent record: key 29360128 169 16384
>> ref mismatch on [29360128 16384] extent item 0, found 1
>> Backref 29360128 parent 5 root 5 not found in extent tree
>> backpointer mismatch on [29360128 16384]
>> bad extent [29360128, 29376512), type mismatch with chunk
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 114688 bytes used, no error found
>> total csum bytes: 0
>> total tree bytes: 114688
>> total fs tree bytes: 32768
>> total extent tree bytes: 16384
>> btree space waste bytes: 109471
>> file data blocks allocated: 0
>>   referenced 0
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> With this patch applied, the test fsck/006 fails, is that intentional?
> 
Yes, it's expected. This patch just let btrfs-progs return a correct
value.

> Log from the last failing testcase:
> 
> checking extents
> ref mismatch on [15474688 905216] extent item 1, found 4
> Data backref 15474688 parent 31817728 owner 0 offset 0 num_refs 0 not found in extent tree
> Incorrect local backref count on 15474688 parent 31817728 owner 0 offset 0 found 1 wanted 0 back 0x12d02f0
> Data backref 15474688 parent 30883840 owner 0 offset 0 num_refs 0 not found in extent tree
> Incorrect local backref count on 15474688 parent 30883840 owner 0 offset 0 found 1 wanted 0 back 0x12cd710
> Data backref 15474688 parent 31326208 owner 0 offset 0 num_refs 0 not found in extent tree
> Incorrect local backref count on 15474688 parent 31326208 owner 0 offset 0 found 1 wanted 0 back 0x12d2b80
> backpointer mismatch on [15474688 905216]
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on test.img
> UUID: 3857c23d-4219-4600-a636-ac7707dc4ff3
> cache and super generation don't match, space cache will be invalidated
> found 6291456 bytes used, error(s) found
> total csum bytes: 660
> total tree bytes: 786432
> total fs tree bytes: 688128
> total extent tree bytes: 16384
> btree space waste bytes: 459860
> file data blocks allocated: 35536896
>   referenced 25890816
> failed: /mnt/big/dsterba/backup-labs-subv/gits/btrfs-progs/btrfs check test.img
> 
The log shows that there are errors in the extent-tree but no error
value returned.

And the abormal output was caused by commit 1f728b1a514f ("Btrfs-
progs,fsck: move root items repair after root rebuilding").

> I haven't tried with the other patches applied, so it might get actually fixed.
> Even in that case, I'd rather keep the branches bisectable.
> 
It is described and fixed by the second and third patch in the
patchset.

Thanks,
Su
> 


