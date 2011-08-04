From: "Helmut Hullen" <Hullen@t-online.de>
Subject: INSTALL hint: create device btrfs-control
Date: 04 Aug 2011 12:10:00 +0200
Message-ID: <BrDeAL0D1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

you should please add a hint in

   .../git/mason/btrfs-progs-unstable.git

in the file "INSTALL" with at least the contents (please excuse my  
gerlish)

"btrfs" needs the device "btrfs-control". Perhaps you have to create it:

        mknod /dev/btrfs-control c 10 234

Viele Gruesse!
Helmut
