From: jck <jck@archlinux.us>
Subject: Disk space usage displayed incorrectly?
Date: Sat, 10 Jul 2010 07:22:26 +0530
Message-ID: <AANLkTil1adG5cmYxbjvzv7OygH9q12SyA2HL8bOWtuxp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
when i check diskspace usage of a btrfs partition using df i get the
wrong free space, this is expected i think.
However even when i use 'btrfs filesystem df' I get wrong freespace:
Data: total=123.58GB, used=87.31GB
Metadata: total=61.00GB, used=396.29MB
System: total=32.00MB, used=16.00KB

Does this mean that after the 123 GB of 'Data' fills up I wont be able
to add more stuff to the partition?
I'm using btrfs-progs-git (jul 10)
