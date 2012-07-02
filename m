Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:35099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2GBP72 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 11:59:28 -0400
Message-ID: <4FF1C557.2040705@zytor.com>
Date: Mon, 02 Jul 2012 08:59:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
References: <4FE1F9E4.5090301@zytor.com> <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com> <20120621005048.GA19507@shiny> <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com> <20120625152142.GD17638@shiny> <4FE8A3D9.3060400@zytor.com> <20120625225424.GG25572@carfax.org.uk> <4FE8EDA1.5090004@zytor.com>
In-Reply-To: <4FE8EDA1.5090004@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2012 04:00 PM, H. Peter Anvin wrote:
>
> I am aware of that, and it is not a problem... the one-device
> bootloader can find out *which* disk it is talking to by comparing
> uuids, and the btrfs data structures will tell it how to find the data
> on that specific disk.  It does of course mean the bootloader needs to
> be aware of the multidisk nature of btrfs, but that isn't a problem in
> itself.
>

So, also, let me address the question why we should care about a 
one-device bootloader.  It is quite common, especially in fileservers, 
for a subset of the boot devices to be inaccessible by the firmware, due 
to bugs, boot time concerns (spinning up all the media in the firmware 
is SLOW) or just plain lack of support of plug-in cards.  As such, the 
reliable thing to do is to make sure that any disk being seen is enough 
to bring up the system; since this is such a small amount of data with 
modern standards, there is just no reason to do anything less robust.

Once the kernel comes up it has all the device drivers, of course.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



