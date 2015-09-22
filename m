Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:35821
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbbIVNgq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:36:46 -0400
Received: from tux.wizards.de (p4FF58F87.dip0.t-ipconnect.de [79.245.143.135])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 7BD6641601DA
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 15:36:44 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id D355B11C0032
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 15:36:43 +0200 (CEST)
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5601596B.1020607@googlemail.com>
Date: Tue, 22 Sep 2015 15:36:43 +0200
MIME-Version: 1.0
In-Reply-To: <560150CD.6070301@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/15 14:59, Jeff Mahoney wrote:
(snip)
> So if they way we want to prevent the loss of raid type info is by
> maintaining the last block group allocated with that raid type, fine,
> but that's a separate discussion.  Personally, I think keeping 1GB

At this point I'm much more surprised to learn that the RAID type can
apparently get "lost" in the first place, and is not persisted
separately. I mean..wat?

> allocated as a placeholder is a bit much.  Beyond that, I've been

Can you explain why keeping at least one data chunk (or the appropriate
number across devices, depending on RAID level..) is "a bit much"?
IMHO this would have no real negative impact on end users (who think
in terms of overall filesystem space, not how much of that has been
lazily touched), nor for more obscure use cases like sparse images -
which would still be sparsely reserved. So there would not be any
actual downside that I can see. From a fs consistency point of view
it sounds much more sane to assume that at least a basic set of data
chunks always need to exist. I know I was very surprised recently to
see all my data chunks cleaned up on an otherwise empty fs.
I mean..it's good to see that the house cleaning works, but you also
gotta know when to stop!

> thinking casually about ways to direct the allocator to use certain
> devices for certain things (e.g. in a hybrid system with SSDs and
> HDDs, always allocate metadata on the SSD) and there's some overlap
> there.  As it stands, we can fake that in mkfs but it'll get stomped
> by balance nearly immediately.

Please share those casual thoughts with the group. :)

-h
