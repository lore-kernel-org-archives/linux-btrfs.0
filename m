Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54488 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2G2TFM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jul 2012 15:05:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SvYnc-000148-VU
	for linux-btrfs@vger.kernel.org; Sun, 29 Jul 2012 21:05:09 +0200
Received: from 176.50.240-63.xdsl.ab.ru ([176.50.240-63.xdsl.ab.ru])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jul 2012 21:05:08 +0200
Received: from ksee.zelgadis by 176.50.240-63.xdsl.ab.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jul 2012 21:05:08 +0200
To: linux-btrfs@vger.kernel.org
From: Konstantin Dmitriev <ksee.zelgadis@gmail.com>
Subject: Re: severe hardlink bug
Date: Sun, 29 Jul 2012 19:02:30 +0000 (UTC)
Message-ID: <loom.20120729T205902-38@post.gmane.org>
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it> <20100124142711.4afe8a81@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dipl.-Ing. Michael Niederle <mniederle <at> gmx.at> writes:

> I reinstalled over 700 packages - plt-scheme beeing the only one failing due to
> the btrfs link restriction.
> 

I have hit the same issue - tried to run BackupPC with a pool on btrfs
filesystem. After some time the error of "too many links (31)" appeared to me.
Now I'm forced to migrate to some other filesystem...

