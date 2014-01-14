Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43320 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaANGEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 01:04:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2x6a-0000Oq-Qy
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 07:04:04 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 07:04:04 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 07:04:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck does not fix
Date: Tue, 14 Jan 2014 06:03:37 +0000 (UTC)
Message-ID: <pan$e93a4$196236e0$f9702991$6860b33e@cox.net>
References: <52C7127F.3060902@friedels.name>
	<6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com>
	<52C87B67.1040503@friedels.name>
	<F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
	<52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name>
	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
	<52D317CF.2070007@friedels.name>
	<EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 13 Jan 2014 17:40:33 -0700 as excerpted:

> If you decide to backup, reformat, restore, then first I suggest
> 
> btrfs-image -c 9-t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>
> 
> You can keep it handy in case a dev asks for it or you can attach it to
> a kernel.org bug report.

I've not actually done one of these, yet.  How big are they?  The manpage 
says it's basically the metadata only (data is zeroed), so I'd guess one 
could expect it to be about the size of metadata as reported by btrfs fi 
df (obviously, when it could still mount if it's now unmountable), right?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

