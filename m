From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: A device dedicated for metadata?
Date: Wed, 28 Jul 2010 13:49:43 -0400
Message-ID: <20100728174943.GA6259@flcl.lan>
References: <AANLkTik3Mrf+vY6qW6TTtGEghm48ma8tjiWYGfcLhhMq@mail.gmail.com>
 <20100728131428.GA2664@laptop.jp.oracle.com>
 <AANLkTi=XBx11aj=_OLpQkAwOzuG4-nENPKvDqdwYA0rT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: wks1986 <wks1986@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=XBx11aj=_OLpQkAwOzuG4-nENPKvDqdwYA0rT@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

In response to your original questions, btrfs currently gives no control
over the allocation of data or metadata. I'm sure someone will implement
more control eventually.

On Wed, Jul 28, 2010 at 11:49:33PM +0800, wks1986 wrote:
> Another issue is the speed of fsck.  There will always be times when
> the operating system is brought down abnormally and fsck is necessary.
>  In order to make the downtime as short as possible, fsck should be
> fast.  In this case, when metadata are stored in a fast device, fsck
> will be significantly faster.  The "hot data tracking" patch is based
> on the statistics of ONLINE accesses.  Some data may suddenly become
> hot when the filesystem goes offline for fsck.

Actually, because of copy-on-write and other aspects of btrfs' design,
there's no need for the typical use of fsck after a crash. Even once a
proper fsck is finished, it will only be necessary when important
information is corrupted. So it generally doesn't make sense to worry
about fsck speed.
