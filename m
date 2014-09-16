Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57967 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752501AbaIPVW1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:22:27 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52765 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XU0Ch-004Mel-44
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 15:22:27 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs balance enospc
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54189581.6050303@intellasoft.net>
Date: Tue, 16 Sep 2014 15:22:25 -0600
Message-Id: <E3D15F9F-B885-47EE-9479-6586F51912B4@colorremedies.com>
References: <54186A4B.60902@intellasoft.net> <54186A82.7070801@intellasoft.net> <5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com> <54189581.6050303@intellasoft.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 16, 2014, at 1:54 PM, Mark Murawski <markm-lists@intellasoft.net> wrote:

> The smart stats on the disk are fine.  The /dev/sdc messages are from me playing around and pulling out the drive.   btrfs fi show, shows the drive as missing, yet it's still trying to write to it.

That's known.

> Basically my goal is to remove this drive and stick it in another box and I can't get btrfs to move all the data off of it due to enospc.

If you can mount it rw, even degraded, you can make ro snapshots of things you want to keep, and then btrfs send to a new volume.

Chris Murphy