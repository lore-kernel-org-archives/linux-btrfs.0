Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:53296
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbbINOvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 10:51:50 -0400
Received: from tux.wizards.de (p4FF58F87.dip0.t-ipconnect.de [79.245.143.135])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 0F2F5416015A
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 16:51:49 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 9C27611C003D
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 16:51:48 +0200 (CEST)
Subject: Re: [PATCH v3 0/9] Btrfs: free space B-tree
To: linux-btrfs@vger.kernel.org
References: <cover.1442209006.git.osandov@osandov.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <55F6DF04.8040700@googlemail.com>
Date: Mon, 14 Sep 2015 16:51:48 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/15 08:04, Omar Sandoval wrote:
> I went back and fixed the issues that came up since v2. Changes below. I
> removed Josef's Reviewed-by on patch 9 because it was completely
> rewritten to change the mount options like Dave suggested. These are
> still based on 4.2

I decided to take one for the team and try this.

Merging it into my custom 4.1++ tree (with btrfs at ~4.3) worked flawlessly,
just as the -progs bits. \o/

Upgrading existing filesystems works fine and performance on my peasant
systems with SATA SSDs and rust is still good; not worse but also not
noticeably better. Maybe it is and I just didn't notice; otherwise I guess
that's good for a cache which is not really supposed to be noticeable. :)

Unmounting, remounting, btrfs check all also seem to work as expected.

Two questions:

1) I believe the previous postings mentioned that the fst inherits the
metadata properties - does this mean that e.g. on a single rotational
disk with data=single,metadata=dup the fst is also dup? Is this good,
bad, intentional? I guess it might prevent some of the problems with
corrupted v1 caches that some people had.

2) the following:

> - Changed the free_space_tree option to space_cache=v2 and made clear_cache
>   clear the free space tree. If the free space tree has been created,
>   the mount will fail unless space_cache=v2 or nospace_cache,clear_cache
>   is given because we cannot allow the free space tree to get out of
>   date.

also all seem to work in my testing (wrt. the clearing/downgrading to v1),
but once a volume has been upgraded to v2 fst, a simple mount does not need
to specify space_cache=v2 again; it seems to stick until cleared/downgraded.
Not sure if that is what you meant to say.

Long story short: +1 excellent job and:
Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

cheers!

Holger

