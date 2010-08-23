From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/6] btrfs: some bug fixes for free space cache
Date: Mon, 23 Aug 2010 09:22:19 +0800
Message-ID: <4C71CD4B.10606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Those bugs are not critical, which means they won't crash the
filesystem, so they're hardly noticeable and no one noticed
them.

---
 fs/btrfs/free-space-cache.c |  161 ++++++++++++++++++++++++++-----------------
 1 files changed, 99 insertions(+), 62 deletions(-)
