Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luna.xtsubasa.org ([128.199.32.223]:55324 "EHLO
	luna.xtsubasa.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761885AbbA1Up5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 15:45:57 -0500
Received: from localhost (melforce.xtsubasa.org [IPv6:2a02:578:5002:8062:285e:12ff:fea0:bb02])
	by luna.xtsubasa.org (Postfix) with ESMTPSA id BD4A95BE64
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Jan 2015 20:04:40 +0300 (MSK)
From: Pavel Volkov <sailor@lists.xtsubasa.org>
To: <linux-btrfs@vger.kernel.org>
Subject: Linux documentation: btrfs.txt
Date: Wed, 28 Jan 2015 20:04:39 +0300
MIME-Version: 1.0
Message-ID: <d39d1736-4e2a-49cd-b6ef-5fdcab90bcaa@lists.xtsubasa.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my 3.18.3 sources the file at Documentation/filesystems/btrfs.txt says:

"Btrfs is under heavy development, and is not suitable for
any uses other than benchmarking and review. The Btrfs disk format is
not yet finalized."

btrfs is no longer marked experimental in kernel and the file format is 
stable. It is suited for general use except some features.
Maybe it's time to update btrfs.txt?
