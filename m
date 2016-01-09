Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33412 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbcAIUBI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 15:01:08 -0500
Received: by mail-wm0-f53.google.com with SMTP id f206so171552870wmf.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 12:01:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
 <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com> <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Sat, 9 Jan 2016 21:00:47 +0100
Message-ID: <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I can repeatedly trigger this bug by making the "data" portion fill
up. If you remember the partition is 6 TB but in btrfs filesystem df
Data is shown as only 2TB when in fact it should be nearly 6TB. So
this has nothing to do with kernel bugs. The filesystem on disk is
structured incorrectly. How do i fix this? How do I make "Data"
bigger? What is it exactly?

Thanks

P.S. Sorry about reposting twice, apparently Google's "Inbox" app
doesn't allow posting plain text at all and the mail got rejected from
the list.

On Thu, 7 Jan 2016 23:22 Chris Murphy <lists@colorremedies.com> wrote:
>
> On Thu, Jan 7, 2016 at 3:04 PM, cheater00 . <cheater00@gmail.com> wrote:
> > Yes, both times it was the same drive. I only have one usb drive now.
>
> That it's the same drive is suspicious. But I don't know what
> errno=-28 means or what could trigger it, if some USB weirdness could
> cause Btrfs to get confused somehow. I have one 7200rpm drive that
> wants 1.15A compared to all the others that have a 900mA spec, and
> while it behaves find 99% of the time like the others, rarely I would
> get the reset message and most of the time it was that drive (and less
> often one other). Now that doesn't happen anymore.
>
> >
> > I am not sure if chasing the kernel makes sense unless you think there is a
> > specific commit that would have foxed it. I only reported here in case
> > anyone here wanted to do some form of debugging before i reset the drive and
> > rescan the fs to make it writeable again. But since there seems to be no
> > interest i will go forward.
>
> I'd chase the hardware problem then first. It's just that the kernel
> switch is easier from my perspective. And it's just as unclear this is
> hardware related than just a bug. And since there are hundreds to
> thousands of Btrfs bugs being fixed per kernel release, I have no way
> to tell you whether it's fixed and maybe even a developer wouldn't
> either, you'd just have to try it.
>
>
> --
> Chris Murphy
