From: "Helmut Hullen" <Hullen@t-online.de>
Subject: time for "balance"
Date: 09 Nov 2010 16:09:00 +0100
Message-ID: <B$YEgUvD1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I'm working with btrfs for some days.

btrfs-progs-20101101, kernel 2.6.35.8 (both self compiled).

First step:

        mkfs.btrfs /dev/sdd1
        mount /dev/sdd1 /srv/MM

for a 2 TByte partition, worked well.

Copying about 1,5 TByte data to this partition worked well.

Second step:

        btrfs device add /dev/sdc1 /srv/MM
        btrfs filesystem balance /srv/MM

adds /dev/sdc1 with about 1,5 TByte ("df" tells so), and the system  
works the second line ("balance") since about 12 hours. How much time  
needs this "balance" command?

If the machine hangs somewhere and I have to restart it: how can/must I  
repair the btrfs system?

Viele Gruesse!
Helmut
