Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41542 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751061AbcIBAhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 20:37:35 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Chris Murphy <lists@colorremedies.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <027906e0-0a81-460e-4ea2-ecf5f099a5a5@cn.fujitsu.com>
Date: Fri, 2 Sep 2016 08:37:28 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/01/2016 05:44 AM, Chris Murphy wrote:
> On Wed, Aug 31, 2016 at 2:49 PM, Ronan Arraes Jardim Chagas
> <ronisbr@gmail.com> wrote:
>> Hi guys!
>>
>> And the problem happened again. This time, I was only using Mozilla
>> Firefox. I could get the very first message after the error. I hope it
>> brings more information:
>>
>> [28039.672199] ------------[ cut here ]------------
>> [28039.672253] WARNING: CPU: 3 PID: 31800 at ../fs/btrfs/qgroup.c:2667
>> btrfs_qgroup_free_meta+0x88/0x90 [btrfs]
>
>
> Does this file system have quota enabled?
>
> I'm testing this right now and can't even figure out how to determine
> when quota is enabled on a Btrfs file system. There's enable, disable,
> and rescan. If it's enabled or disabled, I get the same message if I
> rescan. If I mount the file system with quota previously enabled,
> there is no mount time notification that quota is enabled.
>
> I sincerely hope opensuse isn't enabled quota by default.
>
>
>
The　kernel warning is interesting.

It means qgroup is underflowing its reserved metadata space.
However although it's a warning, it won't really under flow the numbers, 
but decrease it to zero.

It shows there is something wrong with metadata allocation, but won't 
directly cause quota corruption.

Quota uses two isolated different system, one extent based for qgroup 
numbers,
and one reserved space based for reserved space.

The latter one is only used to prevent user from exceeding qgroup limit, 
and if user doesn't use limit, it won't cause any qgroup corruption or 
ENOSPC.

Further more, if it's qgroup reserved space causing anything wrong, it 
won't return -ENOSPC, but -EDQUOT.

So, just as Wang suspected, there is something wrong with metadata 
allocation, causing the problem and triggering the qgroup warning.

Thankg,
Qu


