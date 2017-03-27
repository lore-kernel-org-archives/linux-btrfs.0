Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40005 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdC0SC7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 14:02:59 -0400
Date: Mon, 27 Mar 2017 20:01:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, ednadolski@gmail.com, linux-btrfs@vger.kernel.org,
        Edmund Nadolski <enadolski@suse.com>
Subject: Re: [PATCH 2/2] btrfs: replace hardcoded value with SEQ_NONE macro
Message-ID: <20170327180122.GT4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313203204.11857-1-enadolski@suse.com>
 <20170313203204.11857-3-enadolski@suse.com>
 <20170315143801.GH14605@twin.jikos.cz>
 <befed888-5df2-9fd3-f0fa-a95d8feffda4@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <befed888-5df2-9fd3-f0fa-a95d8feffda4@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 16, 2017 at 09:59:38AM +0800, Qu Wenruo wrote:
> 
> 
> At 03/15/2017 10:38 PM, David Sterba wrote:
> > On Mon, Mar 13, 2017 at 02:32:04PM -0600, ednadolski@gmail.com wrote:
> >> From: Edmund Nadolski <enadolski@suse.com>
> >>
> >> Define the SEQ_NONE macro to replace (u64)-1 in places where said
> >> value triggers a special-case ref search behavior.
> >
> >> index 9c41fba..20915a6 100644
> >> --- a/fs/btrfs/backref.h
> >> +++ b/fs/btrfs/backref.h
> >> @@ -23,6 +23,8 @@
> >>  #include "ulist.h"
> >>  #include "extent_io.h"
> >>
> >> +#define SEQ_NONE	((u64)-1)
> 
> The naming of SEQ_NONE sounds not that good to me.
> 
> The (u64)-1 is to to info the backref walker to only search current 
> root, and no need to worry about delayed_refs, since the caller (qgroup) 
> will ensure that no delayed_ref will exist.
> 
> While the name SEQ_NONE seems a little like to 0, which is far from the 
> original meaning.
> 
> What about SEQ_FINAL or SEQ_LAST?

SEQ_LAST sounds good to me.

> Since the timing we use (u64)-1 is just before switching commit roots, 
> it would be better for the naming to indicate that.

Yes, makes sense.
