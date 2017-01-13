Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45780 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750878AbdAMBOG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 20:14:06 -0500
Subject: Re: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
To: <lakshmipathi.g@giis.co.in>
References: <20170107231955.GA24631@fedori>
 <c9e21f30-2231-94cd-09ed-8422951e7b69@cn.fujitsu.com>
 <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
 <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
 <f5ef3a5bec7fccbd06559eda6a7cf59a@giis.co.in>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9592e847-74a9-d530-96a1-b7b8888975e3@cn.fujitsu.com>
Date: Fri, 13 Jan 2017 09:14:01 +0800
MIME-Version: 1.0
In-Reply-To: <f5ef3a5bec7fccbd06559eda6a7cf59a@giis.co.in>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/12/2017 10:37 PM, lakshmipathi.g@giis.co.in wrote:
> Hi Qu,
>
> Thanks for the details, I'll create image using these steps. Never used
> btrfs-image before will try it out.  in the mean time: I was thinking
> about these two approaches:
>
> --
> I agree on the dependency issue with btrfs-debug-tree. Test script will
> break if output is changed or jumbled.
> If btrfs-debug-tree is the only issue, possible solution can be :
>
> (a) when btrfs-debug-tree breaks the scripts add a backward captiable
> option (--print-old-format) for outputs. (or)
> (b) Use 'ls -i' to find the inode object id?  I guess that will be more
> reliable than parsing btrfs-debug-tree output.  (or)
> (c) may be use hard-corded id, if i'm not wrong, first object id will be
> always 256+1 = 257
>
> I slightly prefer script over image because:
> * It might be more easier to have script to add new functionality (ex:
> corrupt nlink field from hardlink)

Right, but btrfs-corrupt-block is no longer default installed and its 
options are badly arranged, with little documentation.

Quite a lot of its code is old and its output is quite hard to catch.

In short, it's just in bad shape.

> * It allows option to inject corruption sequentitally.
> ex: clean image->injection corrupt-x -> run btrfsck -> fixed image ->
> inject corruption 'variant of' x  -> repeat the process.
> * It might also be more easier to deal with possible RAID-based
> corruption test scripts.

Yes, RAID test indeed needs btrfs-corrupt-block support, just as fstests 
guys pointed out, but we really need to refact it before introducing new 
features.

Before we have a really good btrfs-corrupt-block, current image method 
seems to be best yet.

If btrfs-corrupt-block has the following feature, then I'm OK to convert 
to script based tests:

1) Able to corrupt things CoW or noCoW
    Only part of corruptions are noCow now.
    NoCow corruption is especially important for shared node/leaf case.

2) Ability to corrupt node/leaf header (Already supported)

3) Ability to corrupt data structure pinpointly
    This means, we should be able to corrupt given fields of specified
    data structures, at least covers the current fsck test cases.

    I see patches enhancing them, but 5) still makes them quite hard to
    use.

4) Better error handling and output.

5) Documentation
    No document for current btrfs-currupt-block, and this makes the
    options of it quite chaos and hard to use.
    (So normally I just hard code it to create test images)

But current one is far from those objectives, which makes it unpredictable.

And that's why we are still using binary images, because it's reliable 
and makes error always reproducible.

> --
>
> To my (QA) eyes, creating new image from 'mkfs.btrfs' for a each
> btrfs-progs version, injecting corruption (using ls -i output) and then
> verifying looks better. This way we can even catch any (rare) changes
> made to mkfs.btrfs. Script makes btrfsck heavily dependent on
> 'mkfs.btrfs' which is a good thing,imo.

IIRC current fsck-tests acts more or less like regression or corner-case 
tests.

And in this case, btrfsck dependent on mkfs.btrfs(or 
btrfs-corrupt-block) behavior makes us hard to trigger corner-case or 
regression which only happens on certain cases.

Thanks,
Qu

>
> Let me know your thoughts. thanks!
>
> Cheers.
> Lakshmipathi.G
>
>


