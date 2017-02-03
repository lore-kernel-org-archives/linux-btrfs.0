Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41084 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbdBCO1U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 09:27:20 -0500
Subject: Re: Btrfs Heatmap - v4 ... colors!!
To: Timofey Titovets <nefelim4ag@gmail.com>
References: <33090601-0b56-7360-a256-aa5c27339d99@mendix.com>
 <20170118003838.GA4136@comcast.net>
 <c8f2ebd7-9073-c2e7-5966-5207895c59b7@mendix.com>
 <CAGqmi76w8dqcEEPamB+oe7brXEcwV1iKT8XUdf_65pWMPkb3qw@mail.gmail.com>
 <48c8c404-9490-49b0-9eaf-c16621ff45c8@mendix.com>
 <CAGqmi76pqhK1kx5mOH8=D2z90beZhkmPWj=4kLxO7aQD_jbHsw@mail.gmail.com>
Cc: Tim Walberg <twalberg@comcast.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <160ddbc9-fb38-56e6-cffe-650f9eb5c535@mendix.com>
Date: Fri, 3 Feb 2017 15:27:12 +0100
MIME-Version: 1.0
In-Reply-To: <CAGqmi76pqhK1kx5mOH8=D2z90beZhkmPWj=4kLxO7aQD_jbHsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/03/2017 03:18 PM, Timofey Titovets wrote:
> 2017-02-03 15:57 GMT+03:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
>> On 02/03/2017 12:25 PM, Timofey Titovets wrote:
>>> Thank you for your great work:
>>> JFYI Packaged in AUR:
>>> https://aur.archlinux.org/packages/python-btrfs-heatmap/
>>
>> Hey, thanks.
>>
>> Just wondering... what is that btrfs.py you refer to in...
>> https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=python-btrfs ?
>>
>> It's a package, not a single file, so maybe that compile command doesn't
>> do anything? I'm not familiar with arch, so correct me if I'm wrong.
>>
>> .
>> ├── btrfs
>> │   ├── crc32c.py
>> │   ├── ctree.py
>> │   ├── __init__.py
>> │   ├── ioctl.py
>> │   ├── utils.py
>>
> 
> You right, compile command are useless, so i did remove it, thanks.

-$ python2 -m compileall btrfs
Listing btrfs ...
Compiling btrfs/__init__.py ...
Compiling btrfs/crc32c.py ...
Compiling btrfs/ctree.py ...
Compiling btrfs/ioctl.py ...
Compiling btrfs/utils.py ...

.
├── btrfs
│   ├── crc32c.py
│   ├── crc32c.pyc
│   ├── ctree.py
│   ├── ctree.pyc
│   ├── __init__.py
│   ├── __init__.pyc
│   ├── ioctl.py
│   ├── ioctl.pyc
│   ├── utils.py
│   └── utils.pyc


-$ python3 -m compileall btrfs
Listing 'btrfs'...
Compiling 'btrfs/__init__.py'...
Compiling 'btrfs/crc32c.py'...
Compiling 'btrfs/ctree.py'...
Compiling 'btrfs/ioctl.py'...
Compiling 'btrfs/utils.py'...

.
├── btrfs
│   ├── crc32c.py
│   ├── ctree.py
│   ├── __init__.py
│   ├── ioctl.py
│   ├── __pycache__
│   │   ├── crc32c.cpython-35.pyc
│   │   ├── ctree.cpython-35.pyc
│   │   ├── __init__.cpython-35.pyc
│   │   ├── ioctl.cpython-35.pyc
│   │   └── utils.cpython-35.pyc
│   └── utils.py


-- 
Hans van Kranenburg
