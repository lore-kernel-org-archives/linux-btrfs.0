Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:32868 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2HEKuK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2012 06:50:10 -0400
Date: 05 Aug 2012 12:46:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CEHqV5APCXB@helmut.hullen.de>
In-Reply-To: <CAJtBfr9mX-T8+-nGAvkinaO3yEw20zjRdab=4vjukwZTj0nR7w@mail.gmail.com>
Subject: Re: filesystem show still has stale filesystem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Florian,

Du meintest am 05.08.12:

> I was playing with btrfs and accidentally formatted the disk directly
> (/dev/sdb instead of sdb1). Since then I rewrote the GPT partition
> table, recreated the partition and ran btrfs device scan. Still,
> btrfs filesystem show prints:

> root@horus /mnt # btrfs fi sh --all-devices
> failed to read /dev/sr0: No medium found
> Label: 'test'  uuid: ffab72f2-eff1-4ac8-a694-d56dd84fda24
>         Total devices 1 FS bytes used 28.00KB
>         devid    1 size 2.73TB used 2.04GB path /dev/sdb

> Label: 'home'  uuid: c465d715-098a-4d0d-bebc-6aa51f4cb349
>         Total devices 1 FS bytes used 28.00KB
>         devid    1 size 2.73TB used 2.04GB path /dev/sdb1

"formatting" leaves most bytes on the disk untouched. If you really want  
to use only /dev/sdb (or only /dev/sdb1) then you should first fill many  
bytes at the beginning of the disk with zeros.

Some months ago someone had told the minimum; I have forgotten this  
value. But something like

        dd if=/dev/zero of=/dev/sdb bs=1M count=10

should do the job.

And then "mkfs.btrfs" creates the (only) wanted partition(s).

Viele Gruesse!
Helmut
