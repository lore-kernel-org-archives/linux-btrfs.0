Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38081 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab3A3WQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 17:16:35 -0500
Date: Wed, 30 Jan 2013 14:16:35 -0800
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix freeing delayed ref head while still holding
 its mutex
Message-ID: <20130130221635.GV14246@lenny.home.zabbo.net>
References: <1359579978-2916-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359579978-2916-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 04:06:18PM -0500, Josef Bacik wrote:
> I hit this error when reproducing a bug that would end in a transaction
> abort.  We take the delayed ref head's mutex to keep anybody from processing
> it while we're destroying it, but we fail to drop the mutex before we carry
> on and free the damned thing.  Fix this by doing the remove logic for the
> head ourselves and unlock the mutex, that way we can avoid use after free's
> or hung tasks waiting on that mutex to come back so they know the delayed
> ref completed.  Thanks,
> 

> +			ref->in_tree = 0;
> +			rb_erase(&ref->rb_node, &delayed_refs->root);
> +			delayed_refs->num_entries--;
> +			mutex_unlock(&head->mutex);
> +		} else {
> +			ref->in_tree = 0;
> +			rb_erase(&ref->rb_node, &delayed_refs->root);
> +			delayed_refs->num_entries--;

Do you really need to duplicate the removal under the mutex?  Isn't all
that protected by the delayed_refs->lock?

Isn't it enough to just add the mutex_unlock()?

- z
