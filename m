Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52879 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933678Ab3JOTcI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 15:32:08 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:62373 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VWALc-0005Kc-Hi
	for linux-btrfs@vger.kernel.org; Tue, 15 Oct 2013 13:32:05 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't mount subvol if default subvol is changed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
Date: Tue, 15 Oct 2013 13:32:05 -0600
Message-Id: <DFCB011F-366A-4EE3-92D7-D2A57279FA78@colorremedies.com>
References: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 15, 2013, at 1:23 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> So should the mounting of relative pathnames still work?

Is it related to fix: [PATCH] Btrfs: use right root when checking for hash collision

can't move subvols into subvols
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27848.html


Chris Murphy