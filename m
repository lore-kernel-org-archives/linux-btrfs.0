From: "Helmut Hullen" <Hullen@t-online.de>
Subject: LABEL only 1 device
Date: 26 Feb 2012 16:23:00 +0100
Message-ID: <C3b0ka5D1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

maybe it's a big error using the commmand

  mkfs.btrfs -L xyz /dev/sdx1 /dev/sdy1 /dev/sdz1

(and so labelling many partitions) because each device/partition gets  
the same label.

Mounting seems to be no problem, but (p.e.) "delete" doesn't kill the  
btrfs informations shown with (p.e.) "blkid /dev/sdy1", especially it  
doesn't delete the label.

Viele Gruesse!
Helmut
