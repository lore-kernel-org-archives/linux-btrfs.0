Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41785 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755276AbaBROPM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 09:15:12 -0500
Message-ID: <53036AE9.4060800@fb.com>
Date: Tue, 18 Feb 2014 09:15:05 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Jim Salter <jim@jrs-s.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send problems
References: <52FFD46B.6040109@jrs-s.net> <pxq87dpnnawoh87m9b9w9v60.1392510800062@email.android.com> <530367AF.1090209@jrs-s.net>
In-Reply-To: <530367AF.1090209@jrs-s.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/18/2014 09:01 AM, Jim Salter wrote:
> Having trouble building btrfs-next - getting error ".config not
> found".
> 
> me@locutus:~/git/btrfs-next$ make HOSTCC  scripts/basic/fixdep 
> HOSTCC  scripts/kconfig/conf.o SHIPPED scripts/kconfig/zconf.tab.c 
> SHIPPED scripts/kconfig/zconf.lex.c SHIPPED
> scripts/kconfig/zconf.hash.c HOSTCC  scripts/kconfig/zconf.tab.o 
> HOSTLD  scripts/kconfig/conf scripts/kconfig/conf --silentoldconfig
> Kconfig *** *** Configuration file ".config" not found! *** ***
> Please run some configurator (e.g. "make oldconfig" or *** "make
> menuconfig" or "make xconfig"). *** make[2]: *** [silentoldconfig]
> Error 1 make[1]: *** [silentoldconfig] Error 2 SYSHDR
> arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h SYSHDR
> arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h SYSHDR
> arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h SYSTBL
> arch/x86/syscalls/../include/generated/asm/syscalls_32.h HOSTCC
> arch/x86/tools/relocs_32.o HOSTCC  arch/x86/tools/relocs_64.o 
> HOSTCC  arch/x86/tools/relocs_common.o HOSTLD
> arch/x86/tools/relocs make: *** No rule to make target
> `include/config/auto.conf', needed by 
> `include/config/kernel.release'.  Stop.
> 

cd btrfs-next
cp /boot/config-$(uname -r) .config
make oldconfig
(hold enter until you get a command prompt back)
make -j8 && make modules_install && make install
edit your grub.cfg to make sure it's pointing at the new kernel
reboot

Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTA2rpAAoJEANb+wAKly3BUYMP+wXgRJ3/Jn+Y5TlievpN9ld1
YyiGVzCSz5nybMaVHN4D39TSO9diANd/24GuIlqmGWva91sNYueJ8NFF4n7aKjqH
TiGkqsi5J1m0uP06r+vYFb9oQZyCvs3cmh+zGDkH8+k+DI0IyxqaFTZMjDvvaKY8
tEstHviMd91YvdpD1pH/x9/ubSWed61Dv+mwc3wDg8MrDR2EpoC/6Rrc1nWZsdrm
hjp8wwootlf3/9Z7XwbYX0L6Z869iOnY3HF+8a93earqO+dyCFOTyIAUbkjf5q5I
ZQBDZmtg6KtpH7QlsgPiONRmHELzAV10/bh+3RaOig0cW0x12/EORCWPcw5ktjJ4
PJK8fHK5BcBM6QXI54y8Z6aH/9urA7+FQ/nuxCW0K+Iz4/BxUmRAl6D078MsaLAy
eY9vgBn5hm4jmzKfoCqS7fy5NTxMHGCZSCKCcERPJtu5Adjs2KdQRlyfAav8P+Ul
/oYHKpTcis29SGq+IXgd0EsBBoy/3zrF8F3tIqhwkQpiqSQVL0TbKEd4EPdbEZaI
VFfMYNirJghljl7es4v5ggtRqk8cbAnGKJsc3kw8P67PaedwYH2ecCeNEk9MbIVx
/6SuMq0HDspbPctkFHI4Vtu+dYlnYZtgpONtdrVYKsY/n1Ak3sRCD6hj2fwLJcQl
SbBBOA0WIJYeaNfMm2yu
=o1cI
-----END PGP SIGNATURE-----
