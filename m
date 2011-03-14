From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: cppcheck and btrfs
Date: Tue, 15 Mar 2011 00:24:34 +0200
Message-ID: <20110314222434.GA13960@kwango.lan.net>
References: <201103150732.18300.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201103150732.18300.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2011 at 07:32:13AM +1100, Chris Samuel wrote:
> Hi Chris, et. al,
> 
> I've recently come across cppcheck (static analyser for C code)
> and ran it on the current btrfs directory from Linus's repo and
> it's reported the following potential issues:
> 
> linux-2.6$ cppcheck -q fs/btrfs/
> [fs/btrfs/compression.c:343]: (error) Data is allocated but not initialized: 
> cb
> [fs/btrfs/compression.c:583]: (error) Data is allocated but not initialized: 
> cb
> [fs/btrfs/delayed-ref.c:649]: (error) Data is allocated but not initialized: 
> ref
> [fs/btrfs/delayed-ref.c:694]: (error) Data is allocated but not initialized: 
> ref
> [fs/btrfs/extent-tree.c:5766]: (error) Data is allocated but not initialized: 
> extent_op
> [fs/btrfs/extent-tree.c:5768]: (error) Data is allocated but not initialized: 
> extent_op
> [fs/btrfs/transaction.c:1161]: (error) Data is allocated but not initialized: 
> ac

All of these seems to be warnings cautioning about passing a pointer to
an uninitialized area of memory to some function.  But in most cases
it's an accepted convention, where the called function unconditionally
initializes that memory area, before using it, so it's OK.

> [fs/btrfs/volumes.c:1387]: (error) Possible null pointer dereference: 
> fs_devices

This one is very unlikely, however I doubt a lot of people tested Btrfs
seeding functionality, so it's probably the only one worth looking at.

> [fs/btrfs/volumes.c:3636]: (error) Memory leak: device

This one is bogus, device struct is linked via fs_devices->devices list.

> Now I'm not really a programmer (much less a kernel one) but I
> do see people using it discover issues in kernel code.
> 
> Are these issues real or bugs in cppcheck ?
> 
> cheers!
> Chris
> -- 
>  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
> 
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP

Thanks,

		Ilya
