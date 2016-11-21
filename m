Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbcKUPCy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2016 10:02:54 -0500
Date: Mon, 21 Nov 2016 16:02:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: remove old tree_root dirent processing in
 btrfs_real_readdir()
Message-ID: <20161121150249.GI12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1478366795-27009-1-git-send-email-jeffm@suse.com>
 <20161111160545.GA17158@vader>
 <5953d956-1ff1-6635-f593-12da1c31b36e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5953d956-1ff1-6635-f593-12da1c31b36e@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2016 at 09:08:14PM -0500, Jeff Mahoney wrote:
> >> -			 */
> >> -			if (location.type == BTRFS_ROOT_ITEM_KEY &&
> >> -			    location.objectid == root->root_key.objectid) {
> >> -				over = 0;
> >> -				goto skip;
> >> -			}
> >> -			over = !dir_emit(ctx, name_ptr, name_len,
> >> -				       location.objectid, d_type);
> >> +		over = !dir_emit(ctx, name_ptr, name_len, location.objectid,
> >> +				 d_type);
> >>  
> >> -skip:
> >> -			if (name_ptr != tmp_name)
> >> -				kfree(name_ptr);
> >> +		if (name_ptr != tmp_name)
> >> +			kfree(name_ptr);
> >>  
> >> -			if (over)
> >> -				goto nopos;
> >> -			emitted = true;
> > 
> > Shouldn't this line (getting rid of emitted) be in the next patch?
> 
> Yep.  Good catch.

Updated.
