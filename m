Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:47112 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaAESCD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 13:02:03 -0500
Message-ID: <52C99E19.8020106@jrs-s.net>
Date: Sun, 05 Jan 2014 13:02:01 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, "dhan.war" <wardhan.v.1.0@gmail.com>
Subject: Re: how to properly mount an external usb hard drive & other questions
References: <52C8E0D1.2070904@gmail.com> <52C999D2.4000006@dergleichrichter.de> <52C99B76.2020604@dergleichrichter.de>
In-Reply-To: <52C99B76.2020604@dergleichrichter.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/05/2014 12:50 PM, Justus Seifert wrote:
> oh i forgot: if you want to mount it without su privileges you have to 
> use:
>
> /dev/sdc /path/to/your/favorite/mountpoint compress,noauto,users,user 0 0
If you want LZO compression, as you specified:

           /dev/sdc /path/to/mountpoint compress=lzo,noauto,users,user 0 0

Better yet, if your btrfs is actually on /dev/sdc right now, let's get 
that fstab entry mounting it by UUID instead.

           ls -l /dev/disk/by-uuid | grep sdc
           lrwxrwxrwx 1 root root 10 Jan  3 09:40 
12345678-9abc0-1234-5678-9a0123456789 -> ../../sdc

So then:

           # this is not a real UUID, you need to check 
/dev/disk/by-uuid on your machine for a real UUID
           UUID=12345678-9abc0-1234-5678-9a0123456789 
/path/to/mountpoint   compress=lzo,noauto,users,user   0   0

This is EXTRA important with a USB drive, since it's HIGHLY likely it 
won't always be on the same physical devicename.
