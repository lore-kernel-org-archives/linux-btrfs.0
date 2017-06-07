Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46906 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdFGVYh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 17:24:37 -0400
Date: Wed, 7 Jun 2017 23:24:31 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Stefan G. Weichinger" <lists@xunil.at>,
        Roman Mamedov <rm@romanrm.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: getting rid of "csum failed" on a hw raid
Message-ID: <20170607212431.p4yxccvbq7xjuk5o@angband.pl>
References: <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
 <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
 <20170607130902.q3stj6wj52duvmr2@angband.pl>
 <20170607184848.6218c92f@natsu>
 <20170607135219.blgoomc4mwt5ebvj@angband.pl>
 <ad923a84-bd2c-a8fd-8532-c7dc73d1870f@xunil.at>
 <CAJCQCtSGxC-UxkB7NuXuUvWYg-kC4sRdteiiVYQbPZpx9AUfsw@mail.gmail.com>
 <dd64ae32-83c5-c254-a00f-e0f81d0b3eb9@inwind.it>
 <20170607180429.mxmd6faolxsrry2x@angband.pl>
 <6e5662de-20d1-c990-f0d3-26ff34e2ac09@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6e5662de-20d1-c990-f0d3-26ff34e2ac09@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 10:20:53PM +0200, Goffredo Baroncelli wrote:
> On 2017-06-07 20:04, Adam Borowski wrote:
> > On Wed, Jun 07, 2017 at 07:01:21PM +0200, Goffredo Baroncelli wrote:
> >> It might be useful to have a command to handle these situations: read all
> >> the good data, read even the wrong data logging the range were the
> >> checksum is incorrect.  The fact that you have problem in few bytes,
> >> doesn't mean that all the 4k sector has to be discarded.
> > 
> > This is what we did in the DOS times: even when the OS would fail, reading
> > via INT 13h did usually report an error but the memory you gave as the
> > target buffer would have all the data with just one or a few bits flipped --
> > or at worst, when a sector's header was hit, 512 bytes missing.
> > 
> > But that's not a good idea for regular read(), even for root: it's possible
> > the data is not yours and contains some sensitive info from an unrelated
> > file.
> 
> Depends: if the corrupted data are metadata, you are right.  But the
> biggest part of the disk is occupied by data; so the likelihood that the
> corruption is in the data is greater.

Metadata also happens to be rewritten and manipulated more, thus it has a
relatively bigger chance to get mangled.  Corruption at rest is less likely
than corruption in memory or during transfer, and memory is not checksummed.

Two scenarios:
* mangled metadata points to a block belonging to pre-existing unrelated
  data (or secret metadata)
* a new write by mistake overwrites an innocent block of data

Both of these will correctly be caught by checksums, so there's no
information leak.  But there will be if you take that data anyway.  And you
don't manually read every file you managed to restore.

> It would need an ioctl to read the file content without the checksum
> check...

Do modern disks still send the partial data if they determine it to be
corrupt?  If so, every disk-backed filesystem, not just btrfs, could benefit
from such an ioctl.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ A tit a day keeps the vet away.
⣾⠁⢰⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ (Rejoice as my small-animal-murder-machine got unbroken after
⠈⠳⣄⠀⠀⠀⠀ nearly two years of no catch!)
