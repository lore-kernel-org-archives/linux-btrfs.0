Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:17785 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752365Ab3BNIBk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 03:01:40 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
Date: Thu, 14 Feb 2013 01:01:27 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <357B99EB-183C-4AFA-BF61-433F72BBC65B@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com> <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 13, 2013, at 11:42 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:

> It's worth noting that I still haven't un- and remounted the filesystem since the drive disconnected. 

I suggest capturing the current dmesg, reboot, and see if the btrfs volume will mount read-only without complaints in dmesg.

Also, is a virtual machine being used in any of this, either as host or guest?

Chris Murphy

