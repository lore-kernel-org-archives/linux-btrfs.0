Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38524 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 14:34:16 -0400
Received: by mail-vc0-f173.google.com with SMTP id hy10so12778697vcb.18
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 11:34:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$258d1$c3749601$d83e6a85$e56acf7f@cox.net>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
	<2217061.yFV10mnZWq@merkaba>
	<CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
	<53F6E9B7.1040701@gmail.com>
	<pan$258d1$c3749601$d83e6a85$e56acf7f@cox.net>
Date: Fri, 22 Aug 2014 14:34:15 -0400
Message-ID: <CAGfcS_=uPkF0eF4bROJj1o9V0boC0-it=PGswhtZWSRjhVscwQ@mail.gmail.com>
Subject: Re: Significance of high number of mails on this list?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 3:35 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>
> No claim to be a dev, btrfs or otherwise, here, but I believe in this
> case you /are/ "being too paranoid."
>
> Both btrfs send and receive only deal with data/metadata they know how to
> deal with.  If it's corrupt in some way or if they don't understand it,
> they don't send/write it, they fail.
>
> IOW, if it works without error it's as guaranteed to be golden as these
> things get.  The problem is that it doesn't always work without error in
> the first place, sometimes it /does/ fail.  In that instance you can
> always try again as the existing data/metadata shouldn't be damaged, but
> if it keeps failing you may have to try something else, rsync, etc.

Well, my main use-case for rsync right now is btrfs bug hoses my
filesystem, so it would be nice to have a daily full backup on
something other than btrfs so that it is unlikely to suffer the same
problem at the same time.

Using btrfs send with that backup would certainly be more efficient,
but it would defeat the purpose of the backup, which is to not be
btrfs.  I am already using mirroring in the event of drive failure,
and offsite cloud backups of critical data in the event of a larger
catastrophe.  Btrfs eating my data is a somewhat likely failure mode
in the grand scheme of things, so I protect against it so that I can
still have fun playing with btrfs without losing sleep.

I've actually restored from it once.  I suspect that I could have
fixed my ENOSPC problem without resorting to that, but the usual FAQ
solutions didn't work and I was running short on time, and that
particular filesystem was only 64GB anyway so it was a fast restore
(and that is why this filesystem is prone to ENOSPC in the first
place).

Oh, and I'm using rsnapshot, so I also get the benefit of a few days
worth of backups - almost as good as snapper, though in reality
obviously not the same thing.

--
Rich
