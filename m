Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:42135 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaBLHcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 02:32:36 -0500
Received: by mail-la0-f42.google.com with SMTP id hr13so6875495lab.29
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 23:32:35 -0800 (PST)
Received: from melforce.localnet (melforce.xtsubasa.org. [2a02:578:5002:8062::2])
        by mx.google.com with ESMTPSA id bl8sm22801403lbb.3.2014.02.11.23.32.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 11 Feb 2014 23:32:33 -0800 (PST)
From: Pavel Volkov <negaipub@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Error: could not do orphan cleanup -22
Date: Wed, 12 Feb 2014 11:32:30 +0400
Message-ID: <2426118.ZFJLMUnzLe@melforce>
In-Reply-To: <52F94104.4030201@fb.com>
References: <2047669.QmpNhlvBGM@melforce> <2047838.eX9UXPvc1f@melforce> <52F94104.4030201@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2836118.Zk7nxyL0x2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart2836118.Zk7nxyL0x2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 10 February 2014 16:13:40 Josef Bacik wrote:
> Build a kernel with this patch applied
> 
> http://ur1.ca/glslj
> 
> and re-run the mount and when it fails attach dmesg to this email.  Thanks,
> 
> Josef

Now I re-created the filesystem and have the error again.
Attaching dmesg with patch.
The last error happened when I tried to create a snapshot (from a cron 
script).
--nextPart2836118.Zk7nxyL0x2
Content-Disposition: attachment; filename="dmesg.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.10-gentoomelf (root@melforce) (gcc version 4.8.2 (Gentoo 4.8.2 p1.3r1, pie-0.5.8r1) ) #2 SMP Tue Feb 11 01:26:23 MSK 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel-melf root=/dev/sda3 ro rootflags=subvol=rootfs init=/usr/lib/systemd/systemd resume=/dev/sdb1
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000deb8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000deb90000-0x00000000debd3fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000debd4000-0x00000000dec03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dec04000-0x00000000dec17fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dec18000-0x00000000df141fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df142000-0x00000000df389fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df38a000-0x00000000df396fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000df397000-0x00000000df3c1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df3c2000-0x00000000df3c6fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000df3c7000-0x00000000df409fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df40a000-0x00000000df7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0xdf38a000  ACPI 2.0=0xdf38a000  SMBIOS=0xdec26f98  MPS=0xfc990 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x000000000004e000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000004e000-0x0000000000060000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x0000000000060000-0x000000000009f000) (0MB)
[    0.000000] efi: mem04: type=6, attr=0x800000000000000f, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000c0d000) (11MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000c0d000-0x0000000001000000) (3MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] efi: mem08: type=4, attr=0xf, range=[0x0000000001100000-0x00000000015db000) (4MB)
[    0.000000] efi: mem09: type=3, attr=0xf, range=[0x00000000015db000-0x00000000015dd000) (0MB)
[    0.000000] efi: mem10: type=4, attr=0xf, range=[0x00000000015dd000-0x000000000162a000) (0MB)
[    0.000000] efi: mem11: type=3, attr=0xf, range=[0x000000000162a000-0x000000000162e000) (0MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x000000000162e000-0x0000000001631000) (0MB)
[    0.000000] efi: mem13: type=3, attr=0xf, range=[0x0000000001631000-0x000000000163e000) (0MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000000163e000-0x0000000001a45000) (4MB)
[    0.000000] efi: mem15: type=3, attr=0xf, range=[0x0000000001a45000-0x0000000001a46000) (0MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x0000000001a46000-0x0000000001a4b000) (0MB)
[    0.000000] efi: mem17: type=3, attr=0xf, range=[0x0000000001a4b000-0x0000000001a4d000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x0000000001a4d000-0x0000000001a50000) (0MB)
[    0.000000] efi: mem19: type=3, attr=0xf, range=[0x0000000001a50000-0x0000000001a51000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x0000000001a51000-0x0000000001a5e000) (0MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x0000000001a5e000-0x0000000001a64000) (0MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x0000000001a64000-0x0000000001a67000) (0MB)
[    0.000000] efi: mem23: type=3, attr=0xf, range=[0x0000000001a67000-0x0000000001a6e000) (0MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x0000000001a6e000-0x0000000001a71000) (0MB)
[    0.000000] efi: mem25: type=3, attr=0xf, range=[0x0000000001a71000-0x0000000001a72000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x0000000001a72000-0x0000000001a7a000) (0MB)
[    0.000000] efi: mem27: type=3, attr=0xf, range=[0x0000000001a7a000-0x0000000001a7d000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x0000000001a7d000-0x0000000001a7f000) (0MB)
[    0.000000] efi: mem29: type=3, attr=0xf, range=[0x0000000001a7f000-0x0000000001a81000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x0000000001a81000-0x0000000001a87000) (0MB)
[    0.000000] efi: mem31: type=3, attr=0xf, range=[0x0000000001a87000-0x0000000001a8a000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x0000000001a8a000-0x0000000001ea0000) (4MB)
[    0.000000] efi: mem33: type=3, attr=0xf, range=[0x0000000001ea0000-0x0000000001ea2000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x0000000001ea2000-0x0000000001ea3000) (0MB)
[    0.000000] efi: mem35: type=3, attr=0xf, range=[0x0000000001ea3000-0x0000000001ea4000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x0000000001ea4000-0x0000000001ea8000) (0MB)
[    0.000000] efi: mem37: type=3, attr=0xf, range=[0x0000000001ea8000-0x0000000001ead000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x0000000001ead000-0x0000000001eb0000) (0MB)
[    0.000000] efi: mem39: type=3, attr=0xf, range=[0x0000000001eb0000-0x0000000001eb2000) (0MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x0000000001eb2000-0x0000000001ebe000) (0MB)
[    0.000000] efi: mem41: type=3, attr=0xf, range=[0x0000000001ebe000-0x0000000001ec2000) (0MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x0000000001ec2000-0x0000000001ef0000) (0MB)
[    0.000000] efi: mem43: type=3, attr=0xf, range=[0x0000000001ef0000-0x0000000001ef3000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x0000000001ef3000-0x0000000001f01000) (0MB)
[    0.000000] efi: mem45: type=3, attr=0xf, range=[0x0000000001f01000-0x0000000001f05000) (0MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x0000000001f05000-0x0000000001f1d000) (0MB)
[    0.000000] efi: mem47: type=3, attr=0xf, range=[0x0000000001f1d000-0x0000000001f27000) (0MB)
[    0.000000] efi: mem48: type=4, attr=0xf, range=[0x0000000001f27000-0x0000000001f31000) (0MB)
[    0.000000] efi: mem49: type=3, attr=0xf, range=[0x0000000001f31000-0x0000000001f32000) (0MB)
[    0.000000] efi: mem50: type=4, attr=0xf, range=[0x0000000001f32000-0x0000000001f33000) (0MB)
[    0.000000] efi: mem51: type=3, attr=0xf, range=[0x0000000001f33000-0x0000000001f34000) (0MB)
[    0.000000] efi: mem52: type=4, attr=0xf, range=[0x0000000001f34000-0x0000000001f35000) (0MB)
[    0.000000] efi: mem53: type=3, attr=0xf, range=[0x0000000001f35000-0x0000000001f38000) (0MB)
[    0.000000] efi: mem54: type=4, attr=0xf, range=[0x0000000001f38000-0x0000000001f41000) (0MB)
[    0.000000] efi: mem55: type=3, attr=0xf, range=[0x0000000001f41000-0x0000000001f42000) (0MB)
[    0.000000] efi: mem56: type=4, attr=0xf, range=[0x0000000001f42000-0x0000000001f45000) (0MB)
[    0.000000] efi: mem57: type=3, attr=0xf, range=[0x0000000001f45000-0x0000000001f4a000) (0MB)
[    0.000000] efi: mem58: type=4, attr=0xf, range=[0x0000000001f4a000-0x0000000001f52000) (0MB)
[    0.000000] efi: mem59: type=3, attr=0xf, range=[0x0000000001f52000-0x0000000001f56000) (0MB)
[    0.000000] efi: mem60: type=4, attr=0xf, range=[0x0000000001f56000-0x0000000001f58000) (0MB)
[    0.000000] efi: mem61: type=3, attr=0xf, range=[0x0000000001f58000-0x0000000001f5e000) (0MB)
[    0.000000] efi: mem62: type=4, attr=0xf, range=[0x0000000001f5e000-0x0000000001f61000) (0MB)
[    0.000000] efi: mem63: type=3, attr=0xf, range=[0x0000000001f61000-0x0000000001f62000) (0MB)
[    0.000000] efi: mem64: type=4, attr=0xf, range=[0x0000000001f62000-0x0000000001f63000) (0MB)
[    0.000000] efi: mem65: type=3, attr=0xf, range=[0x0000000001f63000-0x0000000001f65000) (0MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x0000000001f65000-0x0000000001f66000) (0MB)
[    0.000000] efi: mem67: type=3, attr=0xf, range=[0x0000000001f66000-0x0000000001f67000) (0MB)
[    0.000000] efi: mem68: type=4, attr=0xf, range=[0x0000000001f67000-0x0000000001f6d000) (0MB)
[    0.000000] efi: mem69: type=3, attr=0xf, range=[0x0000000001f6d000-0x0000000001f6f000) (0MB)
[    0.000000] efi: mem70: type=4, attr=0xf, range=[0x0000000001f6f000-0x0000000001f74000) (0MB)
[    0.000000] efi: mem71: type=3, attr=0xf, range=[0x0000000001f74000-0x0000000001f75000) (0MB)
[    0.000000] efi: mem72: type=4, attr=0xf, range=[0x0000000001f75000-0x0000000001f8d000) (0MB)
[    0.000000] efi: mem73: type=3, attr=0xf, range=[0x0000000001f8d000-0x0000000001f8e000) (0MB)
[    0.000000] efi: mem74: type=4, attr=0xf, range=[0x0000000001f8e000-0x0000000001f93000) (0MB)
[    0.000000] efi: mem75: type=3, attr=0xf, range=[0x0000000001f93000-0x0000000001f9f000) (0MB)
[    0.000000] efi: mem76: type=4, attr=0xf, range=[0x0000000001f9f000-0x0000000001fac000) (0MB)
[    0.000000] efi: mem77: type=3, attr=0xf, range=[0x0000000001fac000-0x0000000001fb1000) (0MB)
[    0.000000] efi: mem78: type=4, attr=0xf, range=[0x0000000001fb1000-0x0000000001fb2000) (0MB)
[    0.000000] efi: mem79: type=3, attr=0xf, range=[0x0000000001fb2000-0x0000000001fb5000) (0MB)
[    0.000000] efi: mem80: type=4, attr=0xf, range=[0x0000000001fb5000-0x0000000001fb6000) (0MB)
[    0.000000] efi: mem81: type=3, attr=0xf, range=[0x0000000001fb6000-0x0000000001fbb000) (0MB)
[    0.000000] efi: mem82: type=4, attr=0xf, range=[0x0000000001fbb000-0x0000000001fc9000) (0MB)
[    0.000000] efi: mem83: type=3, attr=0xf, range=[0x0000000001fc9000-0x0000000001fcd000) (0MB)
[    0.000000] efi: mem84: type=4, attr=0xf, range=[0x0000000001fcd000-0x0000000001fd5000) (0MB)
[    0.000000] efi: mem85: type=3, attr=0xf, range=[0x0000000001fd5000-0x0000000001fd6000) (0MB)
[    0.000000] efi: mem86: type=4, attr=0xf, range=[0x0000000001fd6000-0x0000000001fec000) (0MB)
[    0.000000] efi: mem87: type=3, attr=0xf, range=[0x0000000001fec000-0x0000000001ff9000) (0MB)
[    0.000000] efi: mem88: type=4, attr=0xf, range=[0x0000000001ff9000-0x0000000001ffd000) (0MB)
[    0.000000] efi: mem89: type=3, attr=0xf, range=[0x0000000001ffd000-0x0000000002003000) (0MB)
[    0.000000] efi: mem90: type=4, attr=0xf, range=[0x0000000002003000-0x0000000002006000) (0MB)
[    0.000000] efi: mem91: type=3, attr=0xf, range=[0x0000000002006000-0x0000000002009000) (0MB)
[    0.000000] efi: mem92: type=4, attr=0xf, range=[0x0000000002009000-0x0000000002011000) (0MB)
[    0.000000] efi: mem93: type=3, attr=0xf, range=[0x0000000002011000-0x0000000002014000) (0MB)
[    0.000000] efi: mem94: type=4, attr=0xf, range=[0x0000000002014000-0x0000000002018000) (0MB)
[    0.000000] efi: mem95: type=3, attr=0xf, range=[0x0000000002018000-0x000000000201b000) (0MB)
[    0.000000] efi: mem96: type=4, attr=0xf, range=[0x000000000201b000-0x000000000201c000) (0MB)
[    0.000000] efi: mem97: type=3, attr=0xf, range=[0x000000000201c000-0x0000000002020000) (0MB)
[    0.000000] efi: mem98: type=4, attr=0xf, range=[0x0000000002020000-0x0000000002024000) (0MB)
[    0.000000] efi: mem99: type=3, attr=0xf, range=[0x0000000002024000-0x0000000002026000) (0MB)
[    0.000000] efi: mem100: type=4, attr=0xf, range=[0x0000000002026000-0x0000000002030000) (0MB)
[    0.000000] efi: mem101: type=3, attr=0xf, range=[0x0000000002030000-0x0000000002038000) (0MB)
[    0.000000] efi: mem102: type=4, attr=0xf, range=[0x0000000002038000-0x000000000203e000) (0MB)
[    0.000000] efi: mem103: type=3, attr=0xf, range=[0x000000000203e000-0x0000000002044000) (0MB)
[    0.000000] efi: mem104: type=4, attr=0xf, range=[0x0000000002044000-0x0000000002046000) (0MB)
[    0.000000] efi: mem105: type=3, attr=0xf, range=[0x0000000002046000-0x0000000002054000) (0MB)
[    0.000000] efi: mem106: type=4, attr=0xf, range=[0x0000000002054000-0x0000000002057000) (0MB)
[    0.000000] efi: mem107: type=3, attr=0xf, range=[0x0000000002057000-0x000000000205a000) (0MB)
[    0.000000] efi: mem108: type=4, attr=0xf, range=[0x000000000205a000-0x000000000205d000) (0MB)
[    0.000000] efi: mem109: type=3, attr=0xf, range=[0x000000000205d000-0x0000000002060000) (0MB)
[    0.000000] efi: mem110: type=4, attr=0xf, range=[0x0000000002060000-0x0000000002061000) (0MB)
[    0.000000] efi: mem111: type=3, attr=0xf, range=[0x0000000002061000-0x0000000002062000) (0MB)
[    0.000000] efi: mem112: type=4, attr=0xf, range=[0x0000000002062000-0x0000000002063000) (0MB)
[    0.000000] efi: mem113: type=3, attr=0xf, range=[0x0000000002063000-0x000000000206a000) (0MB)
[    0.000000] efi: mem114: type=4, attr=0xf, range=[0x000000000206a000-0x0000000002070000) (0MB)
[    0.000000] efi: mem115: type=3, attr=0xf, range=[0x0000000002070000-0x0000000002073000) (0MB)
[    0.000000] efi: mem116: type=4, attr=0xf, range=[0x0000000002073000-0x0000000002076000) (0MB)
[    0.000000] efi: mem117: type=3, attr=0xf, range=[0x0000000002076000-0x000000000207c000) (0MB)
[    0.000000] efi: mem118: type=4, attr=0xf, range=[0x000000000207c000-0x0000000002088000) (0MB)
[    0.000000] efi: mem119: type=3, attr=0xf, range=[0x0000000002088000-0x000000000208c000) (0MB)
[    0.000000] efi: mem120: type=4, attr=0xf, range=[0x000000000208c000-0x0000000002097000) (0MB)
[    0.000000] efi: mem121: type=3, attr=0xf, range=[0x0000000002097000-0x000000000209e000) (0MB)
[    0.000000] efi: mem122: type=4, attr=0xf, range=[0x000000000209e000-0x00000000020a1000) (0MB)
[    0.000000] efi: mem123: type=3, attr=0xf, range=[0x00000000020a1000-0x00000000020a6000) (0MB)
[    0.000000] efi: mem124: type=4, attr=0xf, range=[0x00000000020a6000-0x00000000020dd000) (0MB)
[    0.000000] efi: mem125: type=3, attr=0xf, range=[0x00000000020dd000-0x00000000020e5000) (0MB)
[    0.000000] efi: mem126: type=4, attr=0xf, range=[0x00000000020e5000-0x00000000020ea000) (0MB)
[    0.000000] efi: mem127: type=3, attr=0xf, range=[0x00000000020ea000-0x00000000020fd000) (0MB)
[    0.000000] efi: mem128: type=4, attr=0xf, range=[0x00000000020fd000-0x0000000002104000) (0MB)
[    0.000000] efi: mem129: type=3, attr=0xf, range=[0x0000000002104000-0x0000000002142000) (0MB)
[    0.000000] efi: mem130: type=4, attr=0xf, range=[0x0000000002142000-0x0000000002164000) (0MB)
[    0.000000] efi: mem131: type=3, attr=0xf, range=[0x0000000002164000-0x0000000002166000) (0MB)
[    0.000000] efi: mem132: type=4, attr=0xf, range=[0x0000000002166000-0x0000000002168000) (0MB)
[    0.000000] efi: mem133: type=3, attr=0xf, range=[0x0000000002168000-0x0000000002170000) (0MB)
[    0.000000] efi: mem134: type=4, attr=0xf, range=[0x0000000002170000-0x0000000002172000) (0MB)
[    0.000000] efi: mem135: type=3, attr=0xf, range=[0x0000000002172000-0x0000000002174000) (0MB)
[    0.000000] efi: mem136: type=4, attr=0xf, range=[0x0000000002174000-0x0000000002177000) (0MB)
[    0.000000] efi: mem137: type=3, attr=0xf, range=[0x0000000002177000-0x000000000218a000) (0MB)
[    0.000000] efi: mem138: type=4, attr=0xf, range=[0x000000000218a000-0x0000000002196000) (0MB)
[    0.000000] efi: mem139: type=3, attr=0xf, range=[0x0000000002196000-0x000000000219c000) (0MB)
[    0.000000] efi: mem140: type=4, attr=0xf, range=[0x000000000219c000-0x000000000219f000) (0MB)
[    0.000000] efi: mem141: type=3, attr=0xf, range=[0x000000000219f000-0x00000000021a0000) (0MB)
[    0.000000] efi: mem142: type=4, attr=0xf, range=[0x00000000021a0000-0x00000000021a2000) (0MB)
[    0.000000] efi: mem143: type=3, attr=0xf, range=[0x00000000021a2000-0x00000000021ae000) (0MB)
[    0.000000] efi: mem144: type=4, attr=0xf, range=[0x00000000021ae000-0x00000000021b8000) (0MB)
[    0.000000] efi: mem145: type=3, attr=0xf, range=[0x00000000021b8000-0x00000000021bc000) (0MB)
[    0.000000] efi: mem146: type=4, attr=0xf, range=[0x00000000021bc000-0x00000000021ee000) (0MB)
[    0.000000] efi: mem147: type=3, attr=0xf, range=[0x00000000021ee000-0x00000000021f4000) (0MB)
[    0.000000] efi: mem148: type=4, attr=0xf, range=[0x00000000021f4000-0x00000000021f8000) (0MB)
[    0.000000] efi: mem149: type=3, attr=0xf, range=[0x00000000021f8000-0x0000000002218000) (0MB)
[    0.000000] efi: mem150: type=4, attr=0xf, range=[0x0000000002218000-0x000000000221f000) (0MB)
[    0.000000] efi: mem151: type=3, attr=0xf, range=[0x000000000221f000-0x0000000002221000) (0MB)
[    0.000000] efi: mem152: type=4, attr=0xf, range=[0x0000000002221000-0x0000000002222000) (0MB)
[    0.000000] efi: mem153: type=3, attr=0xf, range=[0x0000000002222000-0x0000000002227000) (0MB)
[    0.000000] efi: mem154: type=4, attr=0xf, range=[0x0000000002227000-0x0000000002228000) (0MB)
[    0.000000] efi: mem155: type=3, attr=0xf, range=[0x0000000002228000-0x000000000222b000) (0MB)
[    0.000000] efi: mem156: type=4, attr=0xf, range=[0x000000000222b000-0x0000000002232000) (0MB)
[    0.000000] efi: mem157: type=3, attr=0xf, range=[0x0000000002232000-0x0000000002234000) (0MB)
[    0.000000] efi: mem158: type=4, attr=0xf, range=[0x0000000002234000-0x0000000002286000) (0MB)
[    0.000000] efi: mem159: type=3, attr=0xf, range=[0x0000000002286000-0x0000000002289000) (0MB)
[    0.000000] efi: mem160: type=4, attr=0xf, range=[0x0000000002289000-0x00000000022aa000) (0MB)
[    0.000000] efi: mem161: type=3, attr=0xf, range=[0x00000000022aa000-0x00000000026b4000) (4MB)
[    0.000000] efi: mem162: type=4, attr=0xf, range=[0x00000000026b4000-0x000000000bfb9000) (153MB)
[    0.000000] efi: mem163: type=3, attr=0xf, range=[0x000000000bfb9000-0x000000000bfbb000) (0MB)
[    0.000000] efi: mem164: type=4, attr=0xf, range=[0x000000000bfbb000-0x000000000bfc3000) (0MB)
[    0.000000] efi: mem165: type=3, attr=0xf, range=[0x000000000bfc3000-0x000000000bfc6000) (0MB)
[    0.000000] efi: mem166: type=4, attr=0xf, range=[0x000000000bfc6000-0x000000000c13b000) (1MB)
[    0.000000] efi: mem167: type=3, attr=0xf, range=[0x000000000c13b000-0x000000000c152000) (0MB)
[    0.000000] efi: mem168: type=4, attr=0xf, range=[0x000000000c152000-0x000000000c1da000) (0MB)
[    0.000000] efi: mem169: type=7, attr=0xf, range=[0x000000000c1da000-0x000000000c1dc000) (0MB)
[    0.000000] efi: mem170: type=4, attr=0xf, range=[0x000000000c1dc000-0x000000000c1e0000) (0MB)
[    0.000000] efi: mem171: type=7, attr=0xf, range=[0x000000000c1e0000-0x000000000c1e6000) (0MB)
[    0.000000] efi: mem172: type=4, attr=0xf, range=[0x000000000c1e6000-0x000000000c1fc000) (0MB)
[    0.000000] efi: mem173: type=7, attr=0xf, range=[0x000000000c1fc000-0x000000000c20f000) (0MB)
[    0.000000] efi: mem174: type=1, attr=0xf, range=[0x000000000c20f000-0x000000000c22c000) (0MB)
[    0.000000] efi: mem175: type=7, attr=0xf, range=[0x000000000c22c000-0x000000000d000000) (13MB)
[    0.000000] efi: mem176: type=2, attr=0xf, range=[0x000000000d000000-0x000000000db0d000) (11MB)
[    0.000000] efi: mem177: type=7, attr=0xf, range=[0x000000000db0d000-0x00000000a9d72000) (2498MB)
[    0.000000] efi: mem178: type=2, attr=0xf, range=[0x00000000a9d72000-0x00000000deb90000) (846MB)
[    0.000000] efi: mem179: type=5, attr=0x800000000000000f, range=[0x00000000deb90000-0x00000000debd4000) (0MB)
[    0.000000] efi: mem180: type=6, attr=0x800000000000000f, range=[0x00000000debd4000-0x00000000dec04000) (0MB)
[    0.000000] efi: mem181: type=5, attr=0x800000000000000f, range=[0x00000000dec04000-0x00000000dec18000) (0MB)
[    0.000000] efi: mem182: type=6, attr=0x800000000000000f, range=[0x00000000dec18000-0x00000000dec26000) (0MB)
[    0.000000] efi: mem183: type=6, attr=0x800000000000000f, range=[0x00000000dec26000-0x00000000dec29000) (0MB)
[    0.000000] efi: mem184: type=6, attr=0x800000000000000f, range=[0x00000000dec29000-0x00000000dec2b000) (0MB)
[    0.000000] efi: mem185: type=6, attr=0x800000000000000f, range=[0x00000000dec2b000-0x00000000dec42000) (0MB)
[    0.000000] efi: mem186: type=0, attr=0xf, range=[0x00000000dec42000-0x00000000defa2000) (3MB)
[    0.000000] efi: mem187: type=0, attr=0xf, range=[0x00000000defa2000-0x00000000df0e8000) (1MB)
[    0.000000] efi: mem188: type=0, attr=0xf, range=[0x00000000df0e8000-0x00000000df0ef000) (0MB)
[    0.000000] efi: mem189: type=0, attr=0xf, range=[0x00000000df0ef000-0x00000000df142000) (0MB)
[    0.000000] efi: mem190: type=10, attr=0xf, range=[0x00000000df142000-0x00000000df306000) (1MB)
[    0.000000] efi: mem191: type=10, attr=0xf, range=[0x00000000df306000-0x00000000df38a000) (0MB)
[    0.000000] efi: mem192: type=9, attr=0xf, range=[0x00000000df38a000-0x00000000df397000) (0MB)
[    0.000000] efi: mem193: type=10, attr=0xf, range=[0x00000000df397000-0x00000000df3a8000) (0MB)
[    0.000000] efi: mem194: type=10, attr=0xf, range=[0x00000000df3a8000-0x00000000df3aa000) (0MB)
[    0.000000] efi: mem195: type=10, attr=0xf, range=[0x00000000df3aa000-0x00000000df3b5000) (0MB)
[    0.000000] efi: mem196: type=10, attr=0xf, range=[0x00000000df3b5000-0x00000000df3bd000) (0MB)
[    0.000000] efi: mem197: type=10, attr=0xf, range=[0x00000000df3bd000-0x00000000df3c2000) (0MB)
[    0.000000] efi: mem198: type=9, attr=0xf, range=[0x00000000df3c2000-0x00000000df3c6000) (0MB)
[    0.000000] efi: mem199: type=9, attr=0xf, range=[0x00000000df3c6000-0x00000000df3c7000) (0MB)
[    0.000000] efi: mem200: type=10, attr=0xf, range=[0x00000000df3c7000-0x00000000df40a000) (0MB)
[    0.000000] efi: mem201: type=4, attr=0xf, range=[0x00000000df40a000-0x00000000df54f000) (1MB)
[    0.000000] efi: mem202: type=3, attr=0xf, range=[0x00000000df54f000-0x00000000df7db000) (2MB)
[    0.000000] efi: mem203: type=4, attr=0xf, range=[0x00000000df7db000-0x00000000df7e3000) (0MB)
[    0.000000] efi: mem204: type=3, attr=0xf, range=[0x00000000df7e3000-0x00000000df7ed000) (0MB)
[    0.000000] efi: mem205: type=4, attr=0xf, range=[0x00000000df7ed000-0x00000000df800000) (0MB)
[    0.000000] efi: mem206: type=7, attr=0xf, range=[0x0000000100000000-0x000000041f000000) (12784MB)
[    0.000000] efi: mem207: type=11, attr=0x8000000000000001, range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem208: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem209: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem210: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem211: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem212: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/P8H67, BIOS 3604 06/25/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x41f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FF0000000 write-back
[    0.000000]   2 base 410000000 mask FF8000000 write-back
[    0.000000]   3 base 418000000 mask FFC000000 write-back
[    0.000000]   4 base 41C000000 mask FFE000000 write-back
[    0.000000]   5 base 41E000000 mask FFF000000 write-back
[    0.000000]   6 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf800 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0d782000, 0x0d782fff] PGTABLE
[    0.000000] BRK [0x0d783000, 0x0d783fff] PGTABLE
[    0.000000] BRK [0x0d784000, 0x0d784fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41ee00000-0x41effffff]
[    0.000000]  [mem 0x41ee00000-0x41effffff] page 2M
[    0.000000] BRK [0x0d785000, 0x0d785fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41edfffff]
[    0.000000]  [mem 0x41c000000-0x41edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdeb8ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xde9fffff] page 2M
[    0.000000]  [mem 0xdea00000-0xdeb8ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdf40a000-0xdf7fffff]
[    0.000000]  [mem 0xdf40a000-0xdf5fffff] page 4k
[    0.000000]  [mem 0xdf600000-0xdf7fffff] page 2M
[    0.000000] BRK [0x0d786000, 0x0d786fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x0d787000, 0x0d787fff] PGTABLE
[    0.000000] ACPI: RSDP 00000000df38a000 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df38a078 00064 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df394c40 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df38a170 0AAC9 (v02 ALASKA    A M I 00000015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df3c0f80 00040
[    0.000000] ACPI: APIC 00000000df394d38 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df394db0 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df394df0 00038 (v01 ALASKA    A M I 01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000df394e28 0036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000df395198 009AA (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000df395b48 00A92 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: DMAR 00000000df3965e0 00078 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff88040e600000-ffff88041c7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdeb8ffff]
[    0.000000]   node   0: [mem 0xdf40a000-0xdf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x41effffff]
[    0.000000] On node 0 totalpages: 4185892
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 44 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12431 pages used for memmap
[    0.000000]   DMA32 zone: 909190 pages, LIFO batch:31
[    0.000000]   Normal zone: 44744 pages used for memmap
[    0.000000]   Normal zone: 3272704 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdeb90000-0xdebd3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdebd4000-0xdec03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdec04000-0xdec17fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdec18000-0xdf141fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf142000-0xdf389fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf38a000-0xdf396fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf397000-0xdf3c1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf3c2000-0xdf3c6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf3c7000-0xdf409fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf800000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf800000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88041ec00000 s74112 r8192 d24192 u524288
[    0.000000] pcpu-alloc: s74112 r8192 d24192 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4128617
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel-melf root=/dev/sda3 ro rootflags=subvol=rootfs init=/usr/lib/systemd/systemd resume=/dev/sdb1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16227740K/16743568K available (4217K kernel code, 390K rwdata, 1632K rodata, 772K init, 628K bss, 515828K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3110.726 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6221.45 BogoMIPS (lpj=12442904)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000025] init_memory_mapping: [mem 0xdeb90000-0xdebd3fff]
[    0.000027]  [mem 0xdeb90000-0xdebd3fff] page 4k
[    0.000033] init_memory_mapping: [mem 0xdebd4000-0xdec03fff]
[    0.000034]  [mem 0xdebd4000-0xdec03fff] page 4k
[    0.000040] init_memory_mapping: [mem 0xdec04000-0xdec17fff]
[    0.000041]  [mem 0xdec04000-0xdec17fff] page 4k
[    0.000046] init_memory_mapping: [mem 0xdec18000-0xdec41fff]
[    0.000047]  [mem 0xdec18000-0xdec41fff] page 4k
[    0.013918] Mount-cache hash table entries: 256
[    0.014038] CPU: Physical Processor ID: 0
[    0.014040] CPU: Processor Core ID: 0
[    0.014043] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.014046] mce: CPU supports 9 MCE banks
[    0.014057] CPU0: Thermal monitoring enabled (TM1)
[    0.014065] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.014152] Freeing SMP alternatives memory: 24K (ffffffff816dd000 - ffffffff816e3000)
[    0.014154] ACPI: Core revision 20130725
[    0.018216] ACPI: All ACPI Tables successfully acquired
[    0.028579] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068241] smpboot: CPU0: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz (fam: 06, model: 2a, stepping: 07)
[    0.068247] TSC deadline timer enabled
[    0.068252] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.068259] ... version:                3
[    0.068260] ... bit width:              48
[    0.068261] ... generic registers:      8
[    0.068263] ... value mask:             0000ffffffffffff
[    0.068264] ... max period:             0000ffffffffffff
[    0.068265] ... fixed-purpose events:   3
[    0.068266] ... event mask:             00000007000000ff
[    0.068394] smpboot: Booting Node   0, Processors  #   1 #   2 #   3 OK
[    0.107923] Brought up 4 CPUs
[    0.107928] smpboot: Total of 4 processors activated (24885.80 BogoMIPS)
[    0.110148] devtmpfs: initialized
[    0.110323] PM: Registering ACPI NVS region [mem 0xdf142000-0xdf389fff] (2392064 bytes)
[    0.110371] PM: Registering ACPI NVS region [mem 0xdf397000-0xdf3c1fff] (176128 bytes)
[    0.110376] PM: Registering ACPI NVS region [mem 0xdf3c7000-0xdf409fff] (274432 bytes)
[    0.110423] xor: automatically using best checksumming function:
[    0.147890]    avx       : 22105.000 MB/sec
[    0.147925] NET: Registered protocol family 16
[    0.148006] cpuidle: using governor ladder
[    0.148007] cpuidle: using governor menu
[    0.148040] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.148042] ACPI: bus type PCI registered
[    0.148071] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.148073] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.150125] PCI: Using configuration type 1 for base access
[    0.150740] bio: create slab <bio-0> at 0
[    0.215869] raid6: sse2x1    8123 MB/s
[    0.283833] raid6: sse2x2   10343 MB/s
[    0.351804] raid6: sse2x4   11908 MB/s
[    0.351806] raid6: using algorithm sse2x4 (11908 MB/s)
[    0.351807] raid6: using ssse3x2 recovery algorithm
[    0.351832] ACPI: Added _OSI(Module Device)
[    0.351834] ACPI: Added _OSI(Processor Device)
[    0.351835] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.351836] ACPI: Added _OSI(Processor Aggregator Device)
[    0.352831] ACPI: EC: Look up EC in DSDT
[    0.353860] ACPI: Executed 1 blocks of module-level executable AML code
[    0.368120] ACPI: SSDT 00000000df0ef018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.368369] ACPI: Dynamic OEM Table Load:
[    0.368371] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.380002] ACPI: SSDT 00000000df0f0a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.380274] ACPI: Dynamic OEM Table Load:
[    0.380276] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.391891] ACPI: SSDT 00000000df0f1c18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.392131] ACPI: Dynamic OEM Table Load:
[    0.392133] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.404249] ACPI: Interpreter enabled
[    0.404258] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.404269] ACPI: (supports S0 S1 S3 S4 S5)
[    0.404270] ACPI: Using IOAPIC for interrupt routing
[    0.404291] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.409024] ACPI: Power Resource [FN00] (off)
[    0.409087] ACPI: Power Resource [FN01] (off)
[    0.409146] ACPI: Power Resource [FN02] (off)
[    0.409206] ACPI: Power Resource [FN03] (off)
[    0.409265] ACPI: Power Resource [FN04] (off)
[    0.409768] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.409859] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.409987] acpi PNP0A08:00: ACPI _OSC control (0x18) granted
[    0.410380] PCI host bridge to bus 0000:00
[    0.410383] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.410385] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.410387] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.410389] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.410391] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.410393] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.410395] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.410397] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff]
[    0.410405] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.410468] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.410491] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.410522] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.410573] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.410595] pci 0000:00:16.0: reg 0x10: [mem 0xf740b000-0xf740b00f 64bit]
[    0.410665] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.410732] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.410751] pci 0000:00:1a.0: reg 0x10: [mem 0xf7408000-0xf74083ff]
[    0.410835] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.410881] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.410911] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.410923] pci 0000:00:1b.0: reg 0x10: [mem 0xf7400000-0xf7403fff 64bit]
[    0.410977] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.411012] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.411038] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.411111] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.411149] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.411175] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.411248] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.411287] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.411313] pci 0000:00:1c.4: [8086:244e] type 01 class 0x060401
[    0.411386] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.411424] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.411449] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.411522] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.411560] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.411585] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    0.411657] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.411695] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.411720] pci 0000:00:1c.7: [8086:1c1e] type 01 class 0x060400
[    0.411793] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.411834] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.411863] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.411882] pci 0000:00:1d.0: reg 0x10: [mem 0xf7407000-0xf74073ff]
[    0.411965] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.412012] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.412040] pci 0000:00:1f.0: [8086:1c4a] type 00 class 0x060100
[    0.412192] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.412208] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.412215] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.412221] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.412228] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.412234] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.412241] pci 0000:00:1f.2: reg 0x24: [mem 0xf7406000-0xf74067ff]
[    0.412282] pci 0000:00:1f.2: PME# supported from D3hot
[    0.412335] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.412348] pci 0000:00:1f.3: reg 0x10: [mem 0xf7405000-0xf74050ff 64bit]
[    0.412367] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.412455] pci 0000:01:00.0: [10de:1040] type 00 class 0x030000
[    0.412463] pci 0000:01:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.412471] pci 0000:01:00.0: reg 0x14: [mem 0xe8000000-0xefffffff 64bit pref]
[    0.412479] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.412485] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.412490] pci 0000:01:00.0: reg 0x30: [mem 0xf7000000-0xf707ffff pref]
[    0.412546] pci 0000:01:00.1: [10de:0e08] type 00 class 0x040300
[    0.412552] pci 0000:01:00.1: reg 0x10: [mem 0xf7080000-0xf7083fff]
[    0.419812] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.419817] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.419821] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.419825] pci 0000:00:01.0:   bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
[    0.419890] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.419967] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.419986] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.420019] pci 0000:03:00.0: reg 0x18: [mem 0xf7300000-0xf7300fff 64bit]
[    0.420039] pci 0000:03:00.0: reg 0x20: [mem 0xf2200000-0xf2203fff 64bit pref]
[    0.420127] pci 0000:03:00.0: supports D1 D2
[    0.420128] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.420159] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.427813] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.427819] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.427824] pci 0000:00:1c.2:   bridge window [mem 0xf7300000-0xf73fffff]
[    0.427831] pci 0000:00:1c.2:   bridge window [mem 0xf2200000-0xf22fffff 64bit pref]
[    0.427909] pci 0000:04:00.0: [1b21:1080] type 01 class 0x060401
[    0.428026] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.428048] pci 0000:00:1c.4: PCI bridge to [bus 04-05] (subtractive decode)
[    0.428052] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.428059] pci 0000:00:1c.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.428060] pci 0000:00:1c.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.428062] pci 0000:00:1c.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.428063] pci 0000:00:1c.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.428064] pci 0000:00:1c.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.428065] pci 0000:00:1c.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.428067] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.428131] pci 0000:05:01.0: [13f6:0111] type 00 class 0x040100
[    0.428157] pci 0000:05:01.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.428274] pci 0000:05:01.0: supports D1 D2
[    0.428364] pci 0000:04:00.0: PCI bridge to [bus 05] (subtractive decode)
[    0.428374] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff]
[    0.428387] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff] (subtractive decode)
[    0.428388] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.428389] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.428391] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.428392] pci 0000:04:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.428393] pci 0000:04:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.428395] pci 0000:04:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.428396] pci 0000:04:00.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.428397] pci 0000:04:00.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.428398] pci 0000:04:00.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.428400] pci 0000:04:00.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.428480] pci 0000:06:00.0: [1106:0415] type 00 class 0x010185
[    0.428499] pci 0000:06:00.0: reg 0x10: [io  0xb040-0xb047]
[    0.428512] pci 0000:06:00.0: reg 0x14: [io  0xb030-0xb033]
[    0.428525] pci 0000:06:00.0: reg 0x18: [io  0xb020-0xb027]
[    0.428539] pci 0000:06:00.0: reg 0x1c: [io  0xb010-0xb013]
[    0.428552] pci 0000:06:00.0: reg 0x20: [io  0xb000-0xb00f]
[    0.428578] pci 0000:06:00.0: reg 0x30: [mem 0xf7200000-0xf720ffff pref]
[    0.428645] pci 0000:06:00.0: supports D1 D2
[    0.428646] pci 0000:06:00.0: PME# supported from D1 D2 D3hot
[    0.435811] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.435817] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.435822] pci 0000:00:1c.5:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.435911] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.435929] pci 0000:07:00.0: reg 0x10: [io  0xa000-0xa0ff]
[    0.435962] pci 0000:07:00.0: reg 0x18: [mem 0xf2104000-0xf2104fff 64bit pref]
[    0.435982] pci 0000:07:00.0: reg 0x20: [mem 0xf2100000-0xf2103fff 64bit pref]
[    0.436070] pci 0000:07:00.0: supports D1 D2
[    0.436071] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.436102] pci 0000:07:00.0: System wakeup disabled by ACPI
[    0.443811] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.443817] pci 0000:00:1c.6:   bridge window [io  0xa000-0xafff]
[    0.443826] pci 0000:00:1c.6:   bridge window [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.443917] pci 0000:08:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.443944] pci 0000:08:00.0: reg 0x10: [mem 0xf7100000-0xf7107fff 64bit]
[    0.444088] pci 0000:08:00.0: PME# supported from D3hot D3cold
[    0.444118] pci 0000:08:00.0: System wakeup disabled by ACPI
[    0.451808] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    0.451817] pci 0000:00:1c.7:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.451877] pci_bus 0000:00: on NUMA node 0
[    0.451878] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.452256] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.452301] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.452342] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.452383] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.452423] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.452464] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 *15)
[    0.452505] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.452545] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 *14 15)
[    0.452711] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.452717] ACPI: \_SB_.PCI0: notify handler is installed
[    0.452751] Found 1 acpi root devices
[    0.452789] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.452792] vgaarb: loaded
[    0.452793] vgaarb: bridge control possible 0000:01:00.0
[    0.452844] SCSI subsystem initialized
[    0.452867] libata version 3.00 loaded.
[    0.452870] ACPI: bus type USB registered
[    0.452883] usbcore: registered new interface driver usbfs
[    0.452889] usbcore: registered new interface driver hub
[    0.452901] usbcore: registered new device driver usb
[    0.452920] PCI: Using ACPI for IRQ routing
[    0.454259] PCI: pci_cache_line_size set to 64 bytes
[    0.454318] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.454319] e820: reserve RAM buffer [mem 0xdeb90000-0xdfffffff]
[    0.454320] e820: reserve RAM buffer [mem 0xdf800000-0xdfffffff]
[    0.454321] e820: reserve RAM buffer [mem 0x41f000000-0x41fffffff]
[    0.454415] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.454420] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.457436] Switched to clocksource hpet
[    0.458320] pnp: PnP ACPI init
[    0.458325] ACPI: bus type PNP registered
[    0.458371] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.458374] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.458382] pnp 00:01: [dma 4]
[    0.458392] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.458406] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.458470] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.458502] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.458505] system 00:04: [io  0x0200-0x020f] has been reserved
[    0.458507] system 00:04: [io  0xffff] has been reserved
[    0.458509] system 00:04: [io  0xffff] has been reserved
[    0.458511] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.458514] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.458516] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.458518] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.458521] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458539] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.458571] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.458574] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.458634] system 00:07: [io  0x0290-0x029f] has been reserved
[    0.458637] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458673] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.458676] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458693] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.458858] pnp 00:0a: [dma 0 disabled]
[    0.458893] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.459074] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.459077] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.459079] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.459081] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.459084] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.459086] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.459088] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.459090] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.459092] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.459095] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.459097] system 00:0b: [mem 0xe0000000-0xe0000fff] has been reserved
[    0.459099] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.459189] pnp: PnP ACPI: found 12 devices
[    0.459191] ACPI: bus type PNP unregistered
[    0.463730] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.463733] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.463736] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.463739] pci 0000:00:01.0:   bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
[    0.463742] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.463752] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.463755] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.463760] pci 0000:00:1c.2:   bridge window [mem 0xf7300000-0xf73fffff]
[    0.463764] pci 0000:00:1c.2:   bridge window [mem 0xf2200000-0xf22fffff 64bit pref]
[    0.463770] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.463773] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff]
[    0.463793] pci 0000:00:1c.4: PCI bridge to [bus 04-05]
[    0.463795] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.463806] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.463808] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.463813] pci 0000:00:1c.5:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.463821] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.463824] pci 0000:00:1c.6:   bridge window [io  0xa000-0xafff]
[    0.463830] pci 0000:00:1c.6:   bridge window [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.463836] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    0.463841] pci 0000:00:1c.7:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.463849] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.463850] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.463851] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.463853] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.463854] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.463855] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.463856] pci_bus 0000:00: resource 10 [mem 0xe0000000-0xfeafffff]
[    0.463857] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.463858] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.463860] pci_bus 0000:01: resource 2 [mem 0xe8000000-0xf1ffffff 64bit pref]
[    0.463861] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.463862] pci_bus 0000:03: resource 1 [mem 0xf7300000-0xf73fffff]
[    0.463863] pci_bus 0000:03: resource 2 [mem 0xf2200000-0xf22fffff 64bit pref]
[    0.463865] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.463866] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.463867] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.463868] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.463869] pci_bus 0000:04: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.463870] pci_bus 0000:04: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.463871] pci_bus 0000:04: resource 9 [mem 0x000dc000-0x000dffff]
[    0.463873] pci_bus 0000:04: resource 10 [mem 0xe0000000-0xfeafffff]
[    0.463874] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.463875] pci_bus 0000:05: resource 4 [io  0xc000-0xcfff]
[    0.463876] pci_bus 0000:05: resource 8 [io  0x0000-0x0cf7]
[    0.463877] pci_bus 0000:05: resource 9 [io  0x0d00-0xffff]
[    0.463878] pci_bus 0000:05: resource 10 [mem 0x000a0000-0x000bffff]
[    0.463879] pci_bus 0000:05: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.463881] pci_bus 0000:05: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.463882] pci_bus 0000:05: resource 13 [mem 0x000dc000-0x000dffff]
[    0.463883] pci_bus 0000:05: resource 14 [mem 0xe0000000-0xfeafffff]
[    0.463884] pci_bus 0000:06: resource 0 [io  0xb000-0xbfff]
[    0.463885] pci_bus 0000:06: resource 1 [mem 0xf7200000-0xf72fffff]
[    0.463886] pci_bus 0000:07: resource 0 [io  0xa000-0xafff]
[    0.463888] pci_bus 0000:07: resource 2 [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.463889] pci_bus 0000:08: resource 1 [mem 0xf7100000-0xf71fffff]
[    0.463914] NET: Registered protocol family 2
[    0.464020] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.464235] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.464338] TCP: Hash tables configured (established 131072 bind 65536)
[    0.464352] TCP: reno registered
[    0.464355] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.464392] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.464468] NET: Registered protocol family 1
[    0.717378] pci 0000:01:00.0: Boot video device
[    0.717506] PCI: CLS 64 bytes, default 64
[    0.717535] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.717538] software IO TLB [mem 0xdab90000-0xdeb90000] (64MB) mapped at [ffff8800dab90000-ffff8800deb8ffff]
[    0.718011] audit: initializing netlink socket (disabled)
[    0.718017] type=2000 audit(1392136376.708:1): initialized
[    0.718398] bio: create slab <bio-1> at 1
[    0.718452] Btrfs loaded
[    0.718456] msgmni has been set to 32056
[    0.718533] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.718535] io scheduler noop registered
[    0.718537] io scheduler deadline registered
[    0.718542] io scheduler cfq registered (default)
[    0.718640] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.724303] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.744738] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.745033] Linux agpgart interface v0.103
[    0.745066] efifb: probing for efifb
[    0.745143] efifb: framebuffer at 0xf1000000, mapped to 0xffffc90009200000, using 1920k, total 1920k
[    0.745145] efifb: mode is 800x600x32, linelength=3200, pages=1
[    0.745147] efifb: scrolling: redraw
[    0.745148] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.746522] Console: switching to colour frame buffer device 100x37
[    0.747863] fb0: EFI VGA frame buffer device
[    0.747915] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.747947] ACPI: Power Button [PWRB]
[    0.747981] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.748008] ACPI: Power Button [PWRF]
[    0.748053] ACPI: Fan [FAN0] (off)
[    0.748080] ACPI: Fan [FAN1] (off)
[    0.748105] ACPI: Fan [FAN2] (off)
[    0.748130] ACPI: Fan [FAN3] (off)
[    0.748154] ACPI: Fan [FAN4] (off)
[    0.748196] ACPI: Requesting acpi_cpufreq
[    0.769468] Monitor-Mwait will be used to enter C-1 state
[    0.769471] Monitor-Mwait will be used to enter C-2 state
[    0.769473] Monitor-Mwait will be used to enter C-3 state
[    0.769479] ACPI: acpi_idle registered with cpuidle
[    0.793533] thermal LNXTHERM:00: registered as thermal_zone0
[    0.794173] ACPI: Thermal Zone [TZ00] (28 C)
[    0.794963] thermal LNXTHERM:01: registered as thermal_zone1
[    0.795597] ACPI: Thermal Zone [TZ01] (30 C)
[    0.797329] brd: module loaded
[    0.798278] loop: module loaded
[    0.798952] ahci 0000:00:1f.2: version 3.0
[    0.799030] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.813276] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xf impl SATA mode
[    0.813902] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.814518] ahci 0000:00:1f.2: setting latency timer to 64
[    0.837617] scsi0 : ahci
[    0.838380] scsi1 : ahci
[    0.839080] scsi2 : ahci
[    0.839771] scsi3 : ahci
[    0.840440] scsi4 : ahci
[    0.841089] scsi5 : ahci
[    0.841656] ata1: SATA max UDMA/133 abar m2048@0xf7406000 port 0xf7406100 irq 41
[    0.842224] ata2: SATA max UDMA/133 abar m2048@0xf7406000 port 0xf7406180 irq 41
[    0.842772] ata3: SATA max UDMA/133 abar m2048@0xf7406000 port 0xf7406200 irq 41
[    0.843300] ata4: SATA max UDMA/133 abar m2048@0xf7406000 port 0xf7406280 irq 41
[    0.843807] ata5: DUMMY
[    0.844303] ata6: DUMMY
[    0.844803] tun: Universal TUN/TAP device driver, 1.6
[    0.845279] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.845808] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.846291] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    0.846786] pcieport 0000:00:1c.2: driver skip pci_set_master, fix it!
[    0.847455] r8169 0000:03:00.0: irq 42 for MSI/MSI-X
[    0.847542] r8169 0000:03:00.0 eth0: RTL8168e/8111e at 0xffffc90000050000, 64:70:02:01:da:24, XID 0c200000 IRQ 42
[    0.848554] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    0.849083] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.849600] r8169 0000:07:00.0: can't disable ASPM; OS doesn't have ASPM control
[    0.850115] pcieport 0000:00:1c.6: driver skip pci_set_master, fix it!
[    0.850810] r8169 0000:07:00.0: irq 43 for MSI/MSI-X
[    0.850882] r8169 0000:07:00.0 eth1: RTL8168e/8111e at 0xffffc90000052000, f4:6d:04:f0:6b:e8, XID 0c200000 IRQ 43
[    0.852021] r8169 0000:07:00.0 eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    0.852655] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.853302] ehci-pci: EHCI PCI platform driver
[    0.854007] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    0.854012] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.854658] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.855318] ehci-pci 0000:00:1a.0: debug port 2
[    0.859832] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.859844] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf7408000
[    0.869183] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.869985] hub 1-0:1.0: USB hub found
[    0.870622] hub 1-0:1.0: 2 ports detected
[    0.871373] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    0.871378] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.871996] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.872624] ehci-pci 0000:00:1d.0: debug port 2
[    0.877125] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.877128] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7407000
[    0.889208] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.890005] hub 2-0:1.0: USB hub found
[    0.890657] hub 2-0:1.0: 2 ports detected
[    0.891389] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.892047] ohci-pci: OHCI PCI platform driver
[    0.892718] uhci_hcd: USB Universal Host Controller Interface driver
[    0.893509] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    0.894211] xhci_hcd 0000:08:00.0: new USB bus registered, assigned bus number 3
[    0.904575] xhci_hcd 0000:08:00.0: irq 44 for MSI/MSI-X
[    0.904579] xhci_hcd 0000:08:00.0: irq 45 for MSI/MSI-X
[    0.904581] xhci_hcd 0000:08:00.0: irq 46 for MSI/MSI-X
[    0.904585] xhci_hcd 0000:08:00.0: irq 47 for MSI/MSI-X
[    0.904588] xhci_hcd 0000:08:00.0: irq 48 for MSI/MSI-X
[    0.904799] hub 3-0:1.0: USB hub found
[    0.905523] hub 3-0:1.0: 2 ports detected
[    0.906275] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    0.906982] xhci_hcd 0000:08:00.0: new USB bus registered, assigned bus number 4
[    0.907837] hub 4-0:1.0: USB hub found
[    0.908542] hub 4-0:1.0: 2 ports detected
[    0.925228] usbcore: registered new interface driver usb-storage
[    0.925927] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.929131] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.929790] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.930587] mousedev: PS/2 mouse device common for all mice
[    0.931399] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    0.932178] rtc_cmos 00:05: RTC can wake from S4
[    0.932917] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.933538] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.934249] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: dm-devel@redhat.com
[    0.934844] EFI Variables Facility v0.08 2004-May-17
[    0.991089] hidraw: raw HID events driver (C) Jiri Kosina
[    0.991736] usbcore: registered new interface driver usbhid
[    0.992330] usbhid: USB HID core driver
[    0.993045] TCP: cubic registered
[    0.993713] NET: Registered protocol family 10
[    0.994457] NET: Registered protocol family 17
[    0.995048] Bridge firewalling registered
[    0.995879] registered taskstats version 1
[    0.996943] rtc_cmos 00:05: setting system clock to 2014-02-11 16:32:57 UTC (1392136377)
[    1.161043] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.161692] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.162322] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.162949] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.163571] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88041c8c5bf0), AE_NOT_FOUND (20130725/psparse-536)
[    1.164879] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.165579] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.166257] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88041c8c5c68), AE_NOT_FOUND (20130725/psparse-536)
[    1.167638] ata2.00: ATA-8: ST3000VX000-9YW166, CV13, max UDMA/133
[    1.168329] ata2.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.169080] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.169818] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88041c8c5b78), AE_NOT_FOUND (20130725/psparse-536)
[    1.171336] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.172122] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node ffff88041c8c5b00), AE_NOT_FOUND (20130725/psparse-536)
[    1.173708] ata4.00: ATAPI: ASUS    DRW-24B1LT, 1.01, max UDMA/100
[    1.174529] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.175359] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88041c8c5bf0), AE_NOT_FOUND (20130725/psparse-536)
[    1.177056] ata3.00: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[    1.177915] ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.178824] ata1.00: ATA-9: M4-CT064M4SSD2, 000F, max UDMA/100
[    1.179684] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.180567] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.181439] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node ffff88041c8c5b00), AE_NOT_FOUND (20130725/psparse-536)
[    1.183191] ata4.00: configured for UDMA/100
[    1.184061] ata2.00: configured for UDMA/133
[    1.185292] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.186206] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88041c8c5c68), AE_NOT_FOUND (20130725/psparse-536)
[    1.188134] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    1.189116] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88041c8c5b78), AE_NOT_FOUND (20130725/psparse-536)
[    1.191115] ata1.00: configured for UDMA/100
[    1.192194] ata3.00: configured for UDMA/133
[    1.192246] scsi 0:0:0:0: Direct-Access     ATA      M4-CT064M4SSD2   000F PQ: 0 ANSI: 5
[    1.192370] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    1.192560] scsi 1:0:0:0: Direct-Access     ATA      ST3000VX000-9YW1 CV13 PQ: 0 ANSI: 5
[    1.192671] sd 0:0:0:0: [sda] Write Protect is off
[    1.192672] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.192692] sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    1.192693] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.192714] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.192879] sd 1:0:0:0: [sdb] Write Protect is off
[    1.192881] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.192943] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.201909] scsi 2:0:0:0: Direct-Access     ATA      WDC WD15EARS-00Z 80.0 PQ: 0 ANSI: 5
[    1.202801]  sda: sda1 sda2 sda3
[    1.203322] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.204840] sd 2:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    1.204972] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.206708] sd 2:0:0:0: [sdc] Write Protect is off
[    1.207577] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.207586] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.208497] scsi 3:0:0:0: CD-ROM            ASUS     DRW-24B1LT       1.01 PQ: 0 ANSI: 5
[    1.212773] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.213695] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.214663] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.228651]  sdb: sdb1 sdb2 sdb3
[    1.229991] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.231061]  sdc: sdc1
[    1.232048] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.254065] btrfs: device label melforce_root devid 1 transid 2425 /dev/sda3
[    1.255410] btrfs: disk space caching is enabled
[    1.264354] Btrfs detected SSD devices, enabling SSD mode
[    1.266244] VFS: Mounted root (btrfs filesystem) readonly on device 0:13.
[    1.267343] devtmpfs: mounted
[    1.268523] Freeing unused kernel memory: 772K (ffffffff8161c000 - ffffffff816dd000)
[    1.308550] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP -AUDIT -SELINUX +IMA -SYSVINIT +LIBCRYPTSETUP -GCRYPT +ACL -XZ)
[    1.312669] systemd[1]: Set hostname to <melforce>.
[    1.328041] systemd[1]: /usr/lib/systemd/system-generators/gentoo-local-generator exited with exit status 1.
[    1.337634] hub 1-1:1.0: USB hub found
[    1.338492] hub 1-1:1.0: 6 ports detected
[    1.355018] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    1.355837] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    1.356617] systemd[1]: Starting Login Prompts.
[    1.358202] systemd[1]: Reached target Login Prompts.
[    1.358955] systemd[1]: Starting Remote File Systems.
[    1.360452] systemd[1]: Reached target Remote File Systems.
[    1.361208] systemd[1]: Expecting device sys-subsystem-net-devices-lan0.device...
[    1.362725] systemd[1]: Starting Delayed Shutdown Socket.
[    1.364232] systemd[1]: Listening on Delayed Shutdown Socket.
[    1.364991] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    1.366477] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    1.367206] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    1.367962] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    1.368697] systemd[1]: Starting Encrypted Volumes.
[    1.370215] systemd[1]: Reached target Encrypted Volumes.
[    1.370967] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    1.371729] systemd[1]: Starting Journal Socket.
[    1.373293] systemd[1]: Listening on Journal Socket.
[    1.374396] systemd[1]: Started Set Up Additional Binary Formats.
[    1.375139] systemd[1]: Starting Setup Virtual Console...
[    1.376789] systemd[1]: Mounted Huge Pages File System.
[    1.377500] systemd[1]: Mounting POSIX Message Queue File System...
[    1.379118] systemd[1]: Mounting Debug File System...
[    1.386969] systemd[1]: Starting Apply Kernel Variables...
[    1.388562] systemd[1]: Starting Journal Service...
[    1.390812] systemd[1]: Started Journal Service.
[    1.395294] systemd-journald[101]: Vacuuming done, freed 0 bytes
[    1.400157] fuse init (API version 7.22)
[    1.439982] systemd-udevd[133]: starting version 208
[    1.448830] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.472907] wmi: Mapper loaded
[    1.473459] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
[    1.473460] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.473465] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    1.473467] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \_SB_.PCI0.LPCB.GPBX 2 (20130725/utaddress-251)
[    1.473467] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.473469] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    1.473471] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.LPCB.GPBX 2 (20130725/utaddress-251)
[    1.473471] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.473473] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    1.473474] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.LPCB.GPBX 2 (20130725/utaddress-251)
[    1.473476] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_GPE.GPIO 3 (20130725/utaddress-251)
[    1.473476] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.473477] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.486946] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    1.487049] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    1.498647] nvidia: module license 'NVIDIA' taints kernel.
[    1.499700] Disabling lock debugging due to kernel taint
[    1.500870] systemd-udevd[146]: renamed network interface eth0 to lan1
[    1.505968] pci 0000:04:00.0: setting latency timer to 64
[    1.505976] snd_cmipci 0000:05:01.0: enabling device (0080 -> 0081)
[    1.509274] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[    1.510393] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  334.16  Tue Feb  4 14:41:05 PST 2014
[    1.515414] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    1.516555] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    1.516854] systemd-udevd[139]: renamed network interface eth1 to lan0
[    1.518896] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    1.520156] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    1.521731] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    1.522912] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    1.524129] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    1.524162] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    1.524444] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    1.524506] hda_intel: Disabling MSI
[    1.530174] ACPI Warning: 0x000000000000f000-0x000000000000f01f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130725/utaddress-251)
[    1.532391] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.537298] btrfs: device label melforce_root devid 1 transid 2425 /dev/sda3
[    1.581192] hub 2-1:1.0: USB hub found
[    1.582298] hub 2-1:1.0: 8 ports detected
[    1.589733] nvidia 0000:01:00.0: irq 50 for MSI/MSI-X
[    1.618043] btrfs: use lzo compression
[    1.618983] btrfs: use ssd allocation scheme
[    1.619897] btrfs: enabling auto defrag
[    1.620823] btrfs: enabling inode map caching
[    1.621689] btrfs: disk space caching is enabled
[    1.622793] found orphan item for inode 184722, last_objectid 0
[    1.624068] unlink is happening
[    1.626323] found orphan item for inode 180735, last_objectid 184722
[    1.627374] unlink is happening
[    1.628272] found orphan item for inode 869, last_objectid 180735
[    1.629138] unlink is happening
[    1.630068] BTRFS debug (device sda3): unlinked 3 orphans
[    1.634379] btrfs: device label melforce_root devid 1 transid 2425 /dev/sda3
[    1.636091] btrfs: device label melforce_root devid 1 transid 2425 /dev/sda3
[    1.639766] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: discard
[    1.656913] usb 1-1.5: new full-speed USB device number 3 using ehci-pci
[    1.716658] tsc: Refined TSC clocksource calibration: 3110.439 MHz
[    1.769101] logitech-djreceiver 0003:046D:C52B.0003: hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.5/input2
[    1.772303] input: Logitech Unifying Device. Wireless PID:1025 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.2/0003:046D:C52B.0003/input/input13
[    1.773911] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:1025] on usb-0000:00:1a.0-1.5:1
[    1.781453] Adding 17825788k swap on /dev/sdb1.  Priority:-1 extents:1 across:17825788k 
[    1.784740] btrfs: device label melforce_hdd devid 1 transid 647 /dev/sdb3
[    1.789114] btrfs: device label melforce_hdd devid 1 transid 647 /dev/sdb3
[    1.790147] btrfs: use no compression
[    1.790978] btrfs: disk space caching is enabled
[    1.791949] btrfs: device label melforce_hdd devid 1 transid 647 /dev/sdb3
[    1.832644] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    1.840633] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card2/input15
[    1.841539] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card2/input14
[    1.971223] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
[    2.004175] usb-storage 1-1.6:1.0: USB Mass Storage device detected
[    2.005125] scsi6 : usb-storage 1-1.6:1.0
[    2.080535] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
[    2.244430] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
[    2.348996] input: HID 0566:3107 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input16
[    2.349948] hid-generic 0003:0566:3107.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 0566:3107] on usb-0000:00:1d.0-1.2/input0
[    2.355393] input: HID 0566:3107 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.1/input/input17
[    2.356441] hid-generic 0003:0566:3107.0006: input,hidraw3: USB HID v1.10 Device [HID 0566:3107] on usb-0000:00:1d.0-1.2/input1
[    2.428290] usb 2-1.4: new full-speed USB device number 5 using ehci-pci
[    2.447026] systemd-journald[101]: Received request to flush runtime journal from PID 1
[    2.459105] NVRM: Your system is not currently configured to drive a VGA console
[    2.459746] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
[    2.460375] NVRM: requires the use of a text-mode VGA console. Use of other console
[    2.460983] NVRM: drivers including, but not limited to, vesafb, may result in
[    2.461599] NVRM: corruption and stability problems, and is not supported.
[    2.713223] Bluetooth: Core ver 2.16
[    2.714015] NET: Registered protocol family 31
[    2.714791] Bluetooth: HCI device and connection manager initialized
[    2.715581] Bluetooth: HCI socket layer initialized
[    2.716377] Bluetooth: L2CAP socket layer initialized
[    2.717150] Bluetooth: SCO socket layer initialized
[    2.717917] Switched to clocksource tsc
[    2.718458] usbcore: registered new interface driver btusb
[    3.005663] scsi 6:0:0:0: Direct-Access     JetFlash Transcend 16GB   8.07 PQ: 0 ANSI: 2
[    3.007835] sd 6:0:0:0: [sdd] 31375360 512-byte logical blocks: (16.0 GB/14.9 GiB)
[    3.009304] sd 6:0:0:0: [sdd] Write Protect is off
[    3.010070] sd 6:0:0:0: [sdd] Mode Sense: 03 00 00 00
[    3.010645] sd 6:0:0:0: [sdd] No Caching mode page found
[    3.011395] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[    3.015015] sd 6:0:0:0: [sdd] No Caching mode page found
[    3.015743] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[    4.335213]  sdd: sdd1 sdd9
[    4.339042] sd 6:0:0:0: [sdd] No Caching mode page found
[    4.339752] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[    4.340414] sd 6:0:0:0: [sdd] Attached SCSI removable disk
[    4.444918] SPL: Loaded module v0.6.2-1
[    4.456123] ZFS: Loaded module v0.6.2-1, ZFS pool version 5000, ZFS filesystem version 5
[    6.573823] nct6775: Found NCT6776D/F or compatible chip at 0x2e:0x290
[    6.574408] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \_GPE.HWRE 1 (20130725/utaddress-251)
[    6.575628] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.704476] Bluetooth: RFCOMM TTY layer initialized
[    6.705060] Bluetooth: RFCOMM socket layer initialized
[    6.705636] Bluetooth: RFCOMM ver 1.11
[    6.746295] IPv6: ADDRCONF(NETDEV_UP): veth1: link is not ready
[    6.768743] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
[    6.775954] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.782378] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.869672] nvidia 0000:01:00.0: irq 50 for MSI/MSI-X
[    6.977252] r8169 0000:07:00.0 lan0: link down
[    6.977259] device lan0 entered promiscuous mode
[    6.977276] IPv6: ADDRCONF(NETDEV_UP): lan0: link is not ready
[    6.981270] device veth1 entered promiscuous mode
[    6.984042] br0: port 2(veth1) entered forwarding state
[    6.984047] br0: port 2(veth1) entered forwarding state
[    7.073982] r8169 0000:07:00.0 lan0: link down
[    9.326726] r8169 0000:07:00.0 lan0: link up
[    9.326734] IPv6: ADDRCONF(NETDEV_CHANGE): lan0: link becomes ready
[    9.327540] br0: port 1(lan0) entered forwarding state
[    9.327544] br0: port 1(lan0) entered forwarding state
[   21.975488] br0: port 2(veth1) entered forwarding state
[   24.341929] br0: port 1(lan0) entered forwarding state
[ 6005.607672] SPL: using hostid 0x00000000
[15661.933166] input: 00:02:3C:31:96:12 as /devices/virtual/input/input18
[17933.818432] input: 00:02:3C:31:96:12 as /devices/virtual/input/input19
[18596.247648] Peer 85.151.138.89:64241/15292 unexpectedly shrunk window 4231871295:4231879612 (repaired)
[18838.843485] usb 1-1.6: USB disconnect, device number 4
[24413.559519] btrfs: device label melforce_root devid 1 transid 2435 /dev/sda3
[24414.003679] btrfs: device label melforce_hdd devid 1 transid 1286 /dev/sdb3
[24414.438678] found orphan item for inode 153006, last_objectid 0
[24414.438681] unlink is happening
[24414.438682] found orphan item for inode 153006, last_objectid 153006
[24414.438684] BTRFS error (device sdb3): Error removing orphan entry, stopping orphan cleanup
[24414.438686] BTRFS critical (device sdb3): could not do orphan cleanup -22

--nextPart2836118.Zk7nxyL0x2--

