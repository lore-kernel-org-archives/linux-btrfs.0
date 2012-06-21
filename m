Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60894 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2FUAfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 20:35:32 -0400
Received: by lbbgm6 with SMTP id gm6so1365698lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2012 17:35:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE1F9E4.5090301@zytor.com>
References: <4FE1F9E4.5090301@zytor.com>
Date: Wed, 20 Jun 2012 20:35:30 -0400
Message-ID: <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
Subject: Re: Feature request: true RAID-1 mode
From: Marios Titas <redneb8888@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 12:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yet another boot loader support request.
>
> Right now btrfs' definition of "RAID-1" with more than two devices is a
> bit unorthodox: it stores on any two drives.  "True RAID-1" would
> instead store N copies on each of N devices, the same way an actual
> RAID-1 would operate with an arbitrary number of devices.
>
> This means that a bootloader can consider a single device in isolation:
> if the firmware gives access only to a single device, it can be booted.
>  Since /boot is usually a very small amount of data, this is a very
> reasonable tradeoff.

+1

In fact, the current RAID-1 should not have been called RAID-1 at all,
it is confusing.
