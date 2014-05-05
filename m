Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:38076 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbaEEWVn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 18:21:43 -0400
Received: by mail-wi0-f194.google.com with SMTP id r20so588065wiv.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 May 2014 15:21:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140505212513.GS10159@merlins.org>
References: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
	<20140505212513.GS10159@merlins.org>
Date: Tue, 6 May 2014 00:21:42 +0200
Message-ID: <CANg_oxzst-UeT8ULiFvNs_uud2b6nfMuuj-4QKRJtM7JM_BuAw@mail.gmail.com>
Subject: Re: btrfs on software RAID0
From: john terragon <jterragon@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 5, 2014 at 11:25 PM, Marc MERLIN <marc@merlins.org> wrote:
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


I know about btrfs native raid capabilities but to be honest most of
the times I see people having "scary" problems with btrfs is when they
use it with multiple devices. So far my experience with btrfs has been
pretty smooth (always with btrfs on top of a single device) and I
wanted to let that part of btrfs to maybe mature a little bit more.
But maybe I'm wrong, so maybe I'll give both approaches a try.

About unlocking all the dm-crypt device in one swoop, there's this script too

https://github.com/gebi/keyctl_keyscript

which uses the kernel keyring to temporarily store the passphrase.
I was thinking about using it in a dm-crypt->md-raid->btrfs setting to
have one thread for each dm-crypt device, but probably aesni
instructions are fast enough
to not cause the single dm-crypt thread  in a md-raid->dm-crypt->btrfs setting
to become a bottleneck (at least with hdds, with sdds it might be a
different story)

John
