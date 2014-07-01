Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51895 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbaGAIxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 04:53:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X1toQ-0002zM-Kl
	for linux-btrfs@vger.kernel.org; Tue, 01 Jul 2014 10:53:14 +0200
Received: from lapsgs09.informatik.uni-stuttgart.de ([129.69.213.139])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jul 2014 10:53:14 +0200
Received: from mailinglists by lapsgs09.informatik.uni-stuttgart.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jul 2014 10:53:14 +0200
To: linux-btrfs@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Re: Scrub being stuck
Date: Tue, 01 Jul 2014 10:53:01 +0200
Message-ID: <lotstd$o00$1@ger.gmane.org>
References: <lophhk$nj1$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Florian Lindner wrote:

> Hello,
> 
> I've just completed a scrub on my home filesystem and now I wanted to
> start on my Archiv btrfs RAID 0.

> A scrub I started at Jan 02 seems to be stuck somehow. The command outputs
> above were generated right now.

Thanks! Changing to canceled:1 in /var/lib/btrfs/scrubXXXfooXXX did the 
trick. Last night the scrub finished successfully.

