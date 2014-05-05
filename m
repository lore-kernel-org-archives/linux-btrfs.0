Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52058 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaEEVmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 17:42:55 -0400
Received: by mail-pd0-f169.google.com with SMTP id z10so7269868pdj.28
        for <linux-btrfs@vger.kernel.org>; Mon, 05 May 2014 14:42:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140505212513.GS10159@merlins.org>
References: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
	<20140505212513.GS10159@merlins.org>
Date: Mon, 5 May 2014 14:42:53 -0700
Message-ID: <CAN05THTVtGp=R_xJg5_1OgmbDEonFSUgza-r0UGWyuuORmYSZg@mail.gmail.com>
Subject: Re: btrfs on software RAID0
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: john terragon <jterragon@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

start-btrfs-dmcrypt :
...
echo "$pwd" |
...

Hmmm. This makes the plaintext password visible in ps output.
It is probably better to pass this in by redirecting a file to stdin.



On Mon, May 5, 2014 at 2:25 PM, Marc MERLIN <marc@merlins.org> wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
