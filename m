Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:56050 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699Ab2FYWhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 18:37:38 -0400
Message-ID: <4FE8E829.6060305@zytor.com>
Date: Mon, 25 Jun 2012 15:37:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Gareth Pye <gareth@cerberos.id.au>
CC: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
References: <4FE1F9E4.5090301@zytor.com> <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com> <20120621005048.GA19507@shiny> <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com> <20120625152142.GD17638@shiny> <4FE8A3D9.3060400@zytor.com> <CA+WRLO87LvTrRJRMNwYQ3SwmZWF7WzO_FDi1=jqt1kwX=YSnWQ@mail.gmail.com>
In-Reply-To: <CA+WRLO87LvTrRJRMNwYQ3SwmZWF7WzO_FDi1=jqt1kwX=YSnWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2012 03:28 PM, Gareth Pye wrote:
> To me one doesn't have to be triggered, a user expects to have to tell
> the disks to rebuild/resync/balance after adding a disk, they may want
> to wait till they've added all 4 disks and run a few extra commands
> before they run the rebalance.

They do?  E.g. mdadm doesn't make them...

> What is important is having a mode that
> doesn't require the user to remember that what they had used as the
> closest analogue to RAID1 that BTRFS supports requires them to run
> another command to change the 'RAID level' to be the RAID1 analogue for
> the new number of disks. 
> 
> Users will forget that and they will lose data because of it. At least
> with a M=N mode BTRFS can say they tried to make it easy to avoid that
> pitfall.

Doesn't that contradict your previous statement?  In either case, I
agree with the latter...
	
	-hpa
