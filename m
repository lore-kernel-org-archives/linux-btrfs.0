Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57841 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaIIVtP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 17:49:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC on mostly empty file system
Date: Tue, 09 Sep 2014 23:49:10 +0200
Message-ID: <10095560.XRujO0W0CE@wuerfel>
In-Reply-To: <CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
References: <3150960.nnNb4J6vhp@wuerfel> <4255785.FLXNWijYCD@wuerfel> <CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 09 September 2014 21:49:12 Clemens Eisserer wrote:
> Hi Arnd,
> 
> > Ok, one more data point:
> 
> Why don't you provide the data point you were specifically asked for,
> "btrfs fi df" ;)

I've cleaned it up again already. At the moment, it's working fine,
with this data:

Data: total=65.11GB, used=7.41GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=799.54MB
Metadata: total=8.00MB, used=0.00
: total=184.00MB, used=0.00

I also realized that the file I uploaded was the uncompressed 800MB
version, not the compressed 82MB file, which is now at
https://drive.google.com/file/d/0B_XQwQ5KlfJAYzY5c1lJRFVQNEE/edit?usp=sharing
Sorry about that.

Ok, now I'm in the bad state again (after running a 'make allmodconfig'
kernel build:

Label: none  uuid: 1d88cccb-3d0e-42d9-8252-a226dc5c2e47
        Total devices 1 FS bytes used 8.79GB
        devid    1 size 67.14GB used 67.14GB path /dev/sdc6

Data: total=65.11GB, used=7.99GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=821.48MB
Metadata: total=8.00MB, used=0.00
: total=200.00MB, used=0.00

Not much extra space used up. Also, a bit from my last shell session
after getting into this state:

arnd@wuerfel:~/arm-soc$ make -skj40
../arch/arm/mach-mmp/devices.c:81:21: warning: 'u2o_get' defined but not used [-Wunused-function]
 static unsigned int u2o_get(void __iomem *base, unsigned int offset)
                     ^
../arch/arm/mach-mmp/devices.c:86:13: warning: 'u2o_set' defined but not used [-Wunused-function]
 static void u2o_set(void __iomem *base, unsigned int offset,
             ^
../arch/arm/mach-mmp/devices.c:97:13: warning: 'u2o_clear' defined but not used [-Wunused-function]
 static void u2o_clear(void __iomem *base, unsigned int offset,
             ^
../arch/arm/mach-mmp/devices.c:108:13: warning: 'u2o_write' defined but not used [-Wunused-function]
 static void u2o_write(void __iomem *base, unsigned int offset,
             ^
mv: cannot move 'security/selinux/ss/.tmp_conditional.o' to 'security/selinux/ss/conditional.o': No space left on device
make[4]: *** [security/selinux/ss/conditional.o] Error 1
mv: cannot move 'kernel/power/.snapshot.o.tmp' to 'kernel/power/.snapshot.o.cmd': No space left on device
make[4]: *** [kernel/power/snapshot.o] Error 1
mv: cannot move 'drivers/ata/.pata_hpt366.o.tmp' to 'drivers/ata/.pata_hpt366.o.cmd': No space left on device
make[4]: *** [drivers/ata/pata_hpt366.o] Error 1
mv: cannot move 'kernel/irq/.proc.o.tmp' to 'kernel/irq/.proc.o.cmd': No space left on device
make[4]: *** [kernel/irq/proc.o] Error 1
...
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: writing to 'x': No space left on device
416642+0 records in
416641+0 records out
213320192 bytes (213 MB) copied, 2.97814 s, 71.6 MB/s
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: opening 'x': No space left on device
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: opening 'x': No space left on device
arnd@wuerfel:~/arm-soc$ rm x
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: writing to 'x': No space left on device
366053+0 records in
366052+0 records out
187418624 bytes (187 MB) copied, 3.04426 s, 61.6 MB/s
arnd@wuerfel:~/arm-soc$ rm x
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: writing to 'x': No space left on device
363482+0 records in
363481+0 records out
186102272 bytes (186 MB) copied, 2.80644 s, 66.3 MB/s
arnd@wuerfel:~/arm-soc$ rm x
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: writing to 'x': No space left on device
366677+0 records in
366676+0 records out
187738112 bytes (188 MB) copied, 2.86939 s, 65.4 MB/s
arnd@wuerfel:~/arm-soc$ sync
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: opening 'x': No space left on device
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: opening 'x': No space left on device
arnd@wuerfel:~/arm-soc$ dd if=/dev/zero of=x
dd: opening 'x': No space left on device

I believe that there were no other processes writing to this partition
at the time.

	Arnd
