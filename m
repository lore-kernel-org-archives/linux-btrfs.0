Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:4170 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755895Ab3JGPoy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 11:44:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs device delete problem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$c82c4$81d08e2c$7fe5940b$26a9f83b@cox.net>
Date: Mon, 7 Oct 2013 09:44:52 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <36E90B61-31BA-41A2-8DFB-E2F4A65FF287@colorremedies.com>
References: <CAKZ=RP9a6A8ni-4s7WdUWfqUhhRHyFGFVkN42kmYOJqnu=4dyA@mail.gmail.com> <pan$c82c4$81d08e2c$7fe5940b$26a9f83b@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 7, 2013, at 4:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> Since your btrfs in raid1 mode has two devices currently, you won't be 
> able to delete one of them as-is.  You will need to ADD a device first 
> (bringing the total to three devices), optionally do a balance, and THEN 
> delete the failed/missing/to-be-removed device (bringing the total back 
> to two, which you never go below that way).

Oops that's right, I forgot about this, and I have read the wiki! The other way to do it is to just pull the device, preferably with the file system unmounted. And then use it in degraded mode. I don't know if it's possible to convert a degraded volume, however.

Chris Murphy

