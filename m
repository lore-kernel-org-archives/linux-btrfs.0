Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbcE2TsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 15:48:10 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4TJm8DN018349
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u4TJm81O021810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:08 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u4TJm795028098
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [regression] make sure seed is writeable sprout after device add
Date: Mon, 30 May 2016 03:48:16 +0800
Message-Id: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally a seed FS becomes a writeable sprout FS after a
device is added to it, however as at 4.6 I don't see this
behavior anymore.

This, the above feature is quite unique to btrfs, and there
are some good future solutions on top it. So please preserve
this feature and here is a test case [1] which is to make
sure we would.

On the point of fixing regression, I am trying, traced until
3.8 looks like it failed beyond that. Will continue after my
vacation.

Further, while digging this out, found another bug in
btrfs_init_new_device() which [2] will fix it. (again [2] is not
a fix for the regression).

----
[1]
[PATCH] btrfs: failed to create sprout should set back to rdonly

[2]
[PATCH] fstests: btrfs: test case to make sure seed FS is writable
after device add
