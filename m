Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:57435 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdFGNJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 09:09:08 -0400
Date: Wed, 7 Jun 2017 15:09:02 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Stefan G. Weichinger" <lists@xunil.at>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: getting rid of "csum failed" on a hw raid
Message-ID: <20170607130902.q3stj6wj52duvmr2@angband.pl>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
 <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
 <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 01:10:26PM +0300, Timofey Titovets wrote:
> 2017-06-07 13:05 GMT+03:00 Stefan G. Weichinger <lists@xunil.at>:
> > Am 2017-06-07 um 11:37 schrieb Timofey Titovets:
> >
> >> btrfs scrub start /mnt_path do this trick
> >>
> >> After, you can find info with paths in dmesg
> >
> > thank you, I think I have the file, it's a qemu-img-file.
> > I try cp-ing it to another fs first, but assume this will fail, right?
> 
> Yes, because btrfs will return -EIO
> So try dd_rescue

Or even plain dd conv=noerror.  Both will do a faithful analogue of a
physical disk with a silent data corruption on the affected sectors.

It might be a better idea to try running the VM in question: it will avoid
silencing the errors, thus let you find out what you lost -- if you run any
filesystem other than btrfs or zfs in the guest, it has no means of spotting
silent corruption.

Obviously, do make the dd copy first.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ A tit a day keeps the vet away.
⣾⠁⢰⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ (Rejoice as my small-animal-murder-machine got unbroken after
⠈⠳⣄⠀⠀⠀⠀ nearly two years of no catch!)
