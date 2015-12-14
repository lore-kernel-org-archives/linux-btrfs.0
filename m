Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34500 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbbLNMin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 07:38:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8SOm-0003eL-Rf
	for linux-btrfs@vger.kernel.org; Mon, 14 Dec 2015 13:38:41 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:38:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:38:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel lockup, might be helpful log.
Date: Mon, 14 Dec 2015 12:38:32 +0000 (UTC)
Message-ID: <pan$e38ea$87a57c38$77699913$c9fa489c@cox.net>
References: <566DF757.8020807@birds-are-nice.me>
	<pan$42e96$8159f644$233ed3aa$27e4f2e6@cox.net>
	<20151214083524.GD26782@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 14 Dec 2015 08:35:24 +0000 as excerpted:

> It's not just btrfs. Invalid opcode is the way that the kernel's BUG and
> BUG_ON macro is implemented.

Thanks.  I indicated that I suspected broader kernel use further down the 
reply, but it's very nice to have confirmation, both of invalid opcode 
use elsewhere, and of it being the kernel's general implementation for 
BUG and BUG_ON.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

