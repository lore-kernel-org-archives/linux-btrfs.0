Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:40868 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaABKS2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 05:18:28 -0500
Date: Thu, 2 Jan 2014 11:10:29 +0100
From: Sander <sander@humilis.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: improve the performance fluctuating of the fsync
Message-ID: <20140102101029.GA16317@panda>
Reply-To: sander@humilis.net
References: <1387363964-20316-1-git-send-email-miaox@cn.fujitsu.com>
 <20131218110944.GA8309@pdb1.th.formicary.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131218110944.GA8309@pdb1.th.formicary.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leonidas Spyropoulos wrote (ao):
> Will this help with apt-get performance over btrfs file system? As far
> as I understand it it's happening because of multiple fsync calls.

apt-get install eatmydata

"This package contains a small LD_PRELOAD library (libeatmydata) and a
couple of helper utilities designed to transparently disable fsync and
friends (like open(O_SYNC))."

Then use it like:
eatmydata apt-get install <package>
