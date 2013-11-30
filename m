Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:58054 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3K3Lh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Nov 2013 06:37:29 -0500
Message-ID: <5299CC95.6010704@informatik.uni-bonn.de>
Date: Sat, 30 Nov 2013 12:31:33 +0100
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: 1i5t5.duncan@cox.net
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 2 errors when scrubbing - but I don't know what they mean
References: <pan$e58f7$107ceb0e$e753a400$c76bf1d5@cox.net>
In-Reply-To: <pan$e58f7$107ceb0e$e753a400$c76bf1d5@cox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

thank you for your input. I didn't know that btrfs keeps the error 
counters over mounts/reboots, but that's nice.

I'm still trying to figure out how such a generation error may occur in 
the first place. One thing I noticed looking at the btrfs code is that 
the generation error counter will only get incremented in the actual 
scrubbing code (either in "scrub_checksum_super" or in 
"scrub_handle_errored_block", both in scrub.c - please correct me if I'm 
wrong, I'm not a btrfs dev). Also, the dmesg errors I saw were not there 
at boot time, but about 10 minutes after boot which was about the time 
when I started the scrub so I'm pretty sure that it was the scrub that 
detected the errors.

The question remains what can cause superblock/gen errors. Sure it could 
be "some" read error, but I'd really like to make sure that it's not a 
systematic error. I wasn't able to reproduce it yet though.

Best
Sebastian
