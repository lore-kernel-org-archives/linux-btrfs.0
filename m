Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53600 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbbE0Rjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 13:39:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YxfIp-0001Yi-9M
	for linux-btrfs@vger.kernel.org; Wed, 27 May 2015 19:39:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 19:39:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 19:39:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Plans for a library for btrfs?
Date: Wed, 27 May 2015 17:39:34 +0000 (UTC)
Message-ID: <pan$a6415$36d8c1c4$3981516e$b8dcb148@cox.net>
References: <CANXojcyqXUNhWLa4ybGyhXceqLdb3DdvM-TvEtwf-KOM6YOsUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stef Bon posted on Wed, 27 May 2015 14:31:28 +0200 as excerpted:

> I'm working on a program (using sqlite, FUSE and btrfs) to provide
> backup and version managment for users. They can enable the backup
> service for folders they own, and select files they want to backup using
> mimetypes.
> 
> This program, which I've called fuse-backup, creates backup subvolumes
> and snapshots by calling an extrenal script, which does something like:
> 
> btrfs subvolume snapshot -r %PathToBackup%/ %PathToSnapshot%
> 
> This works perfect, but are there any plans to do this with a library?

A library is covered on the wiki, project ideas page.

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Provide_a_library_covering_.27btrfs.27_functionality

Status: Project not claimed, no patches, but there's a couple possible 
places to start as parts of other projects.  See the link for more.





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

