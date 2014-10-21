Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58829 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaJUKm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 06:42:27 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 7A173209D5
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 21:42:24 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
Date: Tue, 21 Oct 2014 21:42:22 +1100
References: <201410181454.19375.russell@coker.com.au> <20141020130243.GB29401@hungrycats.org> <201410212113.30887.russell@coker.com.au>
In-Reply-To: <201410212113.30887.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201410212142.22754.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just upgraded the Dom0 (NFS server) from 3.16.3 to 3.16.5 and it all 
works.

Prior to upgrading the Dom0 I had the same problem occur with different file 
names.  All the names in question were truncated names of files that exist.  
It seems that 3.16.3 has a bug with NFS serving files with long names.

Thanks for all the suggestions.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
