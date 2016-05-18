Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35259 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbcERR1R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 13:27:17 -0400
Received: by mail-oi0-f53.google.com with SMTP id x19so87979051oix.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 10:27:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2111761.fDjS2Kou6B@localhost.localdomain>
References: <CAPvkgC0RavB6JrfVrnM0EZGxyy4r1vBCUNAtWKfguvBSBK-JOw@mail.gmail.com>
	<2111761.fDjS2Kou6B@localhost.localdomain>
Date: Wed, 18 May 2016 18:27:16 +0100
Message-ID: <CAPvkgC1b0nL-bdEwQnfavBFsno+G83zw4y1eOxxQSDWkCneKWA@mail.gmail.com>
Subject: Re: btrfs self tests fail on arm64, kernel 4.6
From: Steve Capper <steve.capper@linaro.org>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 May 2016 at 17:58, Chandan Rajendra <chandan@linux.vnet.ibm.com> wrote:
> On Wednesday 18 May 2016 16:46:49 Steve Capper wrote:
>> Hello,
>> I am running into issues running the btrfs self tests from 4.6 on an
>> arm64 system with PAGE_SIZE=64K.
>> Poking around in recalculate_thresholds(), I got the following values:
>> size = 1073741824
>> ctl->unit = 4096
>> bytes_per_bg = 2147483648
>> max_bitmaps = 1
>>
>> I am not sure where the problem is as I'm not familiar with btrfs.
>>
>> A panic log can be found below.
>>
>> Is this a known problem?
>>
>> Are there any more diagnostics I could perform, that would be helpful?
>>
>
> Hi Steve,
>
> The fixes for selftests with respect to 64K block size will be posted soon. I
> am currently testing the changes that have been made.

Ahh okay, thanks Chandan.
Please cc me in the fixes and I can give them a quick test here too.

Cheers,
--
Steve
