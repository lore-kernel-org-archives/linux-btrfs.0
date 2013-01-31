Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48111 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab3AaQYA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:24:00 -0500
Date: Thu, 31 Jan 2013 11:23:57 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix freeing delayed ref head while still holding
 its mutex
Message-ID: <20130131162357.GN3660@localhost.localdomain>
References: <1359579978-2916-1-git-send-email-jbacik@fusionio.com>
 <20130130221635.GV14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130130221635.GV14246@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 03:16:35PM -0700, Zach Brown wrote:
> On Wed, Jan 30, 2013 at 04:06:18PM -0500, Josef Bacik wrote:
> > I hit this error when reproducing a bug that would end in a transaction
> > abort.  We take the delayed ref head's mutex to keep anybody from processing
> > it while we're destroying it, but we fail to drop the mutex before we carry
> > on and free the damned thing.  Fix this by doing the remove logic for the
> > head ourselves and unlock the mutex, that way we can avoid use after free's
> > or hung tasks waiting on that mutex to come back so they know the delayed
> > ref completed.  Thanks,
> > 
> 
> > +			ref->in_tree = 0;
> > +			rb_erase(&ref->rb_node, &delayed_refs->root);
> > +			delayed_refs->num_entries--;
> > +			mutex_unlock(&head->mutex);
> > +		} else {
> > +			ref->in_tree = 0;
> > +			rb_erase(&ref->rb_node, &delayed_refs->root);
> > +			delayed_refs->num_entries--;
> 
> Do you really need to duplicate the removal under the mutex?  Isn't all
> that protected by the delayed_refs->lock?
> 
> Isn't it enough to just add the mutex_unlock()?
> 

Yeah I could re-arrange I guess, either way it's not pretty but I guess not
duplicating stuff is better.  Thanks,

Josef
