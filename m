Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41872 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753819AbaACXcK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 18:32:10 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C746EA.7000006@jrs-s.net>
Date: Fri, 3 Jan 2014 16:32:07 -0700
Cc: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>,
        linux-btrfs@vger.kernel.org
Message-Id: <DC9A9A14-7E27-40A6-8A9E-3722C3F1AEFB@colorremedies.com>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com> <52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com> <52C74415.3020407@jrs-s.net> <20140103231821.GJ8913@carfax.org.uk> <52C746EA.7000006@jrs-s.net>
To: Jim Salter <jim@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 4:25 PM, Jim Salter <jim@jrs-s.net> wrote:

> 
> One thing that concerns me is that edits made directly to grub.cfg will get wiped out with every kernel upgrade when update-grub is run - any idea where I'd put this in /etc/grub.d to have a persistent change?

/etc/default/grub

I don't recommend making it persistent. At this stage of development, a disk failure should cause mount failure so you're alerted to the problem.

> I have to tell you, I'm not real thrilled with this behavior either way - it means I can't have the option to automatically mount degraded filesystems without the filesystems in question ALWAYS showing as being mounted degraded, whether the disks are all present and working fine or not. That's kind of blecchy. =\

If you need something that comes up degraded automatically by design as a supported use case, use md (or possibly LVM which uses different user space tools and monitoring but uses the md kernel driver code and supports raid 0,1,5,6 - quite nifty). I haven't tried this yet, but I think that's also supported with the thin provisioning work, which even if you don't use thin provisioning gets you the significantly more efficient snapshot behavior.

Chris Murphy