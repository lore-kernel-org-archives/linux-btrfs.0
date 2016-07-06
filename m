Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33655 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbcGFSTX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:19:23 -0400
Received: by mail-oi0-f45.google.com with SMTP id u201so281575423oie.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:19:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFDLS-AA6nYJy6BBRPhqAL-7PpA-TTEUqpjLR2+cZ05A+5kx7A@mail.gmail.com>
References: <CAFDLS-CtnVDtD8d=Wtp0tVokKJ6pjptpX7MR862dThBJvSPC5g@mail.gmail.com>
 <CAFDLS-AA6nYJy6BBRPhqAL-7PpA-TTEUqpjLR2+cZ05A+5kx7A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 12:19:21 -0600
Message-ID: <CAJCQCtT82qFxsehXAmSwerPmV1KnVM5LBS=WA1iE8SiVbUtFRg@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: Gonzalo Gomez-Arrue Azpiazu <ggomarr@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 11:12 AM, Gonzalo Gomez-Arrue Azpiazu
<ggomarr@gmail.com> wrote:
> Hello,
>
> I had a RAID5 with 3 disks and one failed; now the filesystem cannot be mounted.
>
> None of the recommendations that I found seem to work. The situation
> seems to be similar to this one:
> http://www.spinics.net/lists/linux-btrfs/msg56825.html
>
> Any suggestion on what to try next?

Basically if you are degraded *and* it runs into additional errors,
then it's broken because raid5 only protects against one device error.
The main problem is if it can't read the chunk root it's hard for any
tool to recover data because the chunk tree mapping is vital to
finding data.

What do you get for:
btrfs rescue super-recover -v /dev/sdc1

It's a problem with the chunk tree because all of your super blocks
point to the same chunk tree root so there isn't another one to try.

>sudo btrfs-find-root /dev/sdc1
>warning, device 2 is missing
>Couldn't read chunk root
>Open ctree failed

It's bad news. I'm not even sure 'btrfs restore' can help this case.


-- 
Chris Murphy
