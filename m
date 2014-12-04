Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:49912 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaLDNva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 08:51:30 -0500
Received: by mail-qa0-f48.google.com with SMTP id v10so11731534qac.7
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 05:51:29 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Thu, 4 Dec 2014 19:21:09 +0530
Message-ID: <CAH-HCWWUF-D9DoJCpa8ZWuJ1fVPuBp0qUs+dmCZrp6tx=5jDuA@mail.gmail.com>
Subject: btrfs df not really doing df?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

IIUC df means "disk free" and is supposed to display the disk's (or
partition's) free space -- but while btrfs fi df displays the
allocated and used sizes, it doesn't actually display the total
capacity of the devices, and subtract the allocated size and display
the rest.

One should not need to run the additional (regular) df command to find
out that info, IMO.

Anyone have any objection to my submitting a bug requesting this
additional info to be printed?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
