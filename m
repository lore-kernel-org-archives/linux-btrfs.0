Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40671 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3AQUXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 15:23:17 -0500
Received: by mail-pb0-f43.google.com with SMTP id jt11so233827pbb.16
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2013 12:23:17 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 17 Jan 2013 17:23:17 -0300
Message-ID: <CAPVzhpxSdjLTUhA0jVm5gLSvX9fB0N9zV6UTTQno2bANTsfGVw@mail.gmail.com>
Subject: btrfs: could not do orphan cleanup -22
From: Reartes Guillermo <rtguille@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I booted the guest in which i was testing btrfs (transient ENOSPC
issues, etc). It booted in emergency mode.

[    6.705187] device label testfs1 devid 1 transid 4141 /dev/sdb1
[    6.724353] device label fedora devid 1 transid 2036 /dev/sda2
[    6.780931] device label fedora devid 1 transid 2036 /dev/sda2
[    6.817157] snd_hda_intel 0000:00:04.0: irq 42 for MSI/MSI-X
[    6.818326] snd_hda_intel 0000:00:04.0: setting latency timer to 64
[    6.928264] Adding 1048572k swap on /dev/sda1.  Priority:-1
extents:1 across:1048572k
[    7.008342] device label testfs1 devid 1 transid 4141 /dev/sdb1
[    7.011071] btrfs: disk space caching is enabled
>> [    7.165692] btrfs: Error removing orphan entry, stopping orphan cleanup
>> [    7.165696] btrfs: could not do orphan cleanup -22
>> [    8.910980] btrfs: open_ctree failed
[    8.944598] systemd-journald[292]: Received SIGTERM
[   70.616949] systemd-modules-load[453]: Module 'uinput' is already loaded
[   70.676072] systemd-udevd[457]: starting version 197
[   70.937319] microcode: AMD CPU family 0x6 not supported
[   71.598671] btrfs: disk space caching is enabled
[   71.617841] device label testfs1 devid 1 transid 4143 /dev/sdb1
[   71.619164] btrfs: disk space caching is enabled
[   71.629969] device label fedora devid 1 transid 2038 /dev/sda2
[   71.805339] btrfs: Error removing orphan entry, stopping orphan cleanup
[   71.806597] btrfs: could not do orphan cleanup -22
[   71.986601] device label testfs1 devid 1 transid 4143 /dev/sdb1
[   72.934724] btrfs: open_ctree failed

I tried to btrfsck sdb1, the first time it

hecking extents
checking fs roots
checking root refs
found 23233744896 bytes used err is 0
total csum bytes: 21888908
total tree bytes: 809082880
total fs tree bytes: 744513536
btree space waste bytes: 209930514
file data blocks allocated: 22424662016
 referenced 22424662016
Btrfs Btrfs v0.19

Since sda2 is mounted i could not check it, but from the logs it is
not clear to me if the issue is in sda2 or sdb1.

maybe the error should be something like that:
btrfs: sdaX: Error XXXXXX

I intend to reinstall the guest, since it is for testing purposes
(btrfs testing)

I booted first with 3.8.0-0.rc3.git1.1.fc19 (which has a lot of
issues) and then back with 3.7.2-201.fc18.

Cheers.
