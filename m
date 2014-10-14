Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34323 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbaJNQZk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 12:25:40 -0400
Received: by mail-ig0-f177.google.com with SMTP id a13so15311762igq.4
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 09:25:39 -0700 (PDT)
Message-ID: <1413303927.1289.6.camel@kepstin.ca>
Subject: Re: Scrub already running
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Bob Williams <linux@barrowhillfarm.org.uk>
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 14 Oct 2014 12:25:27 -0400
In-Reply-To: <543D3EAA.4000706@barrowhillfarm.org.uk>
References: <543D3EAA.4000706@barrowhillfarm.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-10-14 at 16:18 +0100, Bob Williams wrote:
> When I run scrub on the root (system) partition now, I get
> 
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /'.
> To see the status use 'btrfs scrub status [-d] /'.
> 
> but
> 
> # btrfs scrub cancel /
> ERROR: scrub cancel failed on /: not running
> 
> This situation (scrub running persistently) survives reboots.
> 
> On the /home partition, everything is OK:
> 
> scrub status for 56884b1d-93ab-4db9-bc93-eff3833e91e1
>         scrub started at Tue Oct 14 02:00:01 2014 and finished after 
> 9972 seconds
>         total bytes scrubbed: 2.47TiB with 0 errors
> 
> Should I worry about this (apart from the fact that I cannot scrub 
> /)?
> What can I do about it?

This usually just means that the local state file used to track scrub 
history has gotten desynchronized. It's easy enough to fix:

Edit the file /var/lib/btrfs/scrub.status.56884b1d-93ab-4db9-bc93-
eff3833e91e1 (the last bit of the filename is the filesystem uuid)

Look for a line that ends with "finished:0" and change it to say 
"finished:1"

This should allow you to start a new scrub.

I'm not sure if this has been improved in newer versions of the btrfs-
progs.


-- 
Calvin Walton <calvin.walton@kepstin.ca>
