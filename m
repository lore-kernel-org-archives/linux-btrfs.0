Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59457 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab2JaMU5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 08:20:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TTXI8-0004jF-Iu
	for linux-btrfs@vger.kernel.org; Wed, 31 Oct 2012 13:21:04 +0100
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 13:21:04 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 13:21:04 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: (late) REQUEST: Default mkfs.btrfs block size
Date: Wed, 31 Oct 2012 12:20:39 +0000 (UTC)
Message-ID: <loom.20121031T131532-168@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings!

As one 'stuck' with 4k leaves on my main machine for the moment, can I request
the btrfs-progs v0.20 defaults to more efficient decent block sizes before
release. Most distro install programs for the moment don't give access to the
options at install time and there seems to be is a significant advantage to 16k
or 32k

I know you're at -rc stage but I hope that this is a no brainer. ;-)

Kind regards.

