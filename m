Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40478 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaB1H1f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 02:27:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WJHr2-00009E-5c
	for linux-btrfs@vger.kernel.org; Fri, 28 Feb 2014 08:27:32 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 08:27:32 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 08:27:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help with space
Date: Fri, 28 Feb 2014 07:27:06 +0000 (UTC)
Message-ID: <pan$49c16$7a7687d1$aadeeb14$c250e08e@cox.net>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
	<20140228103436.2dfd2669@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Fri, 28 Feb 2014 10:34:36 +0600 as excerpted:

> But then as others mentioned it may be risky to use this FS on 32-bit at
> all, so I'd suggest trying anything else only after you reboot into a
> 64-bit kernel.

Based on what I've read on-list, btrfs is not arch-agnostic, with certain 
on-disk sizes set to native kernel page size, etc, so a filesystem 
created on one arch may well not work on another.

Question: Does this apply to x86/amd64?  Will a filesystem created/used 
on 32-bit x86 even mount/work on 64-bit amd64/x86_64, or does upgrading 
to 64-bit imply backing up (in this case) double-digit TiB of data to 
something other than btrfs and testing it, doing a mkfs on the original 
filesystem once in 64-bit mode, and restoring all that data from backup?

If the existing 32-bit x86 btrfs can't be used on 64-bit amd64, 
transferring all that data (assuming there's something big enough 
available to transfer it to!) to backup and then restoring it is going to 
hurt!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

