Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaKUXJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 18:09:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XrxKk-0002LD-Do
	for linux-btrfs@vger.kernel.org; Sat, 22 Nov 2014 00:09:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 00:09:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 00:09:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Fri, 21 Nov 2014 23:09:34 +0000 (UTC)
Message-ID: <pan$d9898$485c9934$33270393$7d555c81@cox.net>
References: <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
	<20141121175623.GU17395@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Fri, 21 Nov 2014 12:56:23 -0500 as excerpted:

> It's not a bug as long as I can completely control which devices are
> searched for UUIDs, and the system behaves sanely when multiple UUIDs
> are found through automatic discovery; otherwise, it's not only a bug,
> it's a DoS attack security vulnerability.  Consider what happens if
> someone looks at /sys/fs/btrfs, reads the non-secret UUIDs, builds a
> fake filesystem with those UUIDs, puts the fake filesystem on a USB
> stick, and plugs it back into the victim machine...

With the current state of USB vulnerability (firmware reprogrammed as an 
input device, etc, the vuln has been all over the tech news for some 
months now), anyone with USB access to the machine is simply another case 
of anyone with physical access to the machine, they're normally assumed 
to be able to be able to at minimum take down the machine, the ultimate 
DoS, in any case, and often to have effective root, tho that can be 
mitigated to some extent with encryption, etc.  It's generally assumed 
that if you have physical access, as required to plug in that USB, game 
over, the machine is effectively p40wn3d.  At the /very/ least, with 
physical access it's vulnerable to the sledgehammer DoS, and there's 
little to be done about that but prevent physical access by all means 
necessary (armed guards, nuclear silo hosting, etc) in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

