From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: csum errors
Date: Thu, 15 Jul 2010 20:30:17 +0200
Message-ID: <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007111428.10005.johannes.hirte@fem.tu-ilmenau.de> <201007131423.59415.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201007131423.59415.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
> On the Opteron system I got now csum errors. I've synced some data from the
> netbook to the Opteron yesteray. After hitting ENOSPC with 4GB free, I've
> run 'btrfs-vol -b' on this fs in hope to get some more free space. It
> worked but the command failed and I found in dmesg:
> 
> btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
> btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
> btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
> btrfs csum failed ino 339 off 935280640 csum 337776576 private 337776575
> 
> So I've tested the new synced data by syncing them to another disk on the
> Optoern system (XFS). As I've expected (or better feared), some data wasn't
> readable and I found more csum errors in dmesg:
> 
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1849137 off 368640 csum 3354885689 private 3354885688
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1912210 off 5095424 csum 847944548 private 847944547
> btrfs csum failed ino 1959333 off 252362752 csum 686735346 private
> 686735345 btrfs csum failed ino 1959333 off 252362752 csum 686735346
> private 686735345 btrfs csum failed ino 1959333 off 252362752 csum
> 686735346 private 686735345 btrfs csum failed ino 1959333 off 252362752
> csum 686735346 private 686735345 btrfs csum failed ino 1959333 off
> 252362752 csum 686735346 private 686735345 btrfs csum failed ino 1959333
> off 252362752 csum 686735346 private 686735345 btrfs csum failed ino
> 1959333 off 651108352 csum 2851505977 private 2851505976 btrfs csum failed
> ino 1959333 off 651108352 csum 2851505977 private 2851505976 btrfs csum
> failed ino 1959333 off 651108352 csum 2851505977 private 2851505976 btrfs
> csum failed ino 1959333 off 651108352 csum 2851505977 private 2851505976
> btrfs csum failed ino 1959333 off 651108352 csum 2851505977 private
> 2851505976 btrfs csum failed ino 1959333 off 651108352 csum 2851505977
> private 2851505976 btrfs csum failed ino 1959333 off 898342912 csum
> 4271223884 private 4271223883 btrfs csum failed ino 1959333 off 898342912
> csum 4271223884 private 4271223883 btrfs csum failed ino 1959333 off
> 898342912 csum 4271223884 private 4271223883 btrfs csum failed ino 1959333
> off 898342912 csum 4271223884 private 4271223883 btrfs csum failed ino
> 1959333 off 898342912 csum 4271223884 private 4271223883 btrfs csum failed
> ino 1959333 off 898342912 csum 4271223884 private 4271223883

I think, this is a different error. I've only seen them on filesystems from my 
Opteron system. It seems that the recorded csums are wrong and it looks to me 
like rounding errors. The data itself should be correct, as I've tested one 
affected file via md5sum against the original on another filesystem.
Any ideas what is going wrong here?

regards,
  Johannes
