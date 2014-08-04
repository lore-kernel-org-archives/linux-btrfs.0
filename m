Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:58222 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaHDKu6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 06:50:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id ACDB84003F
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Aug 2014 20:50:57 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 16065-07 for <linux-btrfs@vger.kernel.org>;
 Mon,  4 Aug 2014 20:50:57 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-9ddd-740d-de8b-0d3a.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:9ddd:740d:de8b:d3a])
	by csamuel.org (Postfix) with ESMTPSA id 4594640030
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Aug 2014 20:50:57 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Mon, 04 Aug 2014 20:50:55 +1000
Message-ID: <6565984.JHVfJyxURt@quad>
In-Reply-To: <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Aug 2014 11:09:23 AM Peter Waller wrote:

> I accept that. It's all very well if you read the BTRFS list and/or
> are a BTRFS developer. But if you're trying to work it out in the heat
> of battle, as we have sysadmins who would have to, there is a
> combination of things here that makes it unreasonable and harmful for
> production.

To be honest I'm not sure I'd suggest btrfs for production use at all at 
present, it's only recently been unmarked as experimental and to be honest I 
feel that was premature. :-(

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


