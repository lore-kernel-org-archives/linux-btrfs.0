Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:44554 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753006AbcIZG7w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 02:59:52 -0400
Subject: Re: deadlock with btrfs heavy i/o and kswapd
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <281582c9-1307-612e-77e6-9d768337ea3e@profihost.ag>
 <8116272d-6c30-431a-c3e1-781b17bea2c6@fb.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <648d83b8-21c3-fa81-cebc-6001b8d347e6@profihost.ag>
Date: Mon, 26 Sep 2016 08:59:48 +0200
MIME-Version: 1.0
In-Reply-To: <8116272d-6c30-431a-c3e1-781b17bea2c6@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 22.09.2016 um 16:28 schrieb Chris Mason:
> 
> 
> On 09/22/2016 02:41 AM, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> i always encounter btrfs deadlocks / hung tasks, when i have a lot of
>> cached mem and i'm doing heavy rsync --inplace operations in my system
>> from btrfs zlib compressed disk A to btrfs zlib compressed disk B.
>>
>> The last output i see in this case is kswapd0 running for a long time at
>> 100% cpu. Then the whole system get's stuck. I cannot connect to ssh
>> anymore but the kernel still prints hung tasks every few minutes.
>>
>> May be relevant the system has NO swap.
>>
>> vm.vfs_cache_pressure = 100
>> vm.swappiness = 50
> 
> Are you able to capture the stack dumps?  A sysrq-w would really help.

I wasn't as my netconsole didn't work even on the screen no traces were
visible. Currently i can't reproduce this. I'm still fighting with my
ENOSPC problems while using btrfs and reflinks which is a currently a
showstopper for me.

Greets,
Stefan

> -chris
> 
