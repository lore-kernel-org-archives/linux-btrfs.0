Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59056 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbdIPBPx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 21:15:53 -0400
Subject: Re: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: dsterba@suse.cz, kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
 <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
 <20170912170304.GD29043@twin.jikos.cz>
 <0a949fd9-f0cf-22c5-4e91-ebb1bfad1355@libero.it>
 <20170912180753.GI29043@suse.cz>
 <0c906ea3-bfdb-a088-f940-4b63a3da8d2f@gmx.com>
 <20170915125605.GY29043@twin.jikos.cz>
 <9d514995-7706-0157-6b98-93632fe3dce7@gmx.com>
 <20170915154803.GA29043@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ab64da7a-c974-2f5c-ba4a-49a9560a2ea9@gmx.com>
Date: Sat, 16 Sep 2017 09:15:38 +0800
MIME-Version: 1.0
In-Reply-To: <20170915154803.GA29043@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月15日 23:48, David Sterba wrote:
> On Fri, Sep 15, 2017 at 09:24:19PM +0800, Qu Wenruo wrote:
>>> I'm going to review & merge this series to devel. Tests and
>>> documentation should be updated to make the usecase clear.
>>
>> I'm happy to address any comment, both code and doc/test.
> 
> For the tests I'd like to see:
> 
> * with file target, try non-existent file, zero-length file, too-small
>    file and large-enough

No problem.

But it would be better to define the expected behavior first.
I'll show the behavior difference below to see if you're OK with it.

For non-existent file:
New: Fail, no such file at the very beginning
Old: Create new one

Zero-length:
New: Fail, too small file at the very beginning
Old: Expand file and continue mkfs

Too-small:
New: Fail, showing -28 errno half way
Old: Same as zero length.

Large-enough:
New: Success, without shrink
Old: Success, shrink

> 
> * for block device target, I think loop device would do, too-small and
>    large-enough

Same as above too-small and large-enough case.

> 
> * after the test, verify that the files have same size and contents

I'll reuse convert facilities to do that.

And I'll add one extra test case:
No enough privilege to read some file in the directory:
New: Fail gracefully
Old: Fail with BUG_ON.

If you're OK with the behavior difference, I'll create new test cases 
for mkfs --rootdir.

Thanks,
Qu
