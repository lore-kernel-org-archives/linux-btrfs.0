Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:39984 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdKWEUy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 23:20:54 -0500
Received: by mail-qt0-f181.google.com with SMTP id u42so26434553qte.7
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 20:20:54 -0800 (PST)
Subject: Re: btrfs-progs-4.13: cmds-inspect-tree-stats.h: No such file or
 directory
From: "John L. Center" <jlcenter15@gmail.com>
To: Uli Heller <uli.heller@daemons-point.com>, linux-btrfs@vger.kernel.org
References: <8fab0623-c8ad-ade0-fde7-382742c801bf@daemons-point.com>
 <4f52f934-6bbd-88db-e915-7b1a9e079e4f@gmail.com>
Message-ID: <b354680c-5ceb-0e39-f4b6-8d01071e7ec8@gmail.com>
Date: Wed, 22 Nov 2017 23:20:52 -0500
MIME-Version: 1.0
In-Reply-To: <4f52f934-6bbd-88db-e915-7b1a9e079e4f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 11/22/2017 11:15 PM, John L. Center wrote:
> 
> On 09/09/2017 01:48 AM, Uli Heller wrote:
>> I dowloaded the btrfs-progs-v4.13.tar.xz tarball and tried to build it.
>> Unfortunately, I get an error about cmds-inspect-tree-stats.h. The 
>> file seems
>> to be missing from the tarball, it used to exist in v4.12.
>>
>> ...
>> true -g -Os -fstack-protector --param=ssp-buffer-size=4 -Wformat 
>> -Werror=format-security -DBTRFS_FLAT_INCLUDES=1 -I. -Ikernel-lib -Itmp 
>> -include .cc-defines.h -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise 
>> -Wuninitialized -Wshadow -Wundef -U_FORTIFY_SOURCE btrfs-calc-size.c
>>      [CC]     btrfs-calc-size.o
>> gcc -g -Os -fstack-protector --param=ssp-buffer-size=4 -Wformat 
>> -Werror=format-security -DBTRFS_FLAT_INCLUDES=1 -I. -Ikernel-lib -Itmp 
>> -c btrfs-calc-size.c -o btrfs-calc-size.o  \
>>
>> btrfs-calc-size.c:22:37: fatal error: cmds-inspect-tree-stats.h: No 
>> such file or directory
>>   #include "cmds-inspect-tree-stats.h"
>>                                       ^
>>
>> $ LANG=C ls -l btrfs-progs-v4.12/cmds-inspect-tree-stats.h 
>> btrfs-progs-v4.13/cmds-inspect-tree-stats.h
>> ls: cannot access btrfs-progs-v4.13/cmds-inspect-tree-stats.h: No such 
>> file or directory
>> -rw-rw-r-- 1 uli uli 905 Jul 28 15:29 
>> btrfs-progs-v4.12/cmds-inspect-tree-stats.h
>>
> The issue exists in the new btrfs-progs-v4.14.tar.gz, also.
> 
>      -John
> 
I forgot to mention, it was in btrfs-show-super.c.

	-John
