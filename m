From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: btrfs crashes after removing drive that is written to and failed mount until btrfs-zero-log afterwards
Date: Sun, 11 Sep 2011 11:56:40 +0200
Message-ID: <201109111156.41052.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Has a developer fixed this issue in the meanwhile? I did it just again=20
today.

I overlooked Dolphin=B4s "device is busy" message and unplugged it agai=
n. I=20
had to reboot, a mount attempt failed, I had to reboot another time, af=
ter=20
btrfs-zero-log it worked. I have traces available but I think this has=20
been reported several times.

Expected results:

BTRFS fails gracefully except the loss of data from writes in flight, t=
he=20
machine remains usable and BTRFS can be mounted again.


Ideal results (IMHO):

Linux behaved like AmigaOS and told me that I *must* insert the device=20
again and *continues* writing after I did this.=20

I write a different mail also to linux-kernel about this.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
