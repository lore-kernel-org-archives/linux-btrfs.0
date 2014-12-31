Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17779 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751451AbaLaBax (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 20:30:53 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBV1UK7w026979
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Dec 2014 09:30:20 +0800
Message-ID: <54A351C9.7070504@cn.fujitsu.com>
Date: Wed, 31 Dec 2014 09:30:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: What about not warn on some abort_transaction() case whose reason
 is known?
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

While surfing the Redhat BZ, a lot(at least 5 I found in one month) 
users report "bugs" in btrfs about
kernel warning in btrfs_abort_transaction().
And most of them (about 3 or more) are caused by disconnected usb device.

So I'm considering not to warn on some cases if we know its reason, like 
the above device disconnected
case, but still warn on other cases.
This should reduce many unneeded bug report for the usb disconnected case.

Any advice is welcomed.

Thank,
Qu
