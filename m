Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41245 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751110AbdLRHEn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 02:04:43 -0500
From: Ravi Hale <tom@hale.ee>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Date: Mon, 18 Dec 2017 14:04:38 +0700
Message-ID: <16068704b70.277a.1243720eb903aaa2f74f5d2a8df9f525@hale.ee>
In-Reply-To: <19de77b6-0017-d172-993a-438d8bc9023d@gmx.com>
References: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>
 <19de77b6-0017-d172-993a-438d8bc9023d@gmx.com>
Subject: Re: How to repair errors only found with check --mode=lowmem
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My bad. 4.14.
-- 
Tom "Ravi" Hale

Sent from my phone, please excuse brevity



On 18 December 2017 08:10:18 Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
>
> On 2017年12月16日 23:41, Tom Hale wrote:
>> The following shows that errors are found with check --mode=lowmem, but
>> are not picked up without lowmem.
>
> Btrfs-progs version please.
>
> Depending on your btrfs-progs version, and the output, it's possible
> that they're just false alerts and should be addressed in latest version.
>
> Thanks,
> Qu
>
>>
>> How would I go about fixing errors only reported by lowmem?
>>
>> ----------------------------------------
>>
>> [manjaro manjaro]# btrfs check --mode=lowmem --progress
>> /dev/mapper/vg_svelte-home
>> Checking filesystem on /dev/mapper/vg_svelte-home
>> UUID: 93722fa7-7e8f-418a-a7ca-080aca8db94b
>> ERROR: extent[691815358464, 11042816] referencer count mismatch (root:
>> 257, owner: 1869679, offset: 613974016) wanted: 1, have: 2
>> ERROR: extent[720156536832, 99430400] referencer count mismatch (root:
>> 257, owner: 758215, offset: 1610616832) wanted: 8, have: 379
>> ERROR: extent[720669147136, 268435456] referencer count mismatch (root:
>> 257, owner: 758215, offset: 4096) wanted: 86, have: 1021
>> ERROR: extent[720669147136, 268435456] referencer count mismatch (root:
>> 257, owner: 1767807, offset: 4096) wanted: 87, have: 1021
>> ERROR: extent[726724722688, 64069632] referencer count mismatch (root:
>> 257, owner: 1480823, offset: 99090432) wanted: 1, have: 5
>> ERROR: extent[737910194176, 134217728] referencer count mismatch (root:
>> 257, owner: 1480726, offset: 268435456) wanted: 1, have: 8
>> ERROR: extent[738077896704, 134217728] referencer count mismatch (root:
>> 257, owner: 1869696, offset: 402653184) wanted: 5, have: 8
>> ERROR: extent[744334426112, 268435456] referencer count mismatch (root:
>> 257, owner: 1767802, offset: 0) wanted: 111, have: 294
>> ERROR: extent[824948670464, 1671168] referencer count mismatch (root:
>> 257, owner: 2000876, offset: 247861248) wanted: 16, have: 26
>> ERROR: data extent[681550843904 8192] backref lost
>> ERROR: errors found in extent allocation tree or chunk allocation
>> cache and super generation don't match, space cache will be invalidated
>> ERROR: errors found in fs roots
>> found 172094545920 bytes used, error(s) found
>> total csum bytes: 165679768
>> total tree bytes: 3066789888
>> total fs tree bytes: 2751315968
>> total extent tree bytes: 112295936
>> btree space waste bytes: 568660274
>> file data blocks allocated: 8158426562560
>>  referenced 597269540864
>> [manjaro manjaro]# btrfs check --repair  --progress
>> /dev/mapper/vg_svelte-home
>> enabling repair mode
>> Checking filesystem on /dev/mapper/vg_svelte-home
>> UUID: 93722fa7-7e8f-418a-a7ca-080aca8db94b
>> checking extents [.]
>> Fixed 0 roots.
>> cache and super generation don't match, space cache will be invalidated
>> checking fs roots [o]
>> checking csums
>> checking root refs
>> found 172091723777 bytes used, no error found
>> total csum bytes: 165679768
>> total tree bytes: 2003206144
>> total fs tree bytes: 1687732224
>> total extent tree bytes: 112295936
>> btree space waste bytes: 346177995
>> file data blocks allocated: 5952940838912
>>  referenced 474676633600
>> [manjaro manjaro]#
>>
>> ----------------------------------------
>>
>


