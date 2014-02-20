Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45728 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaBTXWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 18:22:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGcwd-0004NB-K5
	for linux-btrfs@vger.kernel.org; Fri, 21 Feb 2014 00:22:19 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 00:22:19 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 00:22:19 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Incremental backup over writable snapshot
Date: Fri, 21 Feb 2014 00:04:38 +0100
Message-ID: <69eita-cgn.ln1@hurikhan77.spdns.de>
References: <17860756.QfG9CfNMqv@linuxpc> <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com> <2091546.7UkK3HMHjX@linuxpc>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GEO <1g2e3o4@gmail.com> schrieb:

> @Kai Krakow: I accept your opinion and thank you for your answer.
> However I have special reasons doing so. I could name you a few use cases.
> For example I do not need to backup search indexes as they mess up over
> time, so I simple recreate the cache in case of a new install.
> I know most of the settings I set and I know exactly what missing
> directories break what in case of deletion, because I have tried so
> various times.

I tried to keep it neutral to help people not to try applying your special 
case as an idea for their own backup which may have a total different 
requirement.

> This is not supposed to be a system backup, or a "home" backup, but a
> backup of my data (documents, videos etc.).
> I know hidden directories contain mails etc. but I know exactly where my
> mails are (most of them imap anyway) and I would include them in the
> backup.
> 
> So I am looking for a different use case.

I may be wrong but it sounds like you approach the problem from the wrong 
direction. If only selective data is important to you for backup: Why not 
put your important data in a single subvolume and backup that? You could 
install some compatibility symlinks to keep consistency with the well known 
directory structure... This is how I usually handle such corner cases. A 
small script like "recreate_symlinks.sh" which you also put into the backup 
will help you in case of restoring.

-- 
Replies to list only preferred.

