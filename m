From: "Gong, Zhipeng" <zhipeng.gong@intel.com>
Subject: kernel oops when sync after rm a file at full disk
Date: Wed, 25 Nov 2009 16:22:43 +0800
Message-ID: <E88DD564E9DC5446A76B2B47C3BCCA150221DC4166@pdsmsx503.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce steps:
     free_size=`df | grep "/" -w | awk '{print $4}'`
     dd if=/dev/zero of=tmpfile bs=1024 count=$free_size
     sync

These got done without any errors until disk is full, and then run these steps:
	rm -rf tmpfile
	sync (will cause oops)


Zhipeng Gong


