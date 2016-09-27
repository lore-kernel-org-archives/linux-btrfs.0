Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:20576 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753070AbcI0GlK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 02:41:10 -0400
Subject: Re: deadlock with btrfs heavy i/o and kswapd
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <281582c9-1307-612e-77e6-9d768337ea3e@profihost.ag>
 <8116272d-6c30-431a-c3e1-781b17bea2c6@fb.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <0cd5ff1d-f3ef-ccfb-4460-884470dab199@profihost.ag>
Date: Tue, 27 Sep 2016 08:41:06 +0200
MIME-Version: 1.0
In-Reply-To: <8116272d-6c30-431a-c3e1-781b17bea2c6@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

today i had this again. But i can't see any stack traces. I just see.

INFO: kworker/u128:5:24301 blocked for more than 120 seconds.
...
INFO: kworker/u128:5:24301 blocked for more than 120 seconds.
...
INFO: task mysqld:929 blocked for more ...
...

sysrq w just prints:
sysrq: SysRq: Show Blcoked State

but nothing more.

Stefan
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
> 
> -chris
> 
