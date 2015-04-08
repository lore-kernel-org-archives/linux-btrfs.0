Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:38059 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbbDHNS2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Apr 2015 09:18:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 2F1BC40514
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2015 23:13:05 +1000 (AEST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 28074-05 for <linux-btrfs@vger.kernel.org>;
 Wed,  8 Apr 2015 23:13:05 +1000 (AEST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id CD1E740474
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2015 23:13:04 +1000 (AEST)
From: Chris Samuel <chris@csamuel.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Porting BTRFS to user space
Date: Wed, 08 Apr 2015 23:13:01 +1000
Message-ID: <9805000.6VT5HnkAKH@quad>
In-Reply-To: <20150408122757.GN13864@carfax.org.uk>
References: <1463140364.591861428494608421.JavaMail.weblogic@epmlwas09b> <20150408122757.GN13864@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 8 Apr 2015 12:27:57 PM Hugo Mills wrote:

> (NFS, Ceph, Gluster certainly work this way. I would be surprised if
> any of the others out there at the moment didn't work like that).

GPFS has its own underlying filesystem format, you can upgrade the
format on the fly with mmchfs once all your GPFS nodes are at the
same minimum version.

Painful IBM URL follows:

http://www-01.ibm.com/support/knowledgecenter/#!/SSFKCN_4.1.0/com.ibm.cluster.gpfs.v4r1.gpfs100.doc/bl1adm_fsmigissues.htm

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

