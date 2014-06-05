Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53761 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751650AbaFESef convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 14:34:35 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:65225 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WscUk-001gYA-BI
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 12:34:34 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Using BTRFS on SSD now ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1493894.GW2nr4reAA@zafu>
Date: Thu, 5 Jun 2014 12:34:33 -0600
Message-Id: <9CF80319-DB4F-40A9-861D-86C23808EA5F@colorremedies.com>
References: <2215647.hErg5R77lo@zafu> <1693566.Q9bXme5jtu@xev> <1493894.GW2nr4reAA@zafu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 5, 2014, at 9:14 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

>> I don't believe that LVM offers any benefit if you use BTRFS.
> 
> BTRFS cannot handle swap.

Yes but Fedora's installer doesn't support swapfiles anyway. It only creates swap partitions (encrypted or not encrypted). And it does allow you to selectively only encrypt swap if you want.

> A full disk encryption needs the swap to be 
> encrypted as well.

The Fedora installer will let you use regular partitions and encrypt them. LVM isn't necessary to achieve this.

> The only solution for getting both the swap and filesystems 
> encrypted using the same key is to put both of them on an LVM itself luks-
> encrypted using dm-crypt.

Why do they need to have the same key? The Fedora installer will let you do a Btrfs installation with swap as a separate partition, encrypt both partitions using one passphrase. Yes there are two LUKS device keys setup, but one passphrase unlocks both at the same time during boot.

> All my machines have been made this way for *years*, so I know it works damn 
> well ;-)

The Fedora installer won't even let you do this. Btrfs can't be put on LVM via anaconda.

Best practices for SSDs has been to encrypt each LV separately because dmcrypt was one thread per logical device. For an SSD this can make a big difference because it's possible to pin that single encryption thread and turn it into a bottle neck. There are multithreaded dmcrypt patches but I have no idea if it's in mainline kernels and if it gets used by default.


> 
> …And it also allows for hibernateing the system to (encrypted) swap space...

*shrug* that's hardware specific, whether it works or not. Right now hibernation in general, let alone encrypted, sucks on Linux right now. It and suspend are totally busted on all of my hardware right now, and forums are littered with people not able to get it to work, or having to become virtual experts getting it to work.


Chris Murphy

