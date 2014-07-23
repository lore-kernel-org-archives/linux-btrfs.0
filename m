Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55068 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755632AbaGWCg5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 22:36:57 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49424 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X9mQK-002ZqS-Qc
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 20:36:57 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: [BUG] bogus out of space reported when mounted raid1 degraded
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
Date: Tue, 22 Jul 2014 20:36:55 -0600
Message-Id: <BEB1C719-6B2A-46DC-9CBA-A22F53C6407C@colorremedies.com>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 22, 2014, at 7:34 PM, Chris Murphy <lists@colorremedies.com> wrote:

> BUG 1: The df command is clearly bogus six ways to Sunday. It's a 12.58 GiB partition, only 6.78GiB used, thus 5.8GiB free, yet df and apparently gvfs think it's full, maybe systemd too because the journal wigged out and stopped logging events while also kept stopping and starting. So whatever changes occurred to clean up the df reporting, are very problematic at best when mounting degraded.

Used strace on df, think I found the problem so I put it all into a bug.

https://bugzilla.kernel.org/show_bug.cgi?id=80951


Chris Murphy