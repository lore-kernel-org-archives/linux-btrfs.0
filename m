Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49142 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaBURQd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 12:16:33 -0500
Received: by mail-oa0-f41.google.com with SMTP id o6so4306591oag.28
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 09:16:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$9db86$8cb7b8f1$9ed699ad$9da2e024@cox.net>
References: <CAAVQaYCkxpp8vX8PnO3OLffSm_MMCt6N2qFT=5DWjseZmZ1xbA@mail.gmail.com>
	<pan$9db86$8cb7b8f1$9ed699ad$9da2e024@cox.net>
Date: Fri, 21 Feb 2014 12:16:32 -0500
Message-ID: <CAAVQaYDDsfuHu-Lfcjjta48YCP50vZmnGdFM67VQJefnnAfOAg@mail.gmail.com>
Subject: Re: Hard drive hangs after excessive I/O
From: Dave <dave@thekilempire.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 21, 2014 at 11:09 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> One other question:  Are you, or perhaps your distro via likely automated
> script, doing any btrfs snapshotting of the VM-image containing btrfs
> (sub)volume?

I haven't done any snapshotting on this machine.

This problem is pretty easy to reproduce, I spawn about five new
virtual machines and begin installing Windows XP on them.  The host
machine obviously slows down quite a bit but the hard drive chatters
throughout the process.

The next day I wipe those five machines, spawn five new ones, and
begin the concurrent installations again.  This time I see the IO
spurts that I described in my first email; that is, drive thrashes for
a while, then hangs for a couple minutes...  repeat until host reboot.
-- 
-=[dave]=-

Entropy isn't what it used to be.
