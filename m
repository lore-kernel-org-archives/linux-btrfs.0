Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:56854 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab3DZHcX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 03:32:23 -0400
Date: Fri, 26 Apr 2013 09:32:20 +0200
From: Sander <sander@humilis.net>
To: Adrien Dessemond <adessemond@funtoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Logical/i-nodes lookups give "path resolving failed with ret=-2"
Message-ID: <20130426073220.GA15882@panda>
Reply-To: sander@humilis.net
References: <CAD2cAXzECvNBNC_3gqLExiE4tnZ33VzDdP7v6O_mS0cOqNz8bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD2cAXzECvNBNC_3gqLExiE4tnZ33VzDdP7v6O_mS0cOqNz8bg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adrien Dessemond wrote (ao):
> I scrubbed a BTRFS volume (mounted as a VFS root) and got several
> errors. However I am not able to make btrfs print the path of the
> corrupted files...
> 
> E.g. kernel log gives :
> 
> 
> [51078.682876] btrfs: unable to fixup (regular) error at logical
> 51241746432 on dev /dev/root
> [51078.683013] btrfs: checksum error at logical 51242385408 on dev
> /dev/root, sector 102196320, root 684, inode 60676040, offset
> 352583680: path resolving failed with ret=-2
> [51078.683016] btrfs: bdev /dev/root errs: wr 0, rd 0, flush 0,
> corrupt 35782, gen 0
> 
> Manual lookup  :
> 
> # btrfs  inspect-internal logical-resolve -v  51241746432 /
> ioctl ret=0, bytes_left=4080, bytes_missing=0, cnt=0, missed=0
> # ./btrfs  inspect-internal inode-resolve 60676040 /
> ioctl ret=-1, error: No such file or directory
> 
> Kernel is Linux 3.9-rc8, latest btrfs-progs from Chris Mason's Git repository.
> 
> I am sure I am missing something but I am unable to figure out
> what.... Any idea? Thanks!!

Maybe: find / -xdev -inum 60676040
