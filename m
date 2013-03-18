Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3CROQO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 10:16:14 -0400
Date: Mon, 18 Mar 2013 15:16:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: build up error handling for merge_reloc_roots
Message-ID: <20130318141612.GM7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
 <1362414341-17306-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362414341-17306-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 05, 2013 at 12:25:37AM +0800, Liu Bo wrote:
> We first use btrfs_std_error hook to replace with BUG_ON, and we
> also need to cleanup what is left, including reloc roots rbtree
> and reloc roots list.
> Here we use a helper function to cleanup both rbtree and list, and
> since this function can also be used in the balance recover path,
> we also make the change as well to keep code simple.

I've noticed that return value from merge_reloc_roots is never checked
in the callers. Did you verify that this is ok?

For example when called from btrfs_recover_relocation, is it possible
that the reloc-to-be-recovered is still left unprocessed but the
filesystem is going to be silently mounted read-write?

The mount and remount callpaths check for recover_relocation errors and
do not proceed otherwise. In RO mount, it's not called.

So, either merge_reloc_roots callers should catch the errors or there
are none by design (ie. the whole reloc operation is restartable).

david
