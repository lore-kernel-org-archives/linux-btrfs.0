Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:53947 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab2FYRqJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 13:46:09 -0400
Message-ID: <4FE8A3D9.3060400@zytor.com>
Date: Mon, 25 Jun 2012 10:46:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
References: <4FE1F9E4.5090301@zytor.com> <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com> <20120621005048.GA19507@shiny> <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com> <20120625152142.GD17638@shiny>
In-Reply-To: <20120625152142.GD17638@shiny>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2012 08:21 AM, Chris Mason wrote:
> Yes and no.  If you have 2 drives and you add one more, we can make it
> do all new chunks over 3 drives.  But, turning the existing double
> mirror chunks into a triple mirror requires a balance.
> 
> -chris

So trigger one.  This is the exact analogue to the resync pass that is
required in classic RAID after adding new media.

	-hpa

