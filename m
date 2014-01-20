Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55998 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaATAxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 19:53:11 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so4057993pab.18
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 16:53:10 -0800 (PST)
Received: from [10.2.222.50] (216-19-183-145.dyn.novuscom.net. [216.19.183.145])
        by mx.google.com with ESMTPSA id qf7sm56738640pac.14.2014.01.19.16.53.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 19 Jan 2014 16:53:09 -0800 (PST)
From: Graham Fleming <graham.fleming@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: Scrubbing with BTRFS Raid 5
Message-Id: <BF66C259-5EEA-46DF-A6C6-1A98DCD95F68@gmail.com>
Date: Sun, 19 Jan 2014 16:53:13 -0800
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the wiki, I see that scrubbing is not supported on a RAID 5 volume.

Can I still run the scrub routing (maybe read-only?) to check for any issues. I understand at this point running 3.12 kernel there are no routines to fix parity issues with RAID 5 while scrubbing but just want to know if I'm either a) not causing any harm by running the scrub on a RAID 5 volume and b) it's actually goin to provide me with useful feedback (ie file X is damaged).

Thanks