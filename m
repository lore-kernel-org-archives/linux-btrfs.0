Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60823 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2KCKAb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2012 06:00:31 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2166065eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 03:00:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 3 Nov 2012 11:00:30 +0100
Message-ID: <CAJtBfr-Pu+jCKp59mq9-83PaGzfQyO9MXR5-go18W1gKKc4WFA@mail.gmail.com>
Subject: btrfs kernel threads producing high load and slow system down
From: Florian Lindner <mailinglists@xgm.de>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I habe the problems described in here
https://btrfs.wiki.kernel.org/index.php/Gotchas:

Files with a lot of random writes can become heavily fragmented
(10000+ extents) causing trashing on HDDs and excessive multi-second
spikes of CPU load on systems with an SSD or large amount a RAM.
On servers and workstations this affects databases and virtual machine images.
The nodatacow mount option may be of use here, with associated gotchas.
On desktops this primarily affects application databases (including
Firefox and Chromium profiles, GNOME Zeitgeist, Ubuntu Desktop Couch,
Banshee, and Evolution's datastore.)
Workarounds include manually defragmenting your home directory using
btrfs fi defragment. Auto-defragment (mount option autodefrag) should
solve this problem in 3.0.
Symptoms include btrfs-transacti and btrfs-endio-wri taking up a lot
of CPU time (in spikes, possibly triggered by syncs). You can use
filefrag to locate heavily fragmented files.

Symptoms are: Very high load, btrfs-transacti, btrfs-endio-wri and
other btfs kernel threads producing high IO load (iotop). top shows
low system and user load, but high in state waiting to IO. Extreme
slowdown of the system, application freezes for more than a minute...

I tried to manually defrag my home parition and also added the
autodefrag mount option but this changed nothing.

System is kernel 3.6.4, ArchLinux.

Anything else beside going back to ext4 I can do?

root@horus /home/florian # btrfs fi show
failed to read /dev/sr0
[..]
Label: 'home'  uuid: 271f1598-288e-4213-bb7a-64c3e83c4cd5
        Total devices 1 FS bytes used 1.30TB
        devid    1 size 2.73TB used 1.74TB path /dev/sdb1


Thanks!

Florian
