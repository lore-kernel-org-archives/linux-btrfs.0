Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48040 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759155Ab3BZQUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 11:20:31 -0500
Date: Tue, 26 Feb 2013 08:20:29 -0800
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3753! These btrfs crashes at mount time on log replay are really a problem
Message-ID: <20130226162029.GB22367@merlins.org>
References: <20130226065102.GC11218@merlins.org> <20130226142300.GE19641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226142300.GE19641@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 09:23:00AM -0500, Josef Bacik wrote:
> So how did you reproduce it?  I'll take a fs_image, but being able to reproduce
> the problem is more valuable.  Thanks,

Here's the image: http://marc.merlins.org/tmp/fs_image

I just wrote details in the other message I just Cced you on.
Please let me know if I'm missing more.

Ah yes, I do use discard passthrough in dm:
dmsetup table /dev/mapper/cryptroot --showkeys | grep discard
0 926304944 crypt aes-xts-plain fdf87a0d79b33008185258e61f890a5a92b39490e0ff62d3690e8cc4591a6e8a 0 8:4 8192 1 allow_discards

as well as in btrfs mount of course:
LABEL=btrfs_pool1 / btrfs subvol=root,defaults,compress=lzo,discard,nossd,space_cache,noatime

But the thing that worries me is: 
I understand how it would be beneficial for you to to reproduce my crashes,
but from what I heard, the workload you code and optimize for is pretty
different from mine :)
I would think that if you put btrfs on top of dmcrypt (that part may or may
not be part of the equation) and pull the sata drive from the bus during
writes, you are bound to reproduce this within 10 times (it happens maybe
one time out of 3 for me).

That said, forgive me if I'm going to say something stupid, I'm not a
filesystem developer :)
If somehow, you can pin down the cause of what I'm seeing, that would be
great (assuming it's a bug between dmcrypt and btrfs), but would you agree
that in the end as a filesystem developer, you can't always control random 
ordering of writes or incomplete writes to a drive before it gets shut down?
(drives do their own reordering separately from linux anyway, right?)
I'm also not talking about actual hardware caused corruption and bad RAM
chips.

Am I wrong when saying that ending up with replay journals that have
unexpected data and that can't be replayed is just inevitable and something
any journalling filesystem must deal with?

If I'm not wrong, it looks like btrfs is very good at detecting unexpected
conditions so that it doesn't replay bad logs and cause corruption as a
result, but instead of discarding the log, it just crashes the kernel with
BUG().

My previous message explains how vexing and time consuming it is to recover
when it's your root filesystem on a laptop :)

Given that, would it indeed be feasible to do a sweep of the log replay code
and have it discard bad logs (unless it's in development mode for folks like
you) and continue the mount with just a few transactions lost but a
consistent filesystem, instead of crashing the kernel and leaving the user
with an unbootable system?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
