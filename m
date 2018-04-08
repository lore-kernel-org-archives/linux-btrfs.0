Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34574 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbeDHILt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Apr 2018 04:11:49 -0400
Received: by mail-io0-f173.google.com with SMTP id d6so6241696iog.1
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Apr 2018 01:11:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1590eb0c-c78a-f77d-dda0-3bb05ec03b2f@suse.com>
References: <CAJVZm6dAcTC7e4RFtfhrJ-DdnR8m4tGGh=z-EAM2uOKVCU_sdg@mail.gmail.com>
 <0b766c86-c515-451a-6747-4984edf5c59f@suse.com> <CAJVZm6cMxhE-5ckEjFvUAjn0rmszg1nVTC5WvYGb7_sf2C9knw@mail.gmail.com>
 <1590eb0c-c78a-f77d-dda0-3bb05ec03b2f@suse.com>
From: Menion <menion@gmail.com>
Date: Sun, 8 Apr 2018 10:11:28 +0200
Message-ID: <CAJVZm6fL_ZQv_efT3Jo0dh9cK4-5B2mcbaARae_aiT4kFSitew@mail.gmail.com>
Subject: Re: Unable to compile btrfs progs 4.16 on ubuntu Xenial
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

./configure --prefix=/usr --disable-documentation --enable-zstd

2018-04-08 9:17 GMT+02:00 Nikolay Borisov <nborisov@suse.com>:
>
>
> On  7.04.2018 23:40, Menion wrote:
>> I am adding - - prefix=/usr that seems you are not using
>>
>
> Clearly you haven't shared all the necessary information, post your
> entire configure line
>
>> 2018-04-07 21:55 GMT+02:00 Nikolay Borisov <nborisov@suse.com>:
>>>
>>>
>>> On  7.04.2018 20:16, Menion wrote:
>>>> Hi all
>>>> Apparently it is not possible to compile with python bindings the
>>>> btrfs progs on ubuntu xenial
>>>>
>>>> checking for a Python interpreter with version >= 3.4... python3
>>>> checking for python3... /usr/bin/python3
>>>> checking for python3 version... 3.5
>>>> checking for python3 platform... linux
>>>> checking for python3 script directory... ${prefix}/lib/python3.5/site-packages
>>>> checking for python3 extension module directory...
>>>> ${exec_prefix}/lib/python3.5/site-packages
>>>> checking for python-3.5... no
>>>> configure: error: Package requirements (python-3.5) were not met:
>>>>
>>>> No package 'python-3.5' found
>>>>
>>>> Consider adjusting the PKG_CONFIG_PATH environment variable if you
>>>> installed software in a non-standard prefix.
>>>>
>>>> Alternatively, you may set the environment variables PYTHON_CFLAGS
>>>> and PYTHON_LIBS to avoid the need to call pkg-config.
>>>> See the pkg-config man page for more details.
>>>>
>>>> /usr/lib/python3.5/site-packages exists, but on Ubuntu the package
>>>> name is python3.5 and not python-3.5
>>>
>>>
>>> Works for me, I'm also on xenial:
>>>
>>> checking for python3... /usr/bin/python3
>>> checking for python3 version... 3.5
>>> checking for python3 platform... linux
>>> checking for python3 script directory... ${prefix}/lib/python3.5/site-packages
>>> checking for python3 extension module directory... ${exec_prefix}/lib/python3.5/site-packages
>>> checking for PYTHON... yes
>>> checking for lzo_version in -llzo2... yes
>>> configure: creating ./config.status
>>> config.status: creating Makefile.inc
>>> config.status: creating Documentation/Makefile
>>> config.status: creating version.h
>>> config.status: creating config.h
>>>
>>>         btrfs-progs v4.16
>>>
>>>         prefix:             /usr/local
>>>         exec prefix:        ${prefix}
>>>
>>>         bindir:             ${exec_prefix}/bin
>>>         libdir:             ${exec_prefix}/lib
>>>         includedir:         ${prefix}/include
>>>
>>>         compiler:           gcc
>>>         cflags:             -g -O1 -Wall -D_FORTIFY_SOURCE=2
>>>         ldflags:
>>>
>>>         documentation:      no
>>>         doc generator:      none
>>>         backtrace support:  yes
>>>         btrfs-convert:      no
>>>         btrfs-restore zstd: no
>>>         Python bindings:    yes
>>>         Python interpreter: /usr/bin/python3
>>>
>>>
>>>
>>>
>>>>
>>>> Bye
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>
