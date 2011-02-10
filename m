From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: 10 Feb 2011 08:49:00 +0100
Message-ID: <BfbSAmeT1uB@helmut.hullen.de>
References: <ij0238$u5g$1@dough.gmane.org>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ij0238$u5g$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Lubos,

Du meintest am 10.02.11:

>>> /dev/root / btrfs rw,noatime,compress,ssd 0 0


> # ls -la /dev/root
> ls: cannot access /dev/root: No such file or directory

        ls -la $(rdev)

(but that's no simple way ...)

Viele Gruesse!
Helmut
