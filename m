Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37639 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAQEDT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 23:03:19 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so2085308pad.39
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 20:03:19 -0800 (PST)
MIME-Version: 1.0
Reply-To: ivo.welch@gmail.com
From: ivo welch <ivo.welch@anderson.ucla.edu>
Date: Thu, 16 Jan 2014 20:02:58 -0800
Message-ID: <CAPr7RtX2NGWssKd=Z8MHt4QpfHt+uUy3wyVcwCSpKwTTE7J2dg@mail.gmail.com>
Subject: btrfs FAQ
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FAQ:

[1] where should I send FAQ questions or suggestions?

[2] mixed HDD and SSD setups are becoming very common.  hybrid drives
even have two partitions.  is it possible to use the HDD to keep
backup sector information for crc scrubbing?  I do not want to RAID1
the SSD with the HDD for obvious speed reasons.  rather, I want to use
the HDD as an asynchronously-updated less important quasi-backup
location for SSD sectors to protect against bitrot.

----
Ivo Welch (ivo.welch@gmail.com)
