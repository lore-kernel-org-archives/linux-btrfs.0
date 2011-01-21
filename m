From: Rodney Beede <mailinglist@rodneybeede.com>
Subject: Shrinking virtual disk with btrfs on it
Date: Fri, 21 Jan 2011 10:20:34 -0700
Message-ID: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Any tools to go about zeroing about the free space on a btrfs file
system so I can shrink the VMware vmdk virtual disk?

I ran the VMware command, but the dynamic disk is still really big.  I
presume it is due to free space that isn't zeroed out.
