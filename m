Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:45973 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbaHENgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 09:36:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id EEE2C40044
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Aug 2014 23:36:41 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 27380-07 for <linux-btrfs@vger.kernel.org>;
 Tue,  5 Aug 2014 23:36:41 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-c95e-8ca3-8649-5522.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:c95e:8ca3:8649:5522])
	by csamuel.org (Postfix) with ESMTPSA id 8B4724000D
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Aug 2014 23:36:41 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 05 Aug 2014 23:36:41 +1000
Message-ID: <4351090.ZJIK5ID6sQ@quad>
In-Reply-To: <5484676.xyTNESz9qN@xev>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net> <5484676.xyTNESz9qN@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Aug 2014 10:20:33 PM Russell Coker wrote:

> The Debian installer has BTRFS in a list of filesystems to choose with no 
> special notice about it.  I'm thinking of filing a Debian bug requesting
> that  they put a warning against it.

I think it's a good plan.  People should be aware of the risks they are 
running.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


