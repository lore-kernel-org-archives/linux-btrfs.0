Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:33988 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbbEHVnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 17:43:40 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Kernel Dump scanning directory
From: Anthony Plack <tmy@plack.net>
In-Reply-To: <pan$ef76f$1decf414$ca28dae0$217ae55f@cox.net>
Date: Fri, 8 May 2015 16:37:05 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D7C742B6-7DD3-49F3-B49A-4C8FD5B97527@plack.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net> <4B045A3B-60E2-4151-86E7-029E79585886@plack.net> <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net> <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net> <pan$ef76f$1decf414$ca28dae0$217ae55f@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On May 8, 2015, at 3:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> And then I wasn't quite so concerned either about losing something 
> critical in the log, or the safety of simply blowing it away, since by 
> design, the log only deals with what hasn't been committed yet, and the 
> commits are themselves designed to be atomic and leave the filesystem in 
> a known good state.
> 

Duncan,
Thank you for joining me in my monolog here.

30 seconds on a server can be allot of data, and is to small of a time span for adequate backups to occur.  What you say makes sense, however, without this fixed going forward, BTRFS can never become a serious data storage file system.

While there are major distros who have switched to this as their default filesystem, and acknowledging that btrfs has no control over who chooses to do this, there should be more than just a warning about it being unstable, but wholly unreliable.

I do get the point that you are relaying what you understood, and it does help me a bit.  Since I have a backup (and always I would like another of the data), I thought I would try to help solve an ongoing problem of the tranid issues.  I realize I am just stumbling around in the dark, so maybe this comes for nothing in the end.

Maybe we need a warning at the top of the BTRFS page that it is highly likely, if BTRFS crashes and the transactions get corrupt, that you WILL loose at a minimum the last 30 seconds of your data and maybe more.