Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:57582 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbaHGJLP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Aug 2014 05:11:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id A582E40045
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:11:14 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 12925-05 for <linux-btrfs@vger.kernel.org>;
 Thu,  7 Aug 2014 19:11:14 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-69b8-7e38-7e07-896b.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:69b8:7e38:7e07:896b])
	by csamuel.org (Postfix) with ESMTPSA id 1252740030
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:11:14 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Unrecoverable errors when the btrfs file system was modified outside the running OS
Date: Thu, 07 Aug 2014 19:11:10 +1000
Message-ID: <6853154.vNEuFh3p4f@quad>
In-Reply-To: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
References: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Aug 2014 01:29:49 AM rocwhite168 wrote:

> being able to recover at least "somewhat"
> in this situation seems to be a desired feature for any file system.

I would add that only specially designed clustered/distributed filesystems will 
survive this sort of accident.

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


