Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46639 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751553Ab3LWRQh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 12:16:37 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:65378 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Vv97K-003SOd-EL
	for linux-btrfs@vger.kernel.org; Mon, 23 Dec 2013 10:16:34 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: unlinked orphans.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
Date: Mon, 23 Dec 2013 10:16:33 -0700
Message-Id: <1C54B604-CF9A-4DDB-9437-BA0B5C05D20D@colorremedies.com>
References: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 22, 2013, at 11:27 PM, Nacho Man <nacho2874@yahoo.com> wrote:

> Hello,
> I ran dmesg and saw a bunch of these:
> [564421.874063] BTRFS debug (device sda2): unlinked 32 orphans

I sometimes see a similar message (minus debug and device), but it occurs on every boot (rootfs is on Btrfs) and is persistent. If I temporarily add mount option recovery, then they get cleaned up. Expected?

Chris Murphy