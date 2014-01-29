Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42873 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751560AbaA2D5r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 22:57:47 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:62936 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W8MHa-001L8n-D8
	for linux-btrfs@vger.kernel.org; Tue, 28 Jan 2014 20:57:46 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Rapid memory exhaustion during normal operation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52E430F7.7030801@gmail.com>
Date: Tue, 28 Jan 2014 20:57:45 -0700
Message-Id: <E429CA17-EBB7-4EA7-80EE-82FDA3D1DA05@colorremedies.com>
References: <52E430F7.7030801@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 25, 2014, at 2:47 PM, Dan Merillat <dan.merillat@gmail.com> wrote:


> [ 1219.366168] ntpd invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [ 1219.366270] CPU: 1 PID: 5479 Comm: ntpd Not tainted 3.12.8-00848-g97f15f1 #2

This and the whole call track don't have anything in it that's implicating btrfs or vfs.

> 
> [ 1219.377263] Free swap  = 0kB
> [ 1219.377320] Total swap = 0kB

No swap?

> 
> [ 1219.428330] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [ 1219.432471] [ 5383]   103  5383   138079    16199      74        0             0 mysqld
> 
> [ 1219.435805] Out of memory: Kill process 5383 (mysqld) score 16 or sacrifice child
> [ 1219.435874] Killed process 5383 (mysqld) total-vm:552316kB, anon-rss:64576kB, file-rss:220kB

It sounds like mysqld is hogging memory for whatever reason, and in the runaway there's no swap to fall back on so things start imploding, which who knows maybe it cause some file system corruption in the process or once the system had to be force quit.

Off hand to me it doesn't seem to be directly related to Btrfs. Try reproducing without running the things implicated in this event: ntpd, mysqld.

Chris Murphy

