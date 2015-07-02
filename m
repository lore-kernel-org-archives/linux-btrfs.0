Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:46050 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbGBQ6G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 12:58:06 -0400
Received: by vnbg7 with SMTP id g7so12238716vnb.12
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 09:58:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
	<CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
	<CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
	<CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
	<CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
	<CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
	<CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
	<CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
	<CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
	<CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com>
Date: Thu, 2 Jul 2015 10:58:05 -0600
Message-ID: <CAJCQCtTQjqsqBTBb4dCjBUFRzP-mkObTD5r+g2C=905=TMTpyA@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
From: Chris Murphy <lists@colorremedies.com>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 2, 2015 at 8:49 AM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:

> Which is curious because this is device id 2, where previously the
> complaint was about device id 1.  So can I believe dmesg about which
> drive is actually the issue or is the drive that's printed in dmesg
> just whichever drive happens to be the last in some loop of code?

devid is static/reliable
/dev/sdX is dynamic/unreliable and related to logic board's firmware

Some systems are more stable in this regard than others, I've worked
with systems that have different drive order every boot, even when
hardware configuration is unchanged. When the config changes, good bet
the drive letters will change.



> Theoretically I should be able to kick another drive out of the pool
> safely, but I'm not sure which one to actually kick out or if that is
> the appropriate next step.

My limited understanding at this point is that once you get "open with
broken chunk error
 Fail to recover the chunk tree." from chunk recover, you've reached
the limits of the current state of recovery tools.

But that it completed suggests it might be possible to get a complete
btrfs image, and get that to a developer who can then use it to
improve the recovery tools.

>
> I do see plenty of complaints about the sdg drive (previously sde) in
> /var/log/messages from the 28th which is when I started noticing
> issues.  Nothing is jumping out at me claiming the btrfs is taking
> action but I may not know what to look for.
>
> journalctl I'm not familiar with.  journalctl -bX returns with "failed
> to parse relative boot ID number 'X'" but perhaps you meant X to be a
> variable of some value?    journalctl -b does run, but I'm not sure
> what to look for.

I don't have a raid56 example handy for what this looks like before
this message appears:

[48466.853589] BTRFS: fixed up error at logical 20971520 on dev /dev/sdb

But that's what I get for corrupt metadata where metadata profile is
DUP. The messages for missing metadata that needs reconstruction would
be different but I'd expect to still see the fixed up message. But I'd
also look at
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/raid56.c?id=refs/tags/v4.1
and read comments and possible raid56 related error messages.

It's similar for data.

[ 1540.865534] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[ 1540.866944] BTRFS: unable to fixup (regular) error at logical
12845056 on dev /dev/sdb

Again this is a corruption example, not a read failure example. It
can't be fixed because the data profile is single in this case.



>
> So, what does the audience suggest?  Shall I compile a newer kernel,
> kick out another drive (which?), or take what's behind door #3 (which
> is...?)

If there's data on this volume you need, put all the drives back in
and look at btrfs-rescue to try and extract what you can. And then try
a btrfs-image again, maybe it'll work too if there aren't read errors.

Once you've gotten what you need out of it, you can decide if it's
worth continuing to try to fix it (seems doubtful to me but I am not a
developer). I'd probably just start over. The one change to make going
forward is more frequent scrubs to hopefully find and fixup any bad
sectors before it starts to cause this problem again.

Maybe someone with more knowledge will say if any of the btrfs kernel
debug features are worth enabling? I suspect those debug features are
only useful to gather more information as the file system is being
used and encounters the first problem, the URE, and any subsequent
events that caused confusion and then the self-corruption of the fs
beyond repair. If so, that implies a whole new fs, and then trying to
reproduce the conditions that caused the problem. Which brings me
to...

hdparm has a dangerous --make-bad-sector option for testing RAID. I
wonder if qemu has such an option? I'd rather test this in a VM than
use a "do not ever use" option in hdparm.


-- 
Chris Murphy
