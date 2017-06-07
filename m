Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:57856 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdFGNwW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 09:52:22 -0400
Date: Wed, 7 Jun 2017 15:52:19 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Roman Mamedov <rm@romanrm.net>
Cc: "Stefan G. Weichinger" <lists@xunil.at>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: getting rid of "csum failed" on a hw raid
Message-ID: <20170607135219.blgoomc4mwt5ebvj@angband.pl>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
 <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
 <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
 <20170607130902.q3stj6wj52duvmr2@angband.pl>
 <20170607184848.6218c92f@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170607184848.6218c92f@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 06:48:48PM +0500, Roman Mamedov wrote:
> On Wed, 7 Jun 2017 15:09:02 +0200
> Adam Borowski <kilobyte@angband.pl> wrote:
> > > Yes, because btrfs will return -EIO
> > > So try dd_rescue
> > 
> > Or even plain dd conv=noerror.  Both will do a faithful analogue of a
> > physical disk with a silent data corruption on the affected sectors.
> 
> Yeah, except "plain dd conv=noerror" will produce a useless corrupted image,
> because it will be shifted forward by the number of unreadable bytes after the
> first error.
> 
> You also need the "sync" flag in there.

Doh, yeah.

> Or just stick with dd_rescue and not try to correct people's perfectly good
> suggestions with completely wrong and harmful ones.

On the other hand, you have dd everywhere, while dd_rescue is not available
on most bootable media not specifically made for rescue purposes.  And
installing extra software when your disk is already unsound but mostly
working might be risky.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ A tit a day keeps the vet away.
⣾⠁⢰⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ (Rejoice as my small-animal-murder-machine got unbroken after
⠈⠳⣄⠀⠀⠀⠀ nearly two years of no catch!)
