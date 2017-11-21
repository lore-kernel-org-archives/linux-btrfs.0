Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:34873 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbdKUWEw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 17:04:52 -0500
Received: by mail-ot0-f180.google.com with SMTP id b17so11896493oth.2
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 14:04:52 -0800 (PST)
MIME-Version: 1.0
From: Andy Leadbetter <andy.leadbetter@theleadbetters.com>
Date: Tue, 21 Nov 2017 22:04:50 +0000
Message-ID: <CAJUWh6odg=eAxmQk_+gvrMkqrptEpykd4EB54_tF31grELsGgQ@mail.gmail.com>
Subject: Kernel 4.14 RAID5 multi disk array on bcache not mounting
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 4 disk array on top of 120GB bcache setup, arranged as follows

dev/sda1: UUID="42AE-12E3" TYPE="vfat" PARTLABEL="EFI System"
PARTUUID="d337c56a-fb0f-4e87-8d5f-a89122c81167"
/dev/sda2: UUID="06e3ce52-f34a-409a-a143-3c04f1d334ff" TYPE="ext4"
PARTLABEL="Linux filesystem"
PARTUUID="d2d3fa93-eebf-41ab-8162-d81722bf47ec"
/dev/sda4: UUID="b729c490-81f0-461f-baa2-977af9a7b6d9" TYPE="bcache"
PARTLABEL="Linux filesystem"
PARTUUID="84548857-f504-440a-857f-c0838c1eb83d"
/dev/sdb1: UUID="6016277c-143d-46b4-ae4e-8565ffc8158f" TYPE="swap"
PARTLABEL="Linux swap" PARTUUID="8692bf67-7271-4bf6-a623-b79d74093f2c"
/dev/sdb2: UUID="bc93c5e2-705a-4cbe-bcd9-7be1181163b2" TYPE="bcache"
PARTLABEL="Linux filesystem"
PARTUUID="662a450b-3592-4929-9647-8e8a1dedae69"
/dev/sdc1: UUID="9df21d4e-de02-4000-b684-5fb95d4d0492" TYPE="swap"
PARTLABEL="Linux swap" PARTUUID="ed9d7b8e-5480-4e70-b983-1a350ecae38a"
/dev/sdc2: UUID="7d8feaf6-aa6a-4b13-af49-0ad1bd1efb64" TYPE="bcache"
PARTLABEL="Linux filesystem"
PARTUUID="d343e23a-39ed-4061-80a2-55b66e20ecc1"
/dev/sdd1: UUID="18defba2-594b-402e-b3b2-8e38035c624d" TYPE="swap"
PARTLABEL="Linux swap" PARTUUID="fed9ffd6-0480-4496-8e6d-02d263d719b7"
/dev/sdd2: UUID="be0f0381-0d7e-46c9-ad04-01415bfc6f61" TYPE="bcache"
PARTLABEL="Linux filesystem"
PARTUUID="8f56de8a-105f-4d56-b699-59e1215b3c6b"
/dev/bcache32: UUID="38d5de43-28fb-40a9-a535-dbf17ff52e75"
UUID_SUB="731c31f1-51dd-477a-9bd1-fac73d0e6f69" TYPE="btrfs"
/dev/sde: UUID="05514ad3-d90a-4e90-aa11-7c6d34515ca2" TYPE="bcache"
/dev/bcache16: UUID="38d5de43-28fb-40a9-a535-dbf17ff52e75"
UUID_SUB="79cbcaf1-40b9-4954-a977-537ed3310e76" TYPE="btrfs"
/dev/bcache0: UUID="38d5de43-28fb-40a9-a535-dbf17ff52e75"
UUID_SUB="42d3a0dd-fbec-4318-9a5b-6d96aa1f6328" TYPE="btrfs"
/dev/bcache48: UUID="38d5de43-28fb-40a9-a535-dbf17ff52e75"
UUID_SUB="cb7018d6-a27d-493e-b41f-e45c64f6873a" TYPE="btrfs"
/dev/sda3: PARTUUID="d9fa3100-5044-4e10-9f2f-f8037786a43f"


ubuntu 17.10 with PPA Kernels up to 4.13.x all mount this array
perfectly, and the performance of the cache is as expected.

Upgraded today to 4.14.1 from their PPA and the

running btrfs dev scan finds the btrfs filesystem devices bcache16 and
bcache32, bcache0 and bcache48 are not recognised, and thus the file
system will not mount.

according bcache all devices are present, and attached to the cache
device correctly.

btrfs fi on Kernel 4.13 gives

Label: none  uuid: 38d5de43-28fb-40a9-a535-dbf17ff52e75
        Total devices 4 FS bytes used 2.03TiB
        devid    1 size 1.82TiB used 1.07TiB path /dev/bcache16
        devid    2 size 1.82TiB used 1.07TiB path /dev/bcache32
        devid    3 size 1.82TiB used 1.07TiB path /dev/bcache0

        devid    4 size 1.82TiB used 1.07TiB path /dev/bcache48


Where do I start in debugging this?

btrfs-progs v4.12

btrfs fi df /

Data, RAID5: total=3.20TiB, used=2.02TiB
System, RAID5: total=192.00MiB, used=288.00KiB
Metadata, RAID5: total=6.09GiB, used=3.69GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

There are no errors in the dmesg that I can see from btrfs scan,
simply the two devices are not found.
