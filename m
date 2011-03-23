From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: read-only subvolumes?
Date: Wed, 23 Mar 2011 16:01:53 +0700
Message-ID: <AANLkTinPCX7x1qAvfrsDYXDLEPjCbJeWA6SfSrZpg2XJ@mail.gmail.com>
References: <4D89ADA7.2000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89ADA7.2000803@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2011 at 3:21 PM, Andreas Philipp
<philipp.andreas@gmail.com> wrote:
> I think it is since I upgraded to kernel version 2.6.38 (I
> do not create subvolumes on a regular basis.).

> thor btrfs # btrfs subvolume create 123456789
> Create subvolume './123456789'
> thor btrfs # touch 123456789/lsdkfj
> touch: cannot touch `123456789/lsdkfj': Read-only file system

It works on my system

# touch test1
# btrfs su cr 123456789
Create subvolume './123456789'
# touch 123456789/lsdkfj
# uname -a
Linux HP 2.6.38-020638-generic #201103151303 SMP Tue Mar 15 14:33:40
UTC 2011 i686 GNU/Linux

-- 
Fajar
