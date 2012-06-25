Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52451 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab2FYPVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 11:21:45 -0400
Date: Mon, 25 Jun 2012 11:21:42 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
Message-ID: <20120625152142.GD17638@shiny>
References: <4FE1F9E4.5090301@zytor.com>
 <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
 <20120621005048.GA19507@shiny>
 <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes and no.  If you have 2 drives and you add one more, we can make it
do all new chunks over 3 drives.  But, turning the existing double
mirror chunks into a triple mirror requires a balance.

-chris

On Wed, Jun 20, 2012 at 07:34:27PM -0600, H. Peter Anvin wrote:
> Could you have a mode, though, where M = N at all times, so a user doesn't end up adding a new drive and get a nasty surprise?
> 
> Chris Mason <chris.mason@fusionio.com> wrote:
> 
> >On Wed, Jun 20, 2012 at 06:35:30PM -0600, Marios Titas wrote:
> >> On Wed, Jun 20, 2012 at 12:27 PM, H. Peter Anvin <hpa@zytor.com>
> >wrote:
> >> > Yet another boot loader support request.
> >> >
> >> > Right now btrfs' definition of "RAID-1" with more than two devices
> >is a
> >> > bit unorthodox: it stores on any two drives.  "True RAID-1" would
> >> > instead store N copies on each of N devices, the same way an actual
> >> > RAID-1 would operate with an arbitrary number of devices.
> >> >
> >> > This means that a bootloader can consider a single device in
> >isolation:
> >> > if the firmware gives access only to a single device, it can be
> >booted.
> >> >  Since /boot is usually a very small amount of data, this is a very
> >> > reasonable tradeoff.
> >> 
> >> +1
> >> 
> >> In fact, the current RAID-1 should not have been called RAID-1 at
> >all,
> >> it is confusing.
> >
> >With the raid5/6 code, I'm changing raid1 (and raid10) to have a
> >configurable number of copies.  So, you'll be able to have N copies on
> >M
> >drives, where N <= M.
> >
> >-chris
> 
> -- 
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
