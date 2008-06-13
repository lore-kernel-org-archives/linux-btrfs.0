From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at volumes.c:1705
Date: Thu, 12 Jun 2008 21:33:35 -0400
Message-ID: <1213320815.10187.336.camel@think.oraclecorp.com>
References: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Thomas Lindroth <thomas.lindroth@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-06-12 at 18:07 +0200, Thomas Lindroth wrote:
> Hello
> 
> I'm using a recently pulled stable checkout on Gentoo i386 with kernel
> 2.6.24 and I get this message:

> 
> I got a similar message yesterday using plain 0.15 without any
> hotfixes. The message occurred when I was unrar:ing files on the FS.
> Both messages show crc errors but I don't think there is anything
> wrong with the disk.
> 

The hotfixes do fix a memory corruption that was present in 0.14.  Could
you please try the hotfixes?

-chris


