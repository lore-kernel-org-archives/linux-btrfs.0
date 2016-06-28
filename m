Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45929 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbcF1J1F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 05:27:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bHpIG-00064K-7f
	for linux-btrfs@vger.kernel.org; Tue, 28 Jun 2016 11:26:57 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:26:56 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:26:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: invalid opcode 0000 / kernel bug with defect HDD
Date: Tue, 28 Jun 2016 09:26:43 +0000 (UTC)
Message-ID: <pan$278cb$db1a74f8$df6075a2$e36deafd@cox.net>
References: <CAEtw4r1OMSwMpoyiaO0oqKM+cWbt0AEo3apwJS5qybG3HsPn-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Becker posted on Tue, 28 Jun 2016 10:16:58 +0200 as excerpted:

> Cause of kernel bugs was a defective HDD (/dev/sdd).

Just a short note to mention that invalid opcode 0000 doesn't say much.  
I'm just another user and list regular, but apparently, opcode 0000 is 
used as a deliberate way to trigger a kernel bugon, when the kernel hits 
code that it isn't expected to ever hit in normal operations.  Given that 
common usage, opcode 0000 itself says very little except that something 
went wrong, which we already know given the triggered backtrace.

While the 0000 opcode isn't of much help, however, devs can make more 
sense of the backtrace, particularly in cases such as this where it has 
the file and line number that triggered the bugon.  That and the other 
information provided does help quite a bit to trace down the bug.

(At first I was wondering about all these opcode 0000 traces too, until 
someone explained that to me.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

