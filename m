Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54448 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbaBUR5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 12:57:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGuLd-0002qs-SZ
	for linux-btrfs@vger.kernel.org; Fri, 21 Feb 2014 18:57:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 18:57:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 18:57:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: VM nocow, should VM software set +C by default?
Date: Fri, 21 Feb 2014 17:56:45 +0000 (UTC)
Message-ID: <pan$d989e$d5cf11f5$8a41e137$a3391985@cox.net>
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 21 Feb 2014 09:55:50 -0700 as excerpted:

> Use case is a user who doesn't know that today xattr +C ought to be set
> on vm images when on Btrfs. They use e.g. Gnome Boxes, or Virtual
> Machine Manager (virt-manager) to configure pools, images, and VMs.
> 
> If libvirt were to set +C on any containing directory configured as a
> pool, then any copied as well as newly created images would inherit +C.
> So is this the long term recommended practice, and should various VM
> projects be asked to build this functionality? Or will there be
> optimizations, such as autodefrag, that will obviate the need for +C on
> such VM images in the somewhat near future?

FWIW...


I had suggested/predicted in an earlier post that having the software set 
NOCOW automatically for VMs, larger databases and pre-allocated files 
such as those used by bittorrent clients would become long term practice, 
but one of the devs (IIRC Bacik) suggested there was still ongoing defrag 
work, that they hoped would ultimately eliminate the need for that.

I'm personally somewhat skeptical and expect NOCOW will always be of some 
help in that regard, and still predict at least some of the apps will 
begin setting it if they detect that they're on btrfs, at some point, but 
I've been overrules by an expert in the domain, something I'm most 
assuredly NOT, so...

I'll allow that it's a bit early to be asking for it ATM, but I also 
believe it's safe to say that regardless of /future/ developments, if a VM 
suite or db wishes to be ahead of the curve /today/ with its btrfs 
support, they should probably at least mention it in the documentation.  
As for implementing it in code, I'd say only if they're ready to take it 
out later if btrfs as it matures proves not to need it, but certainly, 
mentioning it in documentation, should they choose to specifically 
mention btrfs at all, is probably a good idea at this point.

In my definitely NOT-a-btrfs-code-expert opinion, of course. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

