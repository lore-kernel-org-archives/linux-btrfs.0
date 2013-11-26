Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35808 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3KZAu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 19:50:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vl6rC-0005Ux-Ua
	for linux-btrfs@vger.kernel.org; Tue, 26 Nov 2013 01:50:26 +0100
Received: from p5b00795b.dip0.t-ipconnect.de ([91.0.121.91])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 01:50:26 +0100
Received: from holger.hoffstaette by p5b00795b.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 01:50:26 +0100
To: linux-btrfs@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: btrfs scrub ioprio
Date: Tue, 26 Nov 2013 01:50:15 +0100
Message-ID: <pan.2013.11.26.00.50.14.749597@googlemail.com>
References: <5292C7F7.8010200@jrs-s.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 Nov 2013 22:45:59 -0500, Jim Salter wrote:

> TL;DR scrub's ioprio argument isn't really helpful - a scrub murders
> system performance til it's done.
> 
> My system:
> 
> 3.11 kernel (from Ubuntu Saucy)

I don't run Ubuntu, but *maybe* they use the deadline IO scheduler by
default, which does not handle IO priorities (by design). So maybe make
sure your devices don't say "deadline" in /sys/block/sdX/queue/scheduler,
and if they do, set them to cfq.

-h


