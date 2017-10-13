Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44136 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdJMHBw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 03:01:52 -0400
Received: by mail-pf0-f194.google.com with SMTP id x7so8770214pfa.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 00:01:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171012123809.GF3521@twin.jikos.cz>
References: <20171012022224.28376-1-naota@elisp.net> <20171012123809.GF3521@twin.jikos.cz>
From: Naohiro Aota <naota@elisp.net>
Date: Fri, 13 Oct 2017 16:01:31 +0900
Message-ID: <CAEe67=-YoRnbBAQt=d49W0rBVDw+znTXB1Vu6rAcdNSVr+mCaQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: set include path relatively
To: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-12 21:38 GMT+09:00 David Sterba <dsterba@suse.cz>:
> On Thu, Oct 12, 2017 at 11:22:24AM +0900, Naohiro Aota wrote:
>> Currently, gcc is passed the include directory with full path. As a result,
>> dependency files (*.o.d) also record the full path at the build time. Such
>> full path dependency is annoying for sharing the source between multiple
>> machines, containers, or anything the path differ.
>>
>> And this is the same way what other program using autotools e.g. e2fsprogs
>> is doing:
>>
>> $ grep top_builddir Makefile
>> top_builddir = .
>> CPPFLAGS = -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib
>> BUILD_CFLAGS = -g -O2  -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib -DHAVE_CONFIG_H
>> <snip>
>
> Makes sense for the header files. TOPDIR is also used for linking, can
> it cause similar problems, where the library search path is set as -L$(TOPDIR) ?

Since both "TOPDIR := $(shell pwd)" and -L$(TOPDIR) is evaluated at
the build time,
it never cause problem on linking itself. What the problem with
dependency files is persisting
the full path into the dep files. We generate the dep files only for
objects (%.o.d rule)

Well, it's ok to use "-L." here, and it's the same way with autotools does.

>
> I wonder if we should do the same as in the example above and set
> default value of TOPDIR to '.', instead of `pwd`.

TOPDIR is also used by library-test{,.static}. They run gcc in a
temporary directory.
Thus, TOPDIR here should be absolute.

>
>
>> Signed-off-by: Naohiro Aota <naota@elisp.net>
>> ---
>>  Makefile | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index b1f3388..69b94fb 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -70,8 +70,8 @@ CFLAGS = $(SUBST_CFLAGS) \
>>        -D_XOPEN_SOURCE=700  \
>>        -fno-strict-aliasing \
>>        -fPIC \
>> -      -I$(TOPDIR) \
>> -      -I$(TOPDIR)/kernel-lib \
>> +      -I. \
>> +      -I./kernel-lib \
>>        $(EXTRAWARN_CFLAGS) \
>>        $(DEBUG_CFLAGS_INTERNAL) \
>>        $(EXTRA_CFLAGS)
>> --
>> 2.14.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
