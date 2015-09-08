Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33027 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbIHTS0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 15:18:26 -0400
Received: by wiclk2 with SMTP id lk2so131944434wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 12:18:25 -0700 (PDT)
MIME-Version: 1.0
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Tue, 8 Sep 2015 21:18:05 +0200
Message-ID: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
Subject: [btrfs tools] ability to fail a device...
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Currently i have a raid1 configuration on two disks where one of them
is failing.

But since:
btrfs fi df /mnt/disk/
Data, RAID1: total=858.00GiB, used=638.16GiB
Data, single: total=1.00GiB, used=256.00KiB
System, RAID1: total=32.00MiB, used=132.00KiB
Metadata, RAID1: total=4.00GiB, used=1.21GiB
GlobalReserve, single: total=412.00MiB, used=0.00B

There should be no problem in failing one disk... Or so i thought!

btrfs dev delete /dev/sdb2 /mnt/disk/
ERROR: error removing the device '/dev/sdb2' - unable to go below two
devices on raid1

And i can't issue rebalance either since it will tell me about errors
until the failing disk dies.

Whats even more interesting is that i can't mount just the working
disk - ie if the other disk
*has* failed and is inaccessible... though, i haven't tried physically
removing it...

mdam has fail and remove, I assume for this reason - perhaps it's
something that should be added?

uname -r
4.2.0

btrfs --version
btrfs-progs v4.1.2
