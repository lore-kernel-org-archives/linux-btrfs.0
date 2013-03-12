Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51546 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706Ab3CLQRj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 12:17:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UFRtm-0006TA-Ui
	for linux-btrfs@vger.kernel.org; Tue, 12 Mar 2013 17:17:59 +0100
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 17:17:58 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 17:17:58 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: File space cache
Date: Tue, 12 Mar 2013 16:17:20 +0000 (UTC)
Message-ID: <loom.20130312T171252-0@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

It seems my btrfs file space cache is corrupt; I had to run clear the log
through a kernel problem.

I've seen messages that the cache is rebuilt automatically, but this doesn't
seem to be true as the messages that the free space is what is expected keep
coming.

I'm running kernel 3.8.2 (Siduction) on Debian testing.

As a subsidiary question, please, should the <pass> value in fstab be zero or
non-zero?

Kind regards.

Al.

