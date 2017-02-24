Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:47276
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751697AbdBXCdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 21:33:37 -0500
Received: from [122.164.43.112] (port=58592 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1ch5gR-0005iH-F0
        for linux-btrfs@vger.kernel.org; Thu, 23 Feb 2017 19:32:36 -0700
Date: Fri, 24 Feb 2017 08:02:25 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: List of corruption cases for scrub
Message-ID: <20170224023225.GA4006@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I tried to a create list of corruption test scenarios for scrubbing process with RAID5.
Here's the list: https://btrfs.wiki.kernel.org/index.php/Scrub_corruption_cases

If similar list already exists in btrfs wiki, let me know, I'll move this data
to there. Feel free to add/update/delete entries or suggest new corrupt ideas!

Cheers.
Lakshmipathi.G
