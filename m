Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46147 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082AbaICXgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 19:36:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPK5z-0006Ie-To
	for linux-btrfs@vger.kernel.org; Thu, 04 Sep 2014 01:36:11 +0200
Received: from pd953e6e4.dip0.t-ipconnect.de ([217.83.230.228])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 01:36:11 +0200
Received: from holger.hoffstaette by pd953e6e4.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 01:36:11 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Btrfs stable updates for v3.16
Date: Wed, 3 Sep 2014 23:36:00 +0000 (UTC)
Message-ID: <pan.2014.09.03.23.36.00@googlemail.com>
References: <54077F27.1040603@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: stable@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 03 Sep 2014 16:50:47 -0400, Chris Mason wrote:

> Hi everyone,
> 
> For 3.16, please pull these into stable, I've cherry picked and tested
> them here.  For 3.15 and earlier there are a few conflicts, so I'll make
> a git tree with things to pull.
> 
> 8d875f95da43c6a8f18f77869f2ef26e9594fecc v3.15+

This ("fix filemap_flush call in btrfs_file_release") is the only one 
that requires some work for 3.14.

There is one conflict in ordered.data.c - just a sligh work queue 
submission change - and the second in transaction.c where the patch does 
not delete enough from btrfs_flush_all_pending_stuffs(), since 3.14 still 
has the old qgroup calls in place. I removed it wholesale and that makes 
everything fit.

The followup ("fix filemap_flush call in btrfs_file_release") then also 
applies.

Should they also go into the next 3.14.x stable cycle? This rename 
deadlock sounds like a possible problem with rsync, which seems like a 
popular use case, and I guess nobody will complain about slightly better 
performance either.

Holger

