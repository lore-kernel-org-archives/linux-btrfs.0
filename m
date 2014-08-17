Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaHQUZ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 16:25:59 -0400
Message-ID: <53F10FCF.7080208@redhat.com>
Date: Sun, 17 Aug 2014 15:25:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH] btrfs: fix leak in qgroup_subtree_accounting() error
 path
References: <53F10BF1.6070602@redhat.com>
In-Reply-To: <53F10BF1.6070602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/17/14, 3:09 PM, Eric Sandeen wrote:
> Coverity pointed this out; in the newly added
> qgroup_subtree_accounting(), if btrfs_find_all_roots()
> returns an error, we leak at least the parents pointer,
> and possibly the roots pointer, depending on what failure
> occurs.

FWIW, Coverity also doesn't like this line:

        unode = ulist_next(roots, &uiter); /* Only want 1 so no need to loop */

it thinks that unode should be checked for NULL, but it seems
like that can't fail, especially since we already checked that
roots->nnodes == 1...

So maybe that should just be marked & ignored.
Or it could be added as a defensive check, I suppose...

-Eric
