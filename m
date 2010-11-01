From: =?windows-1252?Q?Andreas_Bauer?= <ab@voltage.de>
Subject: RE: Kernel 2.6.36 btrfs csum bugreport
Date: Mon, 1 Nov 2010 01:35:14 +0100
Message-ID: <vmime.4cce0b42.4e03.7a6f42ce1e8ae262@mail.voltage.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: linux-btrfs@vger.kernel.org
To: =?windows-1252?Q?cwillu?= <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So I conclude that these messages are faulty because data is read correctly. 
 In addition, when you have more than one btrfs you cannot see from the message 
 which fs it is refering to.
 
 Is this a raid1 or a dup array?

No, plain vanilla partition on physical hard disk. Btrfs was made with the command "mkfs.btrfs /dev/sdc1" no extra arguments.

bye, A.B.
