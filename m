Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp3.hushmail.com ([65.39.178.200]:42729 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbDQUYk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 16:24:40 -0400
Received: from smtp3.hushmail.com (localhost [127.0.0.1])
	by smtp3.hushmail.com (Postfix) with SMTP id 3CBB6E08E1
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 19:46:09 +0000 (UTC)
Received: from smtp.hushmail.com (w5.hushmail.com [65.39.178.80])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp3.hushmail.com (Postfix) with ESMTPS
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 19:46:09 +0000 (UTC)
MIME-Version: 1.0
Date: Fri, 17 Apr 2015 21:46:08 +0200
To: linux-btrfs@vger.kernel.org
Subject: Background corrections don't show up in device stats, and have low syslog priority. How do I reliably find out about them?
From: ivarun_ml@nym.hush.com
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20150417194609.1192EA03BC@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been running some simple tests in a virtual machine with btrfs raid1 and I found the background correction behaviour to be a bit surprising. I've set up a raid1 and stored a big file along with its sha256sum on the volume. If I manually corrupt one of the underlying devices and run a btrfs scrub then btrfs device stats will show the corruption tally, and the system log will contain err-priority messages informing of the corruption, for example:
BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 94917, gen 0
BTRFS: fixed up error at logical 943534080 on dev /dev/sdb

But if I instead just read the file, then btrfs will still detect and correct the corruption, but the device stats are not updated, and the errors in the syslog have info-priority, making them much harder to notice. Examples:
BTRFS (device sde): bad tree block start 17335229606580733495 521674752
BTRFS info (device sde): csum failed ino 257 off 691347456 csum 4171722801 expected csum 2566472073

If a scrub is run after the file has been read, then some corruptions are still found (presumably because only parts of the file were read from that particular device), but the error count is much lower. I take this to mean that all of the corruptions that were corrected in the background have been "lost", and will not show up in the device stats even after a scrub.

Is this the intended behaviour? What would be the best practice for checking if corruption has been detected under normal operation? Would something like journalctl | grep "csum failed" be robust? Personally I would have expected these messages to have "err" priority, and for the device stats to be updated.

Here is a sample session of the kind of test I've done:

linux-57zx:~ # lsb_release -a
LSB Version:    n/a
Distributor ID: openSUSE project
Description:    openSUSE 20150413 (Tumbleweed) (x86_64)
Release:        20150413
Codename:       n/a
linux-57zx:~ # uname -a
Linux linux-57zx.site 3.19.3-1-desktop #1 SMP PREEMPT Thu Mar 26 17:34:34 UTC 2015 (f10e7fc) x86_64 x86_64 x86_64 GNU/Linux
linux-57zx:~ # btrfs --version
btrfs-progs v3.19.1+20150325
linux-57zx:~ # btrfs fi show
Label: none  uuid: 34d008ef-1d32-4177-9cab-628257ab5302
        Total devices 1 FS bytes used 4.63GiB
        devid    1 size 125.99GiB used 6.04GiB path /dev/sda2

Label: none  uuid: 143c7163-88b1-4e07-9223-6509eae1945d
        Total devices 3 FS bytes used 801.23MiB
        devid    1 size 512.00MiB used 511.00MiB path /dev/sdb
        devid    2 size 512.00MiB used 511.00MiB path /dev/sdc
        devid    3 size 1.00GiB used 1022.00MiB path /dev/sde

btrfs-progs v3.19.1+20150325
linux-57zx:~ # btrfs fi df /mnt/raid/
System, RAID1: total=8.00MiB, used=4.00KiB
Data+Metadata, RAID1: total=1014.00MiB, used=801.23MiB
GlobalReserve, single: total=20.00MiB, used=0.00B
linux-57zx:~ # ls -lh /mnt/raid/
total 801M
-rw-r--r-- 1 root root 800M Apr 16 20:21 zerofile
-rw-r--r-- 1 root root   85 Apr 16 20:22 zerofile.sha256sum
linux-57zx:~ # dd if=/dev/urandom of=/dev/sdb bs=1M count=500
500+0 records in
500+0 records out
524288000 bytes (524 MB) copied, 29.6714 s, 17.7 MB/s
linux-57zx:~ # sha256sum -c /mnt/raid/zerofile.sha256sum 
/mnt/raid/zerofile: OK
linux-57zx:~ # btrfs device stats /mnt/raid/
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    0
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0
[/dev/sdc].write_io_errs   0
[/dev/sdc].read_io_errs    0
[/dev/sdc].flush_io_errs   0
[/dev/sdc].corruption_errs 0
[/dev/sdc].generation_errs 0
[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0

Regards,
Ivar Ursin Nikolaisen

