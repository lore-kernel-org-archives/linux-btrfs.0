Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41903 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbbIWH2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 03:28:30 -0400
Received: from wheezy.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 214A2EB58
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 17:28:27 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
Date: Wed, 23 Sep 2015 17:28:23 +1000
References: <55F88ECC.1040604@menke.ac> <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com> <pan$270e2$4b4f9ec6$a323af50$ada695ce@cox.net>
In-Reply-To: <pan$270e2$4b4f9ec6$a323af50$ada695ce@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201509231728.23941.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Sep 2015 12:00:15 PM Duncan wrote:
> The caveat here is that if the VM/DB is active during the backups (btrfs 
> send/receive or other), it'll still COW1 any writes during the existence 
> of the btrfs snapshot.  If the backup can be scheduled during VM/DB 
> downtime or at least when activity is very low, the relatively short COW1 
> time should avoid serious fragmentation, but if not, even only relatively 
> temporary snapshots are likely to trigger noticeable cow1 fragmentation 
> issues eventually.

One relevant issue for this is whether the working set of the database fits 
into RAM.  RAM has been getting bigger and cheaper while databases I run 
haven't been getting bigger.  Now every database I run has a working set that 
fits into RAM so read performance (and therefore fragmentation) doesn't matter 
for me except when rebooting - and database servers don't get rebooted that 
often.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
