Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44050 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754126AbaCMRMn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 13:12:43 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:58111 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WO9BS-002Fai-4l
	for linux-btrfs@vger.kernel.org; Thu, 13 Mar 2014 11:12:42 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Understanding btrfs and backups
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140307T144540-512@post.gmane.org>
Date: Thu, 13 Mar 2014 11:12:42 -0600
Message-Id: <38A0A27D-1D8C-4BC9-B3A9-E1F5467FF5A6@colorremedies.com>
References: <loom.20140306T191655-366@post.gmane.org> <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net> <loom.20140307T144540-512@post.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 7, 2014, at 7:03 AM, Eric Mesa <ericsbinaryworld@gmail.com> wrote:
> 
> Duncan - thanks for this comprehensive explanation. For a huge portion of
> your reply...I was all wondering why you and others were saying snapshots
> aren't backups. They certainly SEEMED like backups. But now I see that the
> problem is one of precise terminology vs colloquialisms. In other words,
> snapsshots are not backups in and of themselves. They are like Mac's Time
> Machine. BUT if you take these snapshots and then put them on another media
> - whether that's local or not - THEN you have backups. Am I right, or am I
> still missing something subtle?

Hmm, yes because snapshots on a mirrored drive are on another media but that's still not considered a backup. I think what makes a backup is separate device and separate file system. That's because the top vectors for data loss are: user induced, device failure, and file system corruption. These are substantially mitigated by having backup files located both on separate file systems and device.

Also, Time Machine qualifies as a backup because it copies files to a separate device with a separate file system. (There is a feature in recent OS X versions that store hourly incremental backups on the local drive when the usual target device isn't available - these are arguably not backups but rather snapshots that are pending backups. Once the target device is available, the snapshots are copied over to it.)

If you have data you feel is really important, my suggestion is that you have a completely different backup/restore method than what you're talking about. It needs to be bullet proof, well tested. And consider all the Btrfs send/receive work you're doing as testing/work-in-progress. There are still cases on the list where people have had problems with send/receive, both the send and receive code have a lot of churn, so I don't know that anyone can definitively tell you that a btrfs send/receive only based backup is going to reliably restore in one month let alone three years. Should it? Yes of course. Will it?


Chris Murphy

