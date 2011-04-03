From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: minor ID for btrfs-control
Date: 03 Apr 2011 06:12:00 +0200
Message-ID: <Bj8lmcYy1uB@helmut.hullen.de>
References: <20110402233016.18780.qmail@stuge.se>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402233016.18780.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Peter,

Du meintest am 03.04.11:

>> If you don't want to use udev you have two choices:
>> - use devtmpfs
>> - create manually a device. But nobody guarantee that the
>> minor/major will not  change.

> - use a udev replacement intended for embedded systems, such as mdev


http://wildanm.wordpress.com/2007/08/21/mdev-mini-udev-in-busybox/
http://tinderbox.dev.gentoo.org/misc/mdev.conf

I'll take a try - thank you!

Viele Gruesse!
Helmut
