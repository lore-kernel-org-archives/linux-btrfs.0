Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:40156 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbaIBUwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 16:52:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 3955520C007
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Sep 2014 06:52:36 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 12515-07 for <linux-btrfs@vger.kernel.org>;
 Wed,  3 Sep 2014 06:52:36 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-9d18-8ca9-6581-e1ff.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:9d18:8ca9:6581:e1ff])
	by csamuel.org (Postfix) with ESMTPSA id C7D8A20C006
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Sep 2014 06:52:35 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: BUG_ON spams /var/log/messages with the same msg full
Date: Wed, 03 Sep 2014 06:52:31 +1000
Message-ID: <1921647.MYMEsIlUfm@quad>
In-Reply-To: <5404CB12.6030608@gmx.de>
References: <5400ECBC.5090301@gmx.de> <20140901134124.GA18252@localhost.localdomain> <5404CB12.6030608@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 1 Sep 2014 09:37:54 PM Toralf Förster wrote:

> Ah thx, it seems that fix does not made it in -rc3, so -rc4 would be a
> better choice for a re-test, or ?

It all depends on what Chris Mason sends to Linus, and what Linus chooses to 
accept.

Your best bet is to watch the mailing list for the PULL requests to Linus and 
any response, and pull Linus's git tree to see what lands when.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


