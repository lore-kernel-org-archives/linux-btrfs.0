Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59556 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaDNKjB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 06:39:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZeHz-0006Sh-Fp
	for linux-btrfs@vger.kernel.org; Mon, 14 Apr 2014 12:38:59 +0200
Received: from p5b005a90.dip0.t-ipconnect.de ([91.0.90.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 12:38:59 +0200
Received: from holger.hoffstaette by p5b005a90.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 12:38:59 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Subvolumes and isolation
Date: Mon, 14 Apr 2014 10:38:45 +0000 (UTC)
Message-ID: <pan.2014.04.14.10.38.45@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


So I'm happily using subvolumes and snapshots and was wondering about
subvolume low-level isolation. Assuming metadata=single, would a corrupt
metadata block in one subvolume's directory tree affect any other subvolumes
on the same physical partition, or would the fallout from this bad block be
contained?

thanks,
Holger

