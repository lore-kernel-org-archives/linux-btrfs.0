Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:46423 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbaEFHCs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 03:02:48 -0400
Received: by mail-wi0-f196.google.com with SMTP id f8so116500wiw.7
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 00:02:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140505212513.GS10159@merlins.org>
References: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
	<20140505212513.GS10159@merlins.org>
Date: Tue, 6 May 2014 09:02:46 +0200
Message-ID: <CANg_oxw_qy154eiRw9zdsCUwR1JTOGsUEa=VWq-7RM=nsATU3g@mail.gmail.com>
Subject: Re: btrfs on software RAID0
From: john terragon <jterragon@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

just one last doubt:

why do you use --align-payload=1024? (or 8912)
Cryptsetup man says that the default for the payload alignment is 2048
(512-byte sectors). So, it's already aligned by default to 4K-byte
physical sectors (if that was your concern). Am I missing something?

John

On Mon, May 5, 2014 at 11:25 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, May 05, 2014 at 10:51:46PM +0200, john terragon wrote:
>> Hi.
>> I'm about to try btrfs on an RAID0 md device (to be precise there will
>> be dm-crypt in between the md device and btrfs). If I used ext4 I
>> would set the stride and stripe_width extended options. Is there
>> anything similar I should be doing with mkfs.btrfs? Or maybe some
>> mount options beneficial to this kind of setting.
>
> This is not directly an answer to your question, so far I haven't used a
> special option like this with btrfs on my arrays although my
> undertstanding is that it's not as important as with ext4.
>
> That said, please read
> http://marc.merlins.org/perso/btrfs/post_2014-04-27_Btrfs-Multi-Device-Dmcrypt.html
>
> 1) use align-payload=1024 on cryptsetup instead of something bigger like
> 8192. This will reduce write amplification (if you're not on an SSD).
>
> 2) you don't need md0 in the middle, crypt each device and then use
> btrfs built in raid0 which will be faster (and is stable, at least as
> far as we know :) ).
>
> Then use /etc/crypttab or a script like this
> http://marc.merlins.org/linux/scripts/start-btrfs-dmcrypt
> to decrypt all your devices in one swoop and mount btrfs.
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
