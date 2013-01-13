Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53627 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab3AMOet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jan 2013 09:34:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TuOeO-0007Qv-3N
	for linux-btrfs@vger.kernel.org; Sun, 13 Jan 2013 15:35:04 +0100
Received: from p5086b792.dip.t-dialin.net ([80.134.183.146])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Jan 2013 15:35:04 +0100
Received: from holger.hoffstaette by p5086b792.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Jan 2013 15:35:04 +0100
To: linux-btrfs@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Changing metadata block size after the fact
Date: Sun, 13 Jan 2013 15:07:00 +0100
Message-ID: <pan.2013.01.13.14.07.00.577910@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

I have an existing btrfs filesystem which was initialized with defaults. I
want to increase the metadata block size, but after reading wiki/man pages
etc. have come to the conclusion that this does not seem to be possible.
Is this correct, and the only way would be backup/mkfs with -l/restore?

thanks
Holger


