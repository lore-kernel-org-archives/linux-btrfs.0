Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36732 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbcFNUzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 16:55:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bCvMW-0002UR-Jn
	for linux-btrfs@vger.kernel.org; Tue, 14 Jun 2016 22:55:04 +0200
Received: from aftr-185-17-204-173.dynamic.mnet-online.de ([185.17.204.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 22:55:04 +0200
Received: from masc by aftr-185-17-204-173.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 22:55:04 +0200
To: linux-btrfs@vger.kernel.org
From: Marco Schindler <masc@disappear.de>
Subject: Re: refcount overflow in 4.4.6-grsec kernel
Date: Tue, 14 Jun 2016 20:53:38 +0000 (UTC)
Message-ID: <loom.20160614T224124-279@post.gmane.org>
References: <CAMdWP3GVfR+Jr7qpBUOP74c1Vo92APrEygr4n71tCktBgErp-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Hunger <tobias.hunger <at> gmail.com> writes:

> 
> Hi,
> 
> I updated my archlinux to use a grsec kernel (version 4.4.6). Now I
> get lots of errors from PAX and all backtraces show mention btrfs.
> 
> Is this a known problem? Is there anything I can help to debug this?

I'm seeing the same issue with 4.4.8 on hardened gentoo.
This forum post relates, claiming it's a bug within btrfs.
https://forums.grsecurity.net/viewtopic.php?f=3&t=4392

