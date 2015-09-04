Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34054 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbbIDVNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Sep 2015 17:13:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZXyIj-0001Na-2u
	for linux-btrfs@vger.kernel.org; Fri, 04 Sep 2015 23:13:37 +0200
Received: from 178-221-24-38.dynamic.isp.telekom.rs ([178.221.24.38])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2015 23:13:37 +0200
Received: from ivan by 178-221-24-38.dynamic.isp.telekom.rs with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2015 23:13:37 +0200
To: linux-btrfs@vger.kernel.org
From: Ivan <ivan@ipplus.rs>
Subject: Re: unable to mount multi disk volume with recovery mode
Date: Fri, 4 Sep 2015 21:13:30 +0000 (UTC)
Message-ID: <loom.20150904T231312-92@post.gmane.org>
References: <CAEyaVk+QnDb5sbfMtV_pGbkwA4BB9ODpVv-_hdMJWjuPbGG+Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just to add this:

ivan <at> ipplus-dev:~$ sudo btrfs filesystem df /mnt/ambis/
Data, single: total=108.76GiB, used=107.11GiB
System, single: total=32.00MiB, used=20.00KiB
Metadata, single: total=3.00GiB, used=2.34GiB
ivan <at> ipplus-dev:~$ 

