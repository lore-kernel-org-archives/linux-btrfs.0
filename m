Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54903 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbeIGSfz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 14:35:55 -0400
Received: by mail-wm0-f65.google.com with SMTP id c14-v6so14843011wmb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 06:54:49 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 07 Sep 2018 15:54:47 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
In-Reply-To: <1270fa3c-1bb6-25d7-faf5-b2bae322e99a@gmx.com>
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
 <adf0619f947779c7c9c13939f8229a4d@t-5.eu>
 <1270fa3c-1bb6-25d7-faf5-b2bae322e99a@gmx.com>
Message-ID: <1849f3dcc908a20992c8af104610e275@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 7.9.2018 13:13, schrieb Qu Wenruo:
> On 2018/9/7 下午6:45, Jürgen Herrmann wrote:
>> Am 7.9.2018 12:15, schrieb Qu Wenruo:
>>> On 2018/9/7 下午5:56, Jürgen Herrmann wrote:
>>>> Hello!
>>>> 
>>>> I'm having a problem with btrfs send which stops after several 
>>>> seconds.
>>>> The process hangs with 100% cpu time on one cpu. The system is still
>>>> responsive to input but no io is happening anymore so the system
>>>> basically becomes unuseable.
>>> 
>>> Do you have a lot of snapshots or reflinked files (common for offline
>>> dedupe)?
>>> 
>>> If so, send can spend a lot of time trying to iterate all 
>>> referencers.
>> 
>> Linux Mint 19 uses timeshift-btrfs which i find very handy. here's
>> a list of snapshot directories, each containing two subvolumes for
>> @ and @home:
>> 
>> drwxr-xr-x 1 root root 30 Aug 16 20:00 2018-08-16_20-00-01
>> drwxr-xr-x 1 root root 30 Aug 17 14:00 2018-08-17_14-00-02
>> drwxr-xr-x 1 root root 30 Aug 23 20:00 2018-08-23_20-00-01
>> drwxr-xr-x 1 root root 30 Aug 30 20:00 2018-08-30_20-00-01
>> drwxr-xr-x 1 root root 30 Aug 31 17:00 2018-08-31_17-00-01
>> drwxr-xr-x 1 root root 30 Sep  1 20:00 2018-09-01_20-00-02
>> drwxr-xr-x 1 root root 30 Sep  2 20:00 2018-09-02_20-00-02
>> drwxr-xr-x 1 root root 30 Sep  3 22:00 2018-09-03_22-00-01
>> drwxr-xr-x 1 root root 30 Sep  4 22:00 2018-09-04_22-00-02
>> drwxr-xr-x 1 root root 30 Sep  5 22:00 2018-09-05_22-00-01
>> drwxr-xr-x 1 root root 30 Sep  6 20:00 2018-09-06_20-00-01
>> drwxr-xr-x 1 root root 30 Sep  6 22:00 2018-09-06_22-00-01
> 
> Considering the number of snapshots, it's not that many, so it may be
> another bug.
> Not sure about mint, but most deb/ubuntu based distributions don't ship
> the latest kernel, while latest kernel may have a chance to solve it.
> 
>> 
>>> 
>>>> 
>>>> I'm on linux mint 19, freshly installed on a new laptop about 6 
>>>> weeks
>>>> ago. So i wanted to compile latest btrfs-progs and latest stable 
>>>> kernel
>>>> first before reporting that here, BUT: I cannot compile btrfs-progs
>>>> 4.17.1
>>>> because of the following error:
>>> 
>>> Your configure detects reiserfs support but it seems that your 
>>> reiserfs
>>> progs is not up-to-date.
>>> 
>>> You could disable reiserfs convert support by:
>>> 
>>> $ ./configure --with-convert=ext2
>> 
>> This gives me the following error:
>> 
>>     [LD]     btrfs-convert
>> convert/main.o: In function `convert_open_fs':
>> /home/jh/Documents/src/_external/btrfs-progs/convert/main.c:1066:
>> undefined reference to `reiserfs_convert_ops'
>> /home/jh/Documents/src/_external/btrfs-progs/convert/main.c:1066:
>> undefined reference to `reiserfs_convert_ops'
>> collect2: error: ld returned 1 exit status
>> Makefile:506: recipe for target 'btrfs-convert' failed
>> make: *** [btrfs-convert] Error 1
> 
> This is strange, did you clean (make clean) your previous build before
> re-configure?
> 
> If it still fails, you could disable convert completely by:
> 
> $ ./configure --disable-convert
> 
> Thanks,
> Qu

Sorry, another noob mistake :/
after cleaning the src dir it compile fine.

I will report back on the original issue as i now have
btrfs progs 4.17.1 compiled and am running 4.18.6 vanilla kernel.

If the problem with btrfs send is still there, I guess I should post to
a new thread?

Best regards,
Jürgen

> 
>> 
>> Best regards, Jürgen
>> 
>>> 
>>> Thanks,
>>> Qu
>>> 
>>>> 
>>>>     [CC]     convert/source-reiserfs.o
>>>> In file included from convert/source-reiserfs.c:30:0:
>>>> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No 
>>>> such
>>>> file or directory
>>>>  #include <reiserfs/misc.h>
>>>>           ^~~~~~~~~~~~~~~~~
>>>> compilation terminated.
>>>> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
>>>> make: *** [convert/source-reiserfs.o] Error 1
>>>> 
>>>> A google search did not turn up any help nor does apt know of any
>>>> reiserfs related libs that i could install.
>>>> 
>>>> Best regards,
>>>> Jürgen
>>>> 
>> 

-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
