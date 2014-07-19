Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:50932 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbaGSB7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 21:59:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 49BAFCC1A0
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 11:59:23 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 20531-03 for <linux-btrfs@vger.kernel.org>;
 Sat, 19 Jul 2014 11:59:23 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-087a-7115-7313-9012.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:87a:7115:7313:9012])
	by csamuel.org (Postfix) with ESMTPSA id A4053CC1AE
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 11:59:22 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1, raid1 btrfs is no ends of trouble for me
Date: Sat, 19 Jul 2014 11:59:24 +1000
Message-ID: <2070932.kI8iC0EkUq@quad>
In-Reply-To: <20140719004457.GC11996@merlins.org>
References: <53B1A862.50503@fb.com> <20140719003345.GB11996@merlins.org> <20140719004457.GC11996@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Jul 2014 05:44:57 PM Marc MERLIN wrote:

> Sorry, this may be a bit misleading. I actually lost 2 filesystems that
> were raid0 on top of dmcrypt.

Stupid question I know, but does this happen without dmcrypt?

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


