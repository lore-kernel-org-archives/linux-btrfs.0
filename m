Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36423 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbcEYUOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 16:14:51 -0400
Received: by mail-io0-f172.google.com with SMTP id f8so39672488ioe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 13:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <574306CC.3070906@prismatelecomtesting.com>
References: <574306CC.3070906@prismatelecomtesting.com>
Date: Wed, 25 May 2016 22:14:49 +0200
Message-ID: <CAPmG0jYufpnNHAg6YzqE3i_ShJzXB=ZM5ct=tjjrJ_8Toc0Pzw@mail.gmail.com>
Subject: Re: btrfs filesystem usage - Wrong Unallocated indications - RAID10
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a division by 2 missing in the code. With that added, the
RAID10 numbers make more sense. See also:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/53989

More detail in here:
https://www.spinics.net/lists/linux-btrfs/msg52882.html

And if you want to look at allocation in a different way, this might
be interesting:
https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py

On Mon, May 23, 2016 at 3:34 PM, Marco Lorenzo Crociani
<marcoc@prismatelecomtesting.com> wrote:
> Hi,
> as I wrote today in IRCI experienced an issue with 'btrfs filesystem usage'.
> I have a 4 partitions RAID10 btrfs filesystem almost full.
> 'btrfs filesystem usage' reports wrong "Unallocated" indications.
>
> Linux 4.5.3
> btrfs-progs v4.5.3
>
>
> # btrfs fi usage /data/
>
> Overall:
>     Device size:          13.93TiB
>     Device allocated:          13.77TiB
>     Device unallocated:         167.54GiB
>     Device missing:             0.00B
>     Used:              13.44TiB
>     Free (estimated):         244.39GiB    (min: 244.39GiB)
>     Data ratio:                  2.00
>     Metadata ratio:              2.00
>     Global reserve:         512.00MiB    (used: 0.00B)
>
> Data,single: Size:8.00MiB, Used:0.00B
>    /dev/sda4       8.00MiB
>
> Data,RAID10: Size:6.87TiB, Used:6.71TiB
>    /dev/sda4       1.72TiB
>    /dev/sdb3       1.72TiB
>    /dev/sdc3       1.72TiB
>    /dev/sdd3       1.72TiB
>
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/sda4       8.00MiB
>
> Metadata,RAID10: Size:19.00GiB, Used:14.15GiB
>    /dev/sda4       4.75GiB
>    /dev/sdb3       4.75GiB
>    /dev/sdc3       4.75GiB
>    /dev/sdd3       4.75GiB
>
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/sda4       4.00MiB
>
> System,RAID10: Size:16.00MiB, Used:768.00KiB
>    /dev/sda4       4.00MiB
>    /dev/sdb3       4.00MiB
>    /dev/sdc3       4.00MiB
>    /dev/sdd3       4.00MiB
>
> Unallocated:
>    /dev/sda4       1.76TiB
>    /dev/sdb3       1.76TiB
>    /dev/sdc3       1.76TiB
>    /dev/sdd3       1.76TiB
>
> ----------------------------------------------------------------------------------
> # btrfs fi show /data/
> Label: 'data'  uuid: df6639d5-3ef2-4ff6-a871-9ede440e2dae
>     Total devices 4 FS bytes used 6.72TiB
>     devid    1 size 3.48TiB used 3.44TiB path /dev/sda4
>     devid    2 size 3.48TiB used 3.44TiB path /dev/sdb3
>     devid    3 size 3.48TiB used 3.44TiB path /dev/sdc3
>     devid    4 size 3.48TiB used 3.44TiB path /dev/sdd3
>
> ----------------------------------------------------------------------------------
> # btrfs fi df /data/
> Data, RAID10: total=6.87TiB, used=6.71TiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID10: total=16.00MiB, used=768.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID10: total=19.00GiB, used=14.15GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> ----------------------------------------------------------------------------------
> # df -h
> /dev/sda4                     7,0T  6,8T    245G  97% /data
>
> Regards,
>
> --
> Marco Crociani
> Prisma Telecom Testing S.r.l.
> via Petrocchi, 4  20127 MILANO  ITALY
> Phone:  +39 02 26113507
> Fax:  +39 02 26113597
> e-mail:  marcoc@prismatelecomtesting.com
> web:  http://www.prismatelecomtesting.com
>
> Questa email (e I suoi allegati) costituisce informazione riservata e
> confidenziale e può essere soggetto a legal privilege. Può essere utilizzata
> esclusivamente dai suoi destinatari legittimi.  Se avete ricevuto questa
> email per errore, siete pregati di informarne immediatamente il mittente e
> quindi cancellarla.  A meno che non siate stati a ciò espressamente
> autorizzati, la diffusione o la riproduzione di questa email o del suo
> contenuto non sono consentiti.
>
>  Salvo che questa email sia espressamente qualificata come offerta o
> accettazione contrattuale, il mittente non intende con questa email dare
> vita ad un vincolo giuridico e questa email non può essere interpretata
> quale offerta o accettazione che possa dare vita ad un contratto. Qualsiasi
> opinione manifestata in questa email è un'opinione personale del mittente,
> salvo che il mittente dichiari espressamente che si tratti di un'opinione di
> Prisma Engineering.
>
>
> *******************************************************************************
>
>  This e-mail (including any attachments) is private and confidential, and
> may be privileged.  It is for the exclusive use of the intended
> recipient(s).  If you have received this email in error, please inform the
> sender immediately and then delete this email.  Unless you have been given
> specific permission to do so, please do not distribute or copy this email or
> its contents.
>  Unless the text of this email specifically states that it is a contractual
> offer or acceptance, the sender does not intend to create a legal
> relationship and this email shall not constitute an offer or acceptance
> which could give rise to a contract. Any views expressed in this
> communication are those of the individual sender, except where the sender
> specifically states them to be the views of Prisma Engineering.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
