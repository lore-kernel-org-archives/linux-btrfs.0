Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4996 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755206AbbLQBz2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 20:55:28 -0500
To: <fstests@vger.kernel.org>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Ideas to do custom operation just after mount?
Message-ID: <56721602.5050204@cn.fujitsu.com>
Date: Thu, 17 Dec 2015 09:55:14 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Will xfstests provides some API to do some operation just after
mounting a filesystem?

Some filesystem(OK, btrfs again) has some function(now qgroup only) 
which needed to be enabled by ioctl instead of mount option.

Currently, for btrfs qgroup we added special test case enabling qgroup 
and do test.
But there is only less than 10 qgroup test case and we didn't test most 
of the rest cases with qgroup enable.

Things will get even worse if we are adding inband-deduplication.

So is there any good idea to do some operation just after mounting in 
xfstests?

Thanks,
Qu


