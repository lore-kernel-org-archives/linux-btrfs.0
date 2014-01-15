Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:34581 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaAOUWP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 15:22:15 -0500
Date: Wed, 15 Jan 2014 21:22:08 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs@vger.kernel.org
Cc: lists@colorremedies.com
Subject: Re: why am  I getting "No space left on device" here?
Message-ID: <20140115212208.5d9f3aa7@wpkg.org>
In-Reply-To: <20140115115543.790adafb@wpkg.org>
References: <20140115115543.790adafb@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > # dd if=/dev/urandom of=bigfile
> > dd: writing to `bigfile': No space left on device
> > 186+0 records in
> > 185+0 records out
> > 94720 bytes (95 kB) copied, 0.0144045 s, 6.6 MB/s
> > 
> > 
> > I don't understand why - can anyone explain?
> 
> What kernel version? Can you:
> 
> umount
> dmesg -n7
> mount
> 
> And then try to reproduce the behavior and note any kernel messages in
> dmesg?

It was running 3.13.0-rc6 at the time and there were no extra
warnings etc. in dmesg.

I've removed a ~12 GB file (after which I was able to add new data) and
rebooted since then, so unfortunately I won't be able to reproduce it
for now.

-- 
Tomasz Chmielewski
http://wpkg.org



