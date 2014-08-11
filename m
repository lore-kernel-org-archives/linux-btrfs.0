Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48976 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751100AbaHKQlp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 12:41:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 11 Aug 2014 10:41:43 -0600
From: lists@colorremedies.com
To: Chris Murphy <lists@colorremedies.com>
Cc: fdmanana@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] btrfs send/receive, page allocation failure
In-Reply-To: <A0E5F699-0F52-4CD4-B60E-42010C6C3361@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
 <CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
 <CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
 <16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com>
 <CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com>
 <51F1A674-280C-4AF9-93BD-82B38F8E9C92@colorremedies.com>
 <CAL3q7H7MfE84dgfS==HbKE5N9_MiznYM5B6gMN7xQjX5nhKE0Q@mail.gmail.com>
 <A0E5F699-0F52-4CD4-B60E-42010C6C3361@colorremedies.com>
Message-ID: <6316ceac72f53e0500b28f60ef280ad6@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-08-11 10:25, Chris Murphy wrote:
> On Aug 11, 2014, at 10:04 AM, Filipe David Manana <fdmanana@gmail.com> 
> wrote:
> 
>> On Mon, Aug 11, 2014 at 4:55 PM, Chris Murphy 
>> <lists@colorremedies.com> wrote:
>>> 
>>> On Aug 11, 2014, at 2:46 AM, Filipe David Manana <fdmanana@gmail.com> 
>>> wrote:
>>> 
>>>> On Mon, Aug 11, 2014 at 4:07 AM, Chris Murphy 
>>>> <lists@colorremedies.com> wrote:
>>>>>> 
>>>>>> 
>>>>>> Can you try the following patch and confirm if it helps?
>>>>>> https://patchwork.kernel.org/patch/4705171/
>>>>> 
>>>>> This one applies without problems, I didn't build it because I saw 
>>>>> v4. The v4 patch I get:
>>>>> 
>>>>> + patch -p1 -F1 -s
>>>>> 4 out of 4 hunks FAILED -- saving rejects to file 
>>>>> fs/btrfs/send.c.rej
>>>>> 
>>>>> Should v4 alone be applied over 3.16.0? Or each version in 
>>>>> succession?
>>>> 
>>>> Alone. How did you try to apply it to 3.16?
>>> 
>>> rpmbuild
>>> https://fedoraproject.org/wiki/Building_a_custom_kernel
>>> 
>>> Gist is, save the patch, create patch filename entry into 
>>> kernel.spec, then run rpmbuild. rpmbuild uses 'patch -p1 -F1 -s' to 
>>> apply the patch. The v1 patch applies, as does Liu Bo's patch from 
>>> July 29 "Btrfs: fix regression of btrfs device replace" which I was 
>>> also going to test. But the v4 patch isn't applying.
>>> 
>>>> Try "cd source_dir && git
>>>> am patchfile" if you didn't (e.g. you used patch command directly).
>>> 
>>> I'd kinda prefer to build an rpm since I need to test it on baremetal 
>>> for this bug, and a VM for the device replace bug.
>> 
>> Sorry, I don't know anything about fedora's way of kernel patching.
>> Either way, it seems the problem is simple to solve:
>> 
>> git clone 
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> git checkout v3.16
>> git am /path/to/my_patch_file
>> git diff HEAD^..HEAD > /tmp/diff
>> 
>> The resulting patch file [1] /tmp/diff then applies cleanly with
>> "patch -p1 -F1 -s"
>> 
>> https://friendpaste.com/Bgwdjk31P3pZHtArr341G
> 
> OK that friendpaste is completely different than the [PATCH v4] email.
> 
> # from above URL
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 6528aa6..95891c0 100644
> 
> # from [PATCH v4] email
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3c63b29..b29fc5c 100644
> 
> The lines numbers are all completely different also. I'll try the
> patch from the above URL.

The above friendpaste URL patch has applied, and I'm now building.


Chris Murphy
