Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42948 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab3KMMxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 07:53:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgZwf-0007DJ-Jg
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 13:53:21 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:53:21 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:53:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Error from Trying to Mount Btrfs
Date: Wed, 13 Nov 2013 12:52:56 +0000 (UTC)
Message-ID: <pan$63fda$df85d33$eff0354a$38afd821@cox.net>
References: <1382915825.53433.YahooMailNeo@web125705.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gatlin sullivan posted on Sun, 27 Oct 2013 16:17:05 -0700 as excerpted:

> I have the attached error from trying to mount btrfs on external hard
> drive. The F.S. was my primary system, then I dd'd it to an external and
> reinstalled Fedora.
> 
> 
> I tried to follow
> https://btrfs.wiki.kernel.org/index.php/
Problem_FAQ#Filesystem_can.27t_be_mounted_by_label.
> I used "# btrfs device scan --all-devices" before attempting to mount.
> 
> 
> What should I do?
> 
> Appreciatively, Gatlin.
> 
> P.S.
> This file system is very important to me becasue it has a large
> collection of songs.

Commenting on that P.S.:

Of course if you've read the wiki you know this, but it's worth repeating 
for others who may come across this in their googles, etc...

As noted both on the wiki and in description for the kernel's btrfs 
option itself, btrfs remains classified as an experimental filesystem, 
suitable only for testing with data that you don't care about losing, 
either because it's well backed up to tested usable backups (preferably 
on something more stable than btrfs), or because it's low-value data you 
don't particularly care about losing if the test goes wrong and btrfs 
eats your data for breakfast in the first place.

IOW, importance is relative, and relative to the value of the time it 
would have taken to research the filesystem and ensure backups 
appropriate to the importance of the data, if you didn't do that research 
and have those backups, by definition your time saved in skipping that 
was more important to you than the potential loss of that data on what 
you would have known if you /really/ cared about the data you put on it, 
was an experimental filesystem unfit to the purpose you evidently used it 
for.

So you saved the time on the research and backups because you considered 
that more important than the data, and are now paying the tradeoff cost 
for that time saved with the potential loss of the obviously relatively 
unimportant data.  No big deal, since self-evidently that time was more 
important to you than the data you were risking by not spending it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

