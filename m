Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:32811 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753445AbdBCOhK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 09:37:10 -0500
Received: by mail-lf0-f49.google.com with SMTP id x1so11181247lff.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Feb 2017 06:37:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <160ddbc9-fb38-56e6-cffe-650f9eb5c535@mendix.com>
References: <33090601-0b56-7360-a256-aa5c27339d99@mendix.com>
 <20170118003838.GA4136@comcast.net> <c8f2ebd7-9073-c2e7-5966-5207895c59b7@mendix.com>
 <CAGqmi76w8dqcEEPamB+oe7brXEcwV1iKT8XUdf_65pWMPkb3qw@mail.gmail.com>
 <48c8c404-9490-49b0-9eaf-c16621ff45c8@mendix.com> <CAGqmi76pqhK1kx5mOH8=D2z90beZhkmPWj=4kLxO7aQD_jbHsw@mail.gmail.com>
 <160ddbc9-fb38-56e6-cffe-650f9eb5c535@mendix.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 3 Feb 2017 17:36:22 +0300
Message-ID: <CAGqmi75eLTyQ6t4MWU6FdE=vSUy4OjfdEUg5Omx0fNQBWNsAwA@mail.gmail.com>
Subject: Re: Btrfs Heatmap - v4 ... colors!!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Tim Walberg <twalberg@comcast.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-02-03 17:27 GMT+03:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
> On 02/03/2017 03:18 PM, Timofey Titovets wrote:
>> 2017-02-03 15:57 GMT+03:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
>>> On 02/03/2017 12:25 PM, Timofey Titovets wrote:
>>>> Thank you for your great work:
>>>> JFYI Packaged in AUR:
>>>> https://aur.archlinux.org/packages/python-btrfs-heatmap/
>>>
>>> Hey, thanks.
>>>
>>> Just wondering... what is that btrfs.py you refer to in...
>>> https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=python-btrfs ?
>>>
>>> It's a package, not a single file, so maybe that compile command doesn't
>>> do anything? I'm not familiar with arch, so correct me if I'm wrong.
>>>
>>> .
>>> ├── btrfs
>>> │   ├── crc32c.py
>>> │   ├── ctree.py
>>> │   ├── __init__.py
>>> │   ├── ioctl.py
>>> │   ├── utils.py
>>>
>>
>> You right, compile command are useless, so i did remove it, thanks.
>
> -$ python2 -m compileall btrfs
> Listing btrfs ...
> Compiling btrfs/__init__.py ...
> Compiling btrfs/crc32c.py ...
> Compiling btrfs/ctree.py ...
> Compiling btrfs/ioctl.py ...
> Compiling btrfs/utils.py ...
>
> .
> ├── btrfs
> │   ├── crc32c.py
> │   ├── crc32c.pyc
> │   ├── ctree.py
> │   ├── ctree.pyc
> │   ├── __init__.py
> │   ├── __init__.pyc
> │   ├── ioctl.py
> │   ├── ioctl.pyc
> │   ├── utils.py
> │   └── utils.pyc
>
>
> -$ python3 -m compileall btrfs
> Listing 'btrfs'...
> Compiling 'btrfs/__init__.py'...
> Compiling 'btrfs/crc32c.py'...
> Compiling 'btrfs/ctree.py'...
> Compiling 'btrfs/ioctl.py'...
> Compiling 'btrfs/utils.py'...
>
> .
> ├── btrfs
> │   ├── crc32c.py
> │   ├── ctree.py
> │   ├── __init__.py
> │   ├── ioctl.py
> │   ├── __pycache__
> │   │   ├── crc32c.cpython-35.pyc
> │   │   ├── ctree.cpython-35.pyc
> │   │   ├── __init__.cpython-35.pyc
> │   │   ├── ioctl.cpython-35.pyc
> │   │   └── utils.cpython-35.pyc
> │   └── utils.py
>
>
> --
> Hans van Kranenburg

➜  python-btrfs git:(master) ✗ tar -vxf python-btrfs-5-1-any.pkg.tar.xz
.PKGINFO
.BUILDINFO
.MTREE
usr/
usr/lib/
usr/lib/python3.6/
usr/lib/python3.6/site-packages/
usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/
usr/lib/python3.6/site-packages/btrfs/
usr/lib/python3.6/site-packages/btrfs/__pycache__/
usr/lib/python3.6/site-packages/btrfs/utils.py
usr/lib/python3.6/site-packages/btrfs/ioctl.py
usr/lib/python3.6/site-packages/btrfs/ctree.py
usr/lib/python3.6/site-packages/btrfs/crc32c.py
usr/lib/python3.6/site-packages/btrfs/__init__.py
usr/lib/python3.6/site-packages/btrfs/__pycache__/utils.cpython-36.pyc
usr/lib/python3.6/site-packages/btrfs/__pycache__/ioctl.cpython-36.pyc
usr/lib/python3.6/site-packages/btrfs/__pycache__/ctree.cpython-36.pyc
usr/lib/python3.6/site-packages/btrfs/__pycache__/crc32c.cpython-36.pyc
usr/lib/python3.6/site-packages/btrfs/__pycache__/__init__.cpython-36.pyc
usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/installed-files.txt
usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/PKG-INFO
usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/dependency_links.txt
usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/top_level.txt
usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/SOURCES.txt

I think it's building automaticaly by:
PIP_CONFIG_FILE=/dev/null pip install --isolated --root="$pkgdir"
--ignore-installed --no-deps btrfs
-- 
Have a nice day,
Timofey.
