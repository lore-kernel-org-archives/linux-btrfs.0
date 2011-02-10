From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: 10 Feb 2011 08:47:00 +0100
Message-ID: <BfbSAZDD1uB@helmut.hullen.de>
References: <iiusfk$lp4$1@dough.gmane.org>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iiusfk$lp4$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Lubos,

Du meintest am 09.02.11:

> # cat /proc/mounts

> rootfs / rootfs rw 0 0
> /dev/root / btrfs rw,noatime,compress,ssd 0 0

"/dev/root" is a symlink (which I don't like).

        rdev

shows which real device is meant.

Viele Gruesse!
Helmut
