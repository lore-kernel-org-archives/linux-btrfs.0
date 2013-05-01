Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56911 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab3EAJRH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 05:17:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UXT9p-0001lt-8O
	for linux-btrfs@vger.kernel.org; Wed, 01 May 2013 11:17:01 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 11:17:01 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 11:17:01 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Best Practice - Partition, or not?
Date: Wed, 1 May 2013 09:16:45 +0000 (UTC)
Message-ID: <klqmht$gt7$1@ger.gmane.org>
References: <loom.20130501T094600-451@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hello
> 
> If I want to manage a complete disk with btrfs, what's the "Best
> Practice"? Would it be best to create the btrfs filesystem on
> "/dev/sdb", or would it be better to create just one partition from
> start to end and then do "mkfs.btrfs /dev/sdb1"?

Partitions (GPT) are always more flexible and future-proof.  If you ever
need to shrink the btrfs filesystem and give the space to another
partition, or do a conversion to lvm/bcache/luks (shameless plug:
https://github.com/g2p/blocks ), it'd be stupid to be locked into your
current setup for want of a few megabytes of space before your
filesystem.

> Would the same recomendation hold true, if we're talking about huge
> disks, like 4TB or so?

More so, since it can be infeasible to move this much data.


