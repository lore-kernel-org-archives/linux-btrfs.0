From: "Helmut Hullen" <Hullen@t-online.de>
Subject: "scrub" stops the machine
Date: 17 Mar 2012 17:35:00 +0100
Message-ID: <C52qjJ2y1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

next problem ...


I had tested the next possible steps after deleting a partition.

        btrfs device delete /dev/sdb1 /mnt/btr

worked well.

Then

        btrfs scrub start /mnt/btr

and all was dead. Really dead. No access via keybord, no access via SSH.

Restarted the machine, mounted the btrfs bundle, then again

        btrfs scrub start /mnt/btr

and the same reaction. Dead.

No entry in "/var/log/messages", no entry in "/var/log/warn".

Viele Gruesse!
Helmut
