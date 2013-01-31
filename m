Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58139 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab3AaTGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:06:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U0zTH-0001k3-Qf
	for linux-btrfs@vger.kernel.org; Thu, 31 Jan 2013 20:06:51 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 20:06:51 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 20:06:51 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs
 housekeeping process which writes a lot
Date: Thu, 31 Jan 2013 19:06:17 +0000 (UTC)
Message-ID: <keefb9$unr$1@ger.gmane.org>
References: <CAAuLxcbVXFjzvZ+Oj4MUEHnsOhhbVPTeKx-34En2ym37J2wuuA@mail.gmail.com>
	<510A3D1D.4010501@statystyka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> After mounting the system with noatime the problem disappeared, like in 
> magic.

Incidentally, the current version of bedup uses a private mountpoint with 
noatime whenever you don't give it the path to a mounted volume.  You can 
use it with no arguments or designate a filesystem by its uuid or /dev 
path.

> All the writes must have came from the dealyed metadata copy process. 
> Once all the metadata copy-update was done, file system speed was back 
> to normal, but once the new day broke out, all the copying business 
> needed to done again... This in 100% describes all the odd behavior.
> 
> In particular apparently the problem had nothing to do with my complex 
> block device setup, nor with bedup, nor with unison.
> 
> Thank you again, Andrew!
> 
> P.S. Maybe it is not be decided by me, but this small message about 
> performance (not even labeled as warning) in 
> https://btrfs.wiki.kernel.org/index.php/Mount_options IMHO should have 
> been made more conspicuous, maybe put somewhere when the snapshot 
> mechanism is described or in FAQ. I'll try to fix it.

