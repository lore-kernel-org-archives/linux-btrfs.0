Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63323 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaJBT4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 15:56:03 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FIBMAP unsupported
Date: Thu, 02 Oct 2014 21:55:55 +0200
Message-ID: <2356843.HqzAreCEMf@ax5200p>
In-Reply-To: <20141002172549.GV11436@twin.jikos.cz>
References: <6602102.lhBckFYBLs@fb07-iapwap2> <20141002172549.GV11436@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 02 Oktober 2014, 19:25:49 schrieb David Sterba:
> On Thu, Oct 02, 2014 at 05:13:22PM +0200, Marc Dietrich wrote:
> > I have a large (25G) virtual disk on a btrfs fs. Yes, I know this is not
> > optimial. So I try to defrag it from time to time. However, using "btrfs
> > fi
> > defrag -c vm.vdi" results in even more fragments than before (reported by
> > filefrag). So I wrote my own pseudo defragger,
> 
> Unfortunatelly the default target fragment size is 256k. Try
> 'btrfs filesystem defrag -t 32m ...' or higher numbers and see if it
> helps.

ok, need to try if I can ever recover from this error ...

> > which produces much better results (ok, the file must not be in use).
> > Somewhere in the 3.17 cycle the resulting image got corrupted using the
> > script above.
> > 
> > Running filefrag on it returns "FIBMAP unsupported".
> 
> This message doe not mean it is a corruption, but filefrag tries to use
> the FIBMAP ioctl that is not implemented on btrfs, instead FIEMAP is
> used.
> 
> filefrag on a nocow file works for me here (3.16.x kernel), I can see
> that filefrag on a directory prints the FIBMAP message.

ah, for some reason FIBMAP is used on a file:

# strace filefrag vm.vdi
open("vm.vdi", O_RDONLY)           = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=26681016320, ...}) = 0
fstatfs(3, {f_type=0x9123683e, f_bsize=4096, f_blocks=106856459, 
f_bfree=35124686, f_bavail=33785307, f_files=0, f_ffree=0, f_fsid={741604101, 
-890814488}, f_namelen=255, f_frsize=4096}) = 0
ioctl(3, FIGETBSZ, 0x603150)            = 0
ioctl(3, FS_IOC_FIEMAP, 0x7fff8e0b65a0) = -1 EEXIST (File exists)
ioctl(3, FIBMAP, 0x7fff8e0ba65c)        = -1 EINVAL (Invalid argument)
write(2, "vm.vdi: FIBMAP unsupported\n", 32vm.vdi: FIBMAP unsupported
) = 32
close(3)                                = 0
exit_group(22)                          = ?

So it tries first FIEMAP and fails and then it tries FIBMAP which also fails.

> > Virtualbox returns  "AHCI#0P0: Read at offset 606236672 (49152 bytes left)
> > returned rc=VERR_DEV_IO_ERROR". No errors in the kernel log.
> > 
> > Trying "cp vm.vdi /dev/null" returns: cp: Error reading „vm.vdi“: IO-Error
> 
> This could be caused by the virtualization layer. Try to run scrub and
> fsck in the non-destru^Wchecking mode if it finds problems.

the first error comes from the virtual machine log, maybe we can ignore it.

the second error is on the bare metal (no virtual machine). The disk is ok, so 
the I/O error comes from btrfs itself.

> As you're using compression and autodefrag, a quick skim of the 3.17
> patches points to e9512d72e8e61c750c90efacd720abe3c4569822 "fix
> autodefrag with compression", but that's just "keyword" match.

I have this in my kernel already...

> There's another report about nocow corruption and VirtualBox in a 3.16 +
> for-linus version (which is almost 3.17-rc)
> http://article.gmane.org/gmane.comp.file-systems.btrfs/38701/
> 
> But according to the attached messages, the underlying device is
> unreliable and logs a lot of IO errors.
> 
> For now it looks like VirutalBox is not writing the data or there is a
> bug introduced post 3.16 killing nocow files.

as said above, this is not related to virtualbox (problem exists on bare 
metal).

Will try to restore the file using btrfs restore....

Marc

