From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [RFC][BTRFS-PROG] Avoid to scan cdrom and floppy
Date: 15 Jun 2011 22:35:00 +0200
Message-ID: <Bnwmy4zD1uB@helmut.hullen.de>
References: <4DF9160A.4020102@libero.it>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF9160A.4020102@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 15.06.11:

> thanks to the last Hugo's email, I restart to work on the patch which
> avoid to scan cdrom and floppy during a "btrfs filesystem show" and a
> "btrfs device scan". Comparing to my previous patch I modified the
> strategy, and now the scan of the devices is based on the content of
> the file /proc/partitions. The old behavior may be set  passing the
> "--all-devices" options.

Thank you - it's nice for all who don't use udev.

Viele Gruesse!
Helmut
