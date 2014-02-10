Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:55156 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaBJLHS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 06:07:18 -0500
Received: by mail-ve0-f180.google.com with SMTP id db12so4676868veb.25
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 03:07:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F83A69.8080503@gmail.com>
References: <52F83A69.8080503@gmail.com>
Date: Mon, 10 Feb 2014 13:07:17 +0200
Message-ID: <CAK5rZE7hbMFiPOh5LDQsLFTeQw-1H18JKTeopiHMUe1R6b953w@mail.gmail.com>
Subject: Re: Issue with btrfs balance
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've experienced the following with balance:

Setup:
- Kernel 3.12.9
- 11 DVD sized (4.3GB) loopback devices.
(9 Read-Only Seed devices + 2 Read/Write devices)
- 9 device seed created with "-m single -d single" and made
Read-only with "btrfstune -S 1 ..."
- 2 devices was added at different dates. NO balance performed until now.
- NOW add 1 more device to the array and perform a balance.

Result:
Balance did run for a while and exited displaying "Process Killed".
Any attempt to unmount the array failed, preventing any
shutdown. Hence I had no option other than hard reset.

After reboot, issuing balance command gave the message
"Balance in progress".

I cancelled the balance and tried to remove the last device
which ended with a kernel crash. So I dumped 2 + 1 normal devices.

Former 9 multi device seed was OK and was mountable.

Regards,
Imran
