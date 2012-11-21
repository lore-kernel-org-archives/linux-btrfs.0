Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54734 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2KURZR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Nov 2012 12:25:17 -0500
Date: Wed, 21 Nov 2012 18:25:11 +0100
From: David Sterba <dave@jikos.cz>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, bo.li.liu@oracle.com
Subject: Re: per-file NOCOW in 3.7
Message-ID: <20121121172511.GC3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAAdM647=qHnkfk=3c2hhGk61_-Jge02yxbj6nNVAqmEf+BJA-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM647=qHnkfk=3c2hhGk61_-Jge02yxbj6nNVAqmEf+BJA-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 21, 2012 at 10:48:08AM -0500, Marios Titas wrote:
> According to the tentative changelog in the wiki, 3.7 will properly
> support per-file NOCOW. I think this is misleading. In particular, it
> still does not work correctly in the case when the NOCOW flag of a new
> flag is being inherited from the directory. I think it would be better
> to remove that item from the changelog until the the fix [1] is
> merged.
> [1] https://patchwork.kernel.org/patch/1438431/

You're right, the patch is not in 3.7-rc nor in btrfs-next, and fixes a
real bug.

Technically it is a regresssion within the 3.7 cycle (so it could even
go to a late -rc), in any case it's a small change that could also go
through the stable tree.

david
