From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Tue, 13 Jul 2010 14:23:58 +0200
Message-ID: <201007131423.59415.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007111428.10005.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201007111428.10005.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag 11 Juli 2010, 14:28:09 schrieb Johannes Hirte:
...
> I've three systems running with btrfs, a dual Opteron (252), a Pentium 4
> system and a netbook with N270 Atom. The netbook is the only one that shows
> the errors. It's also the only system where I'm using gcc-4.5. Perhaps it's
> related, but I doubt it's the only reason as I'm using gcc-4.5 since May.

On the Opteron system I got now csum errors. I've synced some data from the 
netbook to the Opteron yesteray. After hitting ENOSPC with 4GB free, I've run 
'btrfs-vol -b' on this fs in hope to get some more free space. It worked but 
the command failed and I found in dmesg:

btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575

So I've tested the new synced data by syncing them to another disk on the 
Optoern system (XFS). As I've expected (or better feared), some data wasn't 
readable and I found more csum errors in dmesg:

btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
btrfs csum failed ino 1959333 off 252362752 csum 686735346 private 686735345
btrfs csum failed ino 1959333 off 252362752 csum 686735346 private 686735345
btrfs csum failed ino 1959333 off 252362752 csum 686735346 private 686735345
btrfs csum failed ino 1959333 off 252362752 csum 686735346 private 686735345
btrfs csum failed ino 1959333 off 252362752 csum 686735346 private 686735345
btrfs csum failed ino 1959333 off 252362752 csum 686735346 private 686735345
btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
btrfs csum failed ino 1959333 off 898342912 csum 4271223884 private 4271223883
btrfs csum failed ino 1959333 off 898342912 csum 4271223884 private 4271223883
btrfs csum failed ino 1959333 off 898342912 csum 4271223884 private 4271223883
btrfs csum failed ino 1959333 off 898342912 csum 4271223884 private 4271223883
btrfs csum failed ino 1959333 off 898342912 csum 4271223884 private 4271223883
btrfs csum failed ino 1959333 off 898342912 csum 4271223884 private 4271223883

I suspect something goes horribly wrong on writing to disc within btrfs. On 
the netbook I got missing blocks, on the Opteron System bad csums. Both 
systems are running linux-2.6.35-rc4, the netbook with gcc-4.5.0 the Opteron 
system with gcc-4.4.4. I'll test the P4 system later, if there are similar 
errors too.

regards,
  Johannes
