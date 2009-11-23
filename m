From: Jian Lin <lj@linjian.org>
Subject: A file cloned with "--reflink" different from the original one?
Date: Mon, 23 Nov 2009 17:26:32 +0800
Message-ID: <119341710911230126t542b7921p9dd15d804ba97244@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I installed BtrFS 0.19 and GNU coreutils 8.1 on my Ubuntu 9.10.
I tried to clone some files with "--reflink" to make them "copy-on-writ=
e".
However, I found some of the files cloned have different MD5's to the
original ones.

Is BtrFS (or cp with reflink) buggy?
Or it is indeed a feature that I used incorrectly?

Thanks!


root@lj-laptop:/mnt# uname -a
Linux lj-laptop 2.6.31-15-generic #50-Ubuntu SMP Tue Nov 10 14:54:29
UTC 2009 i686 GNU/Linux

root@lj-laptop:/mnt# cat /proc/filesystems | grep btrfs
	btrfs

root@lj-laptop:/mnt# mount | grep btrfs
/dev/sda4 on /mnt type btrfs (rw)

root@lj-laptop:/mnt# cp --version
cp (GNU coreutils) 8.1
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl=
=2Ehtml>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Torbj=F6rn Granlund, David MacKenzie, and Jim Meyering.

root@lj-laptop:/mnt# cp linjian-test-1-x86 linjian-test-1-x86-ref -R --=
reflink

root@lj-laptop:/mnt# ls -la linjian-test-1-x86/* linjian-test-1-x86-ref=
/*
-rw------- 1 root root 419430400 Oct 10 14:21
linjian-test-1-x86/linjian-test-1-x86.vmdk
-rwxr-xr-x 1 root root      1297 Oct 10 14:21
linjian-test-1-x86/linjian-test-1-x86.vmx
-rw------- 1 root root 419430400 Nov 23 14:59
linjian-test-1-x86-ref/linjian-test-1-x86.vmdk
-rwxr-xr-x 1 root root      1297 Nov 23 14:59
linjian-test-1-x86-ref/linjian-test-1-x86.vmx

root@lj-laptop:/mnt# md5sum linjian-test-1-x86/* linjian-test-1-x86-ref=
/*
c34b30f94d220d38e7bfcd2ff6a36f46  linjian-test-1-x86/linjian-test-1-x86=
=2Evmdk
64841a05c4112aebec9c25d6d4daecdc  linjian-test-1-x86/linjian-test-1-x86=
=2Evmx
2eedfae0f1381de1525ab10eae56d032  linjian-test-1-x86-ref/linjian-test-1=
-x86.vmdk
64841a05c4112aebec9c25d6d4daecdc  linjian-test-1-x86-ref/linjian-test-1=
-x86.vmx

root@lj-laptop:/mnt# cd WinXP_CHS/
root@lj-laptop:/mnt/WinXP_CHS# cp WinXP_CHS.vmdk WinXP_CHS-ref.vmdk --r=
eflink

root@lj-laptop:/mnt/WinXP_CHS# ls -la WinXP_CHS.vmdk WinXP_CHS-ref.vmdk
-rwxr-xr-x 1 root root 1713766400 Nov 23 15:11 WinXP_CHS-ref.vmdk
-rwxr-xr-x 1 root root 1713766400 Nov 23 13:32 WinXP_CHS.vmdk

root@lj-laptop:/mnt/WinXP_CHS# md5sum WinXP_CHS.vmdk WinXP_CHS-ref.vmdk
f6da592d056167a44b089d70fa46f863  WinXP_CHS.vmdk
e3ee0c2c17771811c80eed088c20987d  WinXP_CHS-ref.vmdk



Jian LIN
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
