Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39235 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752238AbaANVqB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:46:01 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55129 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3Bo8-000X7U-Qw
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 14:46:00 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <6F3D91C0-8CCA-4713-BFEC-244E3D65F306@colorremedies.com>
Date: Tue, 14 Jan 2014 14:45:59 -0700
Message-Id: <32D6CA98-6FF3-4C93-BAA2-145079A94E17@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <20140115013703.33bb2799@natsu> <1207CF09-B2A4-4DB6-9CA8-C3C78C1DA0F3@colorremedies.com> <20140115031927.4fd1d44b@natsu> <6F3D91C0-8CCA-4713-BFEC-244E3D65F306@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 2:37 PM, Chris Murphy <lists@colorremedies.com> wrote:

> I've seen that happen on OS X Server (client doesn't produce SMART warnings in user space).

Oops. It does, just not automatically, it seems you have to go look for this in Disk Utility.

Chris Murphy

