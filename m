Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:2858 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753220Ab3LDVvB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 16:51:01 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can scrub also refresh?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <529F95E8.9000409@gmail.com>
Date: Wed, 4 Dec 2013 14:50:57 -0700
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <F3110CAD-4020-4E2A-A6AF-08D6085768A8@colorremedies.com>
References: <529F95E8.9000409@gmail.com>
To: Kyle Evans <kvans32@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 4, 2013, at 1:51 PM, Kyle Evans <kvans32@gmail.com> wrote:
> 
> 200 Multi_Zone_Error_Rate   0x0008   001   001   051    Old_age   Offline  FAILING_NOW 27189

The drive is failing. I would only do what's required to get data off the drive and then get rid of it (RMA it if it's under warranty). It's only worth keeping around as an unreliable test subject!

Otherwise to answer the question, balance is what you're after. It reads and writes all chunks. As you guessed, scrub is read only unless there's an error that can be corrected.

ddrescue will go slowly, because all sectors are being copied, even sectors you probably don't need. So I personally would use rsync or btrfs send, to get the data off the drive rather than every sector, many of which you don't care about.

Chris Murphy