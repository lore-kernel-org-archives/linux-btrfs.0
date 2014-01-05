Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:47754 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaAESJf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 13:09:35 -0500
Message-ID: <52C99FDD.4090709@jrs-s.net>
Date: Sun, 05 Jan 2014 13:09:33 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, "dhan.war" <wardhan.v.1.0@gmail.com>
Subject: Re: how to properly mount an external usb hard drive & other questions
References: <52C8E0D1.2070904@gmail.com> <52C999D2.4000006@dergleichrichter.de> <52C99B76.2020604@dergleichrichter.de> <52C99E19.8020106@jrs-s.net>
In-Reply-To: <52C99E19.8020106@jrs-s.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2014 01:02 PM, Jim Salter wrote:
> If you want LZO compression, as you specified:
>
>           /dev/sdc /path/to/mountpoint compress=lzo,noauto,users,user 0 0
>
> Better yet, if your btrfs is actually on /dev/sdc right now, let's get 
> that fstab entry mounting it by UUID instead.
>
>           ls -l /dev/disk/by-uuid | grep sdc
>           lrwxrwxrwx 1 root root 10 Jan  3 09:40 
> 12345678-9abc0-1234-5678-9a0123456789 -> ../../sdc
>
> So then:
>
>           # this is not a real UUID, you need to check 
> /dev/disk/by-uuid on your machine for a real UUID
>           UUID=12345678-9abc0-1234-5678-9a0123456789 
> /path/to/mountpoint   compress=lzo,noauto,users,user   0   0
>
> This is EXTRA important with a USB drive, since it's HIGHLY likely it 
> won't always be on the same physical devicename.

One other note: in this particular case, you might actually be better 
served setting compression by mounting the drive normally, then:

          cd /path/to/drive
          chattr +c . ; chattr +c * ; chattr +c .*

This will set compression on by default for any future files stored on 
that USB drive, *without* needing any special mount options.

Why might this be a better idea? Well, if it's a USB drive, presumably 
you might want to mount it on foreign systems from time to time. This 
way, even if you mount the drive on a foreign system that doesn't know 
anything about your preferences, it will see the +c on the root 
directory of the drive, and store any new data on the drive compressed.

The only caveat: +c won't set the compression algorithm to LZO. It'll be 
gzip, which is the default algorithm. (And, of course, this won't 
compress any EXISTING data already stored there - only NEW data written 
to it after you set the +c attribute.)
