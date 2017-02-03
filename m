Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33117 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdBCOT2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 09:19:28 -0500
Received: by mail-lf0-f49.google.com with SMTP id x1so10907667lff.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Feb 2017 06:19:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <48c8c404-9490-49b0-9eaf-c16621ff45c8@mendix.com>
References: <33090601-0b56-7360-a256-aa5c27339d99@mendix.com>
 <20170118003838.GA4136@comcast.net> <c8f2ebd7-9073-c2e7-5966-5207895c59b7@mendix.com>
 <CAGqmi76w8dqcEEPamB+oe7brXEcwV1iKT8XUdf_65pWMPkb3qw@mail.gmail.com> <48c8c404-9490-49b0-9eaf-c16621ff45c8@mendix.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 3 Feb 2017 17:18:46 +0300
Message-ID: <CAGqmi76pqhK1kx5mOH8=D2z90beZhkmPWj=4kLxO7aQD_jbHsw@mail.gmail.com>
Subject: Re: Btrfs Heatmap - v4 ... colors!!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Tim Walberg <twalberg@comcast.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-02-03 15:57 GMT+03:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
> On 02/03/2017 12:25 PM, Timofey Titovets wrote:
>> Thank you for your great work:
>> JFYI Packaged in AUR:
>> https://aur.archlinux.org/packages/python-btrfs-heatmap/
>
> Hey, thanks.
>
> Just wondering... what is that btrfs.py you refer to in...
> https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=python-btrfs ?
>
> It's a package, not a single file, so maybe that compile command doesn't
> do anything? I'm not familiar with arch, so correct me if I'm wrong.
>
> .
> ├── btrfs
> │   ├── crc32c.py
> │   ├── ctree.py
> │   ├── __init__.py
> │   ├── ioctl.py
> │   ├── utils.py
>
> --
> Hans van Kranenburg

You right, compile command are useless, so i did remove it, thanks.

-- 
Have a nice day,
Timofey.
