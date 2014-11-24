Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40229 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbaKXIXl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 03:23:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xsovq-0001e7-PG
	for linux-btrfs@vger.kernel.org; Mon, 24 Nov 2014 09:23:38 +0100
Received: from p4ff580e3.dip0.t-ipconnect.de ([79.245.128.227])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 09:23:38 +0100
Received: from holger.hoffstaette by p4ff580e3.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 09:23:38 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 24 Nov 2014 08:23:25 +0000 (UTC)
Message-ID: <pan.2014.11.24.08.23.25@googlemail.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 24 Nov 2014 13:23:05 +0800, Liu Bo wrote:

> This brings a strong-but-slow checksum algorithm, sha256.
> 
> Actually btrfs used sha256 at the early time, but then moved to crc32c for
> performance purposes.
> 
> As crc32c is sort of weak due to its hash collision issue, we need a stronger
> algorithm as an alternative.

I'm curious - did you see actual cases where this happened, i.e. a corrupt
block that would pass crc32 validation? I know some high-integrity use
cases require a stronger algorithm - just wondering.

Would there be room for a compromise with e.g. 128 bits?

> Users can choose sha256 from mkfs.btrfs via
> 
> $ mkfs.btrfs -C 256 /device

Not sure how others feel about this, but it's probably easier for
sysadmins to specify the algorithm by name from the set of supported
ones, similar to how ssh does it ("ssh -C arcfour256").

cheers
Holger

