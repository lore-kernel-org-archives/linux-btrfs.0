From: Cheng Shao <zchshao@gmail.com>
Subject: writes got stuck
Date: Mon, 18 Apr 2011 14:49:29 -0700
Message-ID: <BANLkTinJt3n69=NpPKAvFd3LPeDGnn0bkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I'm periodically having issues with btrfs running in a Ubuntu VM using
VirtualBox. After the VM has been running for a while (a couple days),
any write operation seems getting stuck. The read seems totally fine.
I tried a simple dd of a 4M file and it got stuck after writing 131K
worth of data.

I don't know if this is btrfs related, or it is due to some bug in
VritualBox. Could you guys provide information on how to debug this
(collecting logs, getting dumps etc.)? Thanks a lot!

thanks,
- cheng
