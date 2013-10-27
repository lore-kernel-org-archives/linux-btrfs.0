Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:53317 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab3J0BAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 21:00:35 -0400
Date: Sun, 27 Oct 2013 10:00:22 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        igork20@gmail.com
Subject: Re: No space left on device, problem
Message-ID: <20131027100022.4c76e1e7@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Still no messages. Parameter seems to be active as
> /sys/module/printk/parameters/ignore_loglevel is Y, but there are no
> messages in log files or dmesg. Maybe I need to turn on some kernel
> debugging option and recompile kernel ?
> Also I should mention that cca 230G+ data was copied before this error
> started to occur.

I think I saw a similar issue before.

Can you try using rsync with "--bwlimit XY" option to copy the files?

The option will limit the speed, in kB, at which the file is being
copied; it will work even when source and destination files are on a
local machine.


-- 
Tomasz Chmielewski
http://wpkg.org
