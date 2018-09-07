Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41902 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbeIGPcV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 11:32:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id z96-v6so14492079wrb.8
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 03:51:57 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 07 Sep 2018 12:51:54 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
In-Reply-To: <20180907103803.GK24025@twin.jikos.cz>
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <20180907103803.GK24025@twin.jikos.cz>
Message-ID: <2344f0b5de7e00bdd9d880caca86c05b@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 7.9.2018 12:38, schrieb David Sterba:
> On Fri, Sep 07, 2018 at 11:56:18AM +0200, Jürgen Herrmann wrote:
>> I'm on linux mint 19, freshly installed on a new laptop about 6 weeks
>> ago. So i wanted to compile latest btrfs-progs and latest stable 
>> kernel
>> first before reporting that here, BUT: I cannot compile btrfs-progs
>> 4.17.1
>> because of the following error:
>> 
>>      [CC]     convert/source-reiserfs.o
>> In file included from convert/source-reiserfs.c:30:0:
>> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No 
>> such
>> file or directory
>>   #include <reiserfs/misc.h>
>>            ^~~~~~~~~~~~~~~~~
>> compilation terminated.
>> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
>> make: *** [convert/source-reiserfs.o] Error 1
>> 
>> A google search did not turn up any help nor does apt know of any
>> reiserfs related libs that i could install.
> 
> The build dependencies are in the file INSTALL.

I admit that this was a noob mistake to not read that file :)

There's no libreiserfscore on linux mint 19 though.

Here's what apt finds for "reiser"

p   libguestfs-reiserfs                                 - guest disk 
image management system - ReiserFS support
p   libguestfs-reiserfs:i386                            - guest disk 
image management system - ReiserFS support
i   libreiser4-dev                                      - Reiser4's 
filesystem access and manipulation library. Devel fi
p   libreiser4-dev:i386                                 - Reiser4's 
filesystem access and manipulation library. Devel fi
p   reiser4progs                                        - administration 
utilities for the Reiser4 filesystem
p   reiser4progs:i386                                   - administration 
utilities for the Reiser4 filesystem
i   reiserfsprogs                                       - User-level 
tools for ReiserFS filesystems
p   reiserfsprogs:i386                                  - User-level 
tools for ReiserFS filesystems

As you can see, libreiser4-dev is installed.

Best regards,
Jürgen

-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
