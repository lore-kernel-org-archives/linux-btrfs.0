Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37194 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753351Ab3KPXAJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 18:00:09 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52467 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VhoqR-003yns-1C
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 16:00:03 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: qcow2 on btrfs
Message-Id: <8D975721-E7AC-4591-9CD8-258325251748@colorremedies.com>
Date: Sat, 16 Nov 2013 16:00:01 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since qcow2 only supports metadata preallocation, not full preallocation, I'm wondering if +C on the sparse file is sufficient, or alternatively using qemu-create -o preallocation=metadata,compat=1.1,lazy_refcounts=on? Or is qcow2 on btrfs just not a good idea?


Chris Murphy