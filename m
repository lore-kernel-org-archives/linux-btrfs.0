Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34605 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab2F0H46 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 03:56:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Sjn7P-0002Jl-Np
	for linux-btrfs@vger.kernel.org; Wed, 27 Jun 2012 09:56:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 09:56:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 09:56:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:1887 after hard
 shutdown.
Date: Wed, 27 Jun 2012 07:56:45 +0000 (UTC)
Message-ID: <pan.2012.06.27.07.56.46@cox.net>
References: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jordan Windsor posted on Wed, 27 Jun 2012 13:16:44 +0930 as excerpted:

> My computer locked up and I had to press the reset button.
> Ever since then I can't mount the btrfs filesystem, here's the output:

Are you aware of the btrfs wiki and have you read up on btrfs there, yet?

https://btrfs.wiki.kernel.org/index.php/Main_Page

In particular, check the mount options listed there.  I had a similar 
problem when I was testing here (during the 3.4 kernel dev cycle, I 
decided btrfs was still too experimental for my current needs so am back 
on more reliable reiserfs for now), which turned out to be a corrupted 
space-cache.  Mounting with the listed nospace_cache option allowed the 
filesystem to mount and self-repair, after which I could mount it 
normally again.

https://btrfs.wiki.kernel.org/index.php/Mount_options

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

