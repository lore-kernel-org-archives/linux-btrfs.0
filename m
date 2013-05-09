Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55414 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3EIKLM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 May 2013 06:11:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UaNoa-0008Ra-Ny
	for linux-btrfs@vger.kernel.org; Thu, 09 May 2013 12:11:08 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 12:11:08 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 12:11:08 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: How many subvols/snapshots are possible? (limits?)
Date: Thu, 09 May 2013 11:10:56 +0100
Message-ID: <kmfsnb$bu1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Devs,

This is more a use case question of what is a good idea to do...


Can btrfs support snapshots of the filesystem at very regular intervals,
say minute by minute or even second by second?

Or are there limits that will be hit with metadata overheads or
links/reference limits or CPU overheads if 'too many' snapshots/subvols
are made?

If snapshots were to be taken once a minute and retained, what breaks first?


What are 'reasonable' (maximum) numbers for frequency and number of held
versions?


Thanks,
Martin

