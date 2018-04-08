Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:44104 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbeDHKTO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Apr 2018 06:19:14 -0400
Received: by mail-io0-f180.google.com with SMTP id d7so6381651ioc.11
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Apr 2018 03:19:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <744d42cf-7ace-2921-00ae-86340ad743d7@suse.com>
References: <CAJVZm6dAcTC7e4RFtfhrJ-DdnR8m4tGGh=z-EAM2uOKVCU_sdg@mail.gmail.com>
 <744d42cf-7ace-2921-00ae-86340ad743d7@suse.com>
From: Menion <menion@gmail.com>
Date: Sun, 8 Apr 2018 12:18:53 +0200
Message-ID: <CAJVZm6cdT7==PHEDVsQk57v_iP7K8xtPK7rnj-WhvFn-Y-XFWw@mail.gmail.com>
Subject: Re: Unable to compile btrfs progs 4.16 on ubuntu Xenial
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, that was missing, also python3—setuptools is required.
I think it is worth to add in the wiki the packages dependencies
Bye

2018-04-08 10:51 GMT+02:00 Nikolay Borisov <nborisov@suse.com>:
>
>
> On  7.04.2018 20:16, Menion wrote:
>> Hi all
>> Apparently it is not possible to compile with python bindings the
>> btrfs progs on ubuntu xenial
>>
>> checking for a Python interpreter with version >= 3.4... python3
>> checking for python3... /usr/bin/python3
>> checking for python3 version... 3.5
>> checking for python3 platform... linux
>> checking for python3 script directory... ${prefix}/lib/python3.5/site-packages
>> checking for python3 extension module directory...
>> ${exec_prefix}/lib/python3.5/site-packages
>> checking for python-3.5... no
>> configure: error: Package requirements (python-3.5) were not met:
>>
>> No package 'python-3.5' found
>>
>> Consider adjusting the PKG_CONFIG_PATH environment variable if you
>> installed software in a non-standard prefix.
>>
>> Alternatively, you may set the environment variables PYTHON_CFLAGS
>> and PYTHON_LIBS to avoid the need to call pkg-config.
>> See the pkg-config man page for more details.
>>
>> /usr/lib/python3.5/site-packages exists, but on Ubuntu the package
>> name is python3.5 and not python-3.5
>
>
> Do you have libpython3-dev installed? When I installed it on my ubuntu i
> could compile the progs irrespective of whether --prefix was passed or not
>>
>> Bye
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
