Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:14985 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752241Ab2IOLCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Sep 2012 07:02:47 -0400
Received: from 193.30.77.188.dynamic.jazztel.es ([188.77.30.193] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TCq98-0005rD-JR
	for linux-btrfs@vger.kernel.org; Sat, 15 Sep 2012 11:02:46 +0000
Date: Sat, 15 Sep 2012 13:02:43 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: State of btrfs on ARM
Message-ID: <20120915110243.GA1943@vicerveza.homeunix.net>
References: <20120819221335.GB1960@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20120819221335.GB1960@vicerveza.homeunix.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2012 at 12:13:35AM +0200, Lluís Batlle i Rossell wrote:
> Hello,
> 
> I just tried to mount a btrfs on 3.4.6, on armv5tel, and it wrote an oops.
> Should it work on btrfsnext? Anyone working on that, if not?
> 
> I tried "mount -o compress=lzo myfile-with-holes /mnt/btrfs".

After investigating a bit, I saw the problem is related to running 'mkfs.btrfs'
on ARM. If 'mkfs.btrfs' is run on another platform, it works fine.

But, the problem appears only if the ARM system has "unaligned access kernel
traps" disabled for userland code. That happens to be set by default, it seems.
Setting the kernel to fixup userland unaligned accesses (echo 3 >
/proc/cpu/alignment, for exmaple), then mkfs.btrfs works fine.

I think the kernel mode code has *always* unaligned access fixup, while userland
code is disabled by default. That'd explain the same code was harmless in the
kernel, while it was failing on userland (on a system without fixup enabled).

Nevertheless, those kernel traps on unaligned accesses are very unefficient. So
the best would be to get gcc generate proper code.

There was a slightly dirty patch sent to this list, to avoid gcc generating
instructions that do unaligned accesses:
http://www.spinics.net/lists/linux-btrfs/msg16007.html

I don't know the best way to solve that problem; I think that gcc assumes that
structs are always on unaligned places, and so generates code as if all pointers
to structs are properly aligned. I think that 'memcpy' (gcc builtin) may run
faster than the trap, there. But how to write something faster than a memcpy
call, I don't know.

In fact, looking at the counter of traps run in system-mode in
/proc/cpu/alignment, it increases a lot at every operation I run, either it
writes to btrfs or not. So there should be quite a big amount of code saved by
traps, in the kernel.

Regards,
Lluís.
