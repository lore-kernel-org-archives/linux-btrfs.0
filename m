Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49274 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbaCEWPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 17:15:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLK5f-00022a-69
	for linux-btrfs@vger.kernel.org; Wed, 05 Mar 2014 23:15:03 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Mar 2014 23:15:03 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Mar 2014 23:15:03 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Wed, 5 Mar 2014 22:13:56 +0000 (UTC)
Message-ID: <loom.20140305T231334-952@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>,<20140303183911.GL13899@carfax.org.uk> <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com> <87D857EF-FB03-468E-A0FD-4F5898B9581B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:

> Did you do a defrag and balance after ext4>btrfs conversion, 
> but before data/metadata profile conversion?

No I didn't, as I thought it was only optional and didn't realize 
it might later affect my ability to change profiles. 




