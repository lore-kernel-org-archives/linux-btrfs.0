Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33601 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbcDXMYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Apr 2016 08:24:32 -0400
Received: by mail-io0-f181.google.com with SMTP id f89so129325735ioi.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Apr 2016 05:24:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcrkY+i1QW0dW5y3=szq9vJh8946shAvCehefbRKW4xqv_zBA@mail.gmail.com>
References: <CAAcrkY+i1QW0dW5y3=szq9vJh8946shAvCehefbRKW4xqv_zBA@mail.gmail.com>
From: lenovomi <lenovomi@gmail.com>
Date: Sun, 24 Apr 2016 14:24:02 +0200
Message-ID: <CAAcrkYKn=Eeb2z0axH7qNs-k7J_rMAgbxM9Bzn+T=FOmNkw2rQ@mail.gmail.com>
Subject: Re: restore is failing
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

also can i use these attributes:

-x , -m , -S

to restore uid/gid/ perrmissions?


thanks

On Sun, Apr 24, 2016 at 2:11 PM, lenovomi <lenovomi@gmail.com> wrote:
> hi,
>
> i run restore command and it restored around 300GB of data from 11TB
> but failed here
>
>
>
> Skipping existing file
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/hosts
> Restoring /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> Error creating /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp:
> 22
> Error searching
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> Error searching
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> Error searching
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> Error searching
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> Error searching
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> Error searching
> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
> extent buffer leak: start 17802812047360 len 16384
>
>
> Any idea why? is it because of the <?> character?
>
> my target directory /mnt/restore is nfs mount point.
>
>
> thanks
