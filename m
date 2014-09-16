Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54711 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754065AbaIPCJA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 22:09:00 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49541 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XTiCR-0016LI-TK
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 20:09:00 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [bug] <subvol> doesn't belong to btrfs mount point
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1E99F2EE-0D94-4271-990F-3535BB005A0A@colorremedies.com>
Date: Mon, 15 Sep 2014 20:08:58 -0600
Message-Id: <D8984BA0-E220-4D74-AADC-5C488023EDA1@colorremedies.com>
References: <1E99F2EE-0D94-4271-990F-3535BB005A0A@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 12, 2014, at 5:39 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Summary: When a btrfs subvolume is mounted with -o subvol, and a nested ro subvol/snapshot is created, btrfs send returns with an error. If the top level (id 5) is mounted instead, the send command succeeds.

I'm not able to reproduce this, so at the moment I'm going to say it's user error until I can.


Chris Murphy