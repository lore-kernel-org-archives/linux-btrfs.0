Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58271 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2FUAuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 20:50:51 -0400
Date: Wed, 20 Jun 2012 20:50:48 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Marios Titas <redneb8888@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
Message-ID: <20120621005048.GA19507@shiny>
References: <4FE1F9E4.5090301@zytor.com>
 <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 06:35:30PM -0600, Marios Titas wrote:
> On Wed, Jun 20, 2012 at 12:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Yet another boot loader support request.
> >
> > Right now btrfs' definition of "RAID-1" with more than two devices is a
> > bit unorthodox: it stores on any two drives.  "True RAID-1" would
> > instead store N copies on each of N devices, the same way an actual
> > RAID-1 would operate with an arbitrary number of devices.
> >
> > This means that a bootloader can consider a single device in isolation:
> > if the firmware gives access only to a single device, it can be booted.
> >  Since /boot is usually a very small amount of data, this is a very
> > reasonable tradeoff.
> 
> +1
> 
> In fact, the current RAID-1 should not have been called RAID-1 at all,
> it is confusing.

With the raid5/6 code, I'm changing raid1 (and raid10) to have a
configurable number of copies.  So, you'll be able to have N copies on M
drives, where N <= M.

-chris

