Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37533 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbeIGPg0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 11:36:26 -0400
Received: by mail-wm0-f68.google.com with SMTP id n11-v6so14163663wmc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 03:56:00 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 07 Sep 2018 12:55:58 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
In-Reply-To: <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
Message-ID: <2acfb28f635f8eeb27f192936d8c689f@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 7.9.2018 12:15, schrieb Qu Wenruo:
> On 2018/9/7 下午5:56, Jürgen Herrmann wrote:
>> Hello!
>> 
>> I'm having a problem with btrfs send which stops after several 
>> seconds.
>> The process hangs with 100% cpu time on one cpu. The system is still
>> responsive to input but no io is happening anymore so the system
>> basically becomes unuseable.
> 
> Do you have a lot of snapshots or reflinked files (common for offline
> dedupe)?
> 
> If so, send can spend a lot of time trying to iterate all referencers.

I'd like to point out that the first few sends were either interrupted 
by
me or did succeed without problems (one full send/receive was actually
successful). I'm in the process of scripting the
whole thing... then this error turned up. the hang does not go away 
after
waiting for more than one hour. The laptop is not slow by any means, 
it's
a core i5 with a 1TB samsung 860 m.2 ssd and 16GB of RAM.

Best regards, Jürgen

> 
>> 
>> I'm on linux mint 19, freshly installed on a new laptop about 6 weeks
>> ago. So i wanted to compile latest btrfs-progs and latest stable 
>> kernel
>> first before reporting that here, BUT: I cannot compile btrfs-progs 
>> 4.17.1
>> because of the following error:
> 
> Your configure detects reiserfs support but it seems that your reiserfs
> progs is not up-to-date.
> 
> You could disable reiserfs convert support by:
> 
> $ ./configure --with-convert=ext2
> 
> Thanks,
> Qu
> 
>> 
>>     [CC]     convert/source-reiserfs.o
>> In file included from convert/source-reiserfs.c:30:0:
>> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No 
>> such
>> file or directory
>>  #include <reiserfs/misc.h>
>>           ^~~~~~~~~~~~~~~~~
>> compilation terminated.
>> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
>> make: *** [convert/source-reiserfs.o] Error 1
>> 
>> A google search did not turn up any help nor does apt know of any
>> reiserfs related libs that i could install.
>> 
>> Best regards,
>> Jürgen
>> 

-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
