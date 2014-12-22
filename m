Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:48964 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbaLVLly (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 06:41:54 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 51E0C406BF
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 22:41:54 +1100 (AEDT)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 23557-05 for <linux-btrfs@vger.kernel.org>;
 Mon, 22 Dec 2014 22:41:54 +1100 (AEDT)
Received: from quad.localnet (2001-44b8-41dd-d500-8017-2b93-f171-2d75.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:8017:2b93:f171:2d75])
	by csamuel.org (Postfix) with ESMTPSA id DF526406BD
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 22:41:53 +1100 (AEDT)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
Date: Mon, 22 Dec 2014 22:41:54 +1100
Message-ID: <2088275.TCEagPyUYo@quad>
In-Reply-To: <3748928.v6JPJNQWc6@quad>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com> <CAJCQCtQV3tQZ0WpTt0k3geKUfDJ23EDskyxDCTqkx0FFrSWCsA@mail.gmail.com> <3748928.v6JPJNQWc6@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 22 Dec 2014 10:38:04 PM Chris Samuel wrote:

> I suspect it's this commit and it implies that it's limited to the leafsize:

Forgot to mention that looks like it should be in 3.17 and later.

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


