Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35654 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751636AbaIUR4d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 13:56:33 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52222 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XVlNA-001bsN-HM
	for linux-btrfs@vger.kernel.org; Sun, 21 Sep 2014 11:56:32 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help for creating a useful bugreport
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <541EAF19.2060905@rwth-aachen.de>
Date: Sun, 21 Sep 2014 11:56:31 -0600
Message-Id: <5E85126D-27D1-4778-BB1D-E217C32F2AB1@colorremedies.com>
References: <541BF025.1030309@rwth-aachen.de> <541EAF19.2060905@rwth-aachen.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 21, 2014, at 4:57 AM, Jakob Breier <Jakob.Breier@rwth-aachen.de> wrote:
> 
> I've tried opening a few files and they appear to be fine. I'll take a more thorough look later.

I'm not sure what to expect with --init-extent-tree after the fact. It might have holes in it (?) seeing as I'm not sure how we get something whole from something that had holes in it, that otherwise couldn't be fixed any other way. So I'd take it with a grain of salt unless someone else says it should be fine.

I'm vaguely remembering something about --init-extent-tree discussed in archives, but can't find it, about maybe it should come with a more dire warning, and that the user would probably want to create a new filesystem after retrieving their data from a fixed file system. I know --init-csum-tree removes all csums, so everything produces checksum errors.

You might want to check for hardware related sources for this corruption though. I don't recall if there was any kind of crash that instigated all of this? Do a 'smartctl -t long' test and also a badblocks -swv (destructive write/read with progress) and see if this turns up any problems with device. Check dmesg after badblocks to see if there are any drive or controller related messages, esp link resets or read or write errors. Last it might be worth a memtest86+ overnight or even better over a weekend.

Something caused this corruption, even on crashes I've not had much worse than orphans needing to be cleaned up on the next boot.


Chris Murphy