Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41393 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdBCOq5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 09:46:57 -0500
Subject: Re: Btrfs Heatmap - v4 ... colors!!
To: Timofey Titovets <nefelim4ag@gmail.com>
References: <33090601-0b56-7360-a256-aa5c27339d99@mendix.com>
 <20170118003838.GA4136@comcast.net>
 <c8f2ebd7-9073-c2e7-5966-5207895c59b7@mendix.com>
 <CAGqmi76w8dqcEEPamB+oe7brXEcwV1iKT8XUdf_65pWMPkb3qw@mail.gmail.com>
 <48c8c404-9490-49b0-9eaf-c16621ff45c8@mendix.com>
 <CAGqmi76pqhK1kx5mOH8=D2z90beZhkmPWj=4kLxO7aQD_jbHsw@mail.gmail.com>
 <160ddbc9-fb38-56e6-cffe-650f9eb5c535@mendix.com>
 <CAGqmi75eLTyQ6t4MWU6FdE=vSUy4OjfdEUg5Omx0fNQBWNsAwA@mail.gmail.com>
Cc: Tim Walberg <twalberg@comcast.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e0e66efa-847d-8c2e-f394-1e9a480ab778@mendix.com>
Date: Fri, 3 Feb 2017 15:46:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAGqmi75eLTyQ6t4MWU6FdE=vSUy4OjfdEUg5Omx0fNQBWNsAwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/03/2017 03:36 PM, Timofey Titovets wrote:
> 
> ➜  python-btrfs git:(master) ✗ tar -vxf python-btrfs-5-1-any.pkg.tar.xz
> .PKGINFO
> .BUILDINFO
> .MTREE
> usr/
> usr/lib/
> usr/lib/python3.6/
> usr/lib/python3.6/site-packages/
> usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/
> usr/lib/python3.6/site-packages/btrfs/
> usr/lib/python3.6/site-packages/btrfs/__pycache__/
> usr/lib/python3.6/site-packages/btrfs/utils.py
> usr/lib/python3.6/site-packages/btrfs/ioctl.py
> usr/lib/python3.6/site-packages/btrfs/ctree.py
> usr/lib/python3.6/site-packages/btrfs/crc32c.py
> usr/lib/python3.6/site-packages/btrfs/__init__.py
> usr/lib/python3.6/site-packages/btrfs/__pycache__/utils.cpython-36.pyc
> usr/lib/python3.6/site-packages/btrfs/__pycache__/ioctl.cpython-36.pyc
> usr/lib/python3.6/site-packages/btrfs/__pycache__/ctree.cpython-36.pyc
> usr/lib/python3.6/site-packages/btrfs/__pycache__/crc32c.cpython-36.pyc
> usr/lib/python3.6/site-packages/btrfs/__pycache__/__init__.cpython-36.pyc
> usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/installed-files.txt
> usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/PKG-INFO
> usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/dependency_links.txt
> usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/top_level.txt
> usr/lib/python3.6/site-packages/btrfs-5-py3.6.egg-info/SOURCES.txt
> 
> I think it's building automaticaly by:
> PIP_CONFIG_FILE=/dev/null pip install --isolated --root="$pkgdir"
> --ignore-installed --no-deps btrfs
> 

Even better :-)

Thanks,

-- 
Hans van Kranenburg
