From: "A. James Lewis" <james@fsck.co.uk>
Subject: Confusing...
Date: Sat, 30 Apr 2011 21:42:39 +0100
Message-ID: <d513343c4c6ac383232407e4c6c585ac.squirrel@mail.fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


After completing an installation of Ubuntu 11.04 with a separate /boot
partition and BTRFS as the main filesystem (Ubuntu creates subvolumes for
/ and /home).

sda1 being the GPT stuff
sda2 being most of the disk as BTRFS
sda3 being /boot
sda4 being swap

sdb having an identical partition table...

I patched everything up to date, rebooted to make sure that all was ok..
and then ran:-

btrfs device add /dev/sdb2 /
sync
reboot

The system stops in initrd unable to find the root filesystem...

It's my understanding that nothing should change here, am I missing
something, I don't see how it can even tell I've added more storage, let
alone fail to boot.

-- 
A. James Lewis (james@fsck.co.uk)
"Engineering does not require science. Science helps a lot but people built
perfectly good brick walls long before they knew why cement works."


