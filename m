Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56013 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753819AbaACXd7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:33:59 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C7127F.3060902@friedels.name>
Date: Fri, 3 Jan 2014 16:33:57 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com>
References: <52C7127F.3060902@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 12:41 PM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Hello,
> 
> I ran btrfsck on my volume with the repair option. When I re-run it, I get the same errors as before.

Did you try mounting with -o recovery first?
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

What messages in dmesg so you get when you use recovery?


Chris Murphy