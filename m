From: "Helmut Hullen" <Hullen@t-online.de>
Subject: looking for non existent devices
Date: 17 Mar 2012 10:32:00 +0100
Message-ID: <C52pIRfT1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

some commands still look for non existent devices.

I don't use "udev".
When I run

        btrfs filesystem show

only the existent devices are shown - fine.

When I run

        btrfs filesystem label

or

        btrfs scrub status /dev/sdxn

then I get a lot of error messages with (p.e.)

  failed to read /dev/hda6: No such device or address
  failed to read /dev/sdm7: No such device or address
  failed to read /dev/sr3: No such device or address

Kernel 3.2.9

Viele Gruesse!
Helmut
