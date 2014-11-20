Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60700 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbaKTNSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 08:18:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XrRce-0002Fx-I8
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 14:18:08 +0100
Received: from 195.184.117.138 ([195.184.117.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 14:18:08 +0100
Received: from spam by 195.184.117.138 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 14:18:08 +0100
To: linux-btrfs@vger.kernel.org
From: Bardur Arantsson <spam@scientician.net>
Subject: Re: btrfs send and an existing backup
Date: Thu, 20 Nov 2014 14:17:52 +0100
Message-ID: <m4kpm0$r52$1@ger.gmane.org>
References: <o9rujb-sud.ln1@venus.xundeenergie.ssh22.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <o9rujb-sud.ln1@venus.xundeenergie.ssh22.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-19 16:58, Jakob Schürz wrote:
> Hi there!
> 
> I'm new on btrfs, and I like it :)
> 
> But i have a question. I have a existing backup on an external HDD. This
> was ext4 before i converted it to btrfs.
> And i installed my debian new on btrfs with some subvolumes. (f.e. home,
> var, multimedia/Video multimedia/Audio...)
> 

If you have no other backups, I would really recommend that you *don't*
use btrfs for your backup, or at least have a *third* backup which isn't
on btrfs -- there are *still* problems with btrfs that can potentially
wreck your backup filesystem. (Although it's obviously less likely if
the external HDD will only be connected occasionally.)

Don't get me wrong, btrfs is becoming more and more stable, but I
wouldn't trust it with my *only* backup, especially if also running
btrfs on the backed-up filesystem.

Regards,

