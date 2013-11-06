Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f194.google.com ([74.125.82.194]:56244 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3KFDEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 22:04:20 -0500
Received: by mail-we0-f194.google.com with SMTP id u57so1058595wes.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 19:04:16 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 6 Nov 2013 03:04:16 +0000
Message-ID: <CA+E_Msx0Mgu8nti9x7P-Q0ye76BDSkaj2E-cQvX9WGqs_Kj_vg@mail.gmail.com>
Subject: mount ("ro", "ro,recovery", and "recovery") fail with open_ctree failed
From: Cody Schafer <cody@codyps.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After a hard shutdown (by holding down the power button), mount ("ro",
"ro,recovery", and "recovery") fails with some error output.


Further, btrfs-image (v0.20-rc1-358-g194aa4a)  produces an empty output file.

---
root@sysresccd /mnt/backup/g/btrfs-progs % ./btrfs-image
/dev/mapper/nb205--ssd-main /mnt/backup/nb205.btrfs -w
Check tree block failed, want=610545664, have=12878227550790025961
Check tree block failed, want=610545664, have=12878227550790025961
Check tree block failed, want=610545664, have=3755836431281323167
Check tree block failed, want=610545664, have=3755836431281323167
Check tree block failed, want=610545664, have=3755836431281323167
read block failed check_tree_block
Couldn't setup log root tree
Open ctree failed
create failed (Success)
---

Logs from attempting to mount on 3.10.17: (specifcally,
Linux zero 3.11.2-gentoo #1 SMP Sun Sep 29 05:45:14 EST 2013 x86_64
Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz GenuineIntel GNU/Linux).

---
[  198.686673] bio: create slab <bio-2> at 2
[  215.052531] device fsid 836470b4-7960-4507-858e-991c94139c9c devid
1 transid 9 /dev/dm-0
[  235.732725] device fsid 9c37c7d8-0fcb-4154-be3b-647b0aca9975 devid
1 transid 235930 /dev/dm-2
[  244.882515] device fsid 9c37c7d8-0fcb-4154-be3b-647b0aca9975 devid
1 transid 235930 /dev/dm-2
[  303.683899] device fsid 9c37c7d8-0fcb-4154-be3b-647b0aca9975 devid
1 transid 235930 /dev/mapper/nb205--ssd-main
[  303.686539] btrfs: use ssd allocation scheme
[  303.686554] btrfs: disk space caching is enabled
[  304.363253] btrfs bad tree block start 12878227550790025961 610545664
[  304.363725] btrfs bad tree block start 3755836431281323167 610545664
[  304.363757] btrfs: failed to read log tree
[  304.377198] btrfs: open_ctree failed
[  536.047135] device fsid 9c37c7d8-0fcb-4154-be3b-647b0aca9975 devid
1 transid 235930 /dev/mapper/nb205--ssd-main
[  536.050442] btrfs: use ssd allocation scheme
[  536.050461] btrfs: enabling auto recovery
[  536.050466] btrfs: disk space caching is enabled
[  536.622400] btrfs bad tree block start 12878227550790025961 610545664
[  536.622866] btrfs bad tree block start 3755836431281323167 610545664
[  536.622897] btrfs: failed to read log tree
[  536.635123] btrfs: open_ctree failed
[  550.026300] device fsid 9c37c7d8-0fcb-4154-be3b-647b0aca9975 devid
1 transid 235930 /dev/mapper/nb205--ssd-main
[  550.030176] btrfs: use ssd allocation scheme
[  550.030191] btrfs: enabling auto recovery
[  550.030195] btrfs: disk space caching is enabled
[  550.763381] btrfs bad tree block start 12878227550790025961 610545664
[  550.763849] btrfs bad tree block start 3755836431281323167 610545664
[  550.763882] btrfs: failed to read log tree
[  550.779138] btrfs: open_ctree failed
[ 1239.964789] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
---

The mount also fails on 3.11.6.

I've not tried btrfs-zero-log yet in case that happens to "work". What
can I do to help debug this?
