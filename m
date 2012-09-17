Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57789 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2IQGMn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 02:12:43 -0400
Received: by oago6 with SMTP id o6so4402945oag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2012 23:12:43 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 17 Sep 2012 14:12:43 +0800
Message-ID: <CACHiF8D44zK4Y9jEAvLk975G2=GjOW3hvdNMgP_ZHScVa_LH+Q@mail.gmail.com>
Subject: enquiry about autodefrag option
From: ching lu <lsching17@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am testing btrfs for long-term storage and backup, and i would like
to know more about "autodefrag" option:

1. Will "autodefrag" option benefit ssd?

    My understanding is:

       autodrag -> number of extent decrease -> metadata decrease -> a
"healthier" filesystem in the long run

   (P.S. I am aware that autodefrag will introduce extra write I/O)

2. AFAIK, "autodefrag" detects small random writes into files and
queues them up for an automatic defrag process, so the filesystem will
defragment itself while it's used.

    If the system reboot/crash/remount-ro, will the autodefrag process
continue after resume?
