Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.21]:61005 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308Ab3DIRwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 13:52:43 -0400
Message-ID: <51645567.7060807@free.fr>
Date: Tue, 09 Apr 2013 19:52:39 +0200
From: Maxime Nicco <maxime.nicco@free.fr>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Bad tree block, on root filesystem after reset
References: <51644D81.4090400@free.fr>
	<CAE5mzviyg7pSw0a6GhctBC4sCEFbLSfRqAtC6Qc10t_qi8Je0Q@mail.gmail.com>
In-Reply-To: <CAE5mzviyg7pSw0a6GhctBC4sCEFbLSfRqAtC6Qc10t_qi8Je0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 09/04/2013 19:42, cwillu a écrit :
> On Tue, Apr 9, 2013 at 11:18 AM, Maxime Nicco <maxime.nicco@free.fr
> <mailto:maxime.nicco@free.fr>> wrote:
>
>     Hi,
>
>     Today my laptop messed-up my display configuration between 2
>     screens. I had to reset it, but my btrfs root partition is no longer
>     mountable.
>     I have the following output in dmesg :
>
>
> What kernel is this on, and have you tried mounting with -o recovery?

Oups i forgot to mention my kernel, my system was on 3.8, and i work 
from a live cd in 3.5.

I already tried mounting with -o recovery, here the result

# mount -t btrfs -o recovery /dev/sda2 /mnt/sda2
mount: wrong fs type, bad option, bad superblock on /dev/sda2,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

the dmesg look like this

device fsid f9264db3-f277-47b6-bd8f-57d0a67c93a7 devid 1 transid 78577 
/dev/sda2
btrfs bad tree block start 0 18565984256
btrfs bad tree block start 0 18565984256
btrfs: enabling auto recovery
btrfs: failed to read tree root on sda2
btrfs bad tree block start 0 18565984256
btrfs bad tree block start 0 18565984256
btrfs: failed to read tree root on sda2
parent transid verify failed on 18563280896 wanted 78576 found 78578
parent transid verify failed on 18563280896 wanted 78576 found 78578
btrfs read error corrected: ino 1 off 18563280896 (dev /dev/sda2 sector 
38894232)
btrfs: failed to read tree root on sda2
btrfs bad tree block start 0 18565726208
btrfs bad tree block start 0 18565726208
btrfs: failed to read tree root on sda2
btrfs bad tree block start 0 18564616192
btrfs bad tree block start 0 18564616192
btrfs: failed to read tree root on sda2
btrfs: open_ctree failed
