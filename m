Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:45310 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbdLGJGw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 04:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <a05374d3-401f-bec3-03f4-45d4072d43f4@gmx.com>
References: <20171206141844.788362-1-arnd@arndb.de> <a05374d3-401f-bec3-03f4-45d4072d43f4@gmx.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 7 Dec 2017 10:06:50 +0100
Message-ID: <CAK8P3a1qOGCy70A6TkA9WAdxMDS-D9s8W5RAs=5+Fo3J58-soA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: tree-checker: use %zu format string for size_t
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 7, 2017 at 1:32 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年12月06日 22:18, Arnd Bergmann wrote:
>> The return value of sizeof() is of type size_t, so we must print it
>> using the %z format modifier rather than %l to avoid this warning
>> on some architectures:
>>
>> fs/btrfs/tree-checker.c: In function 'check_dir_item':
>> fs/btrfs/tree-checker.c:273:50: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'u32' {aka 'unsigned int'} [-Werror=format=]
>
> Any idea about which architecture will cause such warning?
> On x86_64 I always fail to get such warning.

I think all 32-bit architectures:

#ifndef __kernel_size_t
#if __BITS_PER_LONG != 64
typedef unsigned int    __kernel_size_t;
typedef int             __kernel_ssize_t;
typedef int             __kernel_ptrdiff_t;
#else
typedef __kernel_ulong_t __kernel_size_t;
typedef __kernel_long_t __kernel_ssize_t;
typedef __kernel_long_t __kernel_ptrdiff_t;
#endif
#endif

      Arnd
