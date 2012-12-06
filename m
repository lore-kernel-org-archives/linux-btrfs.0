Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:60314 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab2LFM7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 07:59:11 -0500
Date: Thu, 6 Dec 2012 13:59:08 +0100
From: Sander <sander@humilis.net>
To: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Message-ID: <20121206125908.GA31070@panda>
Reply-To: sander@humilis.net
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
 <20121206063151.GC20550@merlins.org>
 <CACR_K2sPZMoqr6hO-xzWFiQ95dsi_0=3kWyi+zmY3qKHP0x1NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACR_K2sPZMoqr6hO-xzWFiQ95dsi_0=3kWyi+zmY3qKHP0x1NA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sylvain Alain wrote (ao):
> Hi, right now I own this SSD :
> 
> Intel SSD 520 Series MLC 120 Gigs

> Also, this is my /etc/fstab
> /dev/sda3      /boot            ext2       noauto,noatime,defaults
> /dev/sda1      /boot/efi        vfat        noauto,defaults
> /dev/sda4      /                  btrfs

SSDs are sensitive to partitioning. Easiest is not to partition at all.

	Sander
