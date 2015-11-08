Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35554 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbKHSSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Nov 2015 13:18:21 -0500
Received: by lbces9 with SMTP id es9so15761155lbc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 10:18:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446938562.7297.7.camel@scientia.net>
References: <1446938562.7297.7.camel@scientia.net>
Date: Sun, 8 Nov 2015 19:18:19 +0100
Message-ID: <CAPmG0jb_ynq6qnxf-bysNaLut+5SOGqHrizLMaMN-1o6r2SZwg@mail.gmail.com>
Subject: Re: strange "No space left on device"
From: Henk Slager <eye1tm@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[...]
>    3         3145728         4194303   512.0 MiB   8300  Linux filesystem
[...]
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-data /dev/sdb3
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              boot-data
> UUID:               b1c1fc77-c965-4f0c-a2b5-44a301fd8772
> Node size:          16384
> Sector size:        4096
> Filesystem size:    1.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              59.19MiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     1.00GiB  /dev/sdb3

Somehow your mkfs.btrfs (or some other part of the system) assumed the
wrong size for partition 3. To me, that sounds like a possible cause
of the errors and 'EiB' reported size.
For RAID tests in VMs I have also been using 4-8GB disk sizes (instead
of TB sized like the real hardware) and I encountered many 'No space
left on device' message (with older kernels).
A quick test with kernel 4.3.0 now:

# dd if=/dev/zero of=sd.bin bs=1M count=512

# losetup -f sd.bin

# mkfs.btrfs --nodiscard --label boot-data /dev/loop0
SMALL VOLUME: forcing mixed metadata/data groups
btrfs-progs v4.2.3+20151102
See http://btrfs.wiki.kernel.org for more information.

Label:              boot-data
UUID:               f152781b-b96b-4969-96b8-eede3e3dabc2
Node size:          4096
Sector size:        4096
Filesystem size:    512.00MiB
Block group profiles:
  Data+Metadata:    single            8.00MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  mixed-bg, extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   512.00MiB  /dev/loop0
