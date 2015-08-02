Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:36833 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbHBRNm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 13:13:42 -0400
Received: by ykeb10 with SMTP id b10so14053789yke.3
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 10:13:41 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Aug 2015 13:13:41 -0400
Message-ID: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
Subject: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have had bad dreams about this particular fat finger but after a few
years it has finally happened.

Scenario: 2 drives in a raw btrfs array (no previous partitions and
non-redundant) with various subvols as well. One was sdc the other was
sde, although sde never displays with mount command and blkid is the
same for both.

Thinking I was writing to a flash drive I sent 32MB via dd
===========================
dd if=file of=/dev/sde
===========================
to sde (instead of what I wanted - sdf) and now the volume nor any of
it's subvol's can mount (of course that seems entirely reasonable,
although you can imagine how unhappy I am).

With:
===========================
mount -t btrfs /mnt/butter/
===========================
I get:
===========================
[ 3421.193103] BTRFS info (device sde): disk space caching is enabled
[ 3421.193734] BTRFS (device sde): bad tree block start
8330001001141004672 20971520
[ 3421.193738] BTRFS: failed to read chunk root on sde
[ 3421.203221] BTRFS: open_ctree failed
===========================

If I specify /dev/sdc instead of relying on fstab I get:
===========================
mount -t btrfs -o degraded /dev/sdc /mnt/butter/
===========================
[ 3839.506766] BTRFS info (device sde): allowing degraded mounts
[ 3839.506769] BTRFS info (device sde): disk space caching is enabled
[ 3839.507154] BTRFS (device sde): bad tree block start
8330001001141004672 20971520
[ 3839.507159] BTRFS: failed to read chunk root on sde
[ 3839.515023] BTRFS: open_ctree failed
===========================

Obligatory details:
===========================
uname -a
Linux sartre 4.1.3-gentoo #1 SMP Sat Jul 25 22:34:14 EDT 2015 x86_64
Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz GenuineIntel GNU/Linux
===========================
btrfs --version
btrfs-progs v4.1.2
===========================
btrfs fi show
Label: 'garage'  uuid: 896f615e-6437-41c6-8f2a-25f73ff1af7a
        Total devices 1 FS bytes used 89.33GiB
        devid    1 size 200.00GiB used 92.02GiB path /dev/sdb3

warning, device 2 is missing
bytenr mismatch, want=20971520, have=0
Couldn't read chunk root
Label: 'terrafirm'  uuid: 09024c28-7932-4ddb-960d-becc1ea839e5
        Total devices 2 FS bytes used 6.40TiB
        devid    1 size 3.64TiB used 3.21TiB path /dev/sdc
        *** Some devices missing

btrfs-progs v4.1.2
===========================
btrfs fi df /mnt/butter
ERROR: couldn't get space info - Inappropriate ioctl for device
ERROR: get_df failed Inappropriate ioctl for device
===========================

Please advise.

Thank you,

Chris
