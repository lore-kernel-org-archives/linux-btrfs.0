Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:48419
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808Ab3COEOi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 00:14:38 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs bug reports?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <514299C7.4060200@lolwut.org>
Date: Thu, 14 Mar 2013 22:07:29 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <7F2F6C7E-44E4-4BEE-ABFB-0E2483216E19@colorremedies.com>
References: <514299C7.4060200@lolwut.org>
To: Kyle <kyle@lolwut.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 14, 2013, at 9:47 PM, Kyle <kyle@lolwut.org> wrote:

> Hi,
> 
> Is the linux-btrfs list interested in receiving bug reports relating to btrfs?
> 
> If so, the following error occurred on a server of mine when copying a large amount of data to a linear md-RAID formatted as btrfs. The data transfer hung, and any attempt to kill or strace the copy process hung as well until the system was rebooted.
> 
> Mar 14 12:26:26 Galois kernel: [63516.728545] ------------[ cut here ]------------
> Mar 14 12:26:26 Galois kernel: [63516.728901] kernel BUG at /build/buildd/linux-3.0.0/fs/bio.c:1499!

kernel 3.0.0 is positively ancient in btrfs terms. I defer to others on what kernel should be used at the present time for an Ubuntu server, but I know they have much newer kernels than 3.0.0 available.


Chris Murphy