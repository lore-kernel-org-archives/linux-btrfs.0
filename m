Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14477 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754597AbeGJBay (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 21:30:54 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, Su Yue <Damenly_Su@gmx.com>
References: <94caf6c5-77e1-3da0-d026-a29edb08d410@cn.fujitsu.com>
 <CAKhhfD6svMo=28_UX=ZjRRmF6zNadd3H+8vVZKGX4zjqVr-giw@mail.gmail.com>
 <3a83cb3c-de2b-e803-f07e-31f7de0ee25f@cn.fujitsu.com>
 <b1b2d361-eb1a-f172-45d3-409abd131d2b@cn.fujitsu.com>
 <20180705153023.GA30566@merlins.org>
 <trinity-d028b6bd-31d9-41c0-a091-47bcb810cdc3-1530808069711@msvc-mesg-gmx023>
 <20180705165049.t56dvqpz7ljjan5c@merlins.org>
 <trinity-79578bdf-a849-4342-a082-f2b882f2251e-1530810500266@msvc-mesg-gmx024>
 <20180706160523.kxwxjzwneseaamnt@merlins.org>
 <20180706175636.53ebp7drifiqu5b7@merlins.org>
 <20180707172114.bfc26eoahullffgg@merlins.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <4176efa9-0753-ed28-cf15-69f0b1f1a09b@cn.fujitsu.com>
Date: Tue, 10 Jul 2018 09:37:16 +0800
MIME-Version: 1.0
In-Reply-To: <20180707172114.bfc26eoahullffgg@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[CC to linux-btrfs]

Here is the log of wrong extent data.

On 07/08/2018 01:21 AM, Marc MERLIN wrote:
> On Fri, Jul 06, 2018 at 10:56:36AM -0700, Marc MERLIN wrote:
>> On Fri, Jul 06, 2018 at 09:05:23AM -0700, Marc MERLIN wrote:
>>> Ok, this is where I am now:
>>> WARNING: debug: end of checking extent item[18457780273152 169 1] type: 176 offset: 2
>>> checking extent items [18457780273152/18457780273152]
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> checking fs roots
>>> ERROR: root 17592 EXTENT_DATA[25937109 4096] gap exists, expected: EXTENT_DATA[25937109 4033]
>>> ERROR: root 17592 EXTENT_DATA[25937109 8192] gap exists, expected: EXTENT_DATA[25937109 8129]
>>> ERROR: root 17592 EXTENT_DATA[25937109 20480] gap exists, expected: EXTENT_DATA[25937109 20417]
>>> ERROR: root 17592 EXTENT_DATA[25937493 4096] gap exists, expected: EXTENT_DATA[25937493 3349]
>>> ERROR: root 17592 EXTENT_DATA[25937493 8192] gap exists, expected: EXTENT_DATA[25937493 7445]
>>> ERROR: root 17592 EXTENT_DATA[25937493 12288] gap exists, expected: EXTENT_DATA[25937493 11541]
>>> ERROR: root 17592 EXTENT_DATA[25941335 4096] gap exists, expected: EXTENT_DATA[25941335 4091]
>>> ERROR: root 17592 EXTENT_DATA[25941335 8192] gap exists, expected: EXTENT_DATA[25941335 8187]
>>> ERROR: root 17592 EXTENT_DATA[25942002 4096] gap exists, expected: EXTENT_DATA[25942002 4093]
>>> ERROR: root 17592 EXTENT_DATA[25942790 4096] gap exists, expected: EXTENT_DATA[25942790 4094]
>>> ERROR: root 17592 EXTENT_DATA[25945819 4096] gap exists, expected: EXTENT_DATA[25945819 4093]
>>> ERROR: root 17592 EXTENT_DATA[26064834 4096] gap exists, expected: EXTENT_DATA[26064834 129]
>>> ERROR: root 17592 EXTENT_DATA[26064834 135168] gap exists, expected: EXTENT_DATA[26064834 131201]
>>> ERROR: root 17592 EXTENT_DATA[26064834 266240] gap exists, expected: EXTENT_DATA[26064834 262273]
>>> ERROR: root 17592 EXTENT_DATA[26064834 397312] gap exists, expected: EXTENT_DATA[26064834 393345]
>>> ERROR: root 17592 EXTENT_DATA[26064834 528384] gap exists, expected: EXTENT_DATA[26064834 524417]
>>> ERROR: root 17592 EXTENT_DATA[26064834 659456] gap exists, expected: EXTENT_DATA[26064834 655489]
>>> ERROR: root 17592 EXTENT_DATA[26064834 790528] gap exists, expected: EXTENT_DATA[26064834 786561]
>>> ERROR: root 17592 EXTENT_DATA[26064834 921600] gap exists, expected: EXTENT_DATA[26064834 917633]
>>> ERROR: root 17592 EXTENT_DATA[26064834 929792] gap exists, expected: EXTENT_DATA[26064834 925825]
>>> ERROR: root 17592 EXTENT_DATA[26064834 1224704] gap exists, expected: EXTENT_DATA[26064834 1220737]
>>>
>>> I'm not sure how long it's been stuck on that line. I'll watch it today.
>>
>> Ok, it's been stuck there for 2H.
> 
> Well, it's now the next day and it's finished running:
> 
> checking extent items [18457780273152/18457780273152]
> ERROR: errors found in extent allocation tree or chunk allocation
> checking fs roots
> ERROR: root 17592 EXTENT_DATA[25937109 4096] gap exists, expected: EXTENT_DATA[25937109 4033]
> ERROR: root 17592 EXTENT_DATA[25937109 8192] gap exists, expected: EXTENT_DATA[25937109 8129]
> ERROR: root 17592 EXTENT_DATA[25937109 20480] gap exists, expected: EXTENT_DATA[25937109 20417]
> ERROR: root 17592 EXTENT_DATA[25937493 4096] gap exists, expected: EXTENT_DATA[25937493 3349]
> ERROR: root 17592 EXTENT_DATA[25937493 8192] gap exists, expected: EXTENT_DATA[25937493 7445]
> ERROR: root 17592 EXTENT_DATA[25937493 12288] gap exists, expected: EXTENT_DATA[25937493 11541]
> ERROR: root 17592 EXTENT_DATA[25941335 4096] gap exists, expected: EXTENT_DATA[25941335 4091]
> ERROR: root 17592 EXTENT_DATA[25941335 8192] gap exists, expected: EXTENT_DATA[25941335 8187]
> ERROR: root 17592 EXTENT_DATA[25942002 4096] gap exists, expected: EXTENT_DATA[25942002 4093]
> ERROR: root 17592 EXTENT_DATA[25942790 4096] gap exists, expected: EXTENT_DATA[25942790 4094]
> ERROR: root 17592 EXTENT_DATA[25945819 4096] gap exists, expected: EXTENT_DATA[25945819 4093]
> ERROR: root 17592 EXTENT_DATA[26064834 4096] gap exists, expected: EXTENT_DATA[26064834 129]
> ERROR: root 17592 EXTENT_DATA[26064834 135168] gap exists, expected: EXTENT_DATA[26064834 131201]
> ERROR: root 17592 EXTENT_DATA[26064834 266240] gap exists, expected: EXTENT_DATA[26064834 262273]
> ERROR: root 17592 EXTENT_DATA[26064834 397312] gap exists, expected: EXTENT_DATA[26064834 393345]
> ERROR: root 17592 EXTENT_DATA[26064834 528384] gap exists, expected: EXTENT_DATA[26064834 524417]
> ERROR: root 17592 EXTENT_DATA[26064834 659456] gap exists, expected: EXTENT_DATA[26064834 655489]
> ERROR: root 17592 EXTENT_DATA[26064834 790528] gap exists, expected: EXTENT_DATA[26064834 786561]
> ERROR: root 17592 EXTENT_DATA[26064834 921600] gap exists, expected: EXTENT_DATA[26064834 917633]
> ERROR: root 17592 EXTENT_DATA[26064834 929792] gap exists, expected: EXTENT_DATA[26064834 925825]
> ERROR: root 17592 EXTENT_DATA[26064834 1224704] gap exists, expected: EXTENT_DATA[26064834 1220737]
> ERROR: root 21322 EXTENT_DATA[25320803 4096] gap exists, expected: EXTENT_DATA[25320803 56]
> ERROR: root 21322 EXTENT_DATA[25320803 143360] gap exists, expected: EXTENT_DATA[25320803 139320]
> ERROR: root 21322 EXTENT_DATA[25320803 151552] gap exists, expected: EXTENT_DATA[25320803 147512]
> ERROR: root 21322 EXTENT_DATA[25320803 290816] gap exists, expected: EXTENT_DATA[25320803 286776]
> ERROR: root 21322 EXTENT_DATA[25320803 294912] gap exists, expected: EXTENT_DATA[25320803 290872]
> ERROR: root 21322 EXTENT_DATA[25320803 2949120] gap exists, expected: EXTENT_DATA[25320803 2945080]
> ERROR: root 21322 EXTENT_DATA[25320803 2953216] gap exists, expected: EXTENT_DATA[25320803 2949176]
> ERROR: root 21322 EXTENT_DATA[25320803 5836800] gap exists, expected: EXTENT_DATA[25320803 5832760]
> ERROR: root 22870 EXTENT_DATA[26062114 4096] gap exists, expected: EXTENT_DATA[26062114 89]
> ERROR: root 22870 EXTENT_DATA[26062114 16384] gap exists, expected: EXTENT_DATA[26062114 12377]
> ERROR: root 22870 EXTENT_DATA[26062114 20480] gap exists, expected: EXTENT_DATA[26062114 16473]
> (many lines skipped)
> ERROR: root 23124 EXTENT_DATA[26064190 390852608] gap exists, expected: EXTENT_DATA[26064190 390848601]
> ERROR: root 23124 EXTENT_DATA[26064190 390983680] gap exists, expected: EXTENT_DATA[26064190 390979673]
> ERROR: root 23124 EXTENT_DATA[26064190 391114752] gap exists, expected: EXTENT_DATA[26064190 391110745]
> ERROR: root 23124 EXTENT_DATA[26064190 391245824] gap exists, expected: EXTENT_DATA[26064190 391241817]
> ERROR: root 23124 EXTENT_DATA[26064190 391376896] gap exists, expected: EXTENT_DATA[26064190 391372889]
> ERROR: root 23124 EXTENT_DATA[26064190 391507968] gap exists, expected: EXTENT_DATA[26064190 391503961]
> ERROR: root 23124 EXTENT_DATA[26064190 391639040] gap exists, expected: EXTENT_DATA[26064190 391635033]
> ERROR: root 23124 EXTENT_DATA[26064190 391770112] gap exists, expected: EXTENT_DATA[26064190 391766105]
> ERROR: root 23124 EXTENT_DATA[26064190 391901184] gap exists, expected: EXTENT_DATA[26064190 391897177]
> ERROR: root 23124 EXTENT_DATA[26064190 392032256] gap exists, expected: EXTENT_DATA[26064190 392028249]
> ERROR: root 23124 EXTENT_DATA[26064190 392163328] gap exists, expected: EXTENT_DATA[26064190 392159321]
> ERROR: root 23124 EXTENT_DATA[26064190 392294400] gap exists, expected: EXTENT_DATA[26064190 392290393]
> ERROR: root 23124 EXTENT_DATA[26064190 392425472] gap exists, expected: EXTENT_DATA[26064190 392421465]
> ERROR: root 23124 EXTENT_DATA[26064190 392556544] gap exists, expected: EXTENT_DATA[26064190 392552537]
> ERROR: root 23124 EXTENT_DATA[26064190 392687616] gap exists, expected: EXTENT_DATA[26064190 392683609]
> ERROR: root 23124 EXTENT_DATA[26064190 392818688] gap exists, expected: EXTENT_DATA[26064190 392814681]
> ERROR: root 23124 EXTENT_DATA[26064190 392949760] gap exists, expected: EXTENT_DATA[26064190 392945753]
> ERROR: root 23186 EXTENT_DATA[26064834 4096] gap exists, expected: EXTENT_DATA[26064834 129]
> ERROR: root 23186 EXTENT_DATA[26064834 135168] gap exists, expected: EXTENT_DATA[26064834 131201]
> ERROR: root 23186 EXTENT_DATA[26064834 266240] gap exists, expected: EXTENT_DATA[26064834 262273]
> ERROR: root 23186 EXTENT_DATA[26064834 397312] gap exists, expected: EXTENT_DATA[26064834 393345]
> ERROR: root 23186 EXTENT_DATA[26064834 528384] gap exists, expected: EXTENT_DATA[26064834 524417]
> ERROR: root 23186 EXTENT_DATA[26064834 659456] gap exists, expected: EXTENT_DATA[26064834 655489]
> ERROR: root 23186 EXTENT_DATA[26064834 790528] gap exists, expected: EXTENT_DATA[26064834 786561]
> ERROR: root 23186 EXTENT_DATA[26064834 921600] gap exists, expected: EXTENT_DATA[26064834 917633]
> ERROR: root 23186 EXTENT_DATA[26064834 929792] gap exists, expected: EXTENT_DATA[26064834 925825]
> ERROR: root 23186 EXTENT_DATA[26064834 1224704] gap exists, expected: EXTENT_DATA[26064834 1220737]
> ERROR: errors found in fs roots
> cache and super generation don't match, space cache will be invalidated
> found 13697056956416 bytes used, error(s) found
> total csum bytes: 0
> total tree bytes: 10282598400
> total fs tree bytes: 0
> total extent tree bytes: 10282598400
> btree space waste bytes: 2742975592
> file data blocks allocated: 0
>   referenced 0
> 
> 
> What do I do next?
> 
> Thanks,
> Marc
> 


