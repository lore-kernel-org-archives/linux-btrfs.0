Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:58956 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbbAXOq1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 09:46:27 -0500
Message-ID: <54C3B03E.8080002@pocock.pro>
Date: Sat, 24 Jan 2015 15:46:22 +0100
From: Daniel Pocock <daniel@pocock.pro>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 migrate to bigger disks
References: <54C3AD0C.7080407@pocock.pro> <20150124143632.GF1654@carfax.org.uk>
In-Reply-To: <20150124143632.GF1654@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



On 24/01/15 15:36, Hugo Mills wrote:
> On Sat, Jan 24, 2015 at 03:32:44PM +0100, Daniel Pocock wrote:
>> 
>> 
>> 
>> I've got a RAID1 on two 1TB partitions, /dev/sda3 and /dev/sdb3
>> 
>> I'm adding two new disks, they will have bigger partitions
>> /dev/sdc3 and /dev/sdd3
>> 
>> I'd like the BtrFs to migrate from the old partitions to the new
>> ones as safely and quickly as possible and if it is reasonable to
>> do so, keeping it online throughout the migration.
>> 
>> Should I do the following:
>> 
>> btrfs device add /dev/sdc3 /dev/sdd3 /mnt/btrfs0 btrfs device
>> delete /dev/sda3 /dev/sdb3 /mnt/btrfs0
>> 
>> or should I do it this way:
>> 
>> btrfs device add /dev/sdc3 /mnt/btrfs0 btrfs device delete
>> /dev/sda3 /mnt/btrfs0 btrfs device add /dev/sdd3 /mnt/btrfs0 
>> btrfs device delete /dev/sdb3 /mnt/btrfs0
>> 
>> or is there some other way to go about it?
> 
> btrfs replace start /dev/sda3 /dev/sdc3 /mountpoint btrfs fi resize
> 3:max /mountpoint btrfs replace start /dev/sdb3 /dev/sdd3
> /mountpoint btrfs fi resize 4:max /mountpoint
> 
> The 3 and 4 in the resize commands should be the devid of the 
> newly-added device.

Thanks for the fast reply

In the event of power failure, can I safely shutdown the server during
this operation and resume after starting again?

I get more than 2 hours runtime from the UPS but I suspect that
migrating 1TB will take at least 12 hours.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBCAAGBQJUw7A+AAoJEOm1uwJp1aqDIuoQAKLkc0DgDj1bE6b6RPh6cnb9
lm+rjJD6aCo84dKZ3kVjaYCuUrFK5uXdj1D3ZrELD//jyjr6HbMK7CSJzuzfxmol
rMRM0NaVb4RJ4WPuzbnUjT8pmNytisfP9oG1mV9JmJ+y6sZ2ApvOQwPyHpHWglSL
D+H4clpOa3jXCeNoVxjm1eipLSWnnpSO4NVdXTIgBiHqUaR+LpKpUlh3QGtknvV/
uHegNuTJ+C4/Stp3hrzKy0/OUlIyzucFEXKPJbI/88XvMuZcL/XTO8FoHRP4r/vq
qjICj4Dtjv+xOOe7WKT1Gw8wCz/66xMfSXIUSU02insfwfh0/fFpAS6XybKk4UsH
i7LwswqduJMgFiVHv9bMvwyx3UdmhVJRotjGobVP3XPbI3GMSCEztXHdSGLOFE9D
/IksBehi0XNw/YWOaLcoyA2XTXahBTcsTtktkZStrn5kKXvOPuE7LDyjkHq/o9W8
IYvti9Dvx2IicdJxRM7+5F6bKON2O7foDuSUJFd6/WAkrLVwdudurTqGDmk+uIdS
kZVUVpehmdjYltUyb4wY/ATAvKnQTm/U18L04pSQIbdtdQZD7bAVl7PotLctgdHn
xf7TokhjJZZmOk4C29m+uAQHy0gobDDXlPi3jtpO4Zj+CR9pXM1/+oa40xhWh4Eh
WtDofKi5z7BLVYFNqIix
=BR1V
-----END PGP SIGNATURE-----
