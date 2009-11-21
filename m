From: Andi Drebes <lists-receive@programmierforen.de>
Subject: [PATCH 0/2] btrfs-progs: mounted filesystems checks
Date: Sat, 21 Nov 2009 15:33:25 +0100
Message-ID: <200911211533.25878.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <yanzheng@21cn.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following two patches add code that prevents btrfsck to run on mounted filesystems. The first patch makes check_mounted() work with multidevice filesystems. The second patch finally adds the check to btrfsck.

	Cheers,
		Andi
