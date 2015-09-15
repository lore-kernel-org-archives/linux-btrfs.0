Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33162 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbIOC4F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 22:56:05 -0400
Received: by pacex6 with SMTP id ex6so161956106pac.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 19:56:04 -0700 (PDT)
Date: Mon, 14 Sep 2015 19:56:03 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/9] Btrfs: free space B-tree
Message-ID: <20150915025603.GA4677@mew>
References: <cover.1442209006.git.osandov@osandov.com>
 <55F6DF04.8040700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <55F6DF04.8040700@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2015 at 04:51:48PM +0200, Holger Hoffstätte wrote:
> On 09/14/15 08:04, Omar Sandoval wrote:
> > I went back and fixed the issues that came up since v2. Changes below. I
> > removed Josef's Reviewed-by on patch 9 because it was completely
> > rewritten to change the mount options like Dave suggested. These are
> > still based on 4.2
> 
> I decided to take one for the team and try this.
> 
> Merging it into my custom 4.1++ tree (with btrfs at ~4.3) worked flawlessly,
> just as the -progs bits. \o/
> 
> Upgrading existing filesystems works fine and performance on my peasant
> systems with SATA SSDs and rust is still good; not worse but also not
> noticeably better. Maybe it is and I just didn't notice; otherwise I guess
> that's good for a cache which is not really supposed to be noticeable. :)
> 
> Unmounting, remounting, btrfs check all also seem to work as expected.
> 
> Two questions:
> 
> 1) I believe the previous postings mentioned that the fst inherits the
> metadata properties - does this mean that e.g. on a single rotational
> disk with data=single,metadata=dup the fst is also dup? Is this good,
> bad, intentional? I guess it might prevent some of the problems with
> corrupted v1 caches that some people had.

Yeah, that's correct, the free space tree will have the same profile as
the rest of the metadata. There's certainly a cost in duplicating the
free space tree where the old space cache wouldn't have been duplicated,
but it's a good thing that the free space tree be consistent with the
rest of the metadata.

> 2) the following:
> 
> > - Changed the free_space_tree option to space_cache=v2 and made clear_cache
> >   clear the free space tree. If the free space tree has been created,
> >   the mount will fail unless space_cache=v2 or nospace_cache,clear_cache
> >   is given because we cannot allow the free space tree to get out of
> >   date.
> 
> also all seem to work in my testing (wrt. the clearing/downgrading to v1),
> but once a volume has been upgraded to v2 fst, a simple mount does not need
> to specify space_cache=v2 again; it seems to stick until cleared/downgraded.
> Not sure if that is what you meant to say.

Yeah, to be clear: if the filesystem is mounted with space_cache=v2
once, it's assumed from then on unless the user specifies otherwise
(i.e., nospace_cache,clear_cache). The idea there was to be consistent
with the original space_cache.

> Long story short: +1 excellent job and:
> Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
> 
> cheers!
> 
> Holger

Thanks a ton for testing this out!

-- 
Omar
