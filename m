Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f67.google.com ([74.125.83.67]:64451 "EHLO
	mail-ee0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaBPUH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 15:07:56 -0500
Received: by mail-ee0-f67.google.com with SMTP id d17so3756560eek.10
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 12:07:55 -0800 (PST)
Received: from linuxpc.localnet (91-113-120-146.adsl.highway.telekom.at. [91.113.120.146])
        by mx.google.com with ESMTPSA id j41sm48427254eey.15.2014.02.16.12.07.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 16 Feb 2014 12:07:54 -0800 (PST)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS send: exclude directories
Date: Sun, 16 Feb 2014 21:07:52 +0100
Message-ID: <11335246.MGjIN0NiaF@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been experimenting with btrfs send/receive for incremental backups, but 
could not figure out how to exclude certain directories from 
subvolumes/snapshots. For example, I want to backup my data in home, but I am 
not interested in backing up hidden directories like .cache too. 
Is it currently possible to achieve something like that?

Thanks for the great work!
