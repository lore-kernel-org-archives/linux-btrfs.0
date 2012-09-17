Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40781 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2IQLPd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 07:15:33 -0400
Received: by pbbrr13 with SMTP id rr13so8839855pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 04:15:33 -0700 (PDT)
Message-ID: <50570652.4060200@gmail.com>
Date: Mon, 17 Sep 2012 19:15:30 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: enquiry about autodefrag option (resent)
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


