Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:35413 "EHLO
	mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831AbcHDRou (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 13:44:50 -0400
Received: by mail-qt0-f181.google.com with SMTP id x25so162394096qtx.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 10:43:07 -0700 (PDT)
MIME-Version: 1.0
From: Martin <rc6encrypted@gmail.com>
Date: Thu, 4 Aug 2016 19:43:06 +0200
Message-ID: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
Subject: How to stress test raid6 on 122 disk array
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I would like to find rare raid6 bugs in btrfs, where I have the following hw:

* 2x 8 core CPU
* 128GB ram
* 70 FC disk array (56x 500GB + 14x 1TB SATA disks)
* 24 FC or 2x SAS disk array (1TB SAS disks)
* 16 FC disk array (1TB SATA disks)
* 12 SAS disk array (3TB SATA disks)

The test can run for a month or so.

I prefer CentOS/Fedora, but if someone will write a script that
configures and compiles a preferred kernel, then we can do that on any
preferred OS.

Can anyone give recommendations on how the setup should be configured
to most likely find rare raid6 bugs?

And does there exist a script that is good for testing this sort of thing?

Best regards,
Martin
