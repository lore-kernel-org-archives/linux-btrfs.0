Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:43254 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459Ab3F2Jli (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 05:41:38 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 415A8D982C
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 19:41:35 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Re: raid1 inefficient unbalanced filesystem reads
Date: Sat, 29 Jun 2013 19:41:31 +1000
References: <kqk4sc$t5d$1@ger.gmane.org> <20130628170410.GX4288@localhost.localdomain> <kqki3l$nmr$1@ger.gmane.org>
In-Reply-To: <kqki3l$nmr$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201306291941.32127.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 29 Jun 2013, Martin <m_btrfs@ml1.co.uk> wrote:
> Mmmm... I'm not sure trying to balance historical read/write counts is
> the way to go... What happens for the use case of an SSD paired up with
> a HDD? (For example an SSD and a similarly sized Raptor or enterprise
> SCSI?...) Or even just JBODs of a mishmash of different speeds?
> 
> Rather than trying to balance io counts, can a realtime utilisation
> check be made and go for the least busy?

It would also be nice to be able to tune this.  For example I've got a RAID-1 
array that's mounted noatime, hardly ever written, and accessed via NFS on 
100baseT.  It would be nice if one disk could be spun down for most of the 
time and save 7W of system power.  Something like the --write-mostly option of 
mdadm would be good here.

Also it should be possible for a RAID-1 array to allow faster reads for a 
single process reading a single file if the file in question is fragmented.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
