From: "Helmut Hullen" <Hullen@t-online.de>
Subject: bad tree block start
Date: 22 Oct 2011 09:05:00 +0200
Message-ID: <BwKoID8T1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

my system now shows in "dmesg"

btrfs bad tree block start 0 5064615628800
btrfs bad tree block start 0 5064615632896
btrfs bad tree block start 0 5064615665664
btrfs bad tree block start 0 5064615624704
btrfs bad tree block start 0 5064615628800
btrfs bad tree block start 0 5064615632896
btrfs bad tree block start 0 5064615665664
btrfs bad tree block start 0 5064615624704

Can I repair it? If yes: how?

Kernel 2.6.39.4
btrfs from the "Hugo Mills" tree.
Cluster of 3 Disks, data raid0, metadata raid 1.
Disks: 3* 2TByte, filled with more than 4 TByte.

Viele Gruesse!
Helmut
