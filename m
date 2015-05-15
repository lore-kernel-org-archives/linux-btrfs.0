Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46432 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933595AbbEORPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 13:15:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YtJCz-0003u1-LI
	for linux-btrfs@vger.kernel.org; Fri, 15 May 2015 19:15:37 +0200
Received: from p4ff580f3.dip0.t-ipconnect.de ([79.245.128.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 19:15:37 +0200
Received: from holger.hoffstaette by p4ff580f3.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 19:15:37 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Support for lazytime?
Date: Fri, 15 May 2015 17:15:31 +0000 (UTC)
Message-ID: <pan.2015.05.15.17.15.31@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Support for the lazytime mount option went into 4.0, but I don't see
any btrfs related changes by Ted Tso in Linus' main tree.

Were the originally proposed changes (to inode.c) not necessary after
all or was btrfs support skipped? Or does it "just work"?

Figured I'd ask before I bork my fs..

thanks,
Holger


