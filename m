Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:38659 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdFGSEg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 14:04:36 -0400
Date: Wed, 7 Jun 2017 20:04:29 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Stefan G. Weichinger" <lists@xunil.at>,
        Roman Mamedov <rm@romanrm.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: getting rid of "csum failed" on a hw raid
Message-ID: <20170607180429.mxmd6faolxsrry2x@angband.pl>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
 <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
 <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
 <20170607130902.q3stj6wj52duvmr2@angband.pl>
 <20170607184848.6218c92f@natsu>
 <20170607135219.blgoomc4mwt5ebvj@angband.pl>
 <ad923a84-bd2c-a8fd-8532-c7dc73d1870f@xunil.at>
 <CAJCQCtSGxC-UxkB7NuXuUvWYg-kC4sRdteiiVYQbPZpx9AUfsw@mail.gmail.com>
 <dd64ae32-83c5-c254-a00f-e0f81d0b3eb9@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <dd64ae32-83c5-c254-a00f-e0f81d0b3eb9@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 07:01:21PM +0200, Goffredo Baroncelli wrote:
> On 2017-06-07 17:58, Chris Murphy wrote:
> > 3. My take on this would have been to use btrfs restore and go after
> > the file path if I absolutely needed a copy of this file (no backup),
> > and then copied that back to the file system.
> 
> It might be useful to have a command to handle these situations: read all
> the good data, read even the wrong data logging the range were the
> checksum is incorrect.  The fact that you have problem in few bytes,
> doesn't mean that all the 4k sector has to be discarded.

This is what we did in the DOS times: even when the OS would fail, reading
via INT 13h did usually report an error but the memory you gave as the
target buffer would have all the data with just one or a few bits flipped --
or at worst, when a sector's header was hit, 512 bytes missing.

But that's not a good idea for regular read(), even for root: it's possible
the data is not yours and contains some sensitive info from an unrelated
file.

Thus, it'd have to be a special command or a special argument.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ A tit a day keeps the vet away.
⣾⠁⢰⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ (Rejoice as my small-animal-murder-machine got unbroken after
⠈⠳⣄⠀⠀⠀⠀ nearly two years of no catch!)
