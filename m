Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55200 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751865AbaANHtP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 02:49:15 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49251 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W2ykM-003SFB-NQ
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 00:49:14 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$e93a4$196236e0$f9702991$6860b33e@cox.net>
Date: Tue, 14 Jan 2014 00:49:13 -0700
Message-Id: <4A0D47A5-0FBC-488E-83E9-311FE89DBB03@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name> <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com> <52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com> <pan$e93a4$196236e0$f9702991$6860b33e@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 13, 2014, at 11:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Mon, 13 Jan 2014 17:40:33 -0700 as excerpted:
> 
>> If you decide to backup, reformat, restore, then first I suggest
>> 
>> btrfs-image -c 9-t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>
>> 
>> You can keep it handy in case a dev asks for it or you can attach it to
>> a kernel.org bug report.
> 
> I've not actually done one of these, yet.  How big are they?  The manpage 
> says it's basically the metadata only (data is zeroed), so I'd guess one 
> could expect it to be about the size of metadata as reported by btrfs fi 
> df (obviously, when it could still mount if it's now unmountable), right?

# btrfs fi df /mnt/isos
Data, single: total=196.01GiB, used=185.92GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=289.53MiB
Metadata, single: total=8.00MiB, used=0.00

193M -rw-r--r--. 1 root root 193M Jan 14 00:44 sdb.img


Guess that's too big to attach to a bugzilla bug.


Chris Murphy

