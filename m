Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbaJBRZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 13:25:51 -0400
Date: Thu, 2 Oct 2014 19:25:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FIBMAP unsupported
Message-ID: <20141002172549.GV11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <6602102.lhBckFYBLs@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6602102.lhBckFYBLs@fb07-iapwap2>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 02, 2014 at 05:13:22PM +0200, Marc Dietrich wrote:
> I have a large (25G) virtual disk on a btrfs fs. Yes, I know this is not 
> optimial. So I try to defrag it from time to time. However, using "btrfs fi 
> defrag -c vm.vdi" results in even more fragments than before (reported by 
> filefrag). So I wrote my own pseudo defragger,

Unfortunatelly the default target fragment size is 256k. Try
'btrfs filesystem defrag -t 32m ...' or higher numbers and see if it
helps.

> which produces much better results (ok, the file must not be in use). 
> Somewhere in the 3.17 cycle the resulting image got corrupted using the script 
> above. 
> 
> Running filefrag on it returns "FIBMAP unsupported".

This message doe not mean it is a corruption, but filefrag tries to use
the FIBMAP ioctl that is not implemented on btrfs, instead FIEMAP is
used.

filefrag on a nocow file works for me here (3.16.x kernel), I can see
that filefrag on a directory prints the FIBMAP message.

> Virtualbox returns  "AHCI#0P0: Read at offset 606236672 (49152 bytes left) 
> returned rc=VERR_DEV_IO_ERROR". No errors in the kernel log.
> 
> Trying "cp vm.vdi /dev/null" returns: cp: Error reading „vm.vdi“: IO-Error

This could be caused by the virtualization layer. Try to run scrub and
fsck in the non-destru^Wchecking mode if it finds problems.

As you're using compression and autodefrag, a quick skim of the 3.17
patches points to e9512d72e8e61c750c90efacd720abe3c4569822 "fix
autodefrag with compression", but that's just "keyword" match.

There's another report about nocow corruption and VirtualBox in a 3.16 +
for-linus version (which is almost 3.17-rc)
http://article.gmane.org/gmane.comp.file-systems.btrfs/38701/

But according to the attached messages, the underlying device is
unreliable and logs a lot of IO errors.

For now it looks like VirutalBox is not writing the data or there is a
bug introduced post 3.16 killing nocow files.
