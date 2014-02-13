Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51645 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaBMVmm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 16:42:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WE43N-0000y3-Lu
	for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 22:42:41 +0100
Received: from p5b004dfd.dip0.t-ipconnect.de ([91.0.77.253])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 22:42:41 +0100
Received: from holger.hoffstaette by p5b004dfd.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 22:42:41 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Possible to wait for snapshot deletion?
Date: Thu, 13 Feb 2014 21:42:18 +0000 (UTC)
Message-ID: <pan.2014.02.13.21.42.31@googlemail.com>
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 Feb 2014 20:02:43 +0100, Kai Krakow wrote:

> Is it technically possible to wait for a snapshot completely purged from 
> disk? I imagine an option like "--wait" for btrfs delete subvolume.

That would indeed be sweet (see pointer to patch by Garry Williams).

In the meantime have you tried issuing a simple "sync" in your script
after every snapshot deletion? I've observed that this kicks the cleaner
into action.

-h

