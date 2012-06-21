Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:44025 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2FUBej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 21:34:39 -0400
References: <4FE1F9E4.5090301@zytor.com> <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com> <20120621005048.GA19507@shiny>
In-Reply-To: <20120621005048.GA19507@shiny>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Feature request: true RAID-1 mode
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 20 Jun 2012 18:34:27 -0700
To: Chris Mason <chris.mason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could you have a mode, though, where M = N at all times, so a user doesn't end up adding a new drive and get a nasty surprise?

Chris Mason <chris.mason@fusionio.com> wrote:

>On Wed, Jun 20, 2012 at 06:35:30PM -0600, Marios Titas wrote:
>> On Wed, Jun 20, 2012 at 12:27 PM, H. Peter Anvin <hpa@zytor.com>
>wrote:
>> > Yet another boot loader support request.
>> >
>> > Right now btrfs' definition of "RAID-1" with more than two devices
>is a
>> > bit unorthodox: it stores on any two drives.  "True RAID-1" would
>> > instead store N copies on each of N devices, the same way an actual
>> > RAID-1 would operate with an arbitrary number of devices.
>> >
>> > This means that a bootloader can consider a single device in
>isolation:
>> > if the firmware gives access only to a single device, it can be
>booted.
>> >  Since /boot is usually a very small amount of data, this is a very
>> > reasonable tradeoff.
>> 
>> +1
>> 
>> In fact, the current RAID-1 should not have been called RAID-1 at
>all,
>> it is confusing.
>
>With the raid5/6 code, I'm changing raid1 (and raid10) to have a
>configurable number of copies.  So, you'll be able to have N copies on
>M
>drives, where N <= M.
>
>-chris

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
