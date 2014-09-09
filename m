Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56969 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaIIWMy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 18:12:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Clemens Eisserer <linuxhippy@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC on mostly empty file system
Date: Wed, 10 Sep 2014 00:12:36 +0200
Message-ID: <5508424.WdIdzisQ7q@wuerfel>
In-Reply-To: <20140909215725.GE5783@carfax.org.uk>
References: <3150960.nnNb4J6vhp@wuerfel> <10095560.XRujO0W0CE@wuerfel> <20140909215725.GE5783@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 09 September 2014 22:57:25 Hugo Mills wrote:
> On Tue, Sep 09, 2014 at 11:49:10PM +0200, Arnd Bergmann wrote:
> > Ok, now I'm in the bad state again (after running a 'make allmodconfig'
> > kernel build:
> > 
> > Label: none  uuid: 1d88cccb-3d0e-42d9-8252-a226dc5c2e47
> >         Total devices 1 FS bytes used 8.79GB
> >         devid    1 size 67.14GB used 67.14GB path /dev/sdc6
> 
>    All the space on the FS has been allocated to some purpose or other.
> 
> > Data: total=65.11GB, used=7.99GB
> 
>    Here, you have 65 GiB allocated to data, but only 8 GiB of that
> used. The FS won't automatically free up any of that (yet -- it's one
> of the project ideas).

Ok, I see.
 
>    So... you need to free up some data chunks. You can do this with:
> 
> # btrfs balance start -dusage=5 /mountpoint
> 
>    Take a look at the output of btrfs fi df and btrfs fi show
> afterwards, and see how much the Data allocation has reduced by, and
> how much unallocated space you have left afterwards. You may want to
> increase the number in the above balance command to some higher value,
> to free up even more chunks (it limits the balance to chunks less than
> n% full -- so the command above will only touch chunks with 5% actual
> data or less). This is in the FAQ.

This is the output afterwards:
$ time sudo btrfs fi balance start  -dusage=5 /git/
Done, had to relocate 44 out of 70 chunks

real    0m22.026s
user    0m0.014s
sys     0m8.302s

$ sudo btrfs fi show /dev/sdc6
Label: none  uuid: 1d88cccb-3d0e-42d9-8252-a226dc5c2e47
        Total devices 1 FS bytes used 8.79GB
        devid    1 size 67.14GB used 23.14GB path /dev/sdc6

$ sudo btrfs fi df /git
Data: total=21.01GB, used=7.99GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.05GB, used=821.32MB
Metadata: total=8.00MB, used=0.00
: total=200.00MB, used=0.00

I'm pretty sure I read the FAQ one of the last times this happened,
but I thought it would only apply to mostly full file systems.
I can usually recover by moving all the data to tmpfs and doing
a new mkfs before moving the data back, and that normally lasts
for a few months before I run out of space again.

I'll try to see how long it takes until the problem comes back
now.

	Arnd
