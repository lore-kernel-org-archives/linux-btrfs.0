Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:46166 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752032AbcI1Tpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 15:45:40 -0400
Subject: Re: 4.8rc8 & OOM panic
To: E V <eliventer@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJtFHUTUvJpMSzBXy+Ub+_iPRPocWXHfubA=5p4TyQqCj-29AQ@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57EC1DE1.90608@applied-asynchrony.com>
Date: Wed, 28 Sep 2016 21:45:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAJtFHUTUvJpMSzBXy+Ub+_iPRPocWXHfubA=5p4TyQqCj-29AQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/16 20:46, E V wrote:
> I just booted my backup box with 4.8rc8 and started an rsync onto
> btrfs and it panic'd with OOM a couple hours later. I thought the OOM
> problems from 4.7 we're supposed to be fixed in 4.8, or did I get that
> wrong? No users or anything else on the system.

Keep in mind that those problems are generic, other filesystems also
suffer: http://www.spinics.net/lists/linux-mm/msg114123.html

I don't see any recent compaction-related patches in Linus' tree at
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/mm/

..so it seems they have not been merged yet.

So unless they get merged in the last minute it looks like 4.8 will
be DOA.

-h

